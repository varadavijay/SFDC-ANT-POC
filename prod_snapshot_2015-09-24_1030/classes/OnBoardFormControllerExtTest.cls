@istest
public with sharing class OnBoardFormControllerExtTest {
    
    static final String COMP_NAME = 'Bluewolf adv';
    static final String FIRST_NAME = 'John';
    static final String LAST_NAME = 'Doe';
    static final String LOC_NAME = 'Cloud Atlas, NY';
    
    static OnBoardFormControllerExt ext;
    static OnBoardFormModel__c model;
    static PageReference pref;
    
    static testMethod void test_saveOnBoardFormModelMethod(){
        model = new OnBoardFormModel__c();
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(model);
        ext = new OnBoardFormControllerExt(stdController);
        
        model.Advertiser_Company_Name__c = COMP_NAME;
        model.Advertiser_Contact_First_Name__c = FIRST_NAME;
        model.Advertiser_Contact_Last_Name__c = LAST_NAME;
        model.Location_Name__c = LOC_NAME;
        
        Test.startTest();
            //ext.saveOnBoardForm();
        Test.stopTest();
        
        List<OnBoardFormModel__c> actualFormModels  = [SELECT Id, Advertiser_Company_Name__c, Advertiser_Contact_First_Name__c
                                                       FROM OnBoardFormModel__c];
        /*
        System.assertEquals(1, actualFormModels.size(), 'Their should be 1 OnBoardFormModel created by the saveCase method ' );
        System.assertEquals(model.Id, actualFormModels[0].Id, 'We should have the object we have inserted');
        System.assertEquals(COMP_NAME, actualFormModels[0].Advertiser_Company_Name__c );
        System.assertEquals(FIRST_NAME, actualFormModels[0].Advertiser_Contact_First_Name__c );
        */
    }
}