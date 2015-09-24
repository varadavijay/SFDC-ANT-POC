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
 **/
@isTest
private class afteronAccount_Class {
	
	// <comment>
	// <deletefile>
	// <CC> no *active* calls to this commented out code  </CC>


/****************  BEGIN FULL CLASS COMMENT *****************
	// <refactor> rename testMethod for clarity ?
    static testMethod void myUnitTest1() {
    	// <refactor> possibly use TestingUtils class for standardized data creation
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
        a.Account_Manager__c = '005A0000000cnyO'; // <refactor> do not use hard coded Ids
        update a;
        
        Integer TestCountOfTask = [SELECT count() from Task WHERE WhatId = :a.Id];
        
        System.assertEquals(1, TestCountOfTask);
        
    }
    // <comment>
    // <refactor> rename testMethod for clarity ?
    //static testMethod void myUnitTest2() {
    	  // <refactor> possibly use TestingUtils class for standardized data creation
    //    Account a = new Account();
    //    a.Name = 'Test Account';
    //    insert a;
    
    //    // <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
    //    a.Account_Manager__c = '005A0000000cnyO'; // <refactor> do not use hard coded Ids
    //    update a;
    //    
    //    Integer TestCountOfTask = [SELECT count() from Task WHERE WhatId = :a.Id];
    //    
    //    System.assertEquals(1, TestCountOfTask);
    //    
    	  // <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
    //    a.Account_Manager__c = null;
    //    update a; 
     //   
    //    Integer TestCountOfTask2 = [SELECT count() from Task WHERE WhatId = :a.Id];
    //    
    //    System.assertEquals(0, TestCountOfTask2);
    //    
    //}
    // <refactor> rename testMethod for clarity ?
    static testMethod void myUnitTest3() {
    	// <refactor> possibly use TestingUtils class for standardized data creation
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
        a.Account_Manager__c = '005A0000000cnyO'; // <refactor> do not use hard coded Ids
        update a;
        
        Integer TestCountOfTask = [SELECT count() from Task WHERE WhatId = :a.Id];
      
        System.assertEquals(1, TestCountOfTask);
        
        // <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
        a.Account_Manager__c = '005A0000000cnyO'; // <refactor> do not use hard coded Ids
        update a;
        
        Integer TestCountOfTask2 = [SELECT count() from Task WHERE WhatId = :a.Id];
        
        System.assertEquals(1, TestCountOfTask2);
        
    }
**************  END FULL CLASS COMMENT *******************/
}