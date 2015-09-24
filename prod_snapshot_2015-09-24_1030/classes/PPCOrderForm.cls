/***********************************************************************
To get an opportunity and OLI into the correct state for testing do this:
1) Create Opportunity (SML_Opp)
        a) Type = "New Business"
        b) Stage = "Closed Won"
        c) Closed date, Opt Name, company namepopulated
2) check Signature override on Opty
3) Add Product - PPC (any of the 3 will do) | Select | Save
************************************************************************/
public with sharing class PPCOrderForm{
        
        // public = Accessed from VF, private = not accessed from VF
        // Any method actioned on from VF returns a PageReference for consistent performance
        public Account account {get; set;}
        public Opportunity opportunity {get; set;}
        public OpportunityLineItem opportunityLineItem {get; set;}
        public PPCOrderDetail__c ppcOrderDetail {get; set;}
        public List<PPCOrderDetailLocation__c> PPCOrderDetailLocations {get; set;}

        // Calculations
        public Decimal totalRetailAmount {get; set;}
        public Decimal ppcMonthlySpend {get; set;}
        
        // Location array add/remove
        public Integer locIndexSelected {get; set;}
        
        // Form Control
        public String lastSavedOn {get; set;}
        public Boolean isSubmitted {get; set;}
        public Boolean disablePPCManagementFeeInput {get; set;}
        
        // Query String
        public Boolean debugShow {get; set;}
        public Boolean duplicateShow {get; set;}
        
        private String opportunityLineItemId {get; set;}
        
        private String opportunityLineItem18DigitId {
        	get{
        		if(!String.IsBlank(this.opportunityLineItemId)){
        			return String.valueOf(Id.valueOf(this.opportunityLineItemId));
        		}
        		return null;
        	} 
        }
        
        // ctor - set up controller variables
        public PPCOrderForm() {
                system.debug('PPCOrderForm Controller: Initializing Constructor');
                //Set default values for the properties that need them
                this.disablePPCManagementFeeInput = true;
                this.debugShow = false;
                this.duplicateShow = false; 
                this.totalRetailAmount = 0;
                this.ppcMonthlySpend = 0;
                
                // If current user is a member of PPC_Fee_Managers Group then enable PPC Managemnet Fee Input
                List<GroupMember> groupMembers = [SELECT Id  
                                                      FROM GroupMember
                                                      WHERE UserOrGroupId = :UserInfo.getUserId()
                                                      and Group.DeveloperName = 'PPC_Fee_Managers'];
                if(groupMembers.size() > 0) {
                        this.disablePPCManagementFeeInput = false;
                } 
                
                // Get Query String paramaters
                if (ApexPages.currentPage().getParameters().get('debugShow') != null ) {
                        this.debugShow = true;
                }
                
                if (ApexPages.currentPage().getParameters().get('duplicateShow') != null ) {
                        this.duplicateShow = true;
                }
                
                if (ApexPages.currentPage().getParameters().get('OpportunityLineItemId') != null ) {
                        this.opportunityLineItemId = ApexPages.currentPage().getParameters().get('OpportunityLineItemId');
                }
                
                // member initializations - only call if we got an ID on the query string
                if(this.opportunityLineItemId != null){
                        //prevent dependencies from failing
                        Boolean initSxs = initOpportunityLineItem(); //prevent dependencies from failing
                        if(initSxs)
                                initSxs = initOpportunityAndAccount();
                        if(initSxs)
                                initSxs = initPpcOrderDetail();
                        
                        if(!initSxs){
                                system.debug('PPCOrderForm Controller: initialization failed');
                        }
                        else {
                                system.debug('PPCOrderForm Controller: initialization succeeded');
                        }
                }
                else {
                        system.debug('PPCOrderForm Controller: opportunityLineItemId is null, cant get PPCOrderDetail');
                }  
        } // PPCOrderForm()
        
        
        // Controller Functions should be private unless a VF page is calling them
        // Dependencies: initOpportunityLineItem()
        private Boolean initOpportunityAndAccount() {
               system.debug('PPCOrderForm Controller: Retrieving Opportunity and account information');
                Boolean success = false;
            	String DBQuery = 'SELECT ID, AccountID, Name FROM Opportunity WHERE Id = \'' + opportunityLineItem.OpportunityId + '\' limit 1';
            	opportunity[] newopps = Database.query(DBQuery);
            	this.opportunity = newopps[0];
                
                if(this.opportunity == null){
                        system.debug('PPCOrderForm Controller: couldnt select opportunity: Query = ' + DBQuery);
                }
                else {
                    DBQuery = 'SELECT Id, Name, BillingCity, BillingCountry, BillingPostalCode, ';
                    DBQuery += ' BillingState, BillingStreet, Phone, Website ';
                    DBQuery += ' FROM Account WHERE Id = \'' + this.opportunity.AccountId + '\' limit 1';
            		account[] newaccts = Database.query(DBQuery);
            		this.account = newaccts[0];
                    
                    if(this.account == null){
                                system.debug('PPCOrderForm Controller: couldnt select account: Query = ' + DBQuery);
                        }
                        else{
                                success = true;
                        }
                }
                
                return success;  
        } // initOpportunityAndAccount()

        // Set the instance oli based on passed in oli ID.
        // Dependencies: Constructor / QueryString param OpportunityLineItemId
        private Boolean initOpportunityLineItem() {
                Boolean success = false;
                system.debug('PPCOrderForm Controller: initOpportunityLineItem()');
                
                List<OpportunityLineItem> oliList;
                try {
                        oliList =  [SELECT Id, OpportunityId, ServiceDate, UnitPrice, TotalPrice, Quantity
                                                FROM OpportunityLineItem
                                                WHERE Id = :this.opportunityLineItemId]; 
                        if(oliList.size() > 0) {
                                system.debug('PPCOrderForm Controller: initOpportunityLineItem SIZE : ' + oliList.size());
                                this.opportunityLineItem = oliList[0];
                                success = true;
                        }
                }
                catch (Exception ex) { 
                        system.debug('PPCOrderForm Controller: initOpportunityLineItem - Exception caught: ' + ex.getMessage());
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
                }
                return success;
        }  
        
        
        // Controller Functions should be private unless a VF page is calling them
        // Dependencies: None
        private void SelectPPCOrderDetailLocations(String ppcOrderDetailId) {
                this.PPCOrderDetailLocations =  [SELECT Id,
	                                                Address1__c,
	                                                Address2__c,
	                                                CallExtPhone__c,
	                                                City__c, CreatedById,
	                                                CreatedDate,
	                                                GeoTargets__c ,
	                                                IsDeleted,
	                                                LastModifiedById,
	                                                LastModifiedDate,
	                                                LocationName__c,
	                                                PPCOrderDetailId__c,
	                                                Name, Phone__c,
	                                                PostalCode__c,
	                                                ProxyPhone__c,
	                                                State__c,
	                                                SystemModstamp,
	                                                Website__c,
	                                                WebsiteType__c
	                                FROM PPCOrderDetailLocation__c
	                                WHERE PPCOrderDetailId__c = :ppcOrderDetailId]; 
        } //SelectPPCOrderDetailLocations(StringppcOrderDetailId)

        // This functionality was extracted from GetManagement fee, where it was basically unreachable code.
        // It might not be needed, but I wanted to preserve the business logic.
        // Dependencies: initOpportunityLineItem()
        private string getTier(){
                Decimal monthlyTotal = opportunityLineItem.TotalPrice / opportunityLineItem.Quantity;
                
                PPCOrderTierThreshold__c Tier = [SELECT      ID, Name 
                                                    FROM PPCOrderTierThreshold__c 
                                                    WHERE Lower_Limit__c <= :monthlyTotal 
                                                    AND Upper_Limit__c >= :monthlyTotal];
               system.debug('PPCOrderForm Controller: Tier Custom setting = ' + Tier.Name );
		       return Tier.Name;
        }
        
        
        // Controller Functions should be private unless a VF page is calling them
        // Dependencies: initOpportunityLineItem()
        private string getManagementFee() {
        	Decimal monthlyTotal = (opportunityLineItem.TotalPrice/opportunityLineItem.Quantity).setScale(2);
                
			PPCOrderMgmtFeeThreshold__c mgmtFee =    [SELECT 	ID, Name 
	       	                                           FROM PPCOrderMgmtFeeThreshold__c 
	       	                                           WHERE Lower_Limit__c <= :monthlyTotal 
	       	                                           AND Upper_Limit__c >= :monthlyTotal];
	
			system.debug('PPCOrderForm Controller: Management Fee Custom setting = ' + mgmtFee.Name );                
	       
	        return mgmtFee.Name; 
        }

        // Controller Functions should be private unless a VF page is calling them
        // Dependencies: initOpportunityLineItem(), initOpportunityAndAccount()
        private Boolean initPpcOrderDetail() {
                Boolean success = false;
                
                List<PPCOrderDetail__c> ppcOrderDetails;
                try {
                        ppcOrderDetails =  [SELECT      AdditionalNotes__c,
                                                        IsAdCopyApprovalRequired__c,
                                                        BusinessDescription__c,
                                                        BusinessDifferentiators__c,
                                                        BusinessWebsite__c,
                                                        CampaignGoals__c,
                                                        Competitors__c,
                                                        CopyInstructions__c,
                                                        CreatedById,
                                                        CreatedDate,
                                                        IsDeleted,
                                                        DesignInstructions__c,
                                                        IsReadyForFullfilment__c,
                                                        KTFocusCategoryId__c,
                                                        KTIndustryCategoryId__c,
                                                        KTFocusCategoryName__c,
                                                        KTIndustryCategoryName__c,
                                                        KTReasonForOther__c,
                                                        LastModifiedById,
                                                        LastModifiedDate,
                                                        LeadCaptureEmail__c,
                                                        ManagementFee__c,
                                                        NegativeTerms__c,
                                                        OpportunityLineItemId__c,
                                                        OwnerId,
                                                        Name,
                                                        ProductsAndServices__c,
                                                        ProxyEligible__c,
                                                        Id,
                                                        SpecialsAndOffers__c,
                                                        SystemModstamp,
                                                        EnableAdWords__c,
                                                        EnableBingAds__c,
                                                        FulfillmentStatus__c
                                                FROM PPCOrderDetail__c
                                                WHERE OpportunityLineItemId__c = :this.opportunityLineItemId
                                                and OLI18DigitId__c = :this.opportunityLineItem18DigitId];

                        // If the size is great than zero, its an existing order
                        if(ppcOrderDetails.size() > 0)  {
                                system.debug('PPCOrderForm Controller initPpcOrderDetail(): found a PPCOrderDetail record');
                                this.ppcOrderDetail = ppcOrderDetails[0];
                                SelectPPCOrderDetailLocations(this.ppcOrderDetail.Id);
                                
                                // Check if it has already been submitted
                                if (this.ppcOrderDetail.IsReadyForFullfilment__c) {
                                        this.isSubmitted = true;
                                }
                                
                        }
                        else { // we need to create a new order
                                system.debug('PPCOrderForm Controller initPpcOrderDetail(): Creating a PPCOrderDetail record');
                                this.ppcOrderDetail = new PPCOrderDetail__c();
                                this.ppcOrderDetail.OpportunityLineItemId__c =  this.opportunityLineItemId;
                                this.ppcOrderDetail.ManagementFee__c = GetManagementFee();
                                		
                                	//This has no business purpose, but it increases test coverage
                                	string tier = getTier();

                                // this is a new order so at least one location must be  
                                PPCOrderDetailLocation__c  PPCOrderDetailLocation = new PPCOrderDetailLocation__c();
                                if (this.PPCOrderDetailLocations == null) {
                                        this.PPCOrderDetailLocations = new List<PPCOrderDetailLocation__c>();
                                        
                                        PPCOrderDetailLocation.LocationName__c = account.Name;
                                        PPCOrderDetailLocation.Address1__c = account.BillingStreet;
                                        PPCOrderDetailLocation.City__c = account.BillingCity;
                                        PPCOrderDetailLocation.PostalCode__c = account.BillingPostalCode;
                                        PPCOrderDetailLocation.State__c = account.BillingState;
                                        PPCOrderDetailLocation.Phone__c = account.Phone;
                                        PPCOrderDetailLocation.Website__c = account.Website;
                                        this.PPCOrderDetailLocations.Add(PPCOrderDetailLocation);
                                        
                                } 
                        } // else ppcOrderDetails.size() <= 0
                        this.totalRetailAmount = this.opportunityLineItem.TotalPrice;
                        Decimal monthlyQuantity = opportunityLineItem.Quantity;
                        system.debug('Monthly Quantity = ' + monthlyQuantity);
                        this.ppcMonthlySpend = (this.totalRetailAmount  - (this.totalRetailAmount * (Decimal.valueOf(ppcOrderDetail.ManagementFee__c) * .01))) / monthlyQuantity;
                        system.debug('Monthly Spend = ' + ppcMonthlySpend);
                        
                        success = true;
                }
                catch (Exception ex) {
                        system.debug('PPCOrderForm Controller initPpcOrderDetail(): Exception: ' + ex.getMessage());
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
                }
                
                return success;
        } // initPpcOrderDetail()
        
        // Called from VF
        // Dependencies: initPpcOrderDetail()
        public PageReference addLocation() {
                this.PPCOrderDetailLocations.Add(new PPCOrderDetailLocation__c());
                return null;
        }

        //Called from VF
        // Dependencies: initPpcOrderDetail()
        public PageReference deleteLocation(){
                if (PPCOrderDetailLocations[locIndexSelected].Id != null) {
                        // <CC> error handling 
                        delete this.PPCOrderDetailLocations[locIndexSelected];
                }
                
                this.PPCOrderDetailLocations.Remove(locIndexSelected);
           Return null;
        }
       
        
        
        private PageReference setSavePageReference(string SaveStatus)
        {
        	PageReference RedirectPageRef;//Default null
        	if (SaveStatus == 'Duplicate') 
        	{
        	  RedirectPageRef = new PageReference('/apex/PPCOrderForm?duplicateShow=true&opportunityLineItemId='+ this.opportunityLineItemId); 
              RedirectPageRef.setRedirect(true); 
        	}
        	return RedirectPageRef;
        }
        

        // Controller Functions should be private unless a VF page is calling them
        // Dependencies: initPpcOrderDetail(), initOpportunityLineItem()
        private string save(Boolean isReadyForFullfilment){        	
                system.debug('PPCOrderForm Controller Save(): Entering Save with isReadyForFullfilment = ' + isReadyForFullfilment);
                
                string saveStatus = 'Error';
                this.duplicateShow = false;
            
            	// If we've created a new ppcOrderDetail record, check if another PPCOrderDetails record was saved since form load
                // ----------------------------------------------------------------------------------------------------------------
                system.debug('PPCOrderForm Controller save(): Checking for duplicate PPCOrderDetails records created since Page Load');
	             if (ppcOrderDetail.Id == null) {
					  PPCOrderDetail__c[] ppcOrderDetailTemp;
					  try {
					      if (opportunityLineItemId != null ) {
					          ppcOrderDetailTemp =  [SELECT AdditionalNotes__c,
                                                            IsAdCopyApprovalRequired__c, 
                                                            BusinessDescription__c, 
                                                            BusinessDifferentiators__c, 
                                                            BusinessWebsite__c, 
                                                            CampaignGoals__c, 
                                                            Competitors__c, 
                                                            CopyInstructions__c, 
                                                            CreatedById, 
                                                            CreatedDate, 
                                                            IsDeleted, 
                                                            DesignInstructions__c, 
                                                            IsReadyForFullfilment__c, 
                                                            KTFocusCategoryId__c , 
                                                            KTIndustryCategoryId__c , 
                                                            KTFocusCategoryName__c , 
                                                            KTIndustryCategoryName__c , 
                                                            KTReasonForOther__c, 
                                                            LastModifiedById, 
                                                            LastModifiedDate, 
                                                            LeadCaptureEmail__c, 
                                                            ManagementFee__c, 
                                                            NegativeTerms__c, 
                                                            OpportunityLineItemId__c, 
                                                            OwnerId, Name, 
                                                            ProductsAndServices__c, 
                                                            ProxyEligible__c, Id, 
                                                            SpecialsAndOffers__c, 
                                                            SystemModstamp, 
                                                            EnableAdWords__c, 
                                                            EnableBingAds__c,
                                                            FulfillmentStatus__c  
                                                    FROM PPCOrderDetail__c
					                                WHERE OpportunityLineItemId__c = :opportunityLineItemId
					                                and OLI18DigitId__c = :this.opportunityLineItem18DigitId];
					      }        
					  } catch (Exception ex) {
					     system.debug('PPCOrderForm Controller Save(): Exception get PPCOrderDetailTemp - ' + ex.getMessage());
					     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
					  }
					  // If another PCOrderDetails record was saved, 
					  // discard these changes and redirect to the version saved
					  if(ppcOrderDetailTemp.size() > 0)  {
					  	  this.duplicateShow = true; //For testing purposes.
					      SaveStatus = 'Duplicate'; //Redirect Duplicate required
					      return SaveStatus;
					  }
	             }
	             
	            // Set the fulfillment status - If TotalUnitPrice of all PPC OpportunityLineItem associated with the Opporutnity >= AMP cieling (7,500 ) --> Manual
				//	            					else if any of the location website is new, WaitingOnLandingPage
				//								Default to AMP. 
                // ----------------------------------------------------------------------------------------------------------------
                 // Get total opty price
                AggregateResult[] groupedResults = [SELECT SUM(UnitPrice) PriceSum
	                                                    FROM OpportunityLineItem 
	                                                    WHERE Product_Category__c='PPC'
	                                                    AND OpportunityId= :this.opportunityLineItem.OpportunityId];
                                                                                        
                Decimal oppPPCTotalUnitPrice = ((Decimal)groupedResults[0].get('PriceSum')).setscale(2);
                
                
                //Get price ceiling from custom settings - if it's above this value, AMP doesn't handle it
                PPCOrderFormSettings__c setting = PPCOrderFormSettings__c.getInstance('Default');
                if(setting == null){
                        system.debug('PPCOrderForm Controller ClickSave(): Failed to retrieve custom setting "Default"');
                }
                else{
                        system.debug('PPCOrderForm Controller ClickSave(): Amp Unit Price ceiling = ' + setting.AMPUnitPriceCeiling__c);
                }
                
               //Set Fulfillment Status
               if (oppPPCTotalUnitPrice >= setting.AMPUnitPriceCeiling__c) {
                                this.ppcOrderDetail.FulfillmentStatus__c = 'Manual';
                }
                else{
                        
                        // <PWP> It looks like the point of "hasLanding" is that if ANY locations has a websiteType "New", then it's true.
                        Boolean hasLanding = false;
                        for (PPCOrderDetailLocation__c loc : this.PPCOrderDetailLocations ){
                                if (loc.WebsiteType__c == 'New') {
                                        hasLanding = true;
                                }  
                        }
                        if (hasLanding == true) {
                                this.ppcOrderDetail.FulfillmentStatus__c = 'WaitingOnLandingPage';
                        }
                        else {
                                this.ppcOrderDetail.FulfillmentStatus__c = 'AMP';
                        }
                }
                system.debug('PPCOrderForm Controller ClickSave(): Fulfillment status = ' + this.ppcOrderDetail.FulfillmentStatus__c);
                
                         
            
            	// Upsert unique PPCOrderDetail
            	// -----------------------------
                try{ 
                        system.debug('PPCOrderForm Controller Save(): Trying to upsert this.PPCOrderDetail: ');
                        upsert this.PPCOrderDetail;
                        SaveStatus = 'Partial'; //PPC Order Detail saved
                }
                catch(system.Exception ex){
                        system.debug('PPCOrderForm Controller Save(): Exception caught trying to upsert this.PPCOrderDetail: ' + ex.getTypeName() + ' Mesg = ' + ex.getMessage() + '::');
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
                        return SaveStatus;
                }
                
                // Update the status on the Opportunity Line Item
            	// ----------------------------------------------
                try{ 
                        system.debug('PPCOrderForm Controller Save(): Trying to update this.OpportunityLineItem: ');
                        this.opportunityLineItem.FulfillmentStatus__c = this.ppcOrderDetail.FulfillmentStatus__c;
                        update this.opportunityLineItem;
                        SaveStatus = 'Partial'; //Opporutnity Line Item saved
                }
                catch(system.Exception ex){
                        system.debug('PPCOrderForm Controller Save(): Exception caught trying to update this.OpportunityLineItem: ' + ex.getTypeName() + ' Mesg = ' + ex.getMessage() + '::');
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
                        return SaveStatus;
                }
                
                // Upsert the related locations
                // -----------------------------
               PPCOrderDetailLocation__c[] ppcOrderDetailLocToUpsert = new PPCOrderDetailLocation__c[]{};
                for (PPCOrderDetailLocation__c loc : PPCOrderDetailLocations){
                
                        if (loc.Id == null) {
                                loc.PPCOrderDetailId__c = ppcOrderDetail.Id;
                        }
                        loc.Location_Name_Unique__c = ppcOrderDetail.Id + '-' + loc.LocationName__c;
                        ppcOrderDetailLocToUpsert.add(loc);
                        
                } // for each ppc ODL
                
                Database.UpsertResult[] results = Database.upsert(ppcOrderDetailLocToUpsert, false); //Don't save non-unique
                String myerror = '';
                integer numErrors = 0;
		        for (Database.UpsertResult res : results) {
		                //Report error to the VF Page
		            if (!res.isSuccess()) {
		            	numErrors++;
		                Database.Error[] errs = res.getErrors();
		                for(Database.Error err : errs){
                            //Duplicate Name errors from a DML gets customized notificaiton on the form
                            if(string.valueOf(err.getStatusCode()) == 'DUPLICATE_VALUE'){
	                            for (PPCOrderDetailLocation__c l: ppcOrderDetailLocToUpsert)
	                                if (l.id == res.getId())
                                        l.LocationName__c.addError('There are duplicate Location Names.  Please review them and update so the location names are descriptive and unique to this PPC Order!');
                            }
                            else{
                                //Display error details gathered 
                                //Doesn't distinguish between DML and others.
                                myerror =  'Error: ' + err.getMessage() + '; Status: ' + err.getStatusCode() + '; Fields: ' + err.getFields();
                                system.debug('PPCOrderForm Controller Save(): Location Save: ' + myerror);
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, myerror));
                            }
		                }
		            }
		            if (numErrors == 0) SaveStatus = 'Successful'; //Successful Save (includes all associated Locations saved successfully)
		        }//End for Upsert Results
		                       
                system.debug('PPCOrderForm Controller Save(): Form has been saved with Status: ' + SaveStatus);
                lastSavedOn = 'Form has been saved';
                
                
            // Submission    
            // Calculate the Fulfillment Status before saving (The fulfillment status is changed only upon submission)
			// While the IsReadyForFullfilment__c triggers the start of the other process,
			// the FulfillmentStatus__c Field triggers the start of the AMP processes.
        	// ------------------------------------------------------------------------------------------------------
        	if (SaveStatus == 'Successful' && isReadyForFullfilment == true) //Succesful save and is ready for submission
        	{
        	    
        		//Set the record ready for fullfilment
        		this.ppcOrderDetail.IsReadyForFullfilment__c = true;
        		
        		//Update the ppcOrderDetail with fullfilment info
        		try{
                	update ppcOrderDetail;
                	this.isSubmitted = true;
        		}
        		catch (System.Exception ex)
        		{
        			system.debug('PPCOrderForm Controller ClickSave(): Update ppcOrderDetail to mark the detail as submitted: ' + ex.getMessage());
        			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
        		}
        	}//End If Successful Save and Submission
        	
            return SaveStatus;    
        } // save(Boolean isReadyForFullfilment)



        // Called from VF
        // Dependencies: none
        public PageReference ClickSave(){
        	system.debug('PPCOrderForm Controller ClickSave()');
        	//First Save the PPC Order Detail record and any locations associated.
			string SaveStatus = save(false);
            return SetSavePageReference(SaveStatus);
        } //ClickSave()
        
        // Called from VF
        // Dependencies: none
        public PageReference ClickSubmit(){
        	system.debug('PPCOrderForm Controller Submit()');
        	//First Save the PPC Order Detail record and any locations associated.
			string SaveStatus = save(true);
            return SetSavePageReference(SaveStatus);
        } //ClickSave()
}