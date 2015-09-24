/*
        // Name: ProductSLAServicesTest.cls
        // Date Created: 9/23/2014 (CRM Sprint 1.0.21)
        // Purpose: Built to create test Product SLA Services.
        // Objects affected: ProductSLAServices.cls, Account, opportunity and OLI creation processes
        // Used by: deployment code, and users running the tests.
 
*/

@isTest(seeAllData=true)
// seeAllData=true for selecting default pricebook and custom settings

private class ProductSLAServicesTest {
    private static Account[] accounts {get;set;}
    private static Opportunity[] opportunities {get;set;}
    private static product2 product {get;set;}
    private static OpportunityLineItem[] opportunityLineItems {get;set;}
    private static Opportunity_Product_History__c[] manualHistRecords {get;set;}
    private static datetime LastOutTime{get;set;}

    
    //Currently only increases test coverage for ProductSLA.
    static testMethod void processTestProductSLAServices (){
        populateOLIRelatedData(1);
        createOppProdHist();
        opportunityLineItem[] OLIToUpdate = new opportunityLineItem[]{};            
         for (opportunityLineItem OLI: opportunityLineItems){
             OLI.Waiting_Status__c = 'Live';
             OLI.Live_Date__c = LastOutTime.addHours(24);
             OLIToUpdate.add(OLI);
         }
        update OLIToUpdate;
        set<ID> oliID = new map<ID,opportunityLineItem>(OLIToUpdate).keyset();

        //each History record should have one product SLA.
        ProductSLAServices.callProcessLiveOLIforBatch(oliID);
        Product_SLA__c[] productSLAs = new Product_SLA__c[]{};
        Set<Id> oppLineItemIds = new Map<Id, OpportunityLineItem>(opportunityLineItems).keySet();
        productSLAs = [SELECT ID FROM Product_SLA__c where ID in :oppLineItemIds];
        system.debug('Size of Product  '+ productSLAs.size());
        //system.assertEquals(productSLAs.size(),opportunityLineItems.size(),'Each OLI must have gone live, so each OLI should have exactly one summary record');
    }
    

    //To test the status changes in the OLIServices
    static testMethod void processTestOLIServicesStatusChange(){
         populateOLIRelatedData(1);
        LastOutTime = datetime.now();
         // Inserts values from opportunityLineItem.Waiting_Status__c.  Any addtions to this pick list should be reflected here.
        map <integer, string> OLIStatus = new map <integer,string> {        0 => 'Created',
                                                                            1 => 'Closed Won',
                                                                            2 => 'Awaiting Onboard',
                                                                            3 => 'In Fulfillment',
                                                                            4 => 'Waiting On Client Approval',
                                                                            5 => 'Waiting On Client Resource',
                                                                            6 => 'Cancelled',
                                                                            7 => 'Pending',                                                                     
                                                                            8 => 'Paused:Billing',
                                                                            9 => 'Paused:No Contact',
                                                                            10 => 'Live',
                                                                            11 => 'Fulfilled Renewed',
                                                                            12 => 'Fulfilled Non-Renewal',
                                                                            13 => 'Fulfilled-Complete'
                                                                        };
                                                                        
                                                                        
            

        // Checking the status change code in OLI Services.
        integer prevStatus = 0;
        integer numStatusChanges = 0;
        integer numSameStatus = 0;
        integer changesRecorded = 0;
        integer numIterations = 25;
        opportunityLineItem[] OLIToUpdate = new opportunityLineItem[]{};            
        Map<Id, OpportunityLineItem> oldMap = new Map<Id, OpportunityLineItem>();
        
        // This code will have to change after the status workflow has been locked down. Using random numbers is a quick
        // way to test all the status changes.        
        test.startTest();
        for (integer i=0; i < numIterations; i++){
            integer upperLimit = 13;
            boolean thisStatusChanged;
            integer randStatus = Math.mod(Math.round(Math.random()*1000), upperLimit);
            system.debug(' The value of i: ' + i + '; The value of UpperLimit: ' + upperLimit + '; randStatus: ' + randStatus);
            //If the same prelive status (since we're only setting live once, and the sets have the first 4 numbers in common)
            if (prevStatus == randStatus) {
                numSameStatus++;
                thisStatusChanged =false;
            } else{
                numStatusChanges++;
                thisStatusChanged=true;
            }
            
            // We want to test atleast one update without a status change.
            if (i == numIterations-1 && numSameStatus == 0){
                randStatus = prevStatus;
                numStatusChanges--;
                numSameStatus++;
                thisStatusChanged = false;
            }
            
            OLIToUpdate.clear();
            
            system.debug('Updating the status from: ' + OLIStatus.get(prevStatus) + ' to: ' + OLIStatus.get(randStatus) );
            //system.debug('No of status not changed: ' + numSameStatus + '; No of status changed: ' + numStatusChanges);
            for (opportunityLineItem oli: opportunityLineItems){
                oldMap.put(oli.Id, oli.clone(true,true));       
                 //Enter cancel reason when status is in cancel, and clear it when it isn't
                 // If status reason = cancel or non renewal, enter cancel reason, else make sure none exists.
                if (randStatus == 6 || randStatus == 13 ) {
                    oli.Cancellation_Category__c = 'Test class insert'; 
                } else {
                    oli.Cancellation_Category__c = ''; 
                }

                //system.debug('Updating the status from: ' + OLIStatus.get(prevStatus) + ' to: ' + OLIStatus.get(randStatus) );
                oli.waiting_status__c = OLIStatus.get(randStatus);
                OLIToUpdate.add(oli);
            }//End for each OLI
            OpportunityLineItemServices.processedOLIStatusChanges.removeAll( new map<ID,OpportunityLineItem>(OLIToUpdate).keyset() );// trigger should process an ID only once per execution block
            opportunityLineItem[] UpdatedStatusList = OpportunityLineItemServices.getStatusChange(OLIToUpdate,oldMap);
            ////system.debug('Number of OLI passed: ' + OLIToUpdate.size() + ' Number of status changed: ' + UpdatedStatusList.size());             
            if (!UpdatedStatusList.IsEmpty()){
                changesRecorded++;
                system.assertEquals(UpdatedStatusList.size(), OLIToUpdate.size(),'When updating status, all OLI records are passed to it.  (OLIToUpdate).');
                system.assertEquals(UpdatedStatusList.size(), opportunityLineItems.size(),'When updating status, all OLI records are passed to it.  (opportunityLineItems).');
                //system.debug('Changes Recorded');
            } else {
                if (thisStatusChanged == true) {
                    system.assertequals(1,0,'No Changes recorded for changed status! Updating the status from: ' + OLIStatus.get(prevStatus) + ' to: ' + OLIStatus.get(randStatus));
                }
            }            
            PrevStatus = randStatus;
        }//End iterations.
        test.stopTest();
        
        system.debug('No of status not changed: ' + numSameStatus + '; No of status changed: ' + numStatusChanges + '; Number of status changes recorded: ' + changesRecorded );
        system.assertequals (numStatusChanges + numSameStatus, numIterations,'We loop through numIterations times, so we are expecting numIterations total changes recorded (each time we record, we ensure all related OLI are accounted for).' );   
        //system.assertEquals(changesRecorded,numStatusChanges,'We Should have the same number of changes recorded as the number of times we changed status.');
         
        Set<Id>  SFIDSet = new Map<Id, OpportunityLineItem>(OpportunityLineItems).keyset();
        //OpportunityLineItemServices.getStatusChange only records the status upon entry.  
        system.debug('Number of iterations: ' + numIterations + '; Number of OpportunityLineItems: ' +  SFIDSet.size());
        integer logsExpected = (numIterations * SFIDSet.size());
        //system.assertEquals(logsExpected, ApplicationLogsModel.logList.size(),'Expecting all calls to the OpportunityLineItemServices to be recorded + number of actual status change');

    }


/*          
            Helper classes
            --------------
*/

    private static void populateOLIRelatedData( integer numOliToCreate) {
        // -- Accounts -- 
        system.debug('ProductSLAServicesTest.processTestProductSLAServices: Creating 1 Accounts');       
        accounts = new Account[] {};
        accounts = TestingUtils.createAccounts(1,true);
        
        //  -- Opportunity Data --
        System.debug('ProductSLAServicesTest.processTestProductSLAServices: Creating 1 Opportunities');  
        opportunities = new Opportunity[]{};   
        for (account a: accounts) {
             opportunities.addAll(TestingUtils.createOpportunities(1,'TestProductSLAServicesOpp ' + a.name , a.Id, true));
        }
                
        // -- Opportunity Line Item, Proudct, & PriceBookEntry Data ---
        System.debug('ProductSLAServicesTest.processTestProductSLAServices: Creating Product, Pricebook and PricebookEntry');           
        product = TestingUtils.createProduct('TestProductSLAServicesProduct',true);
        
        Pricebook2 pricebook = [select id from Pricebook2 where isStandard=true]; // Need to query this.  isStandard is not a writable field
                                                                                  // and we need a standard pricebook to insert another.
                                                                                  
        PriceBookEntry pricebookEntry = TestingUtils.createPriceBookEntry(product.Id, pricebook.Id, true);
        
        // Not calling the test util because we want to set the waiting status description here.          
        System.debug('ProductSLAServicesTest.processTestProductSLAServices: Creating 5 opportunity products');           
        opportunityLineItems = new OpportunityLineItem[]{};
        for (integer i=0; i < numOliToCreate; i++) {
            OpportunityLineItem OLI = TestingUtils.createOLI(pricebookEntry.ID, opportunities[0].Id, false);
            OLI.Waiting_Status_Descr__c = 'Test class insert'; 
            opportunityLineItems.add(OLI); 
        }
        insert opportunityLineItems; // This creates the Opportunity_Product_History__c
        
    }
        
    static void createOppProdHist() {
         LastOutTime = datetime.now();
        // Inserts values from opportunityLineItem.Waiting_Status__c.  Any addtions to this pick list should be reflected here.
        map <integer, string> OLIStatus = new map <integer,string> {    0 => 'Created',
                                                                        1 => 'Closed Won',
                                                                        2 => 'Awaiting Onboard',
                                                                        3 => 'In Fulfillment',
                                                                        4 => 'Waiting On Client Approval',
                                                                        5 => 'Waiting On Client Resource',
                                                                        6 => 'Canceled',
                                                                        7 => 'Pending',                                                                     
                                                                        8 => 'Paused:Billing',
                                                                        9 => 'Paused:No Contact',
                                                                        10 => 'Live',
                                                                        11 => 'Fulfilled Renewed',
                                                                        12 => 'Fulfilled Non-Renewal',
                                                                        13 => 'Fulfilled-Complete'
                                                                    }; 
                                                                            
       manualHistRecords = new Opportunity_Product_History__c[] {};
        // Create Opportunity Product History Logs manually.
        for (opportunityLineItem oli:opportunityLineItems) {
            manualHistRecords = TestingUtils.createOliHistory(9,false);//This makes sure every OLI has 9 associated records with the created           
        }
        for (opportunityLineItem OLI: opportunityLineItems) {
            for (integer i=1; i <  10; i++) {
                Opportunity_Product_History__c thisOppHist =  new Opportunity_Product_History__c();
                thisOppHist.Duration__c = 1.00;
                 thisOppHist.OLI_Product__c = OLI.Product2.ID;
                thisOppHist.OLI_Stage__c =  OLIStatus.get(i);
                thisOppHist.Opportunity__c =  OLI.Opportunity.ID;
                 thisOppHist.Opportunity_Product__c = string.valueof(OLI.ID);
                 thisOppHist.Time_In__c = LastOutTime;
                LastOutTime = LastOutTime.addHours(24);  //translates into 9 business hours, and 1 day.
                thisOppHist.Time_Out__c = LastOutTime;
                manualHistRecords.add(thisOppHist);
             }
        }        
        insert manualHistRecords;
        
        opportunityLineItem[] OLIToUpdate = new opportunityLineItem[]{};            
         for (opportunityLineItem OLI: opportunityLineItems) {
             OLI.Waiting_Status__c = 'Live';
             OLI.Live_Date__c = LastOutTime.addHours(24);
             OLIToUpdate.add(OLI);
         }
        update OLIToUpdate;
    }    
}