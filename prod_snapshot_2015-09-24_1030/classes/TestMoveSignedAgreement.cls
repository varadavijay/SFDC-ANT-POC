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
private class TestMoveSignedAgreement {
	
	private static Blob body = Blob.valueOf('test');

    static testMethod void testSignedAgreement() {
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Signed');
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        EContract__c contract = [select Id from EContract__c where Agreement__c = :agreement.Id limit 1];
        // <refactor> needs an assertion message 
        System.assertNotEquals(null, contract) ;
        
        attachment = [select Id from Attachment where ParentId = :contract.Id limit 1];
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachment = [select Id from Attachment where ParentId = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce);
        //System.assertNotEquals(null, exce); <comment>
    }
    
    static testMethod void testSignedAgreementWithAccount() {
    	// <refactor> test data creation utility should be used to create test data
    	Account account = new Account(Name='test');
    	insert account;
    	
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Signed',echosign_dev1__Account__c=account.Id);
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        EContract__c contract = [select Id,Account__c from EContract__c where Agreement__c = :agreement.Id limit 1];
        // <refactor> needs an assertion message 
        System.assertEquals(account.Id, contract.Account__c);
        
        attachment = [select Id from Attachment where ParentId = :contract.Id limit 1];
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachment = [select Id from Attachment where ParentId = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce);
        //System.assertNotEquals(null, exce);  <comment>
    }
    
    static testMethod void testSignedAgreementWithOpp() {
    	// <refactor> test data creation utility should be used to create test data
		Opportunity opp = new Opportunity(Name='test_opportunity',CloseDate=Date.today(),StageName='Prospecting');
    	insert opp;
    	
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Signed',echosign_dev1__Opportunity__c=opp.Id);
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        EContract__c contract = [select Id,Opportunity__c from EContract__c where Agreement__c = :agreement.Id limit 1];
        // <refactor> needs an assertion message 
        System.assertEquals(opp.Id, contract.Opportunity__c);
        
        attachment = [select Id from Attachment where ParentId = :contract.Id limit 1];
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachment = [select Id from Attachment where ParentId = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce);
        //System.assertNotEquals(null, exce); <comment>
    }
    
    static testMethod void testSignedAgreementWithAccountOpp() {
    	// <refactor> test data creation utility should be used to create test data
    	Opportunity opp = new Opportunity(Name='test_opportunity',CloseDate=Date.today(),StageName='Prospecting');
    	insert opp;
    	
    	// <refactor> test data creation utility should be used to create test data
    	Account account = new Account(Name='test');
    	insert account;
    	
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Signed',echosign_dev1__Account__c=account.Id,echosign_dev1__Opportunity__c=opp.Id);
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        EContract__c contract = [select Id,Account__c,Opportunity__c from EContract__c where Agreement__c = :agreement.Id limit 1];
        // <refactor> needs an assertion message 
        System.assertEquals(account.Id, contract.Account__c);
        System.assertEquals(opp.Id, contract.Opportunity__c);
        
        attachment = [select Id from Attachment where ParentId = :contract.Id limit 1];
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachment = [select Id from Attachment where ParentId = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce);
        //System.assertNotEquals(null, exce); 
    }
    
   	static testMethod void testNullStatusAgreement() {
   		// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c=null);
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	EContract__c contract = [select Id from EContract__c where Agreement__c = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertNotEquals(null, exce); 
    }
    
    static testMethod void testDraftStatusAgreement() {
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Draft');
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	EContract__c contract = [select Id from EContract__c where Agreement__c = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertNotEquals(null, exce); 
    }
 
     static testMethod void testRejectedAgreement() {
     	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Cancelled / Declined');
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        Attachment attachment = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        insert attachment;
        
        EContract__c contract = [select Id from EContract__c where Agreement__c = :agreement.Id limit 1];
        // <refactor> needs an assertion message 
        System.assertNotEquals(null, contract) ;
        
        attachment = [select Id from Attachment where ParentId = :contract.Id limit 1];
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachment = [select Id from Attachment where ParentId = :agreement.Id limit 1];
        } catch(Exception e) {
        	exce = e;
        }
        //System.assertNotEquals(null, exce); <comment>
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce); 
    }   
    
    static testMethod void testSignedBulkAgreement() {
    	// <refactor> test data creation utility should be used to create test data
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c(Name='test',echosign_dev1__Status__c='Signed');
        insert agreement;
        
        // <refactor> test data creation utility should be used to create test data
        List<Attachment> attachments = new List<Attachment>();
        
        Attachment attachment1 = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        attachments.add(attachment1);
        
      	Attachment attachment2 = new Attachment(Name='agreement-doc.pdf',Description='Test description',ParentId=agreement.Id,Body=body);
        attachments.add(attachment2);
        
        insert attachments;
        
        List<EContract__c> contracts = [select Id from EContract__c where Agreement__c = :agreement.Id];
        // <refactor> needs an assertion message 
        System.assertNotEquals(null, contracts);
        System.assertEquals(1, contracts.size());
        
        attachments = [select Id from Attachment where ParentId = :contracts.get(0).Id];
        // <refactor> needs an assertion message 
        System.assertNotEquals(null, attachments);
        System.assertEquals(2, attachments.size());
        
        // <refactor> single SOQL query should not be put in a try; catch; block 
        Exception exce;
        try {
        	attachments = [select Id from Attachment where ParentId = :agreement.Id];
        } catch(Exception e) {
        	exce = e;
        }
        // <refactor> what is this asserting ? needs an assertion message 
        System.assertEquals(null, exce); 
    }

}