@isTest(seeAllData=true)
public with sharing class BatchProductSLARecalculationTest {
	public static Account[] accounts {get;set;}
    public static Opportunity[] opportunities {get;set;}
    public static product2 product {get;set;}
    public static PriceBookEntry pricebookEntry {get;set;}
    public static OpportunityLineItem[] opportunityLineItems {get;set;}
    public static Opportunity_Product_History__c[] manualHistRecords {get;set;}
    public static datetime LastOutTime{get;set;}
	public static product_SLA__c[] ProductSLAs {get;set;}
	
	public static testMethod void testBatchProductSLARecalc(){
		populateOLIRelatedData(1,1,1);
		createOppProdHist(true);
		SET<ID> OLISet = new map<ID,OpportunityLineItem>(opportunityLineItems).keyset();
		string query = 'Select id from OpportunityLineItem where ID in (\'';
		query += String.join(new List<ID>(OLISet), '\',\'');	
		query += '\')';	
		system.debug('Passing query: ' + query);
		integer batchsize = 10;
		
		list<SLA_Related_Filters__c> filterSettingsList = [	SELECT 	Live_After__c, 
																	Live_Before__c,
																	Live_Status__c,
																	Opportunity_Product_Created_After__c,
																	Opportunity_Product_Created_Before__c,
																	Product_Filters__c,
																	Is_Active__c
															 FROM SLA_Related_Filters__c
															 WHERE Name = 'BatchProductSLARecalculationFilters'];
															 
		system.assertEquals(filterSettingsList.size(),1,'BatchProductSLARecalculationTest.testBatchProductSLARecalc: We expect to find a record in the custom settings for the batch job.');
		filterSettingsList[0].Live_After__c = LastOutTime.date(); 
		filterSettingsList[0].Live_Before__c = null;
		filterSettingsList[0].Live_Status__c = 'Live';
		filterSettingsList[0].Opportunity_Product_Created_After__c = date.newInstance(2013,12,08);
		filterSettingsList[0].Opportunity_Product_Created_Before__c = null;
		filterSettingsList[0].Product_Filters__c = product.ID;
		filterSettingsList[0].Is_Active__c = true;
		update filterSettingsList;
		OpportunityLineItemServices.processedOLIStatusChanges.clear();
		
		test.startTest();
		batchProductSLARecalculation processSLAusingQuery = new batchProductSLARecalculation(query);
		Database.QueryLocator ql = processSLAusingQuery.start(null);
		processSLAusingQuery.execute(null,opportunityLineItems);
		processSLAusingQuery.finish(null);		
		//ID qBatchExecuteID = Database.executeBatch(processSLAusingQuery,batchsize);
		system.debug('Finished executing the batch with Query:' + query);
        if (!ProductSLAs.isEmpty()){
			ProductSLAs.Clear();
         }
		ProductSLAs = [SELECT ID FROM Product_SLA__c where Opportunity_Product__c in :OLISet];
		system.debug('ProductSLAs: ' + ProductSLAs);
		system.assertEquals (OLISet.size(),ProductSLAs.size(),'BatchProductSLARecalculationTest.testBatchProductSLARecalc: We expect Product SLAs to be created when batchProductSLARecalculation is called with it\'s associated ID');
		 if (!ProductSLAs.isEmpty()){
             delete ProductSLAs;
         }
		OpportunityLineItemServices.processedOLIStatusChanges.clear();
		
		batchProductSLARecalculation processSLAusingCustomSettings = new batchProductSLARecalculation();
		ql = processSLAusingCustomSettings.start(null);
		processSLAusingCustomSettings.execute(null,opportunityLineItems);
		processSLAusingCustomSettings.finish(null);		
		//ID csBatchExecuteID = Database.executeBatch(processSLAusingCustomSettings,batchsize);
		system.debug('Finished executing the batch with custom settings.' );//+ csBatchExecuteID);
		test.stopTest();
		
		ProductSLAs = [SELECT ID FROM Product_SLA__c where Opportunity_Product__c in :OLISet];
		system.assertEquals (OLISet.size(),ProductSLAs.size(),'BatchProductSLARecalculationTest.testBatchProductSLARecalc: We expect Product SLAs to be created when batchProductSLARecalculation is called with custom settings');
	}
	
	
	
      public static void populateOLIRelatedData( integer numAccount, integer numOppPerAcct, integer numOLIperOpp) {
        // -- Accounts -- 
        system.debug('BatchProductSLARecalculationTest.populateOLIRelatedData: Creating 1 Accounts');       
         accounts = TestingUtils.createAccounts(numAccount,true);
        
        //  -- Opportunity Data --
        System.debug('BatchProductSLARecalculationTest.populateOLIRelatedData: Creating 1 Opportunities');  
        opportunities = new Opportunity[]{};   
        for (account a: accounts) {
             opportunities.addAll(TestingUtils.createOpportunities(numOppPerAcct,'TestProductSLAServicesOpp ' + a.name , a.Id, true));
        }
                
     // -- Opportunity Line Item, Proudct, & PriceBookEntry Data ---
        System.debug('BatchProductSLARecalculationTest.populateOLIRelatedData: Creating Product, Pricebook and PricebookEntry');           
        product = TestingUtils.createProduct('TestProductSLAServicesProduct',true);
        
          Pricebook2 pricebook = [select id from Pricebook2 where isStandard=true]; // Need to query this.  isStandard is not a writable field
                                                                                  // and we need a standard pricebook to insert another.
                                                                                  
        pricebookEntry = TestingUtils.createPriceBookEntry(product.Id, pricebook.Id, true);
       
        // Not calling the test util because we want to set the waiting status description here.          
        System.debug('BatchProductSLARecalculationTest.populateOLIRelatedData: Creating 5 opportunity products');           
        opportunityLineItems = new OpportunityLineItem[]{};
        for (Opportunity opp: opportunities) {
            for (integer i=0; i < numOLIperOpp; i++) {
                OpportunityLineItem OLI = TestingUtils.createOLI(pricebookEntry.ID, opp.Id, false);
                OLI.Waiting_Status_Descr__c = 'Test class insert'; 
                opportunityLineItems.add(OLI); 
        	}
        }
        insert opportunityLineItems; // This creates the Opportunity_Product_History__c
    }
    
    public static void createOppProdHist(boolean includeLive) {
        LastOutTime = datetime.now();
        // Inserts values from opportunityLineItem.Waiting_Status__c.  Any addtions to this pick list should be reflected here.
        map <integer, string> OLIStatus = new map <integer,string> {    0 => 'Created',
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
        OpportunityLineItemServices.processedOLIStatusChanges.clear();
         
        if (includeLive){
    		 opportunityLineItem[] OLIToUpdate = new opportunityLineItem[]{};
	         for (opportunityLineItem OLI: opportunityLineItems) {
	             OLI.Waiting_Status__c = 'Live';
	             OLI.Live_Date__c = LastOutTime.addHours(24);
	             OLIToUpdate.add(OLI);
	         }
	                
	        update OLIToUpdate;
	        OpportunityLineItemServices.processedOLIStatusChanges.clear();
            set<ID>OLISet = new map<ID,opportunityLineItem>(opportunityLineItems).keyset();
            ProductSLAs = [SELECT ID FROM Product_SLA__c where Opportunity_Product__c in :OLISet];
        }
    }

}