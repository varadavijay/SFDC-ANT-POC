//CC Ph2 Test Class - not only not named to identify it as such, but actually has "Class" in it's name
// Rename Test Methods to be meaningful

@isTest
private class afteronCase_Class {
	static testMethod void testAfterCaseTrigger() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();
		
		// <refactor> test data creation utility should be used to create test data 
		Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data 
        Opportunity o1 = new Opportunity();
        o1.AccountId = a.Id;
        o1.Name = 'Test Opp 1';
        o1.StageName = 'Booked Appointment';
        o1.CloseDate = date.today().addDays(2);
        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
        insert o1;
        
        // <refactor> test data creation utility should be used to create test data 
        Case c1 = new Case();
        c1.Affl_Sales_Rep__c = Constants.NOT_IN_LIST_CONTACT.id;
        c1.Subject = 'Test1Subject';
        c1.Company_Name__c = 'Test1CompanyName';
        c1.Contact_Name__c = 'Test1ContactName';
        c1.Contact_Phone__c = '(402) 968-9779';
        c1.Product__c = 'PPC;SEO';
        c1.Monthly_Spend__c = 5000;
        c1.Description = 'Test1Description';
        c1.Notify_Email_1__c = 'bobtest@test.com'; // <refactor> could use constants 
        
        insert c1;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        c1.Opportunity__c = o1.Id;
        update c1;
        
        Opportunity testOppAfter = [SELECT Id, Notify_Email_1__c FROM Opportunity WHERE Id = :o1.Id];
        // <refactor> needs an errror message to describe the problem
        system.assertequals('bobtest@test.com',testOppAfter.Notify_Email_1__c);
        
	}
}