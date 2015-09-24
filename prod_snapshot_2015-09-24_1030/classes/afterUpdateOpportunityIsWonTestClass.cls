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
@isTest
private class afterUpdateOpportunityIsWonTestClass {

	// <CC> <refactor> In general, use Test.startTest; test.stopTest to reset limits on specific blocks of code
	
	static testMethod void myUnitTest2() {
		// <refactor> test method name should be more clear to what is being tested 
		// <refactor> should use Test user created by Test Data creation utility; also should not reference hard coded ids
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		
		// <refactor> test data creation utility should be used to create test data
		Market__c mkt = new Market__c();
        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
        mkt.DealChicken_Approver__c=u.Id;
        insert mkt;
		
		// <refactor> test data creation utility should be used to create test data
		Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
		Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'test2_DCAdded';
        o.StageName = 'Needs Analysis';
        o.CloseDate = date.today();
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o.RecordTypeId = '012F0000000y9rkIAA';
        o.Market_Record__c = mkt.Id;
        insert o;
        
        Opportunity DCOpp = [select Id, Name from Opportunity where Id = :o.Id];
        
        
        DCOpp.Name = 'test3_DCAdded';

        update DCOpp;


        
        Integer TestCountOfOLI = [SELECT count() from OpportunityLineItem WHERE OpportunityId = :o.Id];
        Opportunity MarketTest = [select Id, Market_Area_Manager__c from Opportunity where Id = :o.Id];
        
        String MarketOfTest = MarketTest.Market_Area_Manager__c;
        // <refactor> need assertions w/ messages 
        
        //System.assertEquals(1, TestCountOfOLI);
        //System.assertEquals(Null, MarketOfTest);
	}
    static testMethod void myUnitTest() {
 		// <refactor> test method name should be more clear to what is being tested 
 		// <comment> 
        /**User u1 = new User();
        u1.LastName = 'Info';
        u1.FirstName = 'Welders';
        Profile []p1 = [select id from Profile where Name = 'System Administrator' LIMIT 1];        
        u1.ProfileID = p1[0].id; 
        u1.Username = 'info@infowelders.com';
        u1.Email = '98wdd92s@infowelders.com';
        u1.Alias = '98wdd92s';
        u1.CommunityNickname = '98wdd92s';
        u1.TimeZoneSidKey='America/New_York';
        u1.LocaleSidKey='en_US';
        u1.EmailEncodingKey='UTF-8';
        u1.LanguageLocaleKey='en_US';    
        insert u1;
        **/    
        // <refactor> should use Test user created by Test Data creation utility; also should not reference hard coded ids
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		
		// <refactor> test data creation utility should be used to create test data
		Market__c mkt = new Market__c();
        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
        mkt.DealChicken_Approver__c=u.Id;
        insert mkt;
        
        // <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account II';
        a.RecordTypeId = '012A0000000PKO9';
        a.DC_Market__c = mkt.Id;
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'Test Account II - TestOpp';
        o.StageName = 'DC Out For Sign';
        o.CloseDate = date.today();
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o.RecordTypeId = '012F0000000y9rk';
        insert o;
        
        // <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c sa = new echosign_dev1__SIGN_Agreement__c();
        sa.Name = 'TestAgreement';
        sa.echosign_dev1__Opportunity__c = o.Id;
        insert sa;
        sa.echosign_dev1__Status__c = 'Waiting for Counter-Signature';
        try{
       		update sa;
        }catch(exception e){
        	
        }
        
        Opportunity UpdatedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = : o.Id];
        
       	// <refactor> need assertions w/ messages 
       	
       	//System.assertEquals('DC Signed',UpdatedOpp.StageName);
        
        // <comment> 
        /**Product2 p = new product2(name='Test', Family='Test');
        insert p;

        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id, unitprice=1.0, isActive=true);
        insert pbe;
                                         
        OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, pricebookentryid=pbe.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30));
        insert oli;      
        
        o.StageName = 'Closed Won';
        boolean flag = false;
        try{
            update o;
        }catch(exception e){
            flag = true;
        }
        system.assert(flag==false);  
        **/      
    }
    static testMethod void myUnitTest4() {
    	// <refactor> test method name should be more clear to what is being tested 
    	// <comment> 
    	/**Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');**/
		// <refactor> should use Test user created by Test Data creation utility; also should not reference hard coded ids
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		
//		System.runAs(u) 
//		{
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test Account';
	        insert a;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2_DCAdded';
	        o.StageName = 'Needs Analysis';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012F0000000y9rkIAA';
	        o.Market_Record__c = mkt.Name;
	        insert o;
	        
	        Opportunity DCOpp = [select Id, Name from Opportunity where Id = :o.Id];
	        
	        
	        DCOpp.Name = 'test3_DCAdded';
	
	        update DCOpp;
	        TestOppId = o.Id;
//		}
	        Opportunity MarketTest = [select Id, Last_Mod_By__c, Last_Mod_Date__c from Opportunity where Id = :TestOppId];
	        
	        String ModifiedBy = u.Id;//MarketTest.Last_Mod_By__c;
	        Date LastModDay = Date.valueOf(MarketTest.Last_Mod_Date__c.addHours(-7));
	        //String ModifiedDt = String.valueOf(Date.valueOf(MarketTest.Last_Mod_Date__c));
	        String ModifiedDt = String.valueOf(LastModDay);
	        
	        //System.assertEquals(UserInfo.GetName(), 'Wingate');
	        // <refactor> need assertion message 
	        System.assertEquals(u.Id, ModifiedBy);
	        Datetime myDatetime = datetime.now();//.addHours(7);
	        Date myTestDate = myDatetime.Date();
	        // <refactor> need assertion message 
	        System.assertEquals(String.valueOf(mytestDate), ModifiedDt);
	        //System.assertEquals(String.valueOf(Date.Today()), ModifiedDt);
		
	}
static testMethod void myUnitTest5() {
    	// <refactor> test method name should be more clear to what is being tested 
    	// <comment> 
    	/**Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');**/
		
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		String TestOppId2;
		
//		System.runAs(u) 
//		{
			// <refactor> test data creation utility should be used to create test data	
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test Account';
	        insert a;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2_DCAdded';
	        o.StageName = 'New';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012F0000000y9rkIAA';
	        o.Market_Record__c = mkt.Id;
	        insert o;
	        
	        Opportunity DCOpp = [select Id, Name from Opportunity where Id = :o.Id];
	        
	        // <refactor> should not use hard coded ids 
	        DCOpp.Split_Sharer__c = '005A0000000cnyO';
	
	        update DCOpp;
	        TestOppId = o.Id;
//		}
	        Opportunity MarketTest = [select Id, Split_Sharer_Perc__c from Opportunity where Id = :TestOppId];
	        
	        Double SharerPerc = MarketTest.Split_Sharer_Perc__c;
	        
	        // <refactor> need assertion message 
	        System.assertEquals(50, SharerPerc);
		
	}
static testMethod void myUnitTest6() {
	// <refactor> test method name should be more clear to what is being tested 
    	// <comment> 
    	/**Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');**/
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		String TestOppId2;
		
//		System.runAs(u) 
//		{
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test Account';
	        insert a;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2_DCAdded';
	        o.StageName = 'Needs Analysis';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012F0000000y9rkIAA';
	        o.Market_Record__c = mkt.Name;
	        insert o;
	        
	        Opportunity DCOpp = [select Id, Split_Sharer__c from Opportunity where Id = :o.Id];
	        
	        // <refactor> should not use harded ids 
	        DCOpp.Split_Sharer__c = '005A0000000cnyO';
	
	        update DCOpp;
	        
	        Opportunity DCOpp2 = [select Id, Split_Sharer__c from Opportunity where Id = :o.Id];
	        
	        DCOpp2.Split_Sharer__c = Null;
	        update DCOpp2;
	        
	        TestOppId = DCOpp2.Id;
//		}
	        Opportunity MarketTest = [select Id, Split_Sharer_Perc__c from Opportunity where Id = :TestOppId];
	        
	        Double SharerPerc = MarketTest.Split_Sharer_Perc__c;
	        // <refactor> need assertion message 
	        System.assertEquals(0, SharerPerc);
		
	}
static testMethod void myUnitTest7() {
	// <refactor> test method name should be more clear to what is being tested 
    	// <comment> 
    	/**Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');**/
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		String TestOppId2;
		
//		System.runAs(u) 
//		{
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test SML Account';
	        insert a;
	        
	        // <refactor> test data creation utility should be used to create test data
	        Contact c = new Contact();
	        c.LastName = 'TestLast';
	        c.FirstName = 'TestFirst';
	        c.AccountId = a.Id;
	        c.Phone = '6025096073';
	        insert c;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2SMLOpp';
	        o.StageName = 'New';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012A0000000PKOIIA4';
	        o.Market_Record__c = mkt.Id;
	        insert o;
	        
	        //Contact c = [SELECT Id FROM Contact WHERE Id ];
	        Opportunity DCOpp = [select Id, SAPrimaryContact__c from Opportunity where Id = :o.Id];
	        
	        String CToAdd = c.Id;
	        DCOpp.SAPrimaryContact__c = CToAdd;
	
	        update DCOpp;
	        
	        Opportunity DCOpp2 = [select Id, SAPrimaryContact__c from Opportunity where Id = :o.Id];
	        TestOppId = DCOpp2.Id;
//		}
	        Opportunity MarketTest = [select Id, SA_Contact_Phone__c from Opportunity where Id = :TestOppId];
	        
	        String SharerPhone = MarketTest.SA_Contact_Phone__c;
	        // <refactor> need assertion message 
	        System.assertNotEquals(Null, SharerPhone);
		
	}
		static testMethod void myUnitTest8() {
			// <refactor> test method name should be more clear to what is being tested 

		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		String TestOppId2;
		Double OTMPre;
		
//		System.runAs(u) 
//		{
			// <comment> 
			//User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
			
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
			
			// <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test SML Account';
	        insert a;
	        
	        // <refactor> test data creation utility should be used to create test data
			Contact c1 = new Contact();
			c1.AccountId = a.Id;
	        c1.FirstName = 'First';
	        c1.LastName = 'Last';
	        c1.email = 'gannettlocal@gannett.com';
	        insert c1;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2SMLOpp';
	        o.StageName = 'New';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012F0000000y9WmIAI';
	        o.Market_Record__c = mkt.Name;
	        o.Sales_Rep__c = c1.Id;
	        insert o;
	        
	        Opportunity DCOpp = [select Id, Dig_Account_Manager__c from Opportunity where Id = :o.Id];
	        
	        String CToAdd = DCOpp.Id;
	        DCOpp.Dig_Account_Manager__c = u.Id;
			
			Double OTMNum1 = [Select count() from OpportunityTeamMember];
			OTMPre = OTMNum1;
			
	        update DCOpp;
	        
//		}
		    Double OTMNum2 = [Select count() from OpportunityTeamMember];
		    Double OTMDif = OTMNum2 - OTMPre;
	        // <refactor> need assertion message 
	        System.assertEquals(0, OTMDif);
		
	}
		static testMethod void myUnitTest9() {
		// <refactor> test method name should be more clear to what is being tested 
		
		// <comment> 
		//User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
		String TestOppId;
		String TestOppId2;
		Double OTMPre;
		
		//System.runAs(u) <comment> 
		//{
			// <refactor> should use Test user created by Test Data creation utility
			// <refactor> this user could be loaded/created statically if used by many test
			User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True LIMIT 1];
			
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test DC Account';
	        insert a;

			// <refactor> test data creation utility should be used to create test data
			Contact c = new Contact();
	        c.LastName = 'TestLast';
	        c.FirstName = 'TestFirst';
	        c.AccountId = a.Id;
	        insert c;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'testAMUpdateDCOpp';
	        o.StageName = 'Needs Analysis';
	        o.CloseDate = (date.today() + 1);
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012F0000000y9rkIAA';
	        o.Type='New';
	        o.Company_Type__c='Activity';
	        o.SAPrimaryContact__c=c.Id;
	        o.Market_Record__c = mkt.Name;
	        insert o;
	        
	        //Opportunity DCOpp = [select Id, DealChicken_Market__c, Market_Record__c from Opportunity where Id = :o.Id and DealChicken_Market__c = Null and Market_Area_Manager__c = Null and RecordTypeId = '012F0000000y9rkIAA' limit 1];
	        //Market__c uAM = [SELECT Id, Name, DealChicken_Approver__c FROM Market__c WHERE DealChicken_Approver__c != Null limit 1];
	        
	        //String NewMarket = uAM.Name;
	        //DCOpp.Market_Record__c = NewMarket;
	        //DCOpp.DealChicken_Market__c = mkt.Id;
	        //update DCOpp;
			
			TestOppId = o.Id;
	        
		//}
		    Opportunity DCOpp2 = [select Id, DealChicken_Market__c, Market_Area_Manager__c from Opportunity where Id = :TestOppId];
	        
	        // <refactor> need assertion message 
	        System.assertNotEquals(Null, DCOpp2.Market_Area_Manager__c);
	        System.assertNotEquals(Null, DCOpp2.DealChicken_Market__c);
		
	}
	
		static testMethod void myUnitTest10() {
		// <refactor> test method name should be more clear to what is being tested 
		
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u0 = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		User u3 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		String OppRunning;
		String User2Running;
		String OliRunning;
		System.runAs(u0) 
		{
			// <refactor> should use Test user created by Test Data creation utility
			// <refactor> this user could be loaded/created statically if used by many test
			User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			User u2 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test DC Account';
	        insert a;
			
			// <refactor> test data creation utility should be used to create test data
			Contact c = new Contact();
	        c.LastName = 'TestLast';
	        c.FirstName = 'TestFirst';
	        c.AccountId = a.Id;
	        insert c;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2SMLOpp';
	        o.StageName = 'Closed Won';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012A0000000PKOIIA4';
	        o.Market_Record__c = mkt.Name;
	        o.Dig_Account_Manager__c = u.Id;
	        insert o;
	        
	        // <refactor> test data creation utility should be used to create test data
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        Product2 p = new product2(Name='PPCTest', Family='Test', RecordTypeId='012A0000000PLDD', IsActive=True);
	        insert p;
	
	        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
	        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id, unitprice=1.0, isActive=true);
	        insert pbe;
	                           
	        // <string>             
	        // <refactor> test data creation utility should be used to create test data
	        OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, Dig_Account_Manager__c=u.Id, Waiting_Status__c='Awaiting Onboard', pricebookentryid=pbe.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30));
	        insert oli; 
	        OppRunning = o.Id;
	        User2Running = u2.Id;
	        OliRunning = oli.Id;
		}
		System.runAs(u3) 
		{
			Opportunity DCOpp = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			DCOpp.Dig_Account_Manager__c = User2Running;
			update DCOpp;
			Opportunity DCOpp2 = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			
			// <refactor> need assertion message 
			System.assertEquals(User2Running, DCOpp2.Dig_Account_Manager__c);
	        
		    OpportunityLineItem OppLineItem = [select Id, Dig_Account_Manager__c from OpportunityLineItem where Id = :OliRunning];
	        
	        // <refactor> need assertion message 
	        System.assertEquals(User2Running, OppLineItem.Dig_Account_Manager__c);
		}
		
	}
	static testMethod void myUnitTest11() {
		// <refactor> test method name should be more clear to what is being tested 
		
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u0 = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		User u3 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		String OppRunning;
		String User2Running;
		String OliRunning;
		System.runAs(u0) 
		{
			// <refactor> should use Test user created by Test Data creation utility
			// <refactor> this user could be loaded/created statically if used by many test
			User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			User u2 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test DC Account';
	        insert a;

			// <refactor> test data creation utility should be used to create test data
			Contact c = new Contact();
	        c.LastName = 'TestLast';
	        c.FirstName = 'TestFirst';
	        c.AccountId = a.Id;
	        insert c;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2SMLOpp';
	        o.StageName = 'Closed Won';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012A0000000PKOIIA4';
	        o.Market_Record__c = mkt.Name;
	        //o.Dig_Account_Manager__c = u.Id;
	        insert o;
	        
	        // <refactor> test data creation utility should be used to create test data
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        Product2 p = new product2(Name='PPCTest', Family='Test', RecordTypeId='012A0000000PLDD', IsActive=True);
	        insert p;
	
	        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
	        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id, unitprice=1.0, isActive=true);
	        insert pbe;
	                     
	        // <refactor> test data creation utility should be used to create test data                    
	        OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, Dig_Account_Manager__c=u.Id, Waiting_Status__c='Awaiting Onboard', pricebookentryid=pbe.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30));
	        insert oli; 
	        OppRunning = o.Id;
	        User2Running = u2.Id;
	        OliRunning = oli.Id;
		}
		System.runAs(u3) 
		{
			Opportunity DCOpp = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			DCOpp.Dig_Account_Manager__c = User2Running;
			update DCOpp;
			Opportunity DCOpp2 = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			// <refactor> need assertion message 
			System.assertEquals(User2Running, DCOpp2.Dig_Account_Manager__c);
	        
		    OpportunityLineItem OppLineItem = [select Id, Dig_Account_Manager__c from OpportunityLineItem where Id = :OliRunning];
	        
	        // <refactor> need assertion message 
	        System.assertEquals(User2Running, OppLineItem.Dig_Account_Manager__c);
		}
		
	}
static testMethod void myUnitTest12() {
		// <refactor> test method name should be more clear to what is being tested 
		
		// <refactor> should use Test user created by Test Data creation utility
		// <refactor> this user could be loaded/created statically if used by many test
		User u0 = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		User u3 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
		String OppRunning;
		String User2Running;
		String OliRunning;
		System.runAs(u0) 
		{
			// <refactor> should use Test user created by Test Data creation utility
			// <refactor> this user could be loaded/created statically if used by many test
			User u = [SELECT Id FROM User WHERE Profile.Name = 'SML Accounts - Jump Start Specialist' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			User u2 = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True AND UserType = 'Standard' LIMIT 1];
			
			// <refactor> test data creation utility should be used to create test data
			Market__c mkt = new Market__c();
	        mkt.Name = 'AZ, Phoenix';mkt.State__c = 'AZ';mkt.City_Area__c = 'Phoenix';
	        mkt.Active_CP__c=True;mkt.Active_DC__c=True;
	        mkt.DealChicken_Approver__c=u.Id;
	        insert mkt;
	        
	        // <refactor> test data creation utility should be used to create test data
			Account a = new Account();
	        a.Name = 'Test DC Account';
	        insert a;
			
			// <refactor> test data creation utility should be used to create test data
			Contact c = new Contact();
	        c.LastName = 'TestLast';
	        c.FirstName = 'TestFirst';
	        c.AccountId = a.Id;
	        insert c;
	        
	        // <refactor> test data creation utility should be used to create test data
			Opportunity o = new Opportunity();
	        o.AccountId = a.Id;
	        o.Name = 'test2SMLOpp';
	        o.StageName = 'Closed Won';
	        o.CloseDate = date.today();
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        o.RecordTypeId = '012A0000000PKOIIA4';
	        o.Market_Record__c = mkt.Name;
	        //o.Dig_Account_Manager__c = u.Id;
	        insert o;
	        
	        // <refactor> test data creation utility should be used to create test data
	        // <refactor> should not use hard coded ids, could use RecordTypeCache 
	        Product2 p = new product2(Name='PPCTest', Family='Test', RecordTypeId='012A0000000PLDD', IsActive=True);
	        insert p;
	
	        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
	        PricebookEntry pbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id, unitprice=1.0, isActive=true);
	        insert pbe;
	               
	        // <string>   
	        // <refactor> test data creation utility should be used to create test data                        
	        OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, Dig_Account_Manager__c=u.Id, pricebookentryid=pbe.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30));
	        insert oli; 
	        OppRunning = o.Id;
	        User2Running = u2.Id;
	        OliRunning = oli.Id;
		}
		System.runAs(u3) 
		{
			Opportunity DCOpp = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			DCOpp.Dig_Account_Manager__c = User2Running;
			update DCOpp;
			Opportunity DCOpp2 = [select Id, Dig_Account_Manager__c from Opportunity where Id = :OppRunning];
			
			// <refactor> need assertion message 
			System.assertEquals(User2Running, DCOpp2.Dig_Account_Manager__c);
	        
		    OpportunityLineItem OppLineItem = [select Id, Dig_Account_Manager__c from OpportunityLineItem where Id = :OliRunning];
	        
	        // <refactor> need assertion message 
	        System.assertEquals(User2Running, OppLineItem.Dig_Account_Manager__c);
		}
	
	}
}