//<PWP> No Tests of functionality

@isTest
private class test_whooshHandler {

	// <refactor> use better testmethod names for clarity 
    static testMethod void myUnitTest() {
    	
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('JSONWhooshResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        // <comment>
        /*** <PWP> Good effort on the RecordType matching, but mine (RecordTypeCache) is better ;-) Delete once verified
        //Replace the word contact with whichever object you would like to find the record type ID for.
		Map <String,Schema.RecordTypeInfo> recordTypes = Case.sObjectType.getDescribe().getRecordTypeInfosByName();

 		//Get the record type ID of from the Map based on the Name, replace RecordTypeString with whatever the record type's name is 
		ID recTypeId = recordTypes.get('GL Digital Audit').getRecordTypeId();
		</PWP>***/
		
		RecordType rtCaseDigAudit = RecordTypeCache.getRecordType('Case', 'GL_Digital_Audit');
	
		// <refactor> test data creation utility should be used to create test data 
        Case c = new Case();
        c.RecordTypeId = rtCaseDigAudit.Id;
        c.Expected_Prod_Mix__c = 'Social Media';
        c.Status = 'Requested';
        c.W_Keyword_01__c = 'Test';
        c.W_Keyword_02__c = 'Test';
        c.W_Keyword_03__c = 'Test';
        c.W_Keyword_04__c = 'Test';
        c.W_Keyword_05__c = 'Test';
        c.W_Keyword_06__c = 'Test';
        c.W_Keyword_07__c = 'Test';
        c.W_Keyword_08__c = 'Test';
        c.W_Keyword_09__c = 'Test';
        c.W_Keyword_10__c = 'Test';
        insert c;
        
        test.startTest();
        	whooshHandler rh = new whooshHandler();
        	whooshHandler.updateWhooshResults(c.ID);
        test.stopTest();
        
        // <refactor> no assertions 
        //system.debug('RESPONSE BODY: ' + resp.getBody());
        
    }
}