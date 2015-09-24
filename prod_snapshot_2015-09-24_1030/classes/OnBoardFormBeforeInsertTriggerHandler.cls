/*
Below Defects addresses the clearing product details if they are selected(entered details) and then unselected on the UI.
DE598 : OBF: Wrong Data saved in field Social Ads Option on OBFModel record - Trigger Code Fix
DE548 : OBF - Data Issues - Major - Trigger Code Fix
*/
public class OnBoardFormBeforeInsertTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        for(OnBoardFormModel__c oneRecord : (List<OnBoardFormModel__c>)tp.newList){
            this.clearPPCFields(oneRecord); //Clearing PPC fields data
            this.clearSEOFields(oneRecord); //Clearing SEO fields data
            this.clearMapsAndReputationFields(oneRecord); //Clearing Maps & Reputation fields data
            this.clearLeadCapturePagesFields(oneRecord); //Clearing Lead Capture Pages fields data
            this.clearWebsitesFields(oneRecord); //Clearing Websites fields data
            this.clearSocialAdvertisingFields(oneRecord); //Clearing Social Advertising fields data
            this.clearTargetedEmailFields(oneRecord); //Clearing Targeted Email fields data
            this.clearSocialMediaManagementFields(oneRecord); //Clearing Social Media Management fields data
            
            //Set Media_Partner__c by Corp_Partner_Code__c if the request is submitted by OrderHub through API Call
            this.setMediaPartner(oneRecord);
        }
    }
    
    /* 
    ----------- BEGIN CODE TRANSPLANT -----------------
    */
    //Set Media_Partner__c by Corp_Partner_Code__c if the request is submitted by OrderHub through API Call
    private void setMediaPartner(OnBoardFormModel__c oneRecord){
    	if(String.IsNotBlank(oneRecord.Corp_Partner_Code__c) 
    		&& String.IsBlank(oneRecord.Media_Partner__c)){
    		List<Account> mediaPartnerAccounts = [Select Id, Name, Partner_Type__c, Market_Originator__c, Corp_Partner_Code__c from Account 
    												 Where RecordType.Name = 'Partner Market' and Corp_Partner_Code__c =: oneRecord.Corp_Partner_Code__c];
    		System.debug('Orderhub call: mediaPartnerAccountsList by Corp_Partner_Code__c >> ' + mediaPartnerAccounts);
    		if(mediaPartnerAccounts.size()>0){
    			oneRecord.Media_Partner__c = mediaPartnerAccounts[0].Id;
    		}										 
    	}
    }
    //PPC Fields
    private void clearPPCFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing PPC fields data');
        if(!oneRecord.PPC__c){
            oneRecord.PPC_Budget__c = null;
            oneRecord.PPC_Spend_Budget__c = null;
            oneRecord.Contract_Length_Months_PPC__c = null;
            
            oneRecord.Campaign_Goals__c = null;
            oneRecord.Products_Services_to_Advertise_For__c = null;
            oneRecord.Special_Offers__c = null;
            oneRecord.Ad_Copy__c = null;
            oneRecord.Business_Differentiators__c = null;
            oneRecord.Products_Services_Not_to_Advertise_For__c = null;
            oneRecord.Target_Geographical_Location__c = null;
            oneRecord.Target_State__c = null;
            oneRecord.Target_Radius__c = null;
            oneRecord.Notes_PPC__c = null;
        }
    }
    //SEO fields
    private void clearSEOFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing SEO fields data');
        if(!oneRecord.SEO__c){
            oneRecord.SEO_Budget__c = null;
            oneRecord.SEO_Package__c = null;
            oneRecord.Contract_Length_Months_SEO__c = null;
            
            oneRecord.Was_SEO_Done_Prior__c = null;
            oneRecord.Who_Was_Prior_SEO_Provider__c = null;
    
            //Google Analytics
            oneRecord.SEO_Google_Analytics_Admin_Confirmed__c = false;
            oneRecord.SEO_Google_Analytics_Installed__c = null;
            
            //Campaign Targeting
            oneRecord.Campaign_Target_Geographical_Location__c = null;
            oneRecord.Campaign_Target_State__c = null;
            oneRecord.Campaign_Target_City__c = null;
            oneRecord.Products_Services_to_Focus_On__c = null;
        
            oneRecord.Website_Access__c = null; // CMS, FTP, Web Developer
            oneRecord.Notes_SEO__c = null;
        }
        
        // CMS Fields
        if (!(oneRecord.SEO__c 
                && String.IsNotBlank(oneRecord.Website_Access__c) 
                && oneRecord.Website_Access__c == 'FTP/CMS')){
            oneRecord.CMS_Used__c = null;
            oneRecord.CMS_Used_Other__c = null;
            oneRecord.CMS_Login_URL__c = null;
            oneRecord.Username__c = null;
            oneRecord.Password__c = null;
            oneRecord.Host_URL__c = null;  
            oneRecord.Host_Provider_Username__c = null;
            oneRecord.Host_Provider_Password__c = null;
        }
        
        //Web Developer Fields
        if(!(oneRecord.SEO__c 
                && String.IsNotBlank(oneRecord.Website_Access__c) 
                && oneRecord.Website_Access__c == 'Web Developer')){
            oneRecord.First_Name__c = null;
            oneRecord.Last_Name__c = null;
            oneRecord.Web_Developer_Contact_Phone__c = null;
            oneRecord.Web_Developer_Email_Address__c = null;
        }
    }
    //Maps & Reputation fields
    private void clearMapsAndReputationFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Maps & Reputation fields data');
        if(!oneRecord.Local_Places_Reputation__c){
            oneRecord.Local_Places_Reputation_Option__c = null;
            oneRecord.Number_of_Locations__c = null;
            oneRecord.Maps_Budget1__c = null;
            oneRecord.Local_Places_Reputation_Budget__c = null;
            oneRecord.Contract_Length_Months_LocalPlaces__c = null;
            
            oneRecord.Has_Google_Maps_Listing_Been_Claimed__c = null;
            oneRecord.Local_Places_Username__c = null;
            oneRecord.Local_Places_Password__c = null;
            oneRecord.Recovery_Email_or_Phone_Number__c = null;
            oneRecord.Legal_Business_Name_DBA__c = null;
            oneRecord.If_Medical_Dental_Legal_License_Name__c = null;
            oneRecord.Publishable_Email_Address__c = null;
            oneRecord.Business_Payment_Methods_Accepted__c = null;
            oneRecord.Is_Business_Brick_Mortar_or_Mobile__c = null;
            oneRecord.Top_Products_Services_You_Offer_1__c = null;
            oneRecord.Top_Products_Services_You_Offer_2__c = null;
            oneRecord.Top_Products_Services_You_Offer_3__c = null;
            oneRecord.Notes_MapsRep__c = null;
        }
    }
    //Lead Capture Pages fields
    private void clearLeadCapturePagesFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Lead Capture Pages fields data');
        
        if(!oneRecord.Lead_Capture_Pages__c){
            oneRecord.Lead_Capture_Page_Option__c = null;
            oneRecord.Contract_Length_Months_LCP__c = null;
            oneRecord.Lead_Capture_Page_Budget__c = null;
            oneRecord.Notes_LeadCapture__c = null;
        }
        
        if (!(oneRecord.Lead_Capture_Pages__c 
            && String.IsNotBlank(oneRecord.Lead_Capture_Page_Option__c) 
            && oneRecord.Lead_Capture_Page_Option__c == 'Signature')){
            oneRecord.Desired_URL_Domain_Name__c = null;
        }
    }
    //Websites fields
    private void clearWebsitesFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Websites fields data');
        if(!oneRecord.Websites__c){
            oneRecord.Website_Option__c = null;
            oneRecord.Website_Budget_template_or_mobile_only__c = null;
            oneRecord.Email_Hosting_sel__c = null;
            oneRecord.Link_to_Proposal__c = null;
            oneRecord.Website_Quote_Cost_Custom__c = null;
            oneRecord.Contract_Length_Months_Websites__c = null;
            
            oneRecord.Are_We_Hosting_Email_at_Same_URL_Domain__c = null;
            oneRecord.Client_Email_Provider_Name__c = null;
            oneRecord.Email_Hosting_Desired_Email1__c = null;
            oneRecord.Email_Hosting_Desired_Email2__c = null;
            oneRecord.Email_Hosting_Desired_Email3__c = null;
            oneRecord.Email_Hosting_Desired_Email4__c = null;
            oneRecord.Email_Hosting_Desired_Email5__c = null;
            oneRecord.Email_Hosting_Desired_Email6__c = null;
            oneRecord.Email_Hosting_Desired_Email7__c = null;
            oneRecord.Email_Hosting_Desired_Email8__c = null;
            oneRecord.Email_Hosting_Desired_Email9__c = null;
            oneRecord.Email_Hosting_Desired_Email10__c = null;
            oneRecord.Website_Structure_Pages__c = null;
            oneRecord.Website_Structure_Pages_Other__c = null;
            oneRecord.Use_Existing_URL__c = null;
            oneRecord.Domain_Name__c = null;
            oneRecord.Domain_Registrar__c = null;
            oneRecord.Domain_Registrar_Other__c = null;
            oneRecord.Domain_Registrar_Username__c = null;
            oneRecord.Domain_Registrar_Password__c = null;
            
            oneRecord.Template_Website_Package_Name__c = null;
            oneRecord.TWDesired_URL_Domain_Name__c = null;
            oneRecord.Notes_Websites__c = null;
        }
    }
    //Social Advertising fields
    private void clearSocialAdvertisingFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Social Advertising fields data');
        
        if(!oneRecord.Social_Advertising__c){
            oneRecord.Social_Ads_Option__c = null;
            oneRecord.Social_Ads_Package__c = null;
            oneRecord.Social_Ads_Budget_Month__c = null;
            oneRecord.SocialAds_Spend_Budget__c = null;
            oneRecord.Contract_Length_Months_SocialAds__c = null;
            
            oneRecord.SA_Current_Facebook_Page_URL__c = null;
            oneRecord.Facebook_Ads_Landing_Page_URL__c = null;
            oneRecord.SA_Manager_Level_Admin_Access__c = false;
            oneRecord.SA_Campaign_Goal__c = null;
            oneRecord.SA_Campaign_Goal2__c = null;
            oneRecord.Offer_Description__c = null;
            oneRecord.SA_Copy_Theme_Ideas__c = null;
            oneRecord.SA_Target_Geographical_Location__c = null;
            oneRecord.SA_Target_State__c = null;
            oneRecord.SA_Target_Radius__c = null;
            oneRecord.SA_Target_Demographics_Age__c = null;
            oneRecord.SA_Target_Demographics_Gender__c = null;
            oneRecord.Notes_SocialAds__c = null;
        }else{
            //Clearing Subsections data due to Ajax & Submit behavior
            // Clearing Campaign Targeting Section based on Social Ads Package dependant picklist
            if (oneRecord.Social_Ads_Package__c == 'Start'){
                oneRecord.SA_Campaign_Goal2__c = null;
                oneRecord.SA_Target_Geographical_Location__c = null; 
                oneRecord.SA_Target_State__c = null;
                oneRecord.SA_Target_Radius__c = null;
                oneRecord.SA_Target_Demographics_Age__c = null;
                oneRecord.SA_Target_Demographics_Gender__c = null;
                oneRecord.Facebook_Ads_Landing_Page_URL__c = null;
            }else if (oneRecord.Social_Ads_Package__c == 'Build'){
            	oneRecord.SA_Campaign_Goal2__c = null;
            }
            //This part only afects 
            if (!(oneRecord.SA_Target_Geographical_Location__c == 'State')){
        		oneRecord.SA_Target_State__c = null;
        	} else if (!(oneRecord.SA_Target_Geographical_Location__c == 'Radius')){
        		oneRecord.SA_Target_Radius__c = null;
        	}
        }
    }
    //Targeted Email fields
    private void clearTargetedEmailFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Targeted Email fields data');
        if(!oneRecord.Targeted_Email__c){
            oneRecord.Quantity_of_Email_Blasts_per_60_Days__c = null;
            oneRecord.Email_Recipients_per_Blast__c = null;
            oneRecord.Targeted_Email_Budget__c = null;
            oneRecord.TargetedEmail_BlastReminder__c = null;
            oneRecord.TargetedEMail_BlastReminderBudget__c = null;
            oneRecord.TargetedEmail_CreativeOption__c = null;
            oneRecord.TargetedEmail_HTMLFee__c = null;
            
            oneRecord.Email_Count_Pulled_in_Last_60_Days__c = null;
            oneRecord.Count_ID__c = null;
            oneRecord.TargetedEmail_AutoTemplate_Brand__c = null;
            oneRecord.TargetedEmail_AutoTemplate_Persona__c = null;
            oneRecord.TargetedEmail_AutoTemplate_Specific__c = null;
            oneRecord.TargetedEmail_CreativeAnalysis__c = null;
            oneRecord.TargetedEmail_AssetsURL__c = null;
            oneRecord.TargetedEmail_Notes__c = null;
            
        }
    }
    //Social Media Management fields
    private void clearSocialMediaManagementFields(OnBoardFormModel__c oneRecord){
        System.debug('Clearing Social Media Management fields data');
        if(!oneRecord.Social_Media_Management__c){
            oneRecord.Social_Option__c = null;
            oneRecord.Social_Budget__c = null;
            oneRecord.SocialMediaMgmt_Spend_Budget__c  = null;
            oneRecord.Contract_Length_Months_SocialMedia__c = null;
            
            oneRecord.Has_Facebook_Page__c = null;
            oneRecord.Current_Facebook_URL__c = null;
            oneRecord.Confirm_Manager_Level_Admin_Access__c = false;
            oneRecord.Has_Twitter_Profile__c = false;
            oneRecord.Twitter_Username__c = null;
            oneRecord.Twitter_Password__c = null;
            oneRecord.Has_GooglePlus_Profile__c = null;
            oneRecord.GooglePlus_Username__c = null;
            oneRecord.GooglePlus_Password__c = null;
            oneRecord.Campaign_Contact_Email__c = null;
            oneRecord.Campaign_Goal__c = null;
            oneRecord.Copy_Theme_Ideas__c = null;
            oneRecord.FB_Target_Geographical_Location__c = null;
            oneRecord.FB_Target_State__c = null;
            oneRecord.FB_Target_Radius__c = null;
            oneRecord.Notes_SMM__c = null;
            oneRecord.FB_Targeting_Demographics_Age__c = null;
            oneRecord.FB_Targeting_Demographics_Gender__c = null;
        }else{
            //Clearing Subsections data due to Ajax & Submit behavior
            if(String.IsNotBlank(oneRecord.Social_Option__c)){
                //Clearing Twitter Sub Section
                if (!(oneRecord.Social_Option__c == 'Social Mgmt - Engage' 
                        || oneRecord.Social_Option__c == 'Social Mgmt - Expand')){
                    oneRecord.Has_Twitter_Profile__c = false;
                    oneRecord.Twitter_Username__c = null;
                    oneRecord.Twitter_Password__c = null;
                }   
                
                //Clearing GooglePlus Sub Section
                if (!(oneRecord.Social_Option__c == 'Social Mgmt - Engage' 
                        || oneRecord.Social_Option__c == 'Social Mgmt - Expand' 
                        || oneRecord.Social_Option__c =='Custom Social Package')){
                    oneRecord.Has_GooglePlus_Profile__c = null;
                    oneRecord.GooglePlus_Username__c = null;
                    oneRecord.GooglePlus_Password__c = null;
                }   
            }
            
            //Clearing Twitter Subsection
            if(!oneRecord.Has_Twitter_Profile__c){
                oneRecord.Twitter_Username__c = null;
                oneRecord.Twitter_Password__c = null;
            }
            
            //Clearing Google+ Subsection
            if(String.IsNotBlank(oneRecord.Has_GooglePlus_Profile__c) 
                && oneRecord.Has_GooglePlus_Profile__c == 'No'){
                oneRecord.GooglePlus_Username__c = null;
                oneRecord.GooglePlus_Password__c = null;
            }
        }
    }
}