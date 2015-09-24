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
private class beforeonCase_tstclass {

    static testMethod void testBeforeCaseTrigger0() {
    	// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9779';
        c.AccountId = a.Id;
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c2 = new Contact();
        c2.FirstName = 'Not';
        c2.LastName = 'In List';
        c2.Phone = '(402) 968-7777';
        c2.AccountId = a.Id;
        insert c2;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.AccountId = a.Id;
        o1.Affl_Sales_Rep__c = c2.Id;
        o1.Subject = 'Test1Subject';
        o1.ContactId = c.Id;
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9779';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE7e';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        
        Case testCaseAfter = [SELECT Id, AccountId, ContactId from Case WHERE Id = :o1.Id];
        //system.assertequals(a.Id,testCaseAfter.AccountId); <comment>
        // <refactor> need assertion message
        system.assertequals(a.Id,testCaseAfter.AccountId);
        system.assertequals(c.Id,testCaseAfter.ContactId);
        
    }
    static testMethod void testBeforeCaseTrigger1() {
    	// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(402) 968-9669';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9668';
        c.AccountId = a.Id;
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c2 = new Contact();
        c2.FirstName = 'Not';
        c2.LastName = 'In List';
        c2.Phone = '(402) 968-7777';
        c2.AccountId = a.Id;
        insert c2;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.AccountId = a.Id;
        o1.Affl_Sales_Rep__c = c2.Id;
        o1.Subject = 'Test1Subject';
        o1.ContactId = c.Id;
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9668';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE7e';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        Case testCaseAfter = [SELECT Id, AccountId, ContactId FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals(a.Id,testCaseAfter.AccountId);
        system.assertequals(c.Id,testCaseAfter.ContactId);
        
    }
    static testMethod void testBeforeCaseTrigger2() {
    	
          Profile theProfile = [SELECT Id from Profile WHERE Name = 'GL Care Profile']; 
    	
    	// <refactor> test data creation utility should be used to create test data
		  User u1=new User
		     (LastName             = 'Smith',
		      FirstName            = 'Michael',
		      Alias                = 'msmith',
		      Email                = 'msmith@dc.com',
		      Username             = 'msmith@dc.com.michael',
		      CommunityNickname    = 'msmith',
              ProfileId            =  theProfile.Id, 
              EmailEncodingKey     = 'UTF-8',
              TimeZoneSidKey       = 'America/Los_Angeles',
              LocaleSidKey         = 'en_US',
              LanguageLocaleKey    = 'en_US',
              ReceivesInfoEmails   =  False,
              Phone                = '3042333703',
              Street               = '411 Grant St.',
              City                 = 'McMechen',
              State                = 'WV',
              Country              = 'USA',
              IsActive             = true,
              Title                = 'Vice President',
              Department           = 'T.P.');
              
		      insert u1;
		      
		  // <refactor> test data creation utility should be used to create test data
		  User u2=new User
		     (LastName             = 'Smith',
		      FirstName            = 'Bruce',
		      Alias                = 'bsmith',
		      Email                = 'bsmith@dc.com',
		      Username             = 'bsmith@dc.com.bruce',
		      CommunityNickname    = 'bsmith',
              ProfileId            =  theProfile.Id, 
              EmailEncodingKey     = 'UTF-8',
              TimeZoneSidKey       = 'America/Los_Angeles',
              LocaleSidKey         = 'en_US',
              LanguageLocaleKey    = 'en_US',
              ReceivesInfoEmails   =  False,
              Phone                = '3042333703',
              Street               = '411 Grant St.',
              City                 = 'McMechen',
              State                = 'WV',
              Country              = 'USA',
              IsActive             = true,
              Title                = 'Sales Representative',
              Department           = 'T.P.');
              
		      insert u2;
		      
		// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

		// <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9668';
        c.AccountId = a.Id;
        insert c;
       
       // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.OwnerId = '005F0000001zvU1';//'005A0000000cnyO';
        o1.OwnerId = u1.id;
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9669';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        insert o1;
        
        Case Case1 = [SELECT Id, OwnerId FROM Case WHERE Id = :o1.Id];
        Case1.OwnerId = u2.id;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        update Case1;
        
        Case Case2 = [SELECT Id, Owned_Stamp__c FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        //system.assertNotEquals(Null,Case2.Owned_Stamp__c);      
    }
    static testMethod void testBeforeCaseTrigger3() {

          Profile theProfile = [SELECT Id from Profile WHERE Name = 'GL Care Profile']; 
    	
    	// <refactor> test data creation utility should be used to create test data
		  User u1=new User
		     (LastName             = 'Smith',
		      FirstName            = 'Michael',
		      Alias                = 'msmith',
		      Email                = 'msmith@dc.com',
		      Username             = 'msmith@dc.com.michael',
		      CommunityNickname    = 'msmith',
              ProfileId            =  theProfile.Id, 
              EmailEncodingKey     = 'UTF-8',
              TimeZoneSidKey       = 'America/Los_Angeles',
              LocaleSidKey         = 'en_US',
              LanguageLocaleKey    = 'en_US',
              ReceivesInfoEmails   =  False,
              Phone                = '3042333703',
              Street               = '411 Grant St.',
              City                 = 'McMechen',
              State                = 'WV',
              Country              = 'USA',
              IsActive             = true,
              Title                = 'Vice President',
              Department           = 'T.P.');
              
		      insert u1;
		      
		  // <refactor> test data creation utility should be used to create test data
		  User u2=new User
		     (LastName             = 'Smith',
		      FirstName            = 'Bruce',
		      Alias                = 'bsmith',
		      Email                = 'bsmith@dc.com',
		      Username             = 'bsmith@dc.com.bruce',
		      CommunityNickname    = 'bsmith',
              ProfileId            =  theProfile.Id, 
              EmailEncodingKey     = 'UTF-8',
              TimeZoneSidKey       = 'America/Los_Angeles',
              LocaleSidKey         = 'en_US',
              LanguageLocaleKey    = 'en_US',
              ReceivesInfoEmails   =  False,
              Phone                = '3042333703',
              Street               = '411 Grant St.',
              City                 = 'McMechen',
              State                = 'WV',
              Country              = 'USA',
              IsActive             = true,
              Title                = 'Sales Representative',
              Department           = 'T.P.');
              
		      insert u2;
		
		// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

		// <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9668';
        c.AccountId = a.Id;
        insert c;
       
       // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.OwnerId = '005F0000001zvU1';//'005A0000000cnyO';
        o1.OwnerId = u1.id;
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9669';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yDXz';    //The trigger is not coded for this Recordtype to pass.
        o1.Status = 'Unopened';
        insert o1;
        
        Case Case1 = [SELECT Id, OwnerId, Status, Root_Cause_Overall__c, Root_Cause_Primary__c, Root_Cause_Secondary__c FROM Case WHERE Id = :o1.Id];
        //Case1.OwnerId = '005A0000000cnyO';
        Case1.OwnerId = u2.id;
        Case1.Root_Cause_Overall__c = 'People';
        Case1.Root_Cause_Primary__c = 'People';
        Case1.Root_Cause_Secondary__c = 'Operations';
        Case1.Status = 'Invalid';
        Case1.Not_Care_Case_Reason__c = 'Other';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        update Case1;
        
        Case Case2 = [SELECT Id, Closed_Stamp__c FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertNotEquals(Null,Case2.Closed_Stamp__c);      
    }
    static testMethod void testBeforeCaseTrigger() {
    	// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(402) 968-9668';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        a.RecordTypeId = '012A0000000PKO9';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9668';
        c.AccountId = a.Id;
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        c.RecordTypeId = '012A0000000PKOA';
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9668';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE7e';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        Case testCaseAfter = [SELECT Id, AccountId, ContactId FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals(a.Id,testCaseAfter.AccountId);
        system.assertequals(c.Id,testCaseAfter.ContactId);
        
    }
    static testMethod void testBeforeCaseTrigger5() {
    	
    	// <refactor> test data creation utility should be used to create test data
        Lead l = new Lead();
        l.FirstName = 'Bob';
        l.LastName = 'Barker';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        l.RecordTypeId = '012F0000000y9lD';
        l.Phone = '(402) 968-9119';
        l.Affiliated_Sales_Rep__c = 'Bob Barkers Rep';
        l.Company = 'Barker Co';
        insert l;
        
        // <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(402) 968-1111';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        a.RecordTypeId = '012A0000000PKO9';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9119';
        c.AccountId = a.Id;
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        c.RecordTypeId = '012A0000000PKOA';
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9119';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yDth';
        insert o1;

		// <comment>
        //Case o2 = new Case();
        //o2.Affl_Sales_Rep__c = '003F000000y4o1V';
        //o2.Subject = 'Test1Subject';
        //o2.Company_Name__c = 'Test1CompanyName';
        //o2.Contact_Name__c = 'Test1ContactName';
        //o2.Contact_Phone__c = '(402) 968-9119';
        //o2.Product__c = 'PPC;SEO';
        //o2.Monthly_Spend__c = 5000;
        //o2.Description = 'Test1Description';
        //o2.RecordTypeId = '012F0000000yDXz';
        //insert o2;

		// <refactor> test data creation utility should be used to create test data
        Case o3 = new Case();
        //o3.Affl_Sales_Rep__c = '003F000000y4o1V'; <comment>
        o3.Affl_Sales_Rep__c = c.id;
        o3.Subject = 'Test1Subject';
        o3.Company_Name__c = 'Test1CompanyName';
        o3.Contact_Name__c = 'Test1ContactName';
        o3.Contact_Phone__c = '(402) 968-9119';
        o3.Product__c = 'PPC;SEO';
        o3.Monthly_Spend__c = 5000;
        o3.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o3.RecordTypeId = '012F0000000yDv9'; 
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o3;
        
        Case testCaseAfter = [SELECT Id, Subject, Digital_Lead__c, AccountId FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals(l.Id,testCaseAfter.Digital_Lead__c);
        system.assertequals(a.Id,testCaseAfter.AccountId);
        system.assertequals('Call Request - Test1CompanyName',testCaseAfter.Subject);
        
        // <comment>
        //Case testCaseAfter2 = [SELECT Id, Subject FROM Case WHERE Id = :o2.Id];
        //system.assertequals('Care Request - Test1CompanyName',testCaseAfter2.Subject);

        Case testCaseAfter3 = [SELECT Id, Subject FROM Case WHERE Id = :o3.Id];
        // <refactor> need assertion message
        system.assertequals('Rate Request - Test1CompanyName',testCaseAfter3.Subject);
        
    }
    static testMethod void testBeforeCaseTrigger6() {
    	// <refactor> test data creation utility should be used to create test data
        Lead l = new Lead();
        l.FirstName = 'Bob';
        l.LastName = 'Barker';
        l.RecordTypeId = '012F0000000y9lD';
        l.Phone = '(402) 968-9119';
        l.Affiliated_Sales_Rep__c = 'Bob Barkers Rep';
        l.Company = 'Barker Co';
        insert l;
        
        // <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(402) 968-1111';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        a.RecordTypeId = '012A0000000PKO9';
        insert a;
		
		// <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9119';
        c.AccountId = a.Id;
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        c.RecordTypeId = '012A0000000PKOA';
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9119';
        o1.Product__c = 'PPC;SEO';
        o1.Monthly_Spend__c = 5000;
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE0n';
        o1.GLO_RepDash_FName__c = 'Michael';
        insert o1;

		// <refactor> test data creation utility should be used to create test data
        Case o2 = new Case();
        //o2.Affl_Sales_Rep__c = '003F000000y4o1V';
        o2.Affl_Sales_Rep__c = c.id;
        o2.Subject = 'Test1Subject';
        o2.Company_Name__c = 'Test1CompanyName';
        o2.Contact_Name__c = 'Test1ContactName';
        o2.Contact_Phone__c = '(402) 968-1111';
        o2.Product__c = 'PPC;SEO';
        o2.Monthly_Spend__c = 5000;
        o2.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o2.RecordTypeId = '012F0000000yE0n';
        insert o2;
		
		// <refactor> test data creation utility should be used to create test data
        Case o3 = new Case();
        //o3.Affl_Sales_Rep__c = '003F000000y4o1V';
        o3.Affl_Sales_Rep__c = c.id;
        o3.Subject = 'Test1Subject';
        o3.Company_Name__c = 'Test1CompanyNameOnBoard';
        o3.Contact_Name__c = 'Test1ContactName';
        o3.Contact_Phone__c = '(402) 968-2222';
        o3.Product__c = 'PPC;SEO';
        o3.Monthly_Spend__c = 5000;
        o3.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o3.RecordTypeId = '012F0000000yE0n';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o3;
        
        Case testCaseAfter = [SELECT Id, Subject, Digital_Lead__c FROM Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals(l.Id,testCaseAfter.Digital_Lead__c);
        system.assertequals('OnBoard - Test1CompanyName',testCaseAfter.Subject);
        
        Case testCaseAfter2 = [SELECT Id, Subject, AccountId FROM Case WHERE Id = :o2.Id];
        // <refactor> need assertion message
        system.assertequals(a.Id,testCaseAfter2.AccountId);
        system.assertequals('OnBoard - Test1CompanyName',testCaseAfter2.Subject);

        Case testCaseAfter3 = [SELECT Id, Subject, AccountId FROM Case WHERE Id = :o3.Id];
        Account testAcctAfter3 = [SELECT Id FROM Account WHERE Name = 'Test1CompanyNameOnBoard'];
        
        // <refactor> need assertion message
        system.assertequals('OnBoard - Test1CompanyNameOnBoard',testCaseAfter3.Subject);
        system.assertequals(testCaseAfter3.AccountId,testAcctAfter3.Id);
        
    }
    static testMethod void testBeforeCaseTrigger7() {
    	// <refactor> test data creation utility should be used to create test data
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Contact c = new Contact();
        c.FirstName = 'TestFirstName';
        c.LastName = 'TestLastName';
        c.Phone = '(402) 968-9779';
        c.AccountId = a.Id;
        insert c;
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Affl_Sales_Rep__c = c.id;
        o1.Subject = 'Test1Subject';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9779';
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE7e';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        Case testCaseAfter4 = [SELECT Id, Subject, AccountId, ContactId from Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals('Audit Request - Test1CompanyName',testCaseAfter4.Subject);        
    }
    
    static testMethod void testBeforeCaseTrigger8() {
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Subject = 'Audit Request - Test1CompanyName';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9779';
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yE0n';
        o1.Digital_Lead__c = NULL;
        o1.AccountId       = NULL;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        Case testCaseAfter5 = [SELECT Id, Subject from Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals('OnBoard - Test1CompanyName',testCaseAfter5.Subject);        
    }
    
    static testMethod void testBeforeCaseTrigger9() {
        
        // <refactor> test data creation utility should be used to create test data
        Case o1 = new Case();
        //o1.Affl_Sales_Rep__c = '003F000000y4o1V';
        o1.Subject = 'Audit Request - Test1CompanyName';
        o1.Company_Name__c = 'Test1CompanyName';
        o1.Contact_Name__c = 'Test1ContactName';
        o1.Contact_Phone__c = '(402) 968-9779';
        o1.Description = 'Test1Description';
        // <refactor> should not use hard coded ids, could use RecordTypeCache 
        o1.RecordTypeId = '012F0000000yFra';
        o1.Digital_Lead__c = NULL;
        o1.AccountId       = NULL;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert o1;
        
        Case testCaseAfter6 = [SELECT Id, Subject from Case WHERE Id = :o1.Id];
        // <refactor> need assertion message
        system.assertequals('Product Enhancement',testCaseAfter6.Subject);        
    }
}