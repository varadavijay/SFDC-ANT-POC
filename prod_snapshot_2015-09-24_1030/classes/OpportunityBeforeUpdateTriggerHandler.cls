public class OpportunityBeforeUpdateTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
		OpportunityServices.setGOAssistEmail((List<opportunity>)tp.newList);
		validateLeadGenRep((Map<Id, Opportunity>)tp.oldMap,(List<Opportunity>)tp.newList);
    	if(!Validator_MarketUpdate_class.hasAlreadyDone() &&
			!VAlidator_BeforeOppProdUpdate_class.hasAlreadyDone() &&
			!Validator_BeforeOppProdInsert_class.hasAlreadyDone()){
			this.validateIsWonOpportunities((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.validatePausedOrCancelledOnOLIs((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.setOpportunityFieldsBeforeUpdate((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateGLCalendarBasedOnOppCloseDate((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateOppOwnerConfNumber((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateOppAffSalesRepFirstName((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateOpportunityProductListing((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateDealChickenMarketAreaManager((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			this.updateOpportunityOwnerRoleReportName((List<Opportunity>)tp.newList);
			this.updateOpportunityKPIRunDateSfdcId((Map<Id, Opportunity>)tp.newMap);
                        this.ValidateOpportunityOwnedBySalesRep(tp.newList,(Map<Id,Opportunity>)tp.oldMap );
		}
	}
	 
	public override void inProgressEntry(TriggerParameters tp) {
		validateLeadGenRep((Map<Id, Opportunity>)tp.oldMap,(List<Opportunity>)tp.newList);
	}
	
	/* 
						----------- BEGIN CODE TRANSPLANT -----------------
	*/
	//set Opportunity Fields before update based on fields updates on dependent fields 
	private void setOpportunityFieldsBeforeUpdate(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		//Loop through all opps 
		for(Opportunity oneOpportunity: newOpportunities.Values()){
			//setting fields only for users who are not System Administrators - not sure why we are doing so
			if(UserInfo.GetProfileId() != ProfileCache.getProfile('System Administrator').Id){
				oneOpportunity.Last_Mod_By__c = UserInfo.GetUserId(); //Setting Field
				oneOpportunity.Last_Mod_Date__c = Datetime.Now(); //Setting Field
			}	
			
			// Setting Split_Sharer_Perc__c
			if(oneOpportunity.Split_Sharer__c != oldOpportunities.get(oneOpportunity.Id).Split_Sharer__c){
				if(oneOpportunity.Split_Sharer__c != null 
					&& oldOpportunities.get(oneOpportunity.Id).Split_Sharer__c == null){
					oneOpportunity.Split_Sharer_Perc__c = 50; //Setting Field	
				}else if(oneOpportunity.Split_Sharer__c == null 
						&& oldOpportunities.get(oneOpportunity.Id).Split_Sharer__c != null){
					oneOpportunity.Split_Sharer_Perc__c = 0; //Setting Field			
				}
			}
			
			//Setting opp Track Signed to true 
			if(oneOpportunity.Contract_Attached__c == true || oneOpportunity.DC_Parent_Opp__c != null){
				oneOpportunity.Track_Signed__c = true; //Setting Field		
			}
			
			
			//Setting Track_Date_Approved_Signed__c, StageName, CloseDate
			if((oneOpportunity.StageName == 'DC Approved' && oneOpportunity.Track_Signed__c == true) ||
			   (oneOpportunity.StageName == 'DC Signed' && oneOpportunity.Track_Approved__c == true)){
				oneOpportunity.StageName = 'Closed - Appr & Sign'; //Setting Field	
				oneOpportunity.Track_Date_Approved_Signed__c = datetime.now(); //Setting Field	
				if(oneOpportunity.CloseDate != null && oneOpportunity.CloseDate >= date.today()){
					oneOpportunity.CloseDate = date.today(); //Setting Field	
				}
			} 
			
			//Setting opp stage and Track_Date_Approved_Signed__c
			if(oneOpportunity.Track_Approved__c == true 
				&& oneOpportunity.Track_Signed__c == true
				&& (oldOpportunities.get(oneOpportunity.Id).Track_Approved__c == false
				|| oldOpportunities.get(oneOpportunity.Id).Track_Signed__c == false)){
			
				oneOpportunity.Track_Date_Approved_Signed__c = datetime.now(); //Setting Field
				if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SimplyGifted').Id){
					oneOpportunity.StageName = 'SG Approved & Signed';  //Setting Field
				}else if (oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id
                			|| oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'DealChicken_Merchandise').Id){
                	oneOpportunity.StageName = 'Closed - Appr & Sign';  //Setting Field
                }		
			} else if (oneOpportunity.Track_Approved__c == false 
						|| oneOpportunity.Track_Signed__c == false){
				 oneOpportunity.Track_Date_Approved_Signed__c = null;	//Setting Field		
			}
			
			//If SML & Media Partner is Blank, insert Gannett Local Account
			if (oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id 
				&&	oneOpportunity.Media_Partner__c == null){
				oneOpportunity.Media_Partner__c = Constants.GO_DIGITAL_COMPANY.Id; //Setting Field		
			}
			
			//Setting up Sales_Rep_II__c field value
			if(oneOpportunity.OwnerId != oneOpportunity.Sales_Rep_II__c){
				oneOpportunity.Sales_Rep_II__c = oneOpportunity.OwnerId; //Setting Field		
			}
			
			//Opportunity Transfer ownership custom field 
			if(oneOpportunity.Transfer_To_User__c != null){
				oneOpportunity.OwnerId = oneOpportunity.Transfer_To_User__c ; //Setting Field		
				oneOpportunity.Transfer_To_User__c = null; //Setting Field		
			} 
			
			//Setting or Increasing PushCount__c based on Opp Close Date Changes
			if (oneOpportunity.CloseDate > oldOpportunities.get(oneOpportunity.Id).CloseDate) { 
				//Check to see if the changed closed date is not with in the same month
				if ((oneOpportunity.CloseDate.month() > oldOpportunities.get(oneOpportunity.Id).CloseDate.month()) 
					|| (oneOpportunity.CloseDate.year() > oldOpportunities.get(oneOpportunity.Id).CloseDate.year())){ 
					if (oneOpportunity.PushCount__c != null) {
					 	oneOpportunity.PushCount__c++;	 //Setting Field	
					}else{
						oneOpportunity.PushCount__c=1;	 //Setting Field		 
					}
				} 
			}
		}
	} 
	
	//Validate an update on Lead_Gen_Rep__c is to a user in the 'Lead Generation Specialists' profile
	public static void validateLeadGenRep(Map<Id, Opportunity> oldMap, List<opportunity> newOpps) {
		Map<ID,string> leadGenUserProfileMap = new Map<ID,string>();
		//get leadgen associated profiles
		Opportunity[] oppToErrorOut = new Opportunity[]{};
		for (Opportunity opp: newOpps){
			leadGenUserProfileMap.put(opp.Lead_Gen_Rep__c,'');
		}
		user[] leadGenUsers = [SELECT ID, name, Profile.Name from user where ID in :leadGenUserProfileMap.keyset() ];
		for (user lg: leadGenUsers){
			leadGenUserProfileMap.put(lg.ID, lg.Profile.Name);
			system.debug('User: '+ lg.name + '; Profile: '+ lg.Profile.name);
		}
		// for sml opportunities, ensure that the lead gen field is updated with a user in the 'Lead Generation Specialist' profile.
		for (Opportunity opp: newOpps){
			if (opp.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id 
				&&	opp.Lead_Gen_Rep__c != oldMap.get(opp.ID).Lead_Gen_Rep__c
				&&	opp.Lead_Gen_Rep__c != null){
				if (leadGenUserProfileMap.get(opp.Lead_Gen_Rep__c) != 'Lead Generation Specialists'){
					system.debug('Adding error for OppID: ' + opp.ID + '; Record Type: ' + opp.RecordType.Name + '; Old User: ' + oldMap.get(opp.ID).Lead_Gen_Rep__c + '; New User: ' + opp.Lead_Gen_Rep__c + '; New User Profile: ' + leadGenUserProfileMap.get(opp.Lead_Gen_Rep__c));
					opp.Lead_Gen_Rep__c.addError('Lead Gen Rep must be a User in the \'Lead Generation Specialists\' Profile, please look up another User.');
				}
			}
		}
	}
	
	//update GL_Calender__c field based of opportunity Closed Date
	private void updateGLCalendarBasedOnOppCloseDate(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		Map<Id, Date> onlyClosedOpps = new Map<Id, Date>();  
		
		for(Opportunity oneOpportunity: newOpportunities.Values()){
			if(oneOpportunity.closedate != null && oneOpportunity.closedate != oldOpportunities.get(oneOpportunity.Id).closedate){
				onlyClosedOpps.put(oneOpportunity.Id, oneOpportunity.closedate) ;  // only closed opps map 
			}  
		}
		
		//Only closed opps
		if(onlyClosedOpps.size()>0){
			List<KPICalender__c> lstKPICalendar = [SELECT kc.Id, Kc.Date__c FROM KPICalender__c kc WHERE Date__c in :onlyClosedOpps.values()];
			Map<Date, Id> mapKpiCalendarId	 =  new Map<Date, Id> ();
			
			for(KPICalender__c oneKpiCalendar : lstKPICalendar){
				mapKpiCalendarId.put(oneKpiCalendar.Date__c, oneKpiCalendar.Id);
			}
			System.debug('Closed Ops >> ' + onlyClosedOpps);
			System.debug('KPICalender__c >> ' + mapKpiCalendarId);
			//set relation to KPICalender__c based on Opportunity Closed Date
			for(Id oneOppId : onlyClosedOpps.keySet()) {
				Id kpiCalfdcId = mapKpiCalendarId.get(onlyClosedOpps.get(oneOppId));  
				System.debug('What Is kpiCalfdcId >> ' + kpiCalfdcId);
		        newOpportunities.get(oneOppId).GL_Calender__c = kpiCalfdcId;   //Setting Field #1
			}
		} 
	}
	
	//update Affiliated Sales Rep First Name field AfflRep_FirstName__c 
	private void updateOppAffSalesRepFirstName(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		Map<Id, Id> oppSalesRepIds = new Map<Id, Id> ();
		for(Opportunity oneOpportunity : newOpportunities.Values()){
			if(oneOpportunity.Sales_Rep__c !=  oldOpportunities.get(oneOpportunity.Id).Sales_Rep__c){
				oppSalesRepIds.put(oneOpportunity.Id, oneOpportunity.Sales_Rep__c);
			}
		}
		
		if(oppSalesRepIds.size()>0){
			Map<Id, Contact> mapOppSalesReps = new Map<Id, Contact>([Select Id, FirstName, LastName FROM Contact Where Id in :oppSalesRepIds.values()]);
			System.debug('mapOppSalesReps >> ' + mapOppSalesReps);
			for(Id oneOppId: oppSalesRepIds.KeySet()){
				// Setting Field Opp Sales Rep First Name AfflRep_FirstName__c
				if(mapOppSalesReps.get(oppSalesRepIds.get(oneOppId)) != null){
					newOpportunities.get(oneOppId).AfflRep_FirstName__c = mapOppSalesReps.get(oppSalesRepIds.get(oneOppId)).FirstName;
				}else{
					newOpportunities.get(oneOppId).AfflRep_FirstName__c = null;
				} 
			}
		}
	}
	
	
	//Update Conf_Number__c from Owner.Conf_Number__c
	private void updateOppOwnerConfNumber(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		Map<Id, Id> oppOwnerIds = new Map<Id, Id> ();
		for(Opportunity oneOpportunity : newOpportunities.Values()){
			if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id){
				oppOwnerIds.put(oneOpportunity.Id, oneOpportunity.OwnerId);
			}
		}
		
		Map<Id, KPIRep__c> mapUserIdKpiReps = new Map<Id, KPIRep__c>();
		if(oppOwnerIds.size()>0){
			List<KPIRep__c> kpiReps = new List<KPIRep__c>([Select Id, User__c, Conf_Number__c from KPIRep__c Where User__c in :oppOwnerIds.values()]);
			for(KPIRep__c oneKpiRep: kpiReps){
				mapUserIdKpiReps.put(oneKpiRep.User__c, oneKpiRep);
			}
		}
		
		// Setting Field Opp Owner Conf_Number__c
		for(Opportunity oneOpportunity : newOpportunities.Values()){
			oneOpportunity.Conf_Number__c = (mapUserIdKpiReps.get(oneOpportunity.OwnerId) != null?
												mapUserIdKpiReps.get(oneOpportunity.OwnerId).Conf_Number__c: null);
		} 
	}
	
	//Validation Rules for SML Opps when marked as ISWON
    private void validateIsWonOpportunities (Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
    	Set<Id> onlySMLOpps = new Set<Id>(); 
    	for(Opportunity oneOpportunity: newOpportunities.values()){
    		if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id
    			&& !oneOpportunity.Signature_Override__c
    			&& oneOpportunity.IsWon && !oldOpportunities.get(oneOpportunity.Id).IsWon){
    			onlySMLOpps.add(oneOpportunity.Id); //Only SML Opps that match criteria 
    		}
    	}
    	
    	if(onlySMLOpps.size()>0){
    		Map<Id, Id> mapTinderBoxProposals = new Map<Id, Id>();
    		
    		//Querying for Accepted Tinderbox proposals for sml opps 
    		List<tinderbox__Proposal__c>  lstTinderBoxProposals
    				=  [Select t.Id, t.tinderbox__Status__c, t.tinderbox__Opportunity__c
	                            From tinderbox__Proposal__c t
	                            where t.tinderbox__Status__c = 'Accepted'
	                            and t.tinderbox__Opportunity__c in: onlySMLOpps];
		                        
			for(tinderbox__Proposal__c oneTinderBoxProposal: lstTinderBoxProposals){
                mapTinderBoxProposals.put(oneTinderBoxProposal.tinderbox__Opportunity__c, oneTinderBoxProposal.Id);
            }
            
            for(Id oneOpportunityId: onlySMLOpps){
                if(mapTinderBoxProposals.get(oneOpportunityId) == null){
                    //adding error message on the corresponding opportunity
                    newOpportunities.get(oneOpportunityId).addError('The Opportunity may not be Closed Won without an Accepted TinderBox proposal. Please contact your manager with any questions.');   
                }
            }
        }  
    }
    
    //formation Product
    private String formatOpportunityProductNames(List<OpportunityLineItem> opportunityLineItems){
    	Map<String, Integer> mapOppProductsCount = new Map<String, Integer>();
    	
    	for(OpportunityLineItem oneOppLineItem: opportunityLineItems){ 
    		if(String.IsNotBlank(oneOppLineItem.Product_Name__c)){
    			Integer unqProductCount = (mapOppProductsCount.get(oneOppLineItem.Product_Name__c) !=null ? 
    											mapOppProductsCount.get(oneOppLineItem.Product_Name__c):0);
				unqProductCount = unqProductCount + 1;
				mapOppProductsCount.put(oneOppLineItem.Product_Name__c, unqProductCount);   											
    		}
    	}
    	
        String formattedProductsName = '';
        Integer ProductCount = 1 ;
        
        for(String oneOppProduct: mapOppProductsCount.KeySet()){ 
            formattedProductsName = formattedProductsName + ProductCount + ' - ' + oneOppProduct
               						+ ' : Count = ' + mapOppProductsCount.get(oneOppProduct) + '\n';
            ProductCount ++;
        }
        return formattedProductsName;
    }
    
    //Validate paused or cancelled on opp line items based on opporunity update
    private void validatePausedOrCancelledOnOLIs(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
        Set<Id> oppIdsMatchCriteria = new Set<Id>();
        
        for(Opportunity oneOpportunity : newOpportunities.Values()){
            if (oneOpportunity.Paused_Or_Canceled__c != oldOpportunities.get(oneOpportunity.Id).Paused_Or_Canceled__c
                && oneOpportunity.RecordTypeId != RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id 
                && oneOpportunity.StageName == 'Closed Won'
                && oneOpportunity.Paused_Or_Canceled__c == 'Cancelled')
            {
                oppIdsMatchCriteria.add(oneOpportunity.Id);
            }   
        }   
        
        if(oppIdsMatchCriteria.size()>0){
            List<OpportunityLineItem> OpptyLineItems = [SELECT Id, Waiting_Status__c, OpportunityId,
                                                               Waiting_Status_Descr__c, Status_Change_Date__c
                                                            From OpportunityLineItem
                                                            WHERE OpportunityId in :oppIdsMatchCriteria
                                                            AND Waiting_Status__c != 'Cancelled'];
                                                            
            for(OpportunityLineItem oneOpptyLineItem : OpptyLineItems){
                if(!Validator_CancelProjUpdate_class.hasCANAlreadyDone()){
                    newOpportunities.get(oneOpptyLineItem.OpportunityId).Paused_Or_Canceled__c.addError('The Opportunity can not be Cancelled without all Opportunity Products being Cancelled first');
                }
            }
            Validator_CancelProjUpdate_class.setCANAlreadyDone();                                           
        }   
    }
    
    //Update Product Listing Field on Opportunity from Opportunity Line Items
    private void updateOpportunityProductListing(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
        Set<Id> onlyDigitalOppsWithDigAM = new set<Id>();
        
        //fill set for later use
        for(Opportunity oneOpportunity: newOpportunities.Values()){
            if(oneOpportunity.Dig_Account_Manager__c != null){
                onlyDigitalOppsWithDigAM.add(oneOpportunity.Id); 
            }
        }
        
        //All Opps with DigAM Populated
        if(onlyDigitalOppsWithDigAM.size()>0){
            Map<Id, Opportunity> mapOpportunities = new Map<ID, Opportunity>([SELECT Id, (Select Id, Product_Name__c,  Waiting_Status__c, Project__c
                                                                                         FROM OpportunityLineItems ORDER BY Product_Name__c ASC)
                                                                               From Opportunity WHERE Id in :onlyDigitalOppsWithDigAM]);
            
            //Awaiting Onboard & AM Assignment - Status Notifications To Channel
            for(Opportunity oneOpportunity : mapOpportunities.values()) {  
                 newOpportunities.get(oneOpportunity.Id).Product_List__c = this.formatOpportunityProductNames(oneOpportunity.OpportunityLineItems);  //Setting Field #2
            }
        }
    }
    
    //update Dealchicken Market Area Manager opportunity
    private void updateDealChickenMarketAreaManager(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
        Map<Id, String> OnlyDealChickenOpps = new Map<Id, String>();
        //Loop through all opps 
        for(Opportunity oneOpportunity: newOpportunities.Values()){
            //filling map for later use
            if((oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id ||
                oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'DealChicken_Merchandise').Id ||
                oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SimplyGifted').Id) && 
                oneOpportunity.Market_Record__c != null &&
               	((oneOpportunity.Market_Record__c != oldOpportunities.get(oneOpportunity.Id).Market_Record__c) || 
               	oneOpportunity.DealChicken_Market__c == null)){
                                 	
                OnlyDealChickenOpps.put(oneOpportunity.Id, oneOpportunity.Market_Record__c);  //filtered more than just dealchicken record type 	
            }
		}
		
		
		//Updating DealChicken related attributes on Opp
		if(OnlyDealChickenOpps.size()>0){
			Map<String, Market__c> mapMarkets = new Map<String,Market__c>();
			List<Market__c> lstMarkets = [SELECT Id, Name, DealChicken_Approver__c 
                                                  FROM Market__c
                                                  WHERE Name in :OnlyDealChickenOpps.Values()];
			
			for(Market__c oneMarket: lstMarkets){
				mapMarkets.put(oneMarket.Name, oneMarket);	
			}   
			                                               
			for(Id oneOppId : OnlyDealChickenOpps.KeySet()){
				if(mapMarkets.get(newOpportunities.get(oneOppId).Market_Record__c) !=null){
				 	newOpportunities.get(oneOppId).DealChicken_Market__c = mapMarkets.get(newOpportunities.get(oneOppId).Market_Record__c).Id; //Setting Field #3
				 	newOpportunities.get(oneOppId).Market_Area_Manager__c = mapMarkets.get(newOpportunities.get(oneOppId).Market_Record__c).DealChicken_Approver__c; //Setting Field #4
				}
			} 
		}
	}
	
	//Update Opportunity Owner Role Report Name 
	private void updateOpportunityOwnerRoleReportName(List<Opportunity> newOpportunities){
		Set<Id> oppOwnerIds = new Set<Id>();
		for(Opportunity oneOpportunity: newOpportunities){
			if(String.IsBlank(oneOpportunity.RSM__c) && oneOpportunity.IsWon == true){
				oppOwnerIds.add(oneOpportunity.OwnerId);
			}
		}
		
		if(oppOwnerIds.size()>0){
			Map<Id, User> mapUsers = new Map<Id, User>([Select Id, Role_Report_To__r.Name from User Where Id in: oppOwnerIds]);
			for(Opportunity oneOpportunity: newOpportunities){
				if(String.IsBlank(oneOpportunity.RSM__c) && oneOpportunity.IsWon == true){
					if(mapUsers.get(oneOpportunity.OwnerId)!=null){
						oneOpportunity.RSM__c = mapUsers.get(oneOpportunity.OwnerId).Role_Report_To__r.Name; // Setting Field
					}
				}
			}
		}
	}
	
	//Update Opportunity KPI Run Date DC_KPI_Run_Date__c
	private void updateOpportunityKPIRunDateSfdcId(Map<Id, Opportunity> newOpportunities){
		Map<Id, Date> oppRunDates = new Map<Id, Date>();
		for(Opportunity oneOpportunity: newOpportunities.Values()){
			if((oneOpportunity.DC_KPI_Run_Date__c == null && oneOpportunity.DC_Run_Date__c != null) ||
			   (oneOpportunity.StageName == 'Closed - Appr & Sign' && oneOpportunity.Track_Signed__c == false)){
				oppRunDates.put(oneOpportunity.Id, oneOpportunity.DC_Run_Date__c);   	
		   	}
		}
		
		if(oppRunDates.size()>0){
			List<KPICalender__c> kpiCalRecords = [SELECT Id, Date__c FROM KPICalender__c
		   														WHERE Date__c in : oppRunDates.values()];
		   	Map<Date, Id> mapKPICalByDate = new Map<Date, Id>();
		   	for(KPICalender__c oneKPIcal : kpiCalRecords){
		   		mapKPICalByDate.put(oneKPIcal.Date__c, oneKPIcal.Id);
		   	}
		   	
		   	for(Id oneOppId : oppRunDates.KeySet()){
		   		if(mapKPICalByDate.get(oppRunDates.get(oneOppId)) != null){
		   			newOpportunities.get(oneOppId).DC_KPI_Run_Date__c = mapKPICalByDate.get(oppRunDates.get(oneOppId));
		   		}
		   	}
		}    
	}
	  // Getting the count of oppotunities the user has owned and updating on USser_Data__c object
	 private void ValidateOpportunityOwnedBySalesRep(list<Opportunity> newOppList,map<id,Opportunity> oldoppmap){
	 	System.debug('@@@@updatedsize@@@'+newOppList.size());
         Id SMLOpportunityRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SML Opportunity').getRecordTypeId();
         String staleOpportunityId =   Constants.STALE_OPPORTUNITY.Id;
          map<id,list<Opportunity>> userWithOppMap = new map<id,list<Opportunity>>();
          map<id,integer> numberofOpportunitiesOwned = new map<id,integer>();
          map<id,integer> numberofOpportunitiesOwning   = new map<id,integer>();
          set<id> newoppownerids            = new  set<id> ();
            for(Opportunity oppRecord : newOppList){
                if(oppRecord.ownerid != null && (oppRecord.ownerid!=oldoppmap.get(oppRecord.id).Ownerid 
                  || oppRecord.RecordTypeid!=oldoppmap.get(oppRecord.id).RecordTypeid
                  || oppRecord.StageName!=oldoppmap.get(oppRecord.id).StageName)) {
               
                    string oppOwnerid =(string)oppRecord.Ownerid;
                    if(oppOwnerid.contains('005')){
                        newoppownerids.add(oppRecord.Ownerid);    
                       if(oppRecord.RecordTypeid == SMLOpportunityRecTypeId && (!(oppRecord.StageName.contains('Closed Won') || 
                          oppRecord.StageName.contains('Closed Lost') || oppRecord.StageName.contains('Contract Approved by Jumpstart')))){      
                         if(userWithOppMap.containsKey(oppRecord.Ownerid) ){
                             userWithOppMap.get(oppRecord.Ownerid).add(oppRecord);
                         }
                         else {
                            userWithOppMap.put(oppRecord.Ownerid,new list<Opportunity>{oppRecord});
                         }
                       }
                    }
                }//End of If Block
            }//End of FOR loop
           
         map<id,user>      userMap     = new map<id,User>([SELECT id ,name,userRole.name FROM USER WHERE (id IN : newOppownerids or  id = : userinfo.getuserid())]);
         AggregateResult[] oppAggList =[SELECT ownerid,count(id)total FROM Opportunity 
         									WHERE  RecordtypeId = :SMLOpportunityRecTypeId 
         											AND	ownerid IN :userWithOppMap.keySet() 
         											AND owner.name Not In ('Stale Opportunity')
         											AND StageName Not In ('Closed Won', 'Closed Lost' , 'Contract Approved by Jumpstart') 
         									Group By Ownerid];
        
        for(AggregateResult oppAgr :oppAggList){
            id uid = (id)oppAgr.get('ownerid');
            system.debug('uid ======================'+uid );
            integer totalCount = (Integer)oppAgr.get('total');//getting the count of already owned SML Records 
            System.debug('@@@totalcount'+totalcount);
              Integer oppsOwned;          
             if(userWithOppMap.containsKey(uid)){
                oppsOwned = totalCount + userWithOppMap.get(uid).size();// Getting the counts of trying to own SML leads Including the existing SML Lead counts// Getting the counts of trying to own SML leads Including the existing SML Lead counts
              }
                numberofOpportunitiesOwning.put(uid,totalCount);
                numberofOpportunitiesOwned.put(uid,oppsOwned);
                newOppownerids.remove(uid);
         }//End of FOR loop of AggregateResult
       if(!newOppownerids.isempty()){
            for(id oppownerid :userWithOppMap.keyset()){
               if( userMap.containsKey(oppownerid )){
                 Integer totalCount = 0;
                 Integer oppsOwned;
                 user u                         =  userMap.get(oppownerid );
                 if(userWithOppMap.containsKey(u.id)){
                    oppsOwned = totalCount + userWithOppMap.get(oppownerid).size();// Getting the count of trying to own SML leads Including the existing SML Lead counts
                    System.debug('###leadsowned1234'+oppsOwned); 
                 }
                 numberofOpportunitiesOwning.put(u.id,totalCount);
                numberofOpportunitiesOwned.put(u.id,oppsOwned);
               }
           }
        }
       for(Opportunity oppRec : newOpplist){
           if(userMap.containsKey(oppRec.ownerid) && (oppRec.ownerid!=oldoppmap.get(oppRec.id).Ownerid 
              || oppRec.RecordTypeid!=oldoppmap.get(oppRec.id).RecordTypeid
              || oppRec.StageName!=oldoppmap.get(oppRec.id).StageName)){
             User u1 = userMap.get(oppRec.ownerId);
             if(numberofOpportunitiesOwned.containsKey(oppRec.ownerid) && oppRec.RecordTypeid == SMLOpportunityRecTypeId &&  u1.userrole.name!=NULL 
             && (!(oppRec.StageName.contains('Closed Won') || oppRec.StageName.contains('Closed Lost') || oppRec.StageName.contains('Contract Approved by Jumpstart')))){
                 
                 // Validate the max lead count for Sales Rep 
                if( (u1.userrole.name.startsWith('RAE') ||  u1.userrole.name.startsWith('Acquisition'))
                   &&(!(u1.userrole.name.contains('Mgr') || u1.userrole.name.contains('Manager') || u1.userrole.name.contains('Director ')))
                   &&  numberofOpportunitiesOwned.get(oppRec.ownerid)>50){
                   opprec.addError('The User has reached the maximum limit of 50 open Opportunities in their ownership. Please have the User assign another Opportunity to Stale Opps or contact your manager for assistance.');
                 }
                 
                 //Validate the max lead count for Sales Analyst Role Users
                 if(u1.userrole.name == 'Sales Analyst' && numberofOpportunitiesOwned.get(oppRec.ownerid)>1){
                   opprec.addError('The User has reached the maximum limit of 1 open Opportunities in their ownership. Please have the User assign another Opportunity to Stale Opps or contact your manager for assistance.');
              
                 }
              }
       	   }  
       	   
       	     if(userMap.containsKey(userinfo.getuserid()) && oppRec.ownerid!=oldoppmap.get(oppRec.id).Ownerid ){ 
                 User u2 = userMap.get(userinfo.getuserid());
                 if(u2.userrole.name != NULL){
                 String oppOwnerid =(string)oppRec.Ownerid;
   
              //This validation rule prevents Sales Rep  from Changing the Record owner unless the record is owned by "Stale Opportunity".
                  if(oldoppmap.get(oppRec.id).Ownerid != staleOpportunityId  && oldoppmap.get(oppRec.id).Ownerid != Userinfo.getuserid()
                     && (u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
                     || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst')
                     &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director ')))){
                     System.debug('@@@ErrorDebug@@'+oldoppmap.get(oppRec.id).Ownerid);
                               
                      oppRec.addError('You may only assign an Opportunity owned by you to Stale Opps or another Sales Representative. Request that the other User assign the Opportunity to you or Stale Opps or contact your manager for assistance.');
                  }
                       //This validates the current user of ROE stated roles from assigning leads to any other queues except Open Acq Leads Queue.
                    
                  //This validates the current user of ROE stated roles from assigning leads to any other Users except ROE stated Role users.
                if(userMap.containsKey(oppRec.Ownerid)){
                  User u3 = userMap.get(oppRec.Ownerid);
                 if(oppOwnerid.contains('005') && u3.userrole.name!=NULL ){
                    if( oppRec.ownerid !=  staleOpportunityId && (oldoppmap.get(oppRec.id).Ownerid == Userinfo.getuserid() || oldoppmap.get(oppRec.id).Ownerid == staleOpportunityId )
                       && (!(u3.userrole.name.startsWith('RAE') ||  u3.userrole.name.startsWith('Acquisition') || u3.userrole.name.startsWith('National')
                       || u3.userrole.name.startsWith('TSE') || u3.userrole.name == 'Sales Analyst') || u3.userrole.name.contains('Mgr') 
                       || u3.userrole.name.contains('Manager') || u3.userrole.name.contains('Director'))
                       && (u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
                       || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst') 
                       &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
                       
                       opprec.addError('You may only assign an Opportunity from Stale Opps or yourself to another Sales Representative. Assign the Opportunity to Stale Opps or a Sales Representative or contact your manager for assistance.');
                       }
                 }
                
                if(oppOwnerid.contains('005') && u3.userrole.name == NULL ){
                    if((u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
                         || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst') 
                         &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
                         
                         opprec.addError('You may only assign an Opportunity from Stale Opps or yourself to another Sales Representative. Assign the Opportunity to Stale Opps or a Sales Representative or contact your manager for assistance.');
                      }
                }//  End of If Block  
             }//End of If Block
           }//End of If Block
         } //End of If Block
        }//End of For Loop
           
    }//End of Method ValidateOpportunity

}