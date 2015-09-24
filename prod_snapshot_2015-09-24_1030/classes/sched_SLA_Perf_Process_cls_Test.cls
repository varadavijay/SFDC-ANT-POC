/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 // - for testing the scheduling class - http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
@isTest(seeAllData=False)
//doing seealldata so this class can see the kpi calender (constants) records that it needs to
public with sharing class sched_SLA_Perf_Process_cls_Test {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testMethod void Test_batchOnOppProdHistories() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();
    	
    	Account account = new Account();
    	account.Name = 'batchOnOppProd - Test Company';
        account.BillingState = 'AZ';
        account.BillingCity = 'Phoenix';
        account.BillingStreet = '200 E Van Buren St';
        account.BillingPostalCode = '85004';
        account.Phone = '602-444-8000';
        account.Website = 'http://www.gannettlocal.com';
        insert account;
        
        //create test opp (just creating one, and putting all products on it...no reason not to at this point)
        Opportunity nOpp = new Opportunity();
        //nOpp.Media_Partner__c = '001K000000u6XTe';
        nOpp.Market_Record__c = 'AZ, Phoenix';
        nOpp.AccountId = account.Id;
        nOpp.Name = 'OppTestName';
        nOpp.RecordTypeId = '012A0000000PKOI';
        nOpp.StageName = 'Closed Won';
        nOpp.Type = 'New Business';
        nOpp.CloseDate = Date.today();
        insert nOpp;
        
        Product2 p1 = new Product2(Name='TestSocMed1', Family='Test', Social_Media_Notice__c=True, CanUseRevenueSchedule = True);
        insert p1;
        //Product2 p2 = new Product2(Name='TestSocMed2', Family='Test', Social_Media_Notice__c=False, CanUseRevenueSchedule = True);
        //insert p2;
        
        Pricebook2 stdPb = new Pricebook2(Name='NewPriceBook',IsActive=True,Description='Description1');
        insert stdPb;
        //Pricebook2 stdPb = [select Id from Pricebook2 limit 1];
        
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = '01sA0000000L68a', product2id = p1.id, unitprice=1.0, isActive=true, usestandardprice=false);
        insert pbe1;
        //PricebookEntry pbe2 = new PricebookEntry(pricebook2id = '01sA0000000L68a', product2id = p2.id, unitprice=1.0, isActive=true, usestandardprice=false);
        //insert pbe2;
        //
        //create a list for batch of 10 of Opportunity Products On Which To Run changing statuses
        Integer CC = 2;
        String OLI_Id1 = '';
        String OLI_Id2 = '';
        
        List<OpportunityLineItem> OppProdsToLoad = new List<OpportunityLineItem>();
        List<Project__c> OppProjsToLoad = new List<Project__c>();
        for(Integer i = 0; i < CC; i++){
        	OpportunityLineItem oli = new OpportunityLineItem();
        	oli.OpportunityId=nOpp.Id;
        	oli.pricebookentryid=pbe1.id;
        	oli.unitprice=1.5;
        	oli.quantity=2;
        	oli.ServiceDate=date.today();
        	oli.End_Date__c=date.today().adddays(30);
        	oli.Term__c = 'Test0';
        	oli.Waiting_Status__c = '';
        	//
        	OppProdsToLoad.add(oli);
        }
        insert OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	Project__c oProj = new Project__c();
        	oProj.OppProd__c=String.valueOf(OppProdsToLoad[i].Id);
        	oProj.Live_Date__c=datetime.now();
        	oProj.Project_Status__c='Fulfilled-Complete';
        	//
        	OppProjsToLoad.add(oProj);
        }
        insert OppProjsToLoad;
        //get Ids of Line Items Created
        for(Integer i = 0; i < CC; i++){
	    	if(i==0){
	    		OLI_Id1 = OppProdsToLoad[i].Id;
	    		OppProdsToLoad[i].Quantity=3;	    		
	    		}
	    	else if (i==1){
	    		OLI_Id2 = OppProdsToLoad[i].Id;
	    		OppProdsToLoad[i].Quantity=3;
	    		}
	    	else{}
        }
        update OppProdsToLoad;
        //get Project Ids (need to add above created OppProds to a set so can query based on that)
        List<Project__c> oliProj = [SELECT Id, OppProd__c FROM Project__c WHERE OppProd__c = :OLI_Id1 OR OppProd__c = :OLI_Id2];
        //create Opp Prod History Records
        List<Opportunity_Product_History__c> oppProdHist = new List <Opportunity_Product_History__c>();
        //--create list of statuses to use
        List<String> statusList = new List<String>();
        //set number of statuses to use
        Integer statusCount = 10;
        statusList.add('Closed Won');//1
        statusList.add('Awaiting Onboard');//2
        statusList.add('Pending');//3
        statusList.add('In Fulfillment');//4
        statusList.add('Waiting On Client Resource');//5
        statusList.add('In Fulfillment');//6
        statusList.add('Waiting On Client Approval');//7
        statusList.add('Waiting On Client Resource');//8
        statusList.add('Live');//9
        statusList.add('Fulfilled-Complete');//10
        //loop through each OppLineItem, creating a new Opp Prod History record with status in order shown above
        for(Integer i = 0; i < CC; i++){
        	for(Integer j = 0;j < statusCount; j++){
	        	Opportunity_Product_History__c oph = new Opportunity_Product_History__c();
	        	oph.Duration__c=1;
	        	oph.Notes__c='notes';
	        	oph.OLI_Project__c=oliProj[i].Id;
	        	oph.OLI_Stage__c=statusList.get(j);
	        	oph.Opportunity__c=nOpp.Id;
	        	oph.Opportunity_Product__c=string.valueof(OppProdsToLoad[i].Id);
	        	oph.Opportunity_Product_Type__c='PPC';
	        	oph.Product_Days_To_Go_Live__c = 10;
	        	oph.Product_Live_Date__c = date.today();
	        	oph.Time_In__c=datetime.now();
	        	oph.Time_Out__c=datetime.now() + 1;
	        	//
	        	oppProdHist.add(oph);
        	}
        }
        insert oppProdHist;
        
        Integer testOPHCount = oppProdHist.size();
        System.AssertEquals(20,testOPHCount);
        
        //update all products to status closed won' (and so on) so our 'Project' and Opportunity Product History Records will be created accordingly
        //removing this section as it doesn't work
        /**
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Closed Won';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Awaiting Onboard';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Pending';
        	OppProdsToLoad[i].Waiting_Status_Descr__c = 'Notes';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'In Fulfillment';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Waiting On Client Resource';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Waiting On Client Approval';
        }
        update OppProdsToLoad;  
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Waiting On Client Resource';
        }
        update OppProdsToLoad;
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Live';
        }
        update OppProdsToLoad; 
        for(Integer i = 0; i < CC; i++){
        	OppProdsToLoad[i].Waiting_Status__c = 'Fulfilled-Complete';
        }
        update OppProdsToLoad; 
        **/
        
        //Opportunity Product History Records should be created...so start creation of SLA Performance records
        
        
        Test.StartTest();
        String jobId = System.schedule('sched_SLA_Perf_Process_cls', CRON_EXP, new sched_SLA_Perf_Process_cls());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
		System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
        Test.stopTest();
		
		//Commented out the below since they were only there to help trouble shoot the class and test class, but might come in handy to keep
		//test results of Opp Line Item Records Status Updates
		//List<OpportunityLineItem> testLineItem = [SELECT Id, Waiting_Status__c FROM OpportunityLineItem WHERE Id = :OLI_Id1 OR Id = :OLI_Id2];
		//Integer testLineItemCount = testLineItem.size();
		//String testLineItemStatus1 = testLineItem[0].Waiting_Status__c;
		//System.AssertEquals('Fulfilled-Complete',testLineItemStatus1);
        //System.AssertEquals(2,testLineItemCount);
        
		//test results of Opp Line Item Records Status Updates
		//List<Project__c> testProjectItem = [SELECT Id, Project_Status__c FROM Project__c WHERE Opportunity__c = :OLI_Id1 OR Opportunity__c = :OLI_Id2];
		//Integer testProjectItemCount = testProjectItem.size();
		//String testProjectItemStatus1 = testProjectItem[0].Project_Status__c;
		//System.AssertEquals('Fulfilled-Complete',testProjectItemStatus1);
        //System.AssertEquals(2,testProjectItemCount);
        
        //make sure Opp Prod History records are created
		//List<Opportunity_Product_History__c> testHistory = [SELECT Id, OLI_Stage__c FROM Opportunity_Product_History__c];
		//Integer testHistoryCount = testHistory.size();
		//String testHistoryStatus1 = testHistory[0].OLI_Stage__c;
		//System.AssertEquals('Live',testHistoryStatus1);
        //System.AssertEquals(9,testHistoryCount);
        
		//test results of Batch
		List<SLA_Performance__c> testBatch = [SELECT Id, Summary_Id__c FROM SLA_Performance__c WHERE Summary_Id__c = :OLI_Id1 OR Summary_Id__c = :OLI_Id2];
		Integer testBatchCount = testBatch.size();
        System.AssertEquals(2,testBatchCount);
    }
}