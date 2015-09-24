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
 
 
@isTest(SeeAllData=true)
private class CreatePPCOlisTriggerTest {
	// <refactor> should not be querying and using existing data, test data should be used

    static testMethod void testCreatePPCOpportunityLineItemScheduleTrigger() {
        // Initialize Data for testing
        // ---------------------------
        PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
		System.debug('CreatePPCOpportunityLineItemScheduleTrigger: Unit Test started');
        System.debug('CreatePPCOpportunityLineItemScheduleTrigger: Creating Account');
        
       // --  Account Data -- 
       Account account = TestingUtils.createAccounts(1,false)[0];
        // <refactor> should use RecordTypeCache here
        // <CC> Developer Name is safer than Name as DeveloperName is unique; to be implemented in RecordTypeCache
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
		Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = accSchema.getRecordTypeInfosByName();
        Id rtId = AccountRecordTypeInfo.get('SML Company').getRecordTypeId();
        if (rtID == null){
        	System.assertEquals(true,false,'PPC Order Form: Error, unable to locate company type: SML Company');
        	return;
        }
        else{
        	account.RecordTypeId = rtId;
        }
        account.Phone = '602-444-8000';
        account.Website = 'http://www.gannettlocal.com';        
        insert account;        
        System.debug('PPC Order Form: AccountId Created: ' + account.Id);
        
        //  -- Opportunity Data --
        System.debug('PPC Order Form: Creating Opportunity');                
        Opportunity opportunity = TestingUtils.createOpportunities(1,'PPCOrderFormTest - Unit Test Company - Opportunity', account.Id, false)[0];
        // <refactor> should use RecordTypeCache here
        // <CC> Developer Name is safer than Name as DeveloperName is unique; to be implemented in RecordTypeCache
        Schema.DescribeSObjectResult oppSchema = Schema.SObjectType.opportunity; 
		Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = oppSchema.getRecordTypeInfosByName();
        Id oppRTId = oppRecordTypeInfo.get('SML Opportunity').getRecordTypeId();
        if (oppRTId == null)
        {
        	delete account;
        	System.assertEquals(true,false,'PPC Order Form: Error, unable to locate opportunity type: SML Opportunity');
        	return;
        }
        else
        {
        	opportunity.RecordTypeId = oppRTId;
        }
        opportunity.StageName = 'Closed Won';
        opportunity.Type = 'New Business';
        opportunity.CloseDate = Date.today();        
        insert opportunity;
        System.debug('PPC Order Form: OpportunityId Created: ' + opportunity.Id);
        
        // -- Opportunity Line Item, Proudct, & PriceBookEntry Data ---
        System.debug('PPC Order Form: Creating OpportunityLineItem');               
        Schema.DescribeSObjectResult productSchema = Schema.SObjectType.product2; 
		Map<String,Schema.RecordTypeInfo> productRecordTypeInfo = productSchema.getRecordTypeInfosByName();
        Id productRTId = productRecordTypeInfo.get('SML Product').getRecordTypeId();        
        
        product2 product = TestingUtils.createProduct('PPC',false);
        product.Product_Type__c = 'PPC';
        product.SLA_Product_Type__c = 'PPC';
        product.RecordTypeId = productRTId;
        product.CanUseRevenueSchedule = true;
        insert product;
        
        Pricebook2 pricebook = [select id from Pricebook2 where isStandard=true]; // Need to query this.  isStarndard is not a writable field
        																	  	  // and we need a standard pricebook to insert another.
        PriceBookEntry pricebookEntry = TestingUtils.createPriceBookEntry(product.Id, pricebook.Id, true);
        //Not calling the test util because we want to set the Unit Price here.  
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.PricebookEntryId = pricebookEntry.Id;
        opportunityLineItem.OpportunityId =  opportunity.Id;
        opportunityLineItem.Quantity = 3;
        opportunityLineItem.ServiceDate = Date.today();
        opportunityLineItem.UnitPrice = 1000.00;
        opportunityLineItem.Waiting_Status__c = 'In Fulfillment';        
        insert opportunityLineItem;
        System.debug('PPC Order Form: OpportunityLineItemId Created: ' + opportunityLineItem.Id);
        
        // -- PPC Form Info --  
        System.debug('PPC Order Form: Setting Parameter value');        
    	ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15)); // <CC> why substring Id     	 
    	System.debug('PPC Order Form: OpportunityLineItemId Parameter: ' + ApexPages.currentPage().getParameters().get('OpportunityLineItemId')); 
        System.debug('PPC Order Form: Creating an instance of PPCOrderForm controller');
    	
    	// Starting the actual Test
        // ---------------------------
    	// <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
    	test.startTest();
    	
    	// Test Account Selection    	
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        System.assertEquals(ppcOrderForm.account.Name,account.Name,'PPC Form Account not consistent');
		
		// Test PPC Order Form Detail creation                
        ppcOrderForm.ppcOrderDetail.LeadCaptureEmail__c = 'Test Lead Capture Email';
        ppcOrderForm.ppcOrderDetail.BusinessDescription__c = 'Test Business Description';
        ppcOrderForm.ppcOrderDetail.FulfillmentStatus__c = 'AMP';
        ppcOrderForm.ClickSave();        
       System.assertNotEquals(ppcOrderForm.ppcOrderDetail.Id,null,'PPC Order Form: Error, PPCOrderdetail ID is null');        
        
        // Test scheduling of periods 
        opportunityLineItem.Live_Date__c = datetime.now();
        opportunityLineItem.Waiting_Status__c = 'Live';
        update opportunityLineItem;
		List<OpportunityLineItemSchedule> opportunityLineItemSchedules = [SELECT CreatedById,CreatedDate,Description,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityLineItemId,Quantity,Revenue,ScheduleDate,SystemModstamp,Type FROM OpportunityLineItemSchedule where OpportunityLineItemId=:opportunityLineItem.Id ORDER BY ScheduleDate]; 		
		System.assertEquals(opportunityLineItem.Quantity, opportunityLineItemSchedules.size(),'PPC Order Form: Error, Not all periods have been scheduled.');		
				
		date liveDate = Date.newInstance(opportunityLineItem.Live_Date__c.year(), opportunityLineItem.Live_Date__c.month(), opportunityLineItem.Live_Date__c.day());		
		Integer i = 0;		
		for (OpportunityLineItemSchedule sched : opportunityLineItemSchedules )
		{
			System.assertEquals(sched.ScheduleDate, liveDate.addMonths(i),'PPC Order Form: Error, Schedule Date != Live Date + Period.'); 
			i++;
		}
		
		test.stopTest();

    }
}