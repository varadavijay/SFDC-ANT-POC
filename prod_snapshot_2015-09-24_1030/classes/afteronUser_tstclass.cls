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
private class afteronUser_tstclass {
	
	// <comment>
	// <deletefile>
	// <CC> no *active* calls to this commented out code  </CC>

/***************  BEGIN FULL CLASS COMMENT *****************
	// <refactor> rename testMethod for clarity ?
    static testMethod void myUnitTest() {
        User u = new User();
        u.FirstName = 'Bob';
        u.LastName = 'Floth';
        u.Alias = 'bflot';
        u.Email = 'bfloth@gannett.com';
        u.Username = 'bfloth@gannett.com';
        u.CommunityNickname = 'flothed';
        u.UserRoleId = '00EF0000000VKpX'; // <refactor> do not use hard coded Ids
        u.ProfileId = '00eF0000000eAjh'; // <refactor> do not use hard coded Ids
        u.timezonesidkey = 'America/Phoenix';
        u.localesidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        
        
        insert u; // <refactor> Why is this User created ? 
        
        //List<KPIRep__c> testKPIAfter = new List<KPIRep__c>();
        // <refactor> do not use hard coded Ids
        KPIRep__c testKPIAfter = [SELECT Id, Name FROM KPIRep__c WHERE User__c = '005F0000001zyuhIAA'];
        
		testKPIAfter.Name = 'Jay Gussaks';
		
		// <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
		update testKPIAfter;
        Integer MyTest1 = [select count() from KPIRep__c where User__c = :testKPIAfter.Id];
        system.assertequals(1,MyTest1);

    }

**************  END FULL CLASS COMMENT ******************/
}