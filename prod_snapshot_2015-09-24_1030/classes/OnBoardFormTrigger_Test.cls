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
private class OnBoardFormTrigger_Test {
	
	static testMethod void insertOnBoardFormModelData() {
		
		OnBoardFormModel__c newRecord = new OnBoardFormModel__c();
		newRecord = parseJson();
		newRecord.Do_Not_Start_Before__c = Date.today().addDays(30);
		test.startTest();
		insert newRecord;
		test.stopTest();
		
		List <OnBoardFormModel__c> newRecords = [Select Id, PPC_Budget__c from OnBoardFormModel__c];
		if(newRecords.size()==1){
			newRecord = newRecords[0];
		} 
		System.assertNotEquals(newRecord.Id, null);
		System.assertEquals(newRecord.PPC_Budget__c, null);
		
		Id caseRecTypeId = RecordTypeCache.getRecordType('Case', 'GL_OnBoard').Id ; //012F0000000yE0nIAE
		List<Case> newCases = [Select Id from Case Where RecordTypeId =: caseRecTypeId];
		System.assertNotEquals(newCases.Size(), 0);
		
    } 
    
	private static OnBoardFormModel__c parseJson() {
		String json = '{'+
						'    \"Address_1__c\": \"Unit Testing\",'+
						'    \"Address_2__c\": \"Unit Testing\",'+
						'    \"Advertiser_Company_Name__c\": \"Unit Testing\",'+
						'    \"Advertiser_Contact_First_Name__c\": \"Unit Testing\",'+
						'    \"Advertiser_Contact_Last_Name__c\": \"Unit Testing\",'+
						'    \"Advertiser_Contact_Phone__c\": \"1231231234\",'+
						'    \"Advertiser_Email_Address__c\": \"unittesting@test.com\",'+
						'    \"Advertiser_Web_Address__c\": \"http://unittesting.com\",'+
						'    \"Affl_Sales_Rep_Text__c\": \"Unit Testing\",'+
						'    \"Business_Description__c\": \"Unit Testing\",'+
						'    \"Select_if_G_O_Outside_Direct_Rep__c\": \"Yes\",'+
						'    \"City__c\": \"Unit Testing\",'+
						'    \"Do_Not_Start_Before__c\": \"2014-09-26\",'+
						'    \"Lead_Capture_Email__c\": \"unittesting@test.com\",'+
						'    \"Location_Name__c\": \"Unit Testing\",'+
						'    \"Order_Number__c\": \"unittesting@test.c\",'+
						'    \"Phone__c\": \"1231231234\",'+
						'    \"Postal_Code__c\": \"12345\",'+
						'    \"Social_Ads_Option__c\": \"Facebook Ads\",'+
						'    \"State__c\": \"HI\",'+
						'    \"Advertiser_Industry__c\": \"Auto\",'+
						'    \"Advertiser_Primary_Focus__c\": \"Chrysler\",'+
						'    \"Friday_End_Hour__c\": \"23\",'+
						'    \"Friday_End_Min__c\": \"45\",'+
						'    \"Friday_End_Time__c\": \"23:45\",'+
						'    \"Friday_Start_Hour__c\": \"00\",'+
						'    \"Friday_Start_Min__c\": \"00\",'+
						'    \"Friday_Start_Time__c\": \"00:00\",'+
						'    \"Monday_Closed__c\": false,'+
						'    \"Monday_End_Hour__c\": \"23\",'+
						'    \"Monday_End_Min__c\": \"45\",'+
						'    \"Monday_End_Time__c\": \"23:45\",'+
						'    \"Monday_Start_Hour__c\": \"00\",'+
						'    \"Monday_Start_Min__c\": \"00\",'+
						'    \"Monday_Start_Time__c\": \"00:00\",'+
						'    \"Saturday_Closed__c\": false,'+
						'    \"Saturday_End_Hour__c\": \"23\",'+
						'    \"Saturday_End_Min__c\": \"45\",'+
						'    \"Saturday_End_Time__c\": \"23:45\",'+
						'    \"Saturday_Start_Hour__c\": \"00\",'+
						'    \"Saturday_Start_Min__c\": \"00\",'+
						'    \"Saturday_Start_Time__c\": \"00:00\",'+
						'    \"Sunday_Closed__c\": false,'+
						'    \"Sunday_End_Hour__c\": \"23\",'+
						'    \"Sunday_End_Min__c\": \"45\",'+
						'    \"Sunday_End_Time__c\": \"23:45\",'+
						'    \"Sunday_Start_Hour__c\": \"00\",'+
						'    \"Sunday_Start_Min__c\": \"00\",'+
						'    \"Sunday_Start_Time__c\": \"00:00\",'+
						'    \"Thursday_Closed__c\": false,'+
						'    \"Thursday_End_Hour__c\": \"23\",'+
						'    \"Thursday_End_Min__c\": \"45\",'+
						'    \"Thursday_End_Time__c\": \"23:45\",'+
						'    \"Thursday_Start_Hour__c\": \"00\",'+
						'    \"Thursday_Start_Min__c\": \"00\",'+
						'    \"Thursday_Start_Time__c\": \"00:00\",'+
						'    \"Tuesday_Closed__c\": false,'+
						'    \"Tuesday_End_Hour__c\": \"23\",'+
						'    \"Tuesday_End_Min__c\": \"45\",'+
						'    \"Tuesday_End_Time__c\": \"23:45\",'+
						'    \"Tuesday_Start_Hour__c\": \"00\",'+
						'    \"Tuesday_Start_Min__c\": \"00\",'+
						'    \"Tuesday_Start_Time__c\": \"00:00\",'+
						'    \"Wednesday_Closed__c\": false,'+
						'    \"Wednesday_End_Hour__c\": \"23\",'+
						'    \"Wednesday_End_Min__c\": \"45\",'+
						'    \"Wednesday_End_Time__c\": \"23:45\",'+
						'    \"Wednesday_Start_Hour__c\": \"00\",'+
						'    \"Wednesday_Start_Min__c\": \"00\",'+
						'    \"Wednesday_Start_Time__c\": \"00:00\",'+
						'    \"PPC_Budget__c\": \"600\"'+
						'}';
		return (OnBoardFormModel__c) System.JSON.deserialize(json, OnBoardFormModel__c.class);
	}
}