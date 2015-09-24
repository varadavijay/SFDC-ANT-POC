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
private class PPCOrderFormTest {
	private static Account account {get;set;}
	private static Opportunity opportunity {get;set;}
	private static OpportunityLineItem opportunityLineItem {get;set;}
    private static OpportunityLineItem opportunityLineItemSimulSave {get;set;}
	private static account ppcOrderAccount {get;set;}	
	
	static testMethod void testInvalidOppLnItmID()
	{	
		setupdata(2000.00);
		system.debug('PPCOrderFormTest - testInvalidOppLnItmID(): Setup Data Complete' );
		PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
        
        // Test initialization with an invalid OpportunityLineItem ID.  Hardcoded an invalid ID.
        Test.startTest();
        try {
        	ApexPages.currentPage().getParameters().put('OpportunityLineItemId', '00Ks01234584g28');
       		PPCOrderForm ppcOrderFormWithoutAccount = new PPCOrderForm();
       		system.debug('PPCOrderFormTest - testInvalidOppLnItmID(): Initialized PPCOrderForm()' );
        } catch (Exception e) {
        	System.debug('PPCOrderFormTest - testInvalidOppLnItmID(): Caught exception while initializing the PPC Order Form without an Account');
            System.assertequals(e.getMessage(),'');
        } //catch
        test.stopTest();        
	}
	
	static testMethod void standardsave_MgmtFeeInput()
	{
		setupData(2000.00);
		system.debug('PPCOrderFormTest - standardsave_MgmtFeeInput(): Setup Data Complete' );
		PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
        user[] testInputMgmtFee = new user[]{}; 
        testInputMgmtFee = [SELECT ID FROM USER U WHERE U.ID IN       
        						(SELECT UserOrGroupId FROM GroupMember
                                  WHERE Group.DeveloperName = 'PPC_Fee_Managers') limit 1];
		Test.startTest();
	        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
	        System.debug('PPCOrderFormTest - standardsave_MgmtFeeInput(): OpportunityLineItemId Parameter: ' + ApexPages.currentPage().getParameters().get('OpportunityLineItemId'));
	        PPCOrderForm ppcOrderForm; 
			if (testInputMgmtFee.size()>0)
			{	System.RunAs(testInputMgmtFee[0])
		        {	
		        	system.debug('PPCOrderFormTest - standardsave_MgmtFeeInput(): Running as user' + testInputMgmtFee[0].ID);
		        	ppcOrderForm = new PPCOrderForm(); //needs to be initialized by the user in order to have disablePPCManagementFeeInput set correctly
		        	system.assertEquals(ppcOrderForm.disablePPCManagementFeeInput,false);
		        }
			}
			else
			 	ppcOrderForm = new PPCOrderForm();
			
			System.assertEquals(ppcOrderForm.account.Name,string.valueof(account.Name));
	        ppcOrderForm.ppcOrderDetail.LeadCaptureEmail__c = 'Test Lead Capture Email';
	        ppcOrderForm.ppcOrderDetail.BusinessDescription__c = 'Test Business Description';
	        ppcOrderForm.ppcOrderDetail.FulfillmentStatus__c = null;
	        ppcOrderForm.ClickSave();
	        system.debug('PPCOrderFormTest - standardsave_MgmtFeeInput(): Saved Form with ppcOrderDetail ID: '+ ppcOrderForm.ppcOrderDetail.ID );
	        System.AssertNotEquals(ppcOrderForm.ppcOrderDetail.ID,'');
	        Test.stopTest();
	}
	
	static testMethod void LocationSaves()
	{
		setupData(2000.00);
		system.debug('PPCOrderFormTest - LocationSaves(): Setup Data Complete' );
		
        // Testing different Business Locations
        // ----------------------------------------
        PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
         
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        ppcOrderForm.ppcOrderDetail.BusinessDescription__c = 'PPCOrder form test Business Description';
        Test.startTest();           
        // Set the first location
        ppcOrderForm.PPCOrderDetailLocations[0].LocationName__c = 'PPC Test Location1';
        ppcOrderForm.PPCOrderDetailLocations[0].State__c = 'AZ';
        ppcOrderForm.PPCOrderDetailLocations[0].Phone__c = '1234567890';
        ppcOrderForm.PPCOrderDetailLocations[0].Website__c = 'http://www.atkersonlaw.com/';
        
        ppcOrderForm.PPCOrderDetailLocations[0].PostalCode__c = '12345';
        ppcOrderForm.ClickSave();
        system.debug('PPCOrderFormTest - LocationSaves() set first location: Expected Size 1; found ' + ppcOrderForm.PPCOrderDetailLocations.size());
        system.assertEquals(ppcOrderForm.PPCOrderDetailLocations.size(),1);
                                        
        // Test for Duplicate Location Names
        ppcOrderForm.addLocation();
        ppcOrderForm.PPCOrderDetailLocations[1].LocationName__c = 'PPC Test Location1';
        ppcOrderForm.PPCOrderDetailLocations[1].State__c = 'AZ';
        ppcOrderForm.PPCOrderDetailLocations[1].Phone__c = '1234567890';
        ppcOrderForm.PPCOrderDetailLocations[1].Website__c = 'http://www.atkersonlaw.com/';
        ppcOrderForm.PPCOrderDetailLocations[1].PostalCode__c = '12345';
       try {
	        ppcOrderForm.ClickSave();
        } catch (DmlException e) {
        	System.debug('PPCOrderFormTest - LocationSaves(): Caught Duplicate ##' + e.getMessage());
            System.assert( e.getMessage().contains('DUPLICATE_VALUE'),true);
        } //catch
        List<PPCOrderDetailLocation__c> PPCOrderDetailLocations = new PPCOrderDetailLocation__c[]{};
        PPCOrderDetailLocations = [SELECT Id FROM PPCOrderDetailLocation__c where LocationName__c like 'PPC Test Location%'];
        system.debug('##PPCOrderFormTest - LocationSaves() Duplication Locaiton Names: Expected Size 1; found ' + PPCOrderDetailLocations.size());
        system.assertEquals(PPCOrderDetailLocations.size(),1);
         
        // Test deletion of a Saved locaiton
        // First Save a second location
        ppcOrderForm.PPCOrderDetailLocations[1].LocationName__c = 'PPC Test Location2';        
        try {
		        ppcOrderForm.ClickSave();
        } catch (DmlException e) {
            System.assert(e.getMessage().length()==0);
        } //catch
        system.debug('##PPCOrderFormTest - LocationSaves() Save second location: Expected Size 2; found ' + ppcOrderForm.PPCOrderDetailLocations.size());
        system.assertEquals(ppcOrderForm.PPCOrderDetailLocations.size(),2);
         
        ppcOrderForm.locIndexSelected = 1;
        ppcOrderForm.deleteLocation();
        system.debug('##PPCOrderFormTest - LocationSaves() Delete Second Location: Expected Size 1; found ' + ppcOrderForm.PPCOrderDetailLocations.size());
        system.assertEquals(ppcOrderForm.PPCOrderDetailLocations.size(),1);
         
        PPCOrderDetailLocations = [SELECT Id FROM PPCOrderDetailLocation__c where LocationName__c like 'PPC Test Location%'];
        system.assertEquals(PPCOrderDetailLocations.size(),1);
        Test.stopTest();
        system.debug('##PPCOrderFormTest - LocationSaves(): Exit Locationsave() ##');
	}
   
    static testMethod void testSubmitsWaitingOnLandingPage()
    {
        setupData(2000.00);
        System.debug('PPCOrderFormTest - testSubmitsWaitingOnLandingPage(): Setup Data Complete');      
        // Test Submission 
        // ---------------------
        test.StartTest();        
        PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm2 = new PPCOrderForm();
        ppcOrderForm2.ppcOrderDetail.BusinessDescription__c = 'PPCOrder form test Business Description';
        
        //Test save is called upon Submit
        ppcOrderForm2.ppcOrderDetail.BusinessDescription__c = 'Test Business Description Change';
        ppcOrderForm2.PPCOrderDetailLocations[0].LocationName__c = 'PPC Test Location1';
        ppcOrderForm2.PPCOrderDetailLocations[0].State__c = 'AZ';
        ppcOrderForm2.PPCOrderDetailLocations[0].Phone__c = '1234567890';
        ppcOrderForm2.PPCOrderDetailLocations[0].Website__c = 'http://www.atkersonlaw.com/';
        ppcOrderForm2.PPCOrderDetailLocations[0].WebsiteType__c = 'New';
        ppcOrderForm2.ClickSubmit();
        System.debug('PPCOrderFormTest - testSubmitsWaitingOnLandingPage(): check submit = save: ID Comparing in query: ' + string.valueof(opportunityLineItem.id));
        PPCOrderDetail__c[] CheckTestPPCOrderDet = [SELECT ID, BusinessDescription__c, IsReadyForFullfilment__c, FulfillmentStatus__c
                                                    FROM PPCOrderDetail__c
                                                    WHERE OpportunityLineItemId__c = :ppcOrderForm2.ppcOrderDetail.OpportunityLineItemId__c];
        system.assertEquals(CheckTestPPCOrderDet[0].BusinessDescription__c, 'Test Business Description Change');
        system.assertEquals(CheckTestPPCOrderDet[0].IsReadyForFullfilment__c, True);
        
        // Check if location has landing
        PPCOrderDetailLocation__c[] PPCOrderDetailLocations = new PPCOrderDetailLocation__c[]{}; 
        PPCOrderDetailLocations = [SELECT Id FROM PPCOrderDetailLocation__c where LocationName__c like 'PPC Test Location1'];
        system.assertEquals(PPCOrderDetailLocations.size(),1);
        system.assertEquals(CheckTestPPCOrderDet[0].FulfillmentStatus__c,'WaitingOnLandingPage');
        opportunityLineItem[] CheckOLI = [SELECT ID, FulfillmentStatus__c
                                                    FROM opportunityLineItem
                                                    WHERE ID = :ppcOrderForm2.ppcOrderDetail.OpportunityLineItemId__c];
       	system.assertequals(CheckOLI.size(),1);
        system.assertEquals(CheckOLI[0].FulfillmentStatus__c, 'WaitingOnLandingPage');
        
        // Test that a page loads with previous submitted info
        PPCOrderForm ppcOrderForm3 = new PPCOrderForm();
        system.assertEquals(ppcOrderForm3.isSubmitted, True);
        Test.StopTest();
    }
    
    static testMethod void testSubmits_InvalidLocURL_AMP()
    {
    	//1. Location URL Validation Fail,
    	//2. Status AMP
        setupData(2000.00);
        System.debug('PPCOrderFormTest - testSubmits_InvalidLocURL_AMP(): Setup Data Complete');      
        // Test Submission 
        // ---------------------
        test.StartTest();        
        PageReference pageRef = Page.PPCOrderForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        ppcOrderForm.ppcOrderDetail.BusinessDescription__c = 'PPCOrder form test Business Description';
        
        //Test invalid website address for the location (no http:\\ or https:\\)
        ppcOrderForm.ppcOrderDetail.BusinessDescription__c = 'Test Business Description Change';
        ppcOrderForm.PPCOrderDetailLocations[0].LocationName__c = 'PPC Test Location1';
        ppcOrderForm.PPCOrderDetailLocations[0].State__c = 'AZ';
        ppcOrderForm.PPCOrderDetailLocations[0].Phone__c = '1234567890';
        ppcOrderForm.PPCOrderDetailLocations[0].Website__c = 'www.atkersonlaw.com';
         try {
	       	ppcOrderForm.ClickSubmit();
        } catch (DmlException e) {
        	System.debug('PPCOrderFormTest - testSubmits_InvalidLocURL_AMP(): Website Error Caught - ' + e.getMessage());
            System.assertNotEquals(e.getMessage(),'');
        } //catch
        
        PPCOrderDetail__c[] CheckTestPPCOrderDet = [SELECT ID, BusinessDescription__c, IsReadyForFullfilment__c, FulfillmentStatus__c
                                                    FROM PPCOrderDetail__c
                                                    WHERE OpportunityLineItemId__c = :ppcOrderForm.ppcOrderDetail.OpportunityLineItemId__c];
        system.assertNotEquals(CheckTestPPCOrderDet.size(),0); //Location Failure, ensure PPC Order Details is saved
        system.assertEquals(CheckTestPPCOrderDet[0].IsReadyForFullfilment__c, False); //Make sure in case of location errors, it is not submitted
        
        ppcOrderForm.PPCOrderDetailLocations[0].Website__c = 'http://www.atkersonlaw.com/';
         try {
	       	ppcOrderForm.ClickSubmit();
        } catch (DmlException e) {
        	System.debug('PPCOrderFormTest - testSubmits_InvalidLocURL_AMP(): Rectify Website Errors - ' + e.getMessage());
            System.assertNotEquals(true,true);
        } //catch
        
        CheckTestPPCOrderDet = [SELECT ID, BusinessDescription__c, IsReadyForFullfilment__c, FulfillmentStatus__c
                                                    FROM PPCOrderDetail__c
                                                    WHERE OpportunityLineItemId__c = :ppcOrderForm.ppcOrderDetail.OpportunityLineItemId__c];
        
        PPCOrderDetailLocation__c[] PPCOrderDetailLocations = new PPCOrderDetailLocation__c[]{}; 
        PPCOrderDetailLocations = [SELECT Id FROM PPCOrderDetailLocation__c where LocationName__c like 'PPC Test Location1'];
        system.assertEquals(CheckTestPPCOrderDet[0].IsReadyForFullfilment__c, true); //Make submit was successful
        system.assertEquals(CheckTestPPCOrderDet[0].FulfillmentStatus__c,'AMP');
        opportunityLineItem[] CheckOLI = [SELECT ID, FulfillmentStatus__c
                                                    FROM opportunityLineItem
                                                    WHERE ID = :ppcOrderForm.ppcOrderDetail.OpportunityLineItemId__c];
       	system.assertequals(CheckOLI.size(),1);
        system.assertEquals(CheckOLI[0].FulfillmentStatus__c, 'AMP');
        Test.StopTest();
    }
    
    static testMethod void testSimultaneoussaveManualSubmit()
    {
        setupData(800000.00); //Large UnitPrice = Manual during submit
        System.debug('PPCOrderFormTest - testSimultaneoussaveManualSubmit(): Setup Data Complete');
        //Testing Simultaneous saving information
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));        
        PPCOrderForm ppcOrderForm4 = new PPCOrderForm();
        PPCOrderForm ppcOrderForm5 = new PPCOrderForm();
        ppcOrderForm4.ppcOrderDetail.BusinessDescription__c = 'Business Description Insert 1';
        ppcOrderForm5.ppcOrderDetail.BusinessDescription__c = 'Business Description Update 2';
        system.assertEquals(ppcOrderForm4.duplicateShow,false);
        system.assertEquals(ppcOrderForm5.duplicateShow,false);
        System.debug('PPCOrderFormTest - testSimultaneoussaveManualSubmit(): Created two forms for the same Opportunity Line Item');
        ppcOrderForm4.ClickSubmit();
        ppcOrderForm5.ClickSave();
       System.debug('PPCOrderFormTest - testSimultaneoussaveManualSubmit(): Saved two forms for the same Opportunity Line Item; DuplicateShow for Form 1: ' + ppcOrderForm4.duplicateShow + ' and Form 2: ' + ppcOrderForm5.duplicateShow );
        system.assertEquals(ppcOrderForm4.duplicateShow,false);
        system.assertEquals(ppcOrderForm5.duplicateShow,true);
        PPCOrderDetail__c[] CheckTestPPCOrderDet = [SELECT ID, BusinessDescription__c, IsReadyForFullfilment__c, FulfillmentStatus__c
                                                    FROM PPCOrderDetail__c
                                                    WHERE OpportunityLineItemId__c = :ppcOrderForm4.ppcOrderDetail.OpportunityLineItemId__c];
        System.debug('PPCOrderFormTest - testSimultaneoussaveManualSubmit(): CheckTestPPCOrderDet: ' + CheckTestPPCOrderDet);
        system.assertequals(CheckTestPPCOrderDet.size(),1);
        system.assertEquals(CheckTestPPCOrderDet[0].BusinessDescription__c, ppcOrderForm4.ppcOrderDetail.BusinessDescription__c);
        system.assertEquals(CheckTestPPCOrderDet[0].FulfillmentStatus__c, 'Manual');
        system.assertEquals(CheckTestPPCOrderDet[0].IsReadyForFullfilment__c, true);
         opportunityLineItem[] CheckOLI = [SELECT ID, FulfillmentStatus__c
                                                    FROM opportunityLineItem
                                                    WHERE ID = :ppcOrderForm4.ppcOrderDetail.OpportunityLineItemId__c];
       system.assertequals(CheckOLI.size(),1);
        system.assertEquals(CheckOLI[0].FulfillmentStatus__c, 'Manual');
        
    }
    
    static testMethod void CheckManagementFee40()
    {
    	// Testing Total Price 500, expected result management fee of 40%
    	setupData(500.00);
        System.debug('PPCOrderFormTest - CheckManagementFee40(): Setup Data Complete');
        //Testing Simultaneous saving information
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));        
        PPCOrderForm ppcOrderForm = new PPCOrderForm();        
        system.assertequals(ppcOrderForm.ppcOrderDetail.ManagementFee__c,'40');
    }
    
    static testMethod void CheckManagementFee30()
    {
    	// Testing Total Price 750, expected result management fee of 30%
    	setupData(750.00);
        System.debug('PPCOrderFormTest - CheckManagementFee30(): Setup Data Complete');
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        Test.StartTest();
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        system.assertequals(ppcOrderForm.opportunityLineItem.TotalPrice,750.00);
        system.assertequals(ppcOrderForm.opportunityLineItem.Quantity,1);
        system.assertequals(ppcOrderForm.ppcOrderDetail.ManagementFee__c,'30');
        Test.StopTest();
    }
    
    static testMethod void CheckManagementFee25()
    {
    	// Testing Total Price 15000, expected result management fee of 25%
    	setupData(15000.00);
        System.debug('PPCOrderFormTest - CheckManagementFee25(): Setup Data Complete');
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        system.assertequals(ppcOrderForm.opportunityLineItem.TotalPrice,15000.00);
        system.assertequals(ppcOrderForm.opportunityLineItem.Quantity,1);
        system.assertequals(ppcOrderForm.ppcOrderDetail.ManagementFee__c,'25');
        Test.StopTest();
    }
    
    static testMethod void CheckManagementFee20()
    {
    	// Testing Total Price 30000, expected result management fee of 20%
    	setupData(30000.00);
        System.debug('PPCOrderFormTest - CheckManagementFee20(): Setup Data Complete');
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        system.assertequals(ppcOrderForm.opportunityLineItem.TotalPrice,30000.00);
        system.assertequals(ppcOrderForm.opportunityLineItem.Quantity,1);
        system.assertequals(ppcOrderForm.ppcOrderDetail.ManagementFee__c,'20');
        Test.StopTest();
    }
    
    static testMethod void CheckManagement1Fee20()
    {
    	 // Testing Total Price 40000, expected result management fee of 20%
    	setupData(40000.00);
        System.debug('PPCOrderFormTest - CheckManagement1Fee20(): Setup Data Complete');
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('OpportunityLineItemId', String.valueOf(opportunityLineItem.Id).Substring(0,15));
        PPCOrderForm ppcOrderForm = new PPCOrderForm();
        system.assertequals(ppcOrderForm.opportunityLineItem.TotalPrice,40000.00);
        system.assertequals(ppcOrderForm.opportunityLineItem.Quantity,1);
        system.assertequals(ppcOrderForm.ppcOrderDetail.ManagementFee__c,'20');
        Test.StopTest();
    }
    

    private static void setupData( decimal OpportunityUnitPrice ) {
		system.debug('Entering setupData()!! ');
		//Create an Account and build it's details
        //******************************************
        
        // Not using TestingUtil.cls because we need to define the RecordType        
        account = new Account();
        List<RecordType> companyTypes = [SELECT Id FROM RecordType where Name='SML Company']; 
        if(!companyTypes.isEmpty()) {
            account.RecordTypeId = companyTypes.get(0).Id;
        } else {
            System.debug('PPCOrderFormTest - setupData():  Error, unable to locate company type: SML Company');
            System.assertEquals(true,false);
            return;
        }
        account.Name = 'PPCOrderFormTest - Unit Test Company';
        account.BillingState = 'AZ';
        account.BillingCity = 'Phoenix';
        account.BillingStreet = '200 E Van Buren St';
        account.BillingPostalCode = '85004';
        account.Phone = '602-444-8000';
        account.Website = 'http://www.gannettlocal.com';
        insert account;
        
        System.debug('PPCOrderFormTest - setupData(): AccountId Created: ' + account.Id);
        System.debug('PPCOrderFormTest - setupData(): Creating Opportunity');
        
        
        //Create an opportunity and associate it to the above account
        //***********************************************************
        
        // Not using TestingUtil.cls because we need to define the RecordType & StageName
        opportunity = new Opportunity();     
        opportunity.AccountId = account.Id;
        opportunity.Name = 'PPCOrderFormTest - Unit Test Company - Opportunity 1';
        List<RecordType> opportunityTypes = [SELECT Id FROM RecordType where Name='SML Opportunity'];
        if(!opportunityTypes.isEmpty()) {
            opportunity.RecordTypeId = opportunityTypes.get(0).Id;
        } else {
            System.debug('PPCOrderFormTest - setupData(): Error, unable to locate opportunity type: SML Opportunity');
            delete account;
            System.assertEquals(true,false);
            return;
        }
        opportunity.StageName = 'Closed Won';
        opportunity.Type = 'New Business';
        opportunity.CloseDate = Date.today();        
        insert opportunity;
        System.debug('PPCOrderFormTest - setupData(): OpportunityId Created: ' + opportunity.Id);
        System.debug('PPCOrderFormTest - setupData(): Creating OpportunityLineItem');
               
        //Create an opportunityLineItem and assoicate it with the opportunity just created
        //********************************************************************************
        
        opportunityLineItem = new OpportunityLineItem();        
        opportunityLineItem.OpportunityId = opportunity.Id;        
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry where Name='PPC' and Isactive=True limit 1];
        if(!pricebookEntries.isEmpty()) {
            opportunityLineItem.PricebookEntryId = pricebookEntries.get(0).Id;
        } else {
            System.debug('PPCOrderFormTest - setupData(): Error, unable to locate pricebook entry: where Name=PPC and UnitPrice=1000');
            System.assertEquals(true,false);
            return;
        }        
		opportunityLineItem.Quantity = 1;
        opportunityLineItem.ServiceDate = Date.today();
        opportunityLineItem.TotalPrice = OpportunityUnitPrice;        
        insert opportunityLineItem;
        System.debug('PPCOrderFormTest - setupData(): OpportunityLineItemId Created: ' + opportunityLineItem.Id);
        System.debug('PPCOrderFormTest - setupData(): Setting Parameter value');
	}

}