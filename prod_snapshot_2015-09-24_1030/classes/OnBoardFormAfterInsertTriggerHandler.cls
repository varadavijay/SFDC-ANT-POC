/*
Creating Case(GL Onboard) and populating case fields with OnBoardFormModel data
*/

public without sharing class OnBoardFormAfterInsertTriggerHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		for(OnBoardFormModel__c oneRecord : (List<OnBoardFormModel__c>)tp.newList){
			//Inserting GL_ONBOARD Cases
			//Bulkify inserts later, we cant do now because we need case id to stamp on Onboardformmodel object
			Case newCase = createOnboardCase(oneRecord);
			insert newCase;
			
			//Updating OnboardForm with Case Id
			OnBoardFormModel__c updateRecord = [Select Id, Case__c from OnBoardFormModel__c where Id =: oneRecord.Id limit 1];
			updateRecord.Case__c = newCase.Id;
			update updateRecord;
		}
	}
	/* 
	----------- BEGIN CODE TRANSPLANT -----------------
	*/
	private Case createOnboardCase(OnBoardFormModel__c oneRecord){
		System.debug('Entering OnBoardFormAfterInsertTriggerHandler.createOnboardCase');
		System.debug('Creating Onboard Case from sfdcId >> ' + oneRecord.Id);
		
		Case newCase = new Case();
		newCase.RecordTypeId = RecordTypeCache.getRecordType('Case', 'GL_OnBoard').Id ; //012F0000000yE0nIAE
		newCase.Affl_Sales_Rep__c = oneRecord.Affl_Sales_Rep__c;
		newCase.Affl_Sales_Rep_Text__c = oneRecord.Affl_Sales_Rep_Text__c;
		newCase.Media_Partner__c = oneRecord.Media_Partner__c;
		newCase.Order_Number__c = oneRecord.Order_Number__c;
        newCase.Genesys_Account_Number__c = oneRecord.Genesys_Account_Number__c;
		
		newCase.Company_Name__c = oneRecord.Advertiser_Company_Name__c;
		newCase.Contact_Name__c = oneRecord.Advertiser_Contact_First_Name__c + ' ' + oneRecord.Advertiser_Contact_Last_Name__c;
		newCase.Contact_Phone__c = oneRecord.Advertiser_Contact_Phone__c;
		newCase.GLO_Website_Address__c = oneRecord.Advertiser_Web_Address__c;
		newCase.GLO_Advertiser_Email__c = oneRecord.Advertiser_Email_Address__c;
		newCase.Industry_General__c = oneRecord.Advertiser_Industry__c;
		
		newCase.Notify_Email_1__c = oneRecord.First_Email_Address__c;
		newCase.Notify_Email_2__c = oneRecord.Second_Email_Address__c;
		newCase.Notify_Email_3__c = oneRecord.Third_Email_Address__c;
		
		newCase.GLO_RepDash_FName__c = null; // needed info
		newCase.GLO_RepDash_LName__c = null; // needed info
		newCase.GLO_RepDash_Email__c = null; // needed info
		
		String contractLength;
		//PPC
		if(oneRecord.PPC__c){
			newCase.GLO_PPC__c = oneRecord.PPC__c;
			newCase.GLO_PPC_Budget__c = oneRecord.PPC_Budget__c; // needed info 
			newCase.SellType_PPC__c = oneRecord.SellType_PPC__c;
			newCase.GLO_PPC_Spend_Budget__c = oneRecord.PPC_Spend_Budget__c;
            
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_PPC__c);
		}
		
		//SEO
		if(oneRecord.SEO__c){
			newCase.GLO_SEO__c = oneRecord.SEO__c;
			//newCase.GLO_SEO_Keywords__c = oneRecord.SEO_Package__c; // needed info
			newCase.GLO_SEO_Budget__c = oneRecord.SEO_Budget__c; // needed info
			newCase.SellType_SEO__c = oneRecord.SellType_SEO__c;
			
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_SEO__c);
		}
		
		//Maps & Reputation
		if(oneRecord.Local_Places_Reputation__c){
			newCase.GLO_Maps__c = oneRecord.Local_Places_Reputation__c;
			//newCase.GLO_Maps_Options__c = oneRecord.Local_Places_Reputation_Option__c; // needed info
			newCase.GLO_Maps_Budget__c = oneRecord.Local_Places_Reputation_Budget__c; // needed info
			newCase.SellType_Maps__c = oneRecord.SellType_Maps__c;
			
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_LocalPlaces__c);
		}
		
		//Lead Capture Pages --- Contract_Length_Months_LCP__c
		if(oneRecord.Lead_Capture_Pages__c){
			newCase.SellType_LeadCapPage__c = oneRecord.SellType_LeadCapPage__c;
		}
		
		//Websites
		if(oneRecord.Websites__c){
			newCase.GLO_Website__c = oneRecord.Websites__c;
			//newCase.GLO_Website_Options__c = oneRecord.Website_Option__c; // needed info
			newCase.GLO_Website_Budget__c = oneRecord.Website_Quote_Cost_Custom__c; // needed info
			newCase.SellType_Websites__c = oneRecord.SellType_Websites__c;
			
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_Websites__c);
		}
		
		//Social Advertising
		if(oneRecord.Social_Advertising__c){
			newCase.GLO_Facebook_Ads__c = oneRecord.Social_Advertising__c; // needed info
			newCase.GLO_Facebook_Ads_Amount__c = oneRecord.Social_Ads_Budget_Month__c; // needed info
			newCase.SellType_SocialAds__c = oneRecord.SellType_SocialAds__c;
			newCase.GLO_SocialAds_Spend_Budget__c = oneRecord.SocialAds_Spend_Budget__c;
            
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_SocialAds__c);
		}
		
		//Targeted Email
		if(oneRecord.Targeted_Email__c){
			newCase.GLO_Email__c = oneRecord.Targeted_Email__c; // needed info
			//newCase.GLO_Email_Option__c = 'Email Blast'; // needed info
			newCase.GLO_Email_Budget__c = oneRecord.Targeted_Email_Budget__c; // needed info
			newCase.SellType_TargetedEmail__c = oneRecord.SellType_TargetedEmail__c;
		}
		
		//Social Media Management
		if(oneRecord.Social_Media_Management__c){
			newCase.GLO_Social_Media__c = oneRecord.Social_Media_Management__c; // needed info
			//newCase.GLO_Social_Options__c = oneRecord.Social_Option__c; // needed info
			newCase.GLO_Social_Budget__c = oneRecord.Social_Budget__c; // needed info
			newCase.SellType_SocialMediaMgmt__c = oneRecord.SellType_SocialMediaMgmt__c;
			newCase.GLO_SocialMediaMgmt_Spend_Budget__c = oneRecord.SocialMediaMgmt_Spend_Budget__c;
            
			if(String.IsBlank(contractLength))
				contractLength = String.valueOf(oneRecord.Contract_Length_Months_SocialMedia__c);
		}
		
		newCase.GLO_Contract_Length__c = contractLength;
		newCase.GLO_Business_Objectives__c = null; // needed info
		newCase.GLO_Business_Obj_Other__c = null; // needed info
		newCase.GLO_Expectations__c = null; // needed info
		newCase.GLO_Special_Terms__c = null; // needed info
		
		System.debug('Done Creating Onboard Case');
		return newCase;
	}
}