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
private class TestleadSurveyTrigger {

    static testMethod void testLeadInsert() {
        
        // <refactor> test data creation utility should be used to create test data 
        Lead nLead = new Lead();
        nLead.LastName = 'test lead';
        nLead.RecordTypeId = RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id;
        nLead.Company = 'test';
        nLead.Email = 'test.email@gannett.com';
        nLead.Street = '123 W Test Dr';
        nLead.City = 'Phoenix';
        nLead.PostalCode = '85016';
        nLead.State = 'AZ';
        nLead.Country = 'United States';
        insert nLead;
        
        // <refactor> test data creation utility should be used to create test data 
        Case case1 = new Case();
        case1.Affl_Sales_Rep__c = Constants.NOT_IN_LIST_CONTACT.id;
        case1.Subject = 'Test1Subject';
        case1.Company_Name__c = 'Test1CompanyName';
        case1.Contact_Name__c = 'Test1ContactName';
        case1.Contact_Phone__c = '(402) 968-9779';
        case1.Product__c = 'PPC;SEO';
        case1.Monthly_Spend__c = 5000;
        case1.Description = 'Test1Description';
        case1.Digital_Lead__c = nLead.Id;
        insert case1;
         
         // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
         Database.Leadconvert convrtLd =new Database.Leadconvert ();
         convrtLd.setLeadId(nLead.Id);
         convrtLd.setConvertedStatus('Sales Qualified (SQL)');
         Database.Leadconvertresult lcRes = Database.convertLead(convrtLd, true);
         
         Id accountId = lcRes.getAccountId(); 
         
         // <refactor> needs an errror message to describe the problem
         System.assertEquals(accountId, [Select AccountId From Case Where Id =: case1.Id].AccountId );
         //System.assertEquals(contactId, [Select Contact__c From Survey_Results__c Where Id =: sr2.Id].Contact__c );
    }
}