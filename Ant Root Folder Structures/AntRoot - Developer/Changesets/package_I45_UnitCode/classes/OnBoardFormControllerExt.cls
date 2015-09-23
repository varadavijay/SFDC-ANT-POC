/* 
This class is used by OnBoardForm.Page.  This is an intake form that the salesrep fills.  This form has about 200++ fields on the page
All the fields are not displayed upfront. However, depending on the selection criteria the intake fields are visible/hidden on the UI accordingly.

TODO:  UI design is not intutive and we are following the existing page design. We need to revisit the design aspect of site forms.
*/
public without sharing class OnBoardFormControllerExt {

	public OnBoardFormModel__c newOnBoardFormModel {get; set;}	
	public String selectSubmitType {get;set;}
	public String includenotify {get;set;} 
	public String includerepdash {get;set;}
	
	//SEO Budget Map
    public static final Map<String, integer> SEO_BUDGET_BY_SEO_PACKAGE = new Map<String, integer> { 
    	 'Community SEO 5 Keywords' => 599,
		 'Community SEO 10 Keywords'=> 899,
		 'Community SEO 15 Keywords'=> 1299,
		 'Metro SEO 5 Keywords'=> 899,
		 'Metro SEO 10 Keywords'=> 1299,
		 'Metro SEO 15 Keywords'=> 1599,
		 'National SEO 5 Keywords'=> 7699,
		 'National SEO 10 Keywords'=> 8999,
		 'National SEO 15 Keywords'=> 10595
    };
    
    //SEO Budget Map
    public static final Map<String, integer> SOCIAL_BUDGET_BY_MGMT_OPTIONS = new Map<String, integer> { 
    	 'Social Mgmt - Launch' => 999,
		 'Social Mgmt - Engage'=> 1699,
		 'Social Mgmt - Expand'=> 2999,
		 'Social Media Weekend Coverage'=> 1200
    };
    
    //setdefaultbusinesshoursmins
    public void setdefaultbusinesshoursmins(){
    	if(this.webOnBoardFormModel.Sunday_Closed__c){
    		this.webOnBoardFormModel.Sunday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Sunday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Sunday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Sunday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Monday_Closed__c){
    		this.webOnBoardFormModel.Monday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Monday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Monday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Monday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Tuesday_Closed__c){
    		this.webOnBoardFormModel.Tuesday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Tuesday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Tuesday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Tuesday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Wednesday_Closed__c){
    		this.webOnBoardFormModel.Wednesday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Wednesday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Wednesday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Wednesday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Thursday_Closed__c){
    		this.webOnBoardFormModel.Thursday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Thursday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Thursday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Thursday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Friday_Closed__c){
    		this.webOnBoardFormModel.Friday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Friday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Friday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Friday_End_Min__c ='00';
    	}
    	if(this.webOnBoardFormModel.Saturday_Closed__c){
    		this.webOnBoardFormModel.Saturday_Start_Hour__c ='00';
    		this.webOnBoardFormModel.Saturday_Start_Min__c ='00';
    		this.webOnBoardFormModel.Saturday_End_Hour__c ='00';
    		this.webOnBoardFormModel.Saturday_End_Min__c ='00';
    	}
    }
    
    public boolean hasIndustryPicklistChanged{
       get;
       set;
    }      
    
	public String selectedIndustryId {
		get
		{ 
			if( selectedIndustryId == NULL ) 
				selectedIndustryId = NONE; 
			return selectedIndustryId; 
		}
		set{
			if(selectedIndustryId<>value){
				this.hasIndustryPicklistChanged = true;
			}
			selectedIndustryId = value;
		}
	}
	
	public String selectedIndustryFocusId{
		get
		{ 
			if( selectedIndustryFocusId == NULL ) 
				selectedIndustryFocusId = NONE; 
			return selectedIndustryFocusId; 
		}
		set;
	}
	
	public String selectedSalesRepLetter
	{
		get
		{ 
			if( selectedSalesRepLetter == NULL ) 
				selectedSalesRepLetter = '-'; 
			return selectedSalesRepLetter; 
		}
		set;
	}
	
	//Formula for SEO Budget depending on Selected SEO Package
	public void seoFormulaBudget(){ 
		//Disabled = true/false
		//Determining the $ amount
		if(this.webOnBoardFormModel.SEO__c){
			if(SEO_BUDGET_BY_SEO_PACKAGE.get(this.webOnBoardFormModel.SEO_Package__c)<>null){
				this.webOnBoardFormModel.SEO_Budget__c = SEO_BUDGET_BY_SEO_PACKAGE.get(this.webOnBoardFormModel.SEO_Package__c);
			}else{
				this.webOnBoardFormModel.SEO_Budget__c = null;
			}
		}
	}
    
    //PPC ppcBudgetAmountEntered 
    public void ppcBudgetAmountEntered(){
    	String ppcBudgetValue = String.ValueOf(this.webOnBoardFormModel.PPC_Budget__c);
    	System.debug('I am in ppcBudgetAmountEntered');
    	
    	if(this.webOnBoardFormModel.PPC__c){
	    	if(String.IsBlank(ppcBudgetValue)){
	    		this.webOnBoardFormModel.PPC_Budget__c = 0;
	    	}
	    	
	    	if(this.webOnBoardFormModel.PPC_Budget__c > 2499){
	    		// Allow Picklist selection
	    		this.webOnBoardFormModel.Target_Geographical_Location__c = '';
	    		this.ppcTargetGeoPickListDisabled = false;
	    	}else{
	    		//default to radius
	    		this.ppcTargetGeoPickListDisabled = true;
	    		this.webOnBoardFormModel.Target_Geographical_Location__c = 'Radius';
	    	}
    	}
    }
    
    //Formula for Targetted Email Budget 
    // Calculating currency for both standard email and reminder email blasts
    //Currency field with calculated value as follows:  
    //If Email receipients ranges between 10000 - 14999 then Cost per Reminder Blast = ((Email Recipients/1000)*Rate)
    public void targettedEmailFormulaBudget(){ 
        if(this.webOnBoardFormModel.Targeted_Email__c){
            this.targettedEmailHtmlFee(); // Calling HTML as its dependent on Quantity_of_Email_Blasts_per_60_Days__c
            Double roundingValue = 0.01;
            if(String.IsNotBlank(this.webOnBoardFormModel.Quantity_of_Email_Blasts_per_60_Days__c)
                && this.webOnBoardFormModel.Email_Recipients_per_Blast__c != null){
                Integer quantity = Integer.valueOf(this.webOnBoardFormModel.Quantity_of_Email_Blasts_per_60_Days__c);
                //Integer amountBasedOnQty;
                
                Integer emailBlasts = Integer.valueOf(this.webOnBoardFormModel.Email_Recipients_per_Blast__c);
                Integer amountBasedOnEmailBlasts;
                
                if(quantity>0 && quantity <= 2){ //Quantity
                   // amountBasedOnQty = 250;
                   if(emailBlasts >=10000 && emailBlasts < 15000){
                        amountBasedOnEmailBlasts = 85;
                    }else if(emailBlasts >=15000 && emailBlasts < 30000){
                        amountBasedOnEmailBlasts = 75;
                    }else if(emailBlasts >=30000 && emailBlasts < 50000){
                        amountBasedOnEmailBlasts = 65;
                    }else if(emailBlasts >=50000 && emailBlasts < 75000){
                        amountBasedOnEmailBlasts = 60;
                    }else if(emailBlasts >=75000 && emailBlasts < 100000){
                        amountBasedOnEmailBlasts = 50;
                    }else if(emailBlasts >=100000 && emailBlasts < 125000){
                        amountBasedOnEmailBlasts = 40;
                    }else if(emailBlasts >=125000 && emailBlasts < 250000){
                        amountBasedOnEmailBlasts = 35;
                    }else if(emailBlasts >=250000 && emailBlasts < 500000){
                        amountBasedOnEmailBlasts = 30;
                    }else if(emailBlasts >=500000 && emailBlasts < 1000000){
                        amountBasedOnEmailBlasts = 25;
                    }else if(emailBlasts >=1000000 && emailBlasts < 1500000){
                        amountBasedOnEmailBlasts = 15;
                    }else if(emailBlasts >=1500000 && emailBlasts < 2000000){
                        amountBasedOnEmailBlasts = 14;
                    } else if(emailBlasts >=2000000){
                        amountBasedOnEmailBlasts = 13;
                    }   
                    
                }else if (quantity > 2 && quantity <= 5){
                    //amountBasedOnQty = 150;
                   if(emailBlasts >=10000 && emailBlasts < 15000){
                        amountBasedOnEmailBlasts = 80;
                    }else if(emailBlasts >=15000 && emailBlasts < 30000){
                        amountBasedOnEmailBlasts = 71;
                    }else if(emailBlasts >=30000 && emailBlasts < 50000){
                        amountBasedOnEmailBlasts = 62;
                    }else if(emailBlasts >=50000 && emailBlasts < 75000){
                        amountBasedOnEmailBlasts = 57;
                    }else if(emailBlasts >=75000 && emailBlasts < 100000){
                        amountBasedOnEmailBlasts = 47;
                    }else if(emailBlasts >=100000 && emailBlasts < 125000){
                        amountBasedOnEmailBlasts = 38;
                    }else if(emailBlasts >=125000 && emailBlasts < 250000){
                        amountBasedOnEmailBlasts = 33;
                    }else if(emailBlasts >=250000 && emailBlasts < 500000){
                        amountBasedOnEmailBlasts = 28;
                    }else if(emailBlasts >=500000 && emailBlasts < 1000000){
                        amountBasedOnEmailBlasts = 23;
                    }else if(emailBlasts >=1000000 && emailBlasts < 1500000){
                        amountBasedOnEmailBlasts = 14;
                    }else if(emailBlasts >=1500000 && emailBlasts < 2000000){
                        amountBasedOnEmailBlasts = 13;
                    } else if(emailBlasts >=2000000){
                        amountBasedOnEmailBlasts = 12;
                    }
                }else if (quantity > 5 && quantity <= 11){
                    //amountBasedOnQty = 150;
                   if(emailBlasts >=10000 && emailBlasts < 15000){
                        amountBasedOnEmailBlasts = 76;
                    }else if(emailBlasts >=15000 && emailBlasts < 30000){
                        amountBasedOnEmailBlasts = 67;
                    }else if(emailBlasts >=30000 && emailBlasts < 50000){
                        amountBasedOnEmailBlasts = 59;
                    }else if(emailBlasts >=50000 && emailBlasts < 75000){
                        amountBasedOnEmailBlasts = 54;
                    }else if(emailBlasts >=75000 && emailBlasts < 100000){
                        amountBasedOnEmailBlasts = 45;
                    }else if(emailBlasts >=100000 && emailBlasts < 125000){
                        amountBasedOnEmailBlasts = 36;
                    }else if(emailBlasts >=125000 && emailBlasts < 250000){
                        amountBasedOnEmailBlasts = 30;
                    }else if(emailBlasts >=250000 && emailBlasts < 500000){
                        amountBasedOnEmailBlasts = 27;
                    }else if(emailBlasts >=500000 && emailBlasts < 1000000){
                        amountBasedOnEmailBlasts = 22;
                    }else if(emailBlasts >=1000000 && emailBlasts < 1500000){
                        amountBasedOnEmailBlasts = 13;
                    }else if(emailBlasts >=1500000 && emailBlasts < 2000000){
                        amountBasedOnEmailBlasts = 12;
                    } else if(emailBlasts >=2000000){
                        amountBasedOnEmailBlasts = 11;
                    }
                }else if (quantity > 11){
                    //amountBasedOnQty = 150;
                   if(emailBlasts >=10000 && emailBlasts < 15000){
                        amountBasedOnEmailBlasts = 72;
                    }else if(emailBlasts >=15000 && emailBlasts < 30000){
                        amountBasedOnEmailBlasts = 63;
                    }else if(emailBlasts >=30000 && emailBlasts < 50000){
                        amountBasedOnEmailBlasts = 55;
                    }else if(emailBlasts >=50000 && emailBlasts < 75000){
                        amountBasedOnEmailBlasts = 51;
                    }else if(emailBlasts >=75000 && emailBlasts < 100000){
                        amountBasedOnEmailBlasts = 42;
                    }else if(emailBlasts >=100000 && emailBlasts < 125000){
                        amountBasedOnEmailBlasts = 34;
                    }else if(emailBlasts >=125000 && emailBlasts < 250000){
                        amountBasedOnEmailBlasts = 30;
                    }else if(emailBlasts >=250000 && emailBlasts < 500000){
                        amountBasedOnEmailBlasts = 25;
                    }else if(emailBlasts >=500000 && emailBlasts < 1000000){
                        amountBasedOnEmailBlasts = 21;
                    }else if(emailBlasts >=1000000 && emailBlasts < 1500000){
                        amountBasedOnEmailBlasts = 12;
                    }else if(emailBlasts >=1500000 && emailBlasts < 2000000){
                        amountBasedOnEmailBlasts = 11;
                    } else if(emailBlasts >=2000000){
                        amountBasedOnEmailBlasts = 11;
                    }
                }
                
                if( amountBasedOnEmailBlasts > 0){
                    //System.debug('What am i getting out >> ' + emailBlasts + '  >> ' + amountBasedOnQty + ' >> ' + amountBasedOnEmailBlasts);
                    //System.debug(' Math >> ' + ((emailBlasts/1000) * (amountBasedOnEmailBlasts)));
                    this.webOnBoardFormModel.Targeted_Email_Budget__c = Math.round(roundingValue + (emailBlasts/1000.00) * (amountBasedOnEmailBlasts) );
                }else{
                    this.webOnBoardFormModel.Targeted_Email_Budget__c=null;
                }
            }else{
                this.webOnBoardFormModel.Targeted_Email_Budget__c=null;
            }
            if(this.webOnBoardFormModel.TargetedEmail_BlastReminder__c != null
                && this.webOnBoardFormModel.Email_Recipients_per_Blast__c != null){
                Integer reminderBlastquantity = Integer.valueOf(this.webOnBoardFormModel.TargetedEmail_BlastReminder__c);
                Integer amountBasedOnQty1;
                
                Integer reminderEmailBlasts = Integer.valueOf(this.webOnBoardFormModel.Email_Recipients_per_Blast__c);
                Integer amountBasedOnReminderEmailBlasts;
                
                    if(reminderBlastquantity > 0){
	                    if(reminderEmailBlasts >=10000 && reminderEmailBlasts < 15000){
	                        amountBasedOnReminderEmailBlasts = 43;
	                    }else if(reminderEmailBlasts >=15000 && reminderEmailBlasts < 30000){
	                        amountBasedOnReminderEmailBlasts = 38;
	                    }else if(reminderEmailBlasts >=30000 && reminderEmailBlasts < 50000){
	                        amountBasedOnReminderEmailBlasts = 33;
	                    }else if(reminderEmailBlasts >=50000 && reminderEmailBlasts < 75000){
	                        amountBasedOnReminderEmailBlasts = 30;
	                    }else if(reminderEmailBlasts >=75000 && reminderEmailBlasts < 100000){
	                        amountBasedOnReminderEmailBlasts = 25;
	                    }else if(reminderEmailBlasts >=100000 && reminderEmailBlasts < 125000){
	                        amountBasedOnReminderEmailBlasts = 20;
	                    }else if(reminderEmailBlasts >=125000 && reminderEmailBlasts < 250000){
	                        amountBasedOnReminderEmailBlasts = 18;
	                    }else if(reminderEmailBlasts >=250000 && reminderEmailBlasts < 500000){
	                        amountBasedOnReminderEmailBlasts = 15;
	                    }else if(reminderEmailBlasts >=500000 && reminderEmailBlasts < 1000000){
	                        amountBasedOnReminderEmailBlasts = 13;
	                    }else if(reminderEmailBlasts >=1000000 && reminderEmailBlasts < 1500000){
	                        amountBasedOnReminderEmailBlasts = 8;
	                    }else if(reminderEmailBlasts >=1500000 && reminderEmailBlasts < 2000000){
	                        amountBasedOnReminderEmailBlasts = 7;
	                    } else if(reminderEmailBlasts >=2000000){
	                        amountBasedOnReminderEmailBlasts = 7;
	                    }
                   }  
                   if(amountBasedOnReminderEmailBlasts > 0){
                     this.webOnBoardFormModel.TargetedEMail_BlastReminderBudget__c = Math.roundToLong(roundingValue + (reminderEmailBlasts/1000.00) * (amountBasedOnReminderEmailBlasts));
                   }else{
                    this.webOnBoardFormModel.TargetedEMail_BlastReminderBudget__c=null;
                   }
              }else{
                     this.webOnBoardFormModel.TargetedEMail_BlastReminderBudget__c=null;
               }
        }
    }
    
    /*
     *  Calculation:
     *  IF "Email Creative Option" IN ("G/O Digital Design") THEN "$250"
     *  IF "Email Creative Option" IN ("Client Provided HTML") THEN "$0"
     *  IF "Email Creative Option" IN ("Client Provided Non-HTML") THEN "$200"
     *  IF "Email Creative Option" IN ("Automotive Template") THEN "$200"
    */
    public void targettedEmailHtmlFee(){ 
        if(this.webOnBoardFormModel.Targeted_Email__c){
            if(String.IsNotBlank(this.webOnBoardFormModel.Quantity_of_Email_Blasts_per_60_Days__c)
                && String.IsNotBlank(this.webOnBoardFormModel.TargetedEmail_CreativeOption__c)){
                    
               
			   Integer htmlFee = 0;
			   
               
                   if(this.webOnBoardFormModel.TargetedEmail_CreativeOption__c == 'G/O Digital Design'){
                      htmlFee = 250;
                   }
               
                   if(this.webOnBoardFormModel.TargetedEmail_CreativeOption__c == 'Client Provided HTML'){
                      htmlFee = 0;
                   }
                   if(this.webOnBoardFormModel.TargetedEmail_CreativeOption__c == 'Client Provided Non-HTML'){
                      htmlFee = 200;
                   }
                   if(this.webOnBoardFormModel.TargetedEmail_CreativeOption__c == 'Automotive Template'){
                      htmlFee = 200;
                   }
               
               this.webOnBoardFormModel.TargetedEmail_HTMLFee__c=htmlFee;
            }else{
                this.webOnBoardFormModel.TargetedEmail_HTMLFee__c=0;
            }
        }
    }
    
    public Boolean ppcTargetGeoPickListDisabled {
    	get;
    	set;
    }
    
    /* Below formula is commented out as part of DEV-2041
    
    //Local_Places_Reputation_Budget__c (formula/currency)
    //Populated based on the following formula 
    // $349 for first location,
    // $200 for locations 2-14, 
    // $175 for locations 15-49, 
    // $150 for locations 50+
 
       public void setLPRBudgetFormula(){
        if(this.webOnBoardFormModel.Local_Places_Reputation__c){
            if(this.webOnBoardFormModel.Number_of_Locations__c == null){
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 0;
                return;
            }else if(this.webOnBoardFormModel.Number_of_Locations__c == 1){
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 349;
                return;
            }else if(this.webOnBoardFormModel.Number_of_Locations__c > 1
               && this.webOnBoardFormModel.Number_of_Locations__c <= 14){
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 200;
                return;
            }else if(this.webOnBoardFormModel.Number_of_Locations__c > 14
               && this.webOnBoardFormModel.Number_of_Locations__c <= 49){
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 175;
                return;
            }else if(this.webOnBoardFormModel.Number_of_Locations__c > 49){
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 150;
                return;
            }else{
                this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = 0;
            }
            }
    }*/
    
    //Local_Places_Reputation_Budget_c is populated based on following formula
    //IF Number_of_Locations_c IN (2-14) THEN Local_Places_Reputation_Budget_c = ((Number_of_Locationsc - 1)*200) 
    //IF Number_of_Locations_c IN (15-49) THEN Local_Places_Reputation_Budget_c = ((Number_of_Locationsc - 1)*175)
    //IF Number_of_Locations_c >= (50) THEN Local_Places_Reputation_Budget_c = ((Number_of_Locationsc - 1)*150) 
      public void setLPRBudgetFormula(){
       if(this.webOnBoardFormModel.Local_Places_Reputation__c){
         if(this.webOnBoardFormModel.Number_of_Locations__c != null){
           Integer LPRBudget = 0;
           Integer FirstLocationBudget = null;
           Integer numberOfLocations = Integer.valueOf(this.webOnBoardFormModel.Number_of_Locations__c);
           if(numberOfLocations >= 2 && numberOfLocations <= 16){
             LPRBudget = ((numberOfLocations-1)*200);
           }else if(numberOfLocations >= 17 && numberOfLocations <= 49){
              LPRBudget = ((numberOfLocations-1)*175);
           }else if(numberOfLocations >= 50){
              LPRBudget = ((numberOfLocations-1)*150); 
           }
            this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = LPRBudget;
            if(numberOfLocations > 0){
            	FirstLocationBudget = 349 ;// For any number of locations 1st Location Budget is $349
            }
               this.webOnBoardFormModel.Maps_Budget1__c = FirstLocationBudget;
            }else{
               this.webOnBoardFormModel.Local_Places_Reputation_Budget__c = null;
               this.webOnBoardFormModel.Maps_Budget1__c = null;
           }
        }
       }
    //setLCPFormulaBudget
    //Auto filled in by option picked above; Premium: $129, Signature: $199, Single: $299: 
    public void setLCPFormulaBudget(){
    	if(this.webOnBoardFormModel.Lead_Capture_Pages__c){
	    	if(String.isNotBlank(this.webOnBoardFormModel.Lead_Capture_Page_Option__c)){
	    		this.webOnBoardFormModel.Contract_Length_Months_LCP__c = '';
	    		if(this.webOnBoardFormModel.Lead_Capture_Page_Option__c == 'Premium'){
	    			this.webOnBoardFormModel.Lead_Capture_Page_Budget__c = 129;
	    		}else if (this.webOnBoardFormModel.Lead_Capture_Page_Option__c == 'Signature'){
	    			this.webOnBoardFormModel.Lead_Capture_Page_Budget__c = 199;
	    		}else if (this.webOnBoardFormModel.Lead_Capture_Page_Option__c == 'Single'){
	    			this.webOnBoardFormModel.Lead_Capture_Page_Budget__c = 299;
	    			this.webOnBoardFormModel.Contract_Length_Months_LCP__c = '1';
	    		}else{
	    			this.webOnBoardFormModel.Lead_Capture_Page_Budget__c = 0;
	    		}
	    	}else{
	    		this.webOnBoardFormModel.Lead_Capture_Page_Budget__c = 0;
	    	}
    	}
    }
    
	public Boolean seoFormulaBudgetDisabled {
		get{
			if(SEO_BUDGET_BY_SEO_PACKAGE.get(this.webOnBoardFormModel.SEO_Package__c)<>null){
				return true;
			}else{
				return false;
			}
		}
	}
	
	//SetWebSiteBudgetAndQuote
	//Auto filled in with Premium $249, Signature $399, Mobile Only $69, Custom $25.
	//Start Template (5 Page Website), Professional Template (15 Page Website), Mobile Only, Custom Website, Website Maintenance.
	//Auto filled in with Website Maintenance $999, but allow write-in of $5000 minimum if Custom Website selected in Row 59.
	public void SetWebSiteBudgetAndQuote(){
		if(this.webOnBoardFormModel.Websites__c && String.isNotBlank(this.webOnBoardFormModel.Website_Option__c)){
			if(this.webOnBoardFormModel.Website_Option__c == 'Start Template (5 Page Website)'){
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = 249;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
			}else if(this.webOnBoardFormModel.Website_Option__c == 'Professional Template (15 Page Website)'){
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = 399;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
			}else if (this.webOnBoardFormModel.Website_Option__c == 'Mobile Only'){
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = 69;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
			}else if (this.webOnBoardFormModel.Website_Option__c == 'Custom Website'){
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = 25;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
			}else if (this.webOnBoardFormModel.Website_Option__c == 'Website Maintenance'){
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = null;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = 999;
			}else{
				this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = null;
				this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
			}
		}else{
			this.webOnBoardFormModel.Website_Budget_template_or_mobile_only__c = null;
			this.webOnBoardFormModel.Website_Quote_Cost_Custom__c = null;
		}
	}
	
	//Validation >= 5000 for custom website
	private boolean customWebsiteQuote(){
		if(this.webOnBoardFormModel.Websites__c && String.isNotBlank(this.webOnBoardFormModel.Website_Option__c)){
			if (this.webOnBoardFormModel.Website_Option__c == 'Custom Website'){
				if(this.webOnBoardFormModel.Website_Quote_Cost_Custom__c == null ||
					  this.webOnBoardFormModel.Website_Quote_Cost_Custom__c < 5000){
					 ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Website Quote Cost (custom): You must enter minimum of 5000',''));
					 return false;
				}
			}
		}
		return true;
	}
	
	public String selectedSalesRep {get;set;} 
	private final OnBoardFormModel__c webOnBoardFormModel;
	
	//Media Kit >> logoUploadAttachment
	public AttachmentsExt logoUploadAttachment {
		get {
			if(logoUploadAttachment == NULL){
				logoUploadAttachment=new AttachmentsExt();
				logoUploadAttachment.AttachmentDescription = AttachmentTypes.MEDIAKIT_LOGO.name();
			}
			return logoUploadAttachment;
		}
		set;
	}
	
	//Media Kit >> imagesCreativeFile
	public AttachmentsExt imagesCreativeFileAttachment {
		get {
			if(imagesCreativeFileAttachment == NULL){
				imagesCreativeFileAttachment=new AttachmentsExt();
				imagesCreativeFileAttachment.AttachmentDescription = AttachmentTypes.MEDIAKIT_IMAGES.name();
			}
			return imagesCreativeFileAttachment;
		}
		set;
	}
	
	//Contract Information >> ContractFile
	public AttachmentsExt contractFileAttachment {
		get {
			if(contractFileAttachment == NULL){
				contractFileAttachment=new AttachmentsExt();
				contractFileAttachment.AttachmentDescription = AttachmentTypes.CONTRACT_INFO.name();
			}
			return contractFileAttachment;
		}
		set;
	}
	
	//Targetted Email>> If creative supplied by client upload >> ClientUploadFileAttachment
	/* Commneted out below Section as part of DEV-1073
	public AttachmentsExt ClientUploadFileAttachment {
		get {
			if(ClientUploadFileAttachment == NULL){
				ClientUploadFileAttachment=new AttachmentsExt();
				ClientUploadFileAttachment.AttachmentDescription = AttachmentTypes.CLIENT_UPLOAD.name();
			}
			return ClientUploadFileAttachment;
		}
		set;
	}
	*/
	
	//Managed Email>> Database list upload (in excel or csv) >> DatabaselistFileAttachment
	public AttachmentsExt DatabaselistFileAttachment {
		get {
			if(DatabaselistFileAttachment == NULL){
				DatabaselistFileAttachment=new AttachmentsExt();  
				DatabaselistFileAttachment.AttachmentDescription = AttachmentTypes.DATABASE_LIST.name();
			}
			return DatabaselistFileAttachment;
		}
		set;
	}
	
	//Managed Email>> Attach signed Opt-in Liability Form >> LiabilityFormFileAttachment
	public AttachmentsExt LiabilityFormFileAttachment {
		get {
			if(LiabilityFormFileAttachment == NULL){
				LiabilityFormFileAttachment=new AttachmentsExt();
				LiabilityFormFileAttachment.AttachmentDescription = AttachmentTypes.LIABILITY_FORM.name();
			}
			return LiabilityFormFileAttachment;
		}
		set;
	}
	
	//Social Media Management>> Asset/Image/Logo Upload(1 of 4) >> AssetImageLogo1FileAttachment
	public AttachmentsExt AssetImageLogo1FileAttachment {
		get {
			if(AssetImageLogo1FileAttachment == NULL){
				AssetImageLogo1FileAttachment=new AttachmentsExt();
				AssetImageLogo1FileAttachment.AttachmentDescription = AttachmentTypes.ASSET_IMAGE_LOGO_1.name();
			}
			return AssetImageLogo1FileAttachment;
		}
		set;
	}
	
	//Social Media Management>> Asset/Image/Logo Upload(1 of 4) >> AssetImageLogo2FileAttachment
	public AttachmentsExt AssetImageLogo2FileAttachment {
		get {
			if(AssetImageLogo2FileAttachment == NULL){
				AssetImageLogo2FileAttachment=new AttachmentsExt();
				AssetImageLogo2FileAttachment.AttachmentDescription = AttachmentTypes.ASSET_IMAGE_LOGO_2.name();
			}
			return AssetImageLogo2FileAttachment;
		}
		set;
	}
	
	//Social Media Management>> Asset/Image/Logo Upload(1 of 4) >> AssetImageLogo3FileAttachment
	public AttachmentsExt AssetImageLogo3FileAttachment {
		get {
			if(AssetImageLogo3FileAttachment == NULL){
				AssetImageLogo3FileAttachment=new AttachmentsExt();
				AssetImageLogo3FileAttachment.AttachmentDescription = AttachmentTypes.ASSET_IMAGE_LOGO_3.name();
			}
			return AssetImageLogo3FileAttachment;
		}
		set;
	}
	
	//Social Media Management>> Asset/Image/Logo Upload(1 of 4) >> AssetImageLogo4FileAttachment
	public AttachmentsExt AssetImageLogo4FileAttachment {
		get {
			if(AssetImageLogo4FileAttachment == NULL){
				AssetImageLogo4FileAttachment=new AttachmentsExt();
				AssetImageLogo4FileAttachment.AttachmentDescription = AttachmentTypes.ASSET_IMAGE_LOGO_4.name();
			}
			return AssetImageLogo4FileAttachment;
		}
		set;
	}
	
	public String NONE {get{return '--None--';} private set;}
	public String OTHER {get{return 'Other';} private set;}
	
	public final String RECTYPE_AFFILIATED = 'Affiliated';
	public final String RECTYPE_PARTNER_MARKET = 'PartnerMarket';
	public String Target_Email_Link { get{ return 'http://gannettlocal.force.com/digitalaudit'; } private set; }
	public Id DEFAULT_CONTACT_ID { get{ return '003F000000y4o1V'; } private set; }
	//This is just a dummy Id so that its different from DEFAULT_CONTACT_ID which is used for 'Not In List'
	//This is used for NONE or CHOOSE ONE
	public Id NONE_CONTACT_ID { get{ return '003F000000y4o2V'; } private set; }
	public Id GANNETT_LOCAL_ACCOUNT_ID { get{ return '001A000000QTk0g'; } private set; }
	
	public enum AttachmentTypes {MEDIAKIT_LOGO, MEDIAKIT_IMAGES, CONTRACT_INFO, CLIENT_UPLOAD, DATABASE_LIST, LIABILITY_FORM, ASSET_IMAGE_LOGO_1, ASSET_IMAGE_LOGO_2, ASSET_IMAGE_LOGO_3, ASSET_IMAGE_LOGO_4}
	
	private Pagereference currentPage;
	
	public OnBoardFormControllerExt(){
		
	}
	
	public OnBoardFormControllerExt ( ApexPages.StandardController stdController )
	{
		currentPage = ApexPages.currentPage();
		webOnBoardFormModel = (OnBoardFormModel__c)stdcontroller.getRecord(); 
	}
	
	/*Select First Letter of Sales Rep Name*/
	public List<SelectOption> getLetters() 
    {
        List<SelectOption> alpha = new List<SelectOption>();
        alpha.add(new SelectOption('-','-'));
        alpha.add(new SelectOption('A','A'));
        alpha.add(new SelectOption('B','B'));
        alpha.add(new SelectOption('C','C'));
        alpha.add(new SelectOption('D','D'));
        alpha.add(new SelectOption('E','E'));
        alpha.add(new SelectOption('F','F'));
        alpha.add(new SelectOption('G','G'));
        alpha.add(new SelectOption('H','H'));
        alpha.add(new SelectOption('I','I'));
        alpha.add(new SelectOption('J','J'));
        alpha.add(new SelectOption('K','K'));
        alpha.add(new SelectOption('L','L'));
        alpha.add(new SelectOption('M','M'));
        alpha.add(new SelectOption('N','N'));
        alpha.add(new SelectOption('O','O'));
        alpha.add(new SelectOption('P','P'));
        alpha.add(new SelectOption('Q','Q'));
        alpha.add(new SelectOption('R','R'));
        alpha.add(new SelectOption('S','S'));
        alpha.add(new SelectOption('T','T'));
        alpha.add(new SelectOption('U','U'));
        alpha.add(new SelectOption('V','V'));
        alpha.add(new SelectOption('W','W'));
        alpha.add(new SelectOption('X','X'));
        alpha.add(new SelectOption('Y','Y'));
        alpha.add(new SelectOption('Z','Z'));
        return alpha;
    }
    /*
       Sales Rep: Affiliated Record Type
    */
    private Id affiliatedRecTypeId
    {
    	get
    	{
    		if( affiliatedRecTypeId == NULL )
    		{
    			RecordType cachedRecType = RecordTypeCache.getRecordType( 'Contact', RECTYPE_AFFILIATED );
    			if( cachedRecType != NULL )
    				affiliatedRecTypeId = cachedRecType.Id;
    		}
    		return affiliatedRecTypeId;
    	}
    	private set;
    }
    /*
       MediaType : ParterMarket Account Record Type
    */
    private Id partnerMarketRecTypeId
    {
    	get
    	{
    		if( partnerMarketRecTypeId == NULL )
    		{
    			RecordType cachedRecType = RecordTypeCache.getRecordType( 'Account', RECTYPE_PARTNER_MARKET );
    			if( cachedRecType != NULL )
    				partnerMarketRecTypeId = cachedRecType.Id;
    		}
    		return partnerMarketRecTypeId;
    	}
    	private set;
    }
    
    /*
      List of Sales Reps
    */
    public List<Contact> contactList
    {
    	get
    	{
	    	if( contactList == NULL )
	    	{
	    		System.debug('Querying All Sales Rep Contacts');
	    		contactList = [Select Id, Name
	  							FROM Contact
	  							where RecordTypeId = :affiliatedRecTypeId
	  							and LastName != 'In List'
	  							and Email != ''
	  							and Web_Submitter__c = True
	  							order by Name];
	    	}
    		return contactList;
    	}
    	private set;
    }
    
    /*
       Default Contact Select Options
    */
    public Map<String, List<SelectOption>> initialToContactSelectOptions
    {
    	get
    	{
    		if( initialToContactSelectOptions == NULL)
    		{
    			initialToContactSelectOptions = new Map<String, List<SelectOption>>();
    			for( SelectOption aSelectOption : getLetters() )
    			{
    				String initial = aSelectOption.getLabel();
					if( !initialToContactSelectOptions.containsKey( initial ) )
					{ 
						SelectOption chooseOne = new SelectOption( NONE_CONTACT_ID, 'Choose One' );
						SelectOption notInList = new SelectOption( DEFAULT_CONTACT_ID, 'Not In List' );
						initialToContactSelectOptions.put( initial, new List<SelectOption>{ chooseOne, notInList } );
					}
    				for(Contact aContact : contactList)
    				{
    					if( aContact.Name.startsWith( initial ) )
    					{
    						initialToContactSelectOptions.get( initial ).add( new SelectOption( aContact.Id, aContact.Name ) );
    					}
    				}
    					
    			}
    		}
    		return initialToContactSelectOptions;
    	}
    	private set;
    }
    
	Integer Cons = contactList.size();
  	
    /*
    Dropdown with YES or NO
    */
	public List<SelectOption> yesNoOptions{
		get{
			if (yesNoOptions == null){
				yesNoOptions = new List<SelectOption>();
				yesNoOptions.add(new SelectOption('false','No'));
				yesNoOptions.add(new SelectOption('true','Yes'));
			}
			return yesNoOptions;
		}
		private set;
	}
	
	/*
	   Media Partner List from Account of recordType PartnerMarket
	*/
	public List<SelectOption> getMediaPartnerList(){
    	List<SelectOption> moptions = new List<SelectOption>();
    	List<Account> marketList = [Select Id, Media_Property_List__c
    								FROM Account
    								where RecordTypeId = :partnerMarketRecTypeId
    								and Id != :GANNETT_LOCAL_ACCOUNT_ID
    								order by Media_Property_List__c];
    	
    	moptions.add(new SelectOption(NONE_CONTACT_ID,NONE));  //We need to set some sfdc id value and hence providing dummy val
    	
    	for (Integer j=0; j<marketList.size(); j++){
    		moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));
    	}
    	moptions.add(new SelectOption(GANNETT_LOCAL_ACCOUNT_ID,'G/O Digital'));
    	return moptions;
    }
    
    /*
      Advertise Industry 
    */
    public List<SelectOption> AdvertiserIndustry{
    	get{
    		if(AdvertiserIndustry == NULL){
    			System.debug('Testing AdvertiserIndustry for duuplicate calls');
		    	AdvertiserIndustry = new List<SelectOption>();
		    	AdvertiserIndustry.add(new SelectOption(NONE,NONE));
		    	Map<String,String> listobjs = AMPRestService.getIndustryList();
		    	if(listobjs<>null && listobjs.size()>0){
		    		List<SelectOption> options = new List<SelectOption>();
			    	for (String categoryId: listobjs.keySet()){
			    		options.add(new SelectOption(categoryId,listobjs.get(categoryId)));
			    	}
			    	options = SortSelectOptions.selectOptionSortByLabel(options);
			    	AdvertiserIndustry.addall(options);
		    	}
		    	AdvertiserIndustry.add(new SelectOption(this.OTHER,this.OTHER));
		    	this.hasIndustryPicklistChanged = true;
	    	}
	    	return AdvertiserIndustry;
    	}
    	private set;
    }
    
    /*
      Advertise Industry 
    */ 
    public List<SelectOption> AdvertiserIndustryFocus{
    	get{
	    	System.debug('What is Selected Company Name' + selectedIndustryId);
	    	if(hasIndustryPicklistChanged){
	    		System.debug('hasIndustryPicklistChanged  >> ' + hasIndustryPicklistChanged);
	    		AdvertiserIndustryFocus = new List<SelectOption>();
		    	if(this.selectedIndustryId <> NONE ){
		    		if(this.selectedIndustryId <> this.OTHER){
				    	AdvertiserIndustryFocus.add(new SelectOption(NONE,NONE));
				    	Map<String,String> listobjs = AMPRestService.getFocusByIndustry(selectedIndustryId);
				    	if(listobjs<>null && listobjs.size()>0){
				    		List<SelectOption> options = new List<SelectOption>();
				    		for (String categoryId: listobjs.keySet()){
				    			options.add(new SelectOption(categoryId,listobjs.get(categoryId)));
				    		}
				    		options = SortSelectOptions.selectOptionSortByLabel(options);
					    	AdvertiserIndustryFocus.addall(options);
				    	}
		    		}	
			    	AdvertiserIndustryFocus.add(new Selectoption(this.OTHER, this.OTHER));
		    	}else{
		    		AdvertiserIndustryFocus.add(new SelectOption(NONE,NONE));
		    	}
		    	this.hasIndustryPicklistChanged = false;
	    	}
	    	return AdvertiserIndustryFocus;
    	}
    	private set;
    }
    
    /*
       Save Customer Onboarding form with 240+ fields data
    */
    public PageReference saveOnBoardForm(){
		System.debug('Entering saveOnBoardForm()');
		try{
			if(! this.ValidateFormFields()){
				return this.currentPage;
			}
			
			//Sales Rep contact  
			if(this.selectedSalesRep <> this.DEFAULT_CONTACT_ID 
				 && this.selectedSalesRep<> this.NONE_CONTACT_ID){	
			
				webOnBoardFormModel.Affl_Sales_Rep__c = selectedSalesRep;
			}
			
			//Advertiser Industry
			System.debug('List<SelectOption> AdvertiserIndustry' + AdvertiserIndustry);
			if(this.selectedIndustryId != NONE && this.selectedIndustryId != OTHER){
				this.webOnBoardFormModel.Advertiser_Industry_Id__c = Integer.valueOf(this.selectedIndustryId);
				for(SelectOption oneIndustry: AdvertiserIndustry){
					if(oneIndustry.getValue().equals(this.selectedIndustryId)){
						this.webOnBoardFormModel.Advertiser_Industry__c = oneIndustry.getLabel();
						System.debug('Adviser Industry Label before service call : ' + this.webOnBoardFormModel.Advertiser_Industry__c);
					}
				}
			}else if(this.selectedIndustryId == OTHER){
				this.webOnBoardFormModel.Advertiser_Industry__c = OTHER;
			}
			
			//Advertiser Industry Focus
			System.debug('List<SelectOption> AdvertiserIndustryFocus' + AdvertiserIndustryFocus);
			if(this.selectedIndustryFocusId != NONE && this.selectedIndustryFocusId != OTHER){
				this.webOnBoardFormModel.Advertiser_Primary_Focus_Id__c = Integer.valueOf(this.selectedIndustryFocusId);
				for(SelectOption oneIndustryFocus: AdvertiserIndustryFocus){
					if(oneIndustryFocus.getValue().equals(this.selectedIndustryFocusId)){
						this.webOnBoardFormModel.Advertiser_Primary_Focus__c = oneIndustryFocus.getLabel();
						System.debug('Adviser Industry Focus Label before service call : ' + this.webOnBoardFormModel.Advertiser_Primary_Focus__c);
					}
				}
			}else if(this.selectedIndustryFocusId == OTHER){
				this.webOnBoardFormModel.Advertiser_Primary_Focus__c = OTHER;
			}
						
			if (this.includenotify != 'true'){
				webOnBoardFormModel.First_Email_Address__c = null;
				webOnBoardFormModel.Second_Email_Address__c = null;
				webOnBoardFormModel.Third_Email_Address__c = null;
				webOnBoardFormModel.Copy_Others_on_Fulfillment_Notifications__c = false;
			}else{
				webOnBoardFormModel.Copy_Others_on_Fulfillment_Notifications__c = true;
			}
			
			//Re-calculation targetted email budget & targetted Html fee DEV-1112 
			this.targettedEmailFormulaBudget();
			this.targettedEmailHtmlFee();
			
			// todo: add error handling
			insert(webOnBoardFormModel);
		}catch(DmlException ex){
			if(ex.getDmlStatusCode(0) !=null && ex.getDmlStatusCode(0) == 'FIELD_CUSTOM_VALIDATION_EXCEPTION'){
				//Warn Application Log	
				ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
															null, 'OnBoardFormControllerExt', 'saveOnBoardForm', false, ApplicationLogsModel.Loglevel.Warn);
		    }else{
		    	//Error Application Log
				ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
															null, 'OnBoardFormControllerExt', 'saveOnBoardForm', false, ApplicationLogsModel.Loglevel.Error);
		    }
			return this.currentPage;
		}catch(Exception ex){
			ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
														null, 'OnBoardFormControllerExt', 'saveOnBoardForm', false, ApplicationLogsModel.Loglevel.Warn);
		    return this.currentPage;
		}
		
		//Attachments DML
		try{
			//Re-Parenting all siteAttachment Id's to OnboardFormModel and
	    	//Deleting attachments on SiteAttachments Object
	    	Set<Id> newAttachmentIds = new Set<Id>();
	    	/*
	    		MEDIAKIT_LOGO, MEDIAKIT_IMAGES, CONTRACT_INFO, CLIENT_UPLOAD, DATABASE_LIST, LIABILITY_FORM, ASSET_IMAGE_LOGO_1, ASSET_IMAGE_LOGO_2, ASSET_IMAGE_LOGO_3, ASSET_IMAGE_LOGO_4
	    	*/	
			if(this.logoUploadAttachment <> null && 
					String.isNotBlank(this.logoUploadAttachment.AttachmentId)){
				 newAttachmentIds.add(this.logoUploadAttachment.AttachmentId);
			}
			
			if(this.imagesCreativeFileAttachment <> null && 
					String.isNotBlank(this.imagesCreativeFileAttachment.AttachmentId)){
				newAttachmentIds.add(this.imagesCreativeFileAttachment.AttachmentId);
			}
			
			if(this.contractFileAttachment <> null && 
					String.isNotBlank(this.contractFileAttachment.AttachmentId)){
				newAttachmentIds.add(this.contractFileAttachment.AttachmentId);
			}
			
			//Targetted Email Blast
			/* Commneted out below Section as part of DEV-1073 
			if(this.ClientUploadFileAttachment <> null && 
					String.isNotBlank(this.ClientUploadFileAttachment.AttachmentId)){
				newAttachmentIds.add(this.ClientUploadFileAttachment.AttachmentId);
			}*/
			
			//Managed Email Section
			if(this.webOnBoardFormModel.Managed_Email__c){
				if(this.DatabaselistFileAttachment <> null && 
					String.isNotBlank(this.DatabaselistFileAttachment.AttachmentId)){
					newAttachmentIds.add(this.DatabaselistFileAttachment.AttachmentId);
				}
				
				if(this.LiabilityFormFileAttachment <> null && 
					String.isNotBlank(this.LiabilityFormFileAttachment.AttachmentId)){
					newAttachmentIds.add(this.LiabilityFormFileAttachment.AttachmentId);
				}
			}
			
			//All 4 Attachments Social Media Management
			if(this.webOnBoardFormModel.Social_Media_Management__c){
				if(this.AssetImageLogo1FileAttachment <> null && 
					String.isNotBlank(this.AssetImageLogo1FileAttachment.AttachmentId)){
					newAttachmentIds.add(this.AssetImageLogo1FileAttachment.AttachmentId);
				}	
				
				if(this.AssetImageLogo2FileAttachment <> null && 
					String.isNotBlank(this.AssetImageLogo2FileAttachment.AttachmentId)){
					newAttachmentIds.add(this.AssetImageLogo2FileAttachment.AttachmentId);
				}
				
				if(this.AssetImageLogo3FileAttachment <> null && 
					String.isNotBlank(this.AssetImageLogo3FileAttachment.AttachmentId)){
					newAttachmentIds.add(this.AssetImageLogo3FileAttachment.AttachmentId);
				}
				
				if(this.AssetImageLogo4FileAttachment <> null && 
					String.isNotBlank(this.AssetImageLogo4FileAttachment.AttachmentId)){
					newAttachmentIds.add(this.AssetImageLogo4FileAttachment.AttachmentId);
				}
			}
			List<Attachment> attachmentsToInsert = new List<Attachment>();
			List<Attachment> siteAttachments = [Select Name, Description, Body, ContentType from Attachment Where Id In: newAttachmentIds];
			for(Attachment oneAttachment: siteAttachments){
				Attachment newAttachment = new Attachment(); 
				newAttachment.Name=oneAttachment.Name;
	            newAttachment.ContentType=oneAttachment.ContentType;
	            newAttachment.Body = oneAttachment.Body;
	            newAttachment.Description = oneAttachment.Description;
				newAttachment.ParentId = webOnBoardFormModel.Id;
				attachmentsToInsert.add(newAttachment);
			}
			
			insert attachmentsToInsert;
			delete siteAttachments;
			
			PageReference p = new PageReference('/ThankYouFromGLOnBoard');
			p.setRedirect(true);
			return p;
		}catch(Exception ex){
			ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
														null, 'OnBoardFormControllerExt', 'saveOnBoardForm', true, ApplicationLogsModel.Loglevel.Error);
            return this.currentPage;														
		}
    }
    
    /*
       Custom Apex Properties that requires validation on the backend
       Also, Some Object fields that have additional validation
    */
    private boolean ValidateFormFields(){
    	boolean isValid = true;
    	//Sales Rep Alphabets
    	if (this.selectedSalesRepLetter == '-'){
    		isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Sales Rep First Letter: You must enter a value',''));
		}
		
		//Sales Rep dropdown is Manditory
		if(this.selectedSalesRep == NONE_CONTACT_ID){
			isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Sales Rep: You must select a value',''));
		}
		
		//Advertiser Industry Name
		if(this.selectedIndustryId == NONE){
			isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Advertiser Industry: You must select a value',''));
		}
		
		//Advertiser Industry Focus
		if(this.selectedIndustryFocusId == NONE){
			isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Advertiser Primary Focus: You must select a value',''));
		}
		
		//Media Partner
		if(webOnBoardFormModel.Media_Partner__c == NONE_CONTACT_ID){
			isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Media Partner: You must select a value'));
		}


		
		//ContractInformation>> Contract File attachment is manditory
		if (!(this.contractFileAttachment <> null && String.isNotBlank(this.contractFileAttachment.AttachmentId))){
			isValid = false;	
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Contract Information, Contract: You must upload a file',''));
		}
		
		//Managed Email >> 'Attach signed Opt-in Liability Form' is required only if 'Database list upload (in excel or csv)' is uploaded
		if (this.webOnBoardFormModel.Managed_Email__c && this.DatabaselistFileAttachment <> null && String.isNotBlank(this.DatabaselistFileAttachment.AttachmentId)
			 && !(this.LiabilityFormFileAttachment <> null && String.isNotBlank(this.LiabilityFormFileAttachment.AttachmentId))){
			isValid = false;	
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Opt-In Email System, Liability Form: You must upload a file',''));
		}
        if(!this.customWebsiteQuote()){
        	isValid = false;
        }
        
        if(!this.ValidateSOCustomSelect()){
        	isValid=false;
        }
        
        if(!this.validSocialadsbugdet()){
        	isValid=false;
        }
        
        if(!this.ValidateSEOPackage()){
        	isValid=false;
        }
        
        //Number_of_Locations__c > 0
	    if(this.webOnBoardFormModel.Local_Places_Reputation__c){
	       if(this.webOnBoardFormModel.Number_of_Locations__c != null 
	       		&& this.webOnBoardFormModel.Number_of_Locations__c <=0){
    	   	   isValid = false;	
			   ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Maps & Reputation, Number of Locations: You must enter minimum 1 or above',''));
	       }
	    }
	    
	    //Website Structure/Pages is required
		if(this.webOnBoardFormModel.Websites__c
				&& String.IsNotBlank(this.webOnBoardFormModel.Website_Option__c) 
				&& this.webOnBoardFormModel.Website_Option__c == 'Custom Website'
				&& String.IsBlank(this.webOnBoardFormModel.Website_Structure_Pages__c)){
			isValid = false;
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Website Structure/Pages: You must select a value',''));
		}
        //Rate Request ID / Notes - PPC is required
        if(this.webOnBoardFormModel.PPC__c && 
            (this.webOnBoardFormModel.Contract_Length_Months_PPC__c=='1' 
            || webOnBoardFormModel.Contract_Length_Months_PPC__c=='2')){   
   	            if(this.webOnBoardFormModel.Rate_Request_ID__c == null 
   	            || this.webOnBoardFormModel.Rate_Request_ID__c == ''){	
                      isValid = false;
                      ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Rate Request ID : You must enter a value',''));
                 }
                 if(webOnBoardFormModel.Notes_PPC__c == null 
                 || webOnBoardFormModel.Notes_PPC__c == ''){
	                isValid = false;
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Notes - PPC : You must enter a value',''));
	              }
         }  
	      return isValid;
        
    }
    
    //ValidateSOCustomSelect
    //Validation that cannot select Custom unless URL included in Row 38 (Audit__c)
    public boolean ValidateSOCustomSelect(){
    	Boolean isValid = true;
	    if(this.webOnBoardFormModel.Social_Media_Management__c && String.IsNotBlank(this.webOnBoardFormModel.Social_Option__c)){
	    	if(this.webOnBoardFormModel.Social_Option__c == 'Custom Social Package' 
	    			&& String.IsBlank(this.webOnBoardFormModel.Audit__c)){
	    		ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Option: You cannot select (Custom Social Package) without Audit Url in Contact Information',''));
	    		//this.webOnBoardFormModel.Audit__c.addError('You cannot select (Custom Social Package) without Audit Url in Contact Information');
	    		isValid = false;
	    	}
	    	
	    	if(this.webOnBoardFormModel.Social_Option__c == 'Custom Social Package' 
	    			&& String.IsNotBlank(this.webOnBoardFormModel.Audit__c)){
	    		if(this.webOnBoardFormModel.Social_Budget__c < 3000){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Budget: You must enter minimum $3000',''));
	    			this.webOnBoardFormModel.Social_Budget__c.addError('You must enter minimum $3000');
	    			isValid = false;
	    		}
	    	}
	    	
	    	if(this.webOnBoardFormModel.Social_Option__c == 'Social Mgmt - Reach Ad Spend'){
	    		if(this.webOnBoardFormModel.Social_Budget__c < 1){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Budget: You must enter minimum $1',''));
	    			this.webOnBoardFormModel.Social_Budget__c.addError('You must enter minimum $1');
	    			isValid = false;
	    		}
	    	}
	    }
	    return isValid;
    }
    
    // SEO Validation rule " Validation that cannot select National/Custom Quote SEO Package unless URL (Audit) is included"
    // if National/Custom Quote SEO Package is selected with a minimum value validation of $7700.
    public boolean ValidateSEOPackage(){
    	if(this.webOnBoardFormModel.SEO__c 
    		&& String.IsNotBlank(this.webOnBoardFormModel.SEO_Package__c)
    		&& this.webOnBoardFormModel.SEO_Package__c == 'National/Custom Quote SEO Package'){
	    	if(String.IsBlank(this.webOnBoardFormModel.Audit__c)){
	    		ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'SEO Package: You cannot select <National/Custom Quote SEO Package> without Audit Url in Contact Information',''));
	    		return false;
	    	}else if(String.IsNotBlank(this.webOnBoardFormModel.Audit__c)){
	    		if(this.webOnBoardFormModel.SEO_Budget__c < 7700){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'SEO Budget/Mth: You must enter minimum $7700',''));
	    			return false;
	    		}
	    	}
	    }
	    return true;
    }
    
	// Social_Budget__c - UPDATE budget population based on Social_Option__c selection:
	// Social Mgmt - Launch = $999 (no change)
	// Social Mgmt - Engage = $1699 (no change)
	// Social Mgmt - Expand = $2999 (no change)
	// Social Mgmt - Reach Ad Spend = Currency entry (7,0); >=1
	// Social Media Weekend Coverage = $1,200 (add)
	// Custom Social Package = Currency entry (7,0); >=3000)
    public void setSocialBudget(){
    	if(this.webOnBoardFormModel.Social_Media_Management__c && String.IsNotBlank(this.webOnBoardFormModel.Social_Option__c)){
    		if(SOCIAL_BUDGET_BY_MGMT_OPTIONS.get(this.webOnBoardFormModel.Social_Option__c)<>null){
    			  this.webOnBoardFormModel.Social_Budget__c = SOCIAL_BUDGET_BY_MGMT_OPTIONS.get(this.webOnBoardFormModel.Social_Option__c);
    		}else{
	    		this.webOnBoardFormModel.Social_Budget__c =null;
	    	}
	    }else{
	    	this.webOnBoardFormModel.Social_Budget__c =null;
	    }
    }
    
    //setTargetEmailBudget
    //Currency field with calculated value as follows:  
    //if Email Blast Quantity = 1 or 2, then $250 + ((Email Recipients x 1or2_Quantity_Rate  
    //if Email Blast Count = 3+, then $150 + ((Email Recipients x 3+_Quantity_Rate)/1000).  
    //1or2_Quantity_rate for 10,000-49,999 = $80; 
    //50,000-74,999 = $50; 75,000-99,999 = $40; 100,000+ = $35.  
    //3+_Quantity_rate for 10,000-49,999 = $70; 50,000-74,999 = $45; 75,000-99,999 = $35; 100,000+ = $30.
    
    //TODO
    public void setTargetEmailBudget(){
    	
    }
    
    //Managed Email Budget
    //Auto filled based on selection above at 0-499 = $25; 500-2,499 = $45; 2,500-4,999 = $65, 5,000-9,999 = $110, 10,000-15,000 = $140.
    public void setManagedEmailBudget(){
    	if(this.webOnBoardFormModel.Managed_Email__c && string.isnotblank(this.webOnBoardFormModel.Email_Subscribers__c)){
    		if(this.webOnBoardFormModel.Email_Subscribers__c == '0-499'){
    			this.webOnBoardFormModel.Managed_Email_Budget__c =25;
    		}else if(this.webOnBoardFormModel.Email_Subscribers__c == '500-2,499'){
    			this.webOnBoardFormModel.Managed_Email_Budget__c =45;
    		}else if(this.webOnBoardFormModel.Email_Subscribers__c == '2,500-4,999'){
    			this.webOnBoardFormModel.Managed_Email_Budget__c =65;
    		}else if(this.webOnBoardFormModel.Email_Subscribers__c == '5,000-9,999'){
    			this.webOnBoardFormModel.Managed_Email_Budget__c =110;
    		}else if(this.webOnBoardFormModel.Email_Subscribers__c == '10,000-15,000'){
    			this.webOnBoardFormModel.Managed_Email_Budget__c =140;
    		}else{
    			this.webOnBoardFormModel.Managed_Email_Budget__c =0;
    		}
    	}else{
    		this.webOnBoardFormModel.Managed_Email_Budget__c =0;
    	}
    }
    
    //Validate social ads budget
    //Currency field with validation of minimal value of $500, 
    //and start must be = $500, $750, $1000, $1500, $2000; 
    //Build must be between $2001, and $7499; 
    //Grow must be $7500 or above 
    public boolean validSocialadsbugdet(){
    	if(this.webOnBoardFormModel.Social_Advertising__c 
    		&& this.webOnBoardFormModel.Social_Ads_Budget_Month__c <>null
    		&& String.IsNotBlank(this.webOnBoardFormModel.Social_Ads_Package__c)){
    	    if(this.webOnBoardFormModel.Social_Ads_Budget_Month__c <500){
	    		ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Ads Budget/Month: You must enter minimum $500',''));
    			return false;
    	    }
    		if(this.webOnBoardFormModel.Social_Ads_Package__c == 'Start'){
    			if(this.webOnBoardFormModel.Social_Ads_Budget_Month__c <> 500
    			   && this.webOnBoardFormModel.Social_Ads_Budget_Month__c <> 650
    			   && this.webOnBoardFormModel.Social_Ads_Budget_Month__c <> 750){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Ads Budget/Month(Start): You must enter $500, $650, $750',''));
	    			return false;
    			}
     		}else if(this.webOnBoardFormModel.Social_Ads_Package__c == 'Climb'){
    			if(!(this.webOnBoardFormModel.Social_Ads_Budget_Month__c >= 750
     				  && this.webOnBoardFormModel.Social_Ads_Budget_Month__c < 2000)){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Ads Budget/Month(Climb): You must enter between $750, and $1999',''));
	    			return false;
    			}
    		}else if(this.webOnBoardFormModel.Social_Ads_Package__c == 'Build'){
     			//DE556
     			if(!(this.webOnBoardFormModel.Social_Ads_Budget_Month__c >= 2000
     				&& this.webOnBoardFormModel.Social_Ads_Budget_Month__c < 7500)){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Ads Budget/Month(Build): You must enter between $2000, and $7499',''));
	    			return false;
     			}
    		}else if(this.webOnBoardFormModel.Social_Ads_Package__c == 'Grow'){
    			if(this.webOnBoardFormModel.Social_Ads_Budget_Month__c < 7500){
	    			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Social Ads Budget/Month(Grow): You must enter $7500 or above',''));
	    			return false;
    			}
    		}
    	}
    	return true;
    }
}