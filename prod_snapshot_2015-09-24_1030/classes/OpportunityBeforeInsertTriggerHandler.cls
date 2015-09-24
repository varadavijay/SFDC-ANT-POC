public class OpportunityBeforeInsertTriggerHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		OpportunityServices.setGOAssistEmail((List<Opportunity>)tp.newList);
		this.setOpportunityFieldsBeforeInsert((List<Opportunity>)tp.newList);
		this.updateGLCalendarBasedOnOppCloseDate((List<Opportunity>)tp.newList);
		this.updateOppOwnerConfNumber((List<Opportunity>)tp.newList);
		this.updateDealChickenMarketAreaManager((List<Opportunity>)tp.newList);
		validateLeadGenRep((List<Opportunity>)tp.newList);
		this.OppsOwnedBySalesRep((List<Opportunity>)tp.newList);
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		validateLeadGenRep((List<Opportunity>)tp.newList);
	}
	
	/* 
						----------- BEGIN CODE TRANSPLANT -----------------
	*/
	//set Opportunity Fields before insert based on other field data
	private void setOpportunityFieldsBeforeInsert(List<Opportunity> newOpportunities){
		//Loop through all opps 
		for(Opportunity oneOpportunity: newOpportunities){
			//IF SML & Media Partner is Blank, insert Gannett Local Account
			if (oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id 
					&&	oneOpportunity.Media_Partner__c == null){
				oneOpportunity.Media_Partner__c = Constants.GO_DIGITAL_COMPANY.Id;   //Setting Media_Partner__c Field Value
			}
			
			//Setting up Sales_Rep_II__c field value
			if(oneOpportunity.OwnerId != oneOpportunity.Sales_Rep_II__c){
				oneOpportunity.Sales_Rep_II__c = oneOpportunity.OwnerId;
			}
		}
	}
	
	//Validate an update on Lead_Gen_Rep__c is to a user in the 'Lead Generation Specialists' profile
	public static void validateLeadGenRep(List<opportunity> newOpps) {
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
					&&	leadGenUserProfileMap.get(opp.Lead_Gen_Rep__c) != 'Lead Generation Specialists'
					&&	opp.Lead_Gen_Rep__c != null){
				system.debug('Adding error for OppID: ' + opp.ID + '; Record Type: ' + opp.RecordType.Name + '; New User: ' + opp.Lead_Gen_Rep__c + '; New User Profile: ' + leadGenUserProfileMap.get(opp.Lead_Gen_Rep__c));
				opp.Lead_Gen_Rep__c.addError('Lead Gen Rep must be a User in the \'Lead Generation Specialists\' Profile, please look up another User.');
			}
		}
	}
	
	//update GL_Calender__c field based of opportunity Closed Date
	private void updateGLCalendarBasedOnOppCloseDate(List<Opportunity> newOpportunities){
		Set<Date> onlyClosedOppDates = new set<Date>();  
		
		for(Opportunity oneOpportunity: newOpportunities){
			if(oneOpportunity.closedate != null){
				onlyClosedOppDates.add(oneOpportunity.closedate) ;  // only closed opp dates  
			}  
		}
		
		//Only closed opps
		if(onlyClosedOppDates.size()>0){
			List<KPICalender__c> lstKPICalendar = [SELECT kc.Id, Kc.Date__c FROM KPICalender__c kc 
														WHERE Date__c in :onlyClosedOppDates];
			Map<Date, Id> mapKpiCalendarId	 =  new Map<Date, Id> ();
			
			for(KPICalender__c oneKpiCalendar : lstKPICalendar){
				mapKpiCalendarId.put(oneKpiCalendar.Date__c, oneKpiCalendar.Id);
			}
			
			System.debug('Closed Ops >> ' + onlyClosedOppDates);
			System.debug('KPICalender__c >> ' + mapKpiCalendarId);
			//set relation to KPICalender__c based on Opportunity Closed Date
			for(Opportunity oneOpportunity : newOpportunities) { 
				Id kpiCalfdcId = mapKpiCalendarId.get(oneOpportunity.closedate);  
				System.debug('What Is kpiCalfdcId >> ' + kpiCalfdcId);
		        oneOpportunity.GL_Calender__c = kpiCalfdcId;   //Setting Field #1
			}
		} 
	}
	
		 
	
	//Update Conf_Number__c from Owner.Conf_Number__c
	private void updateOppOwnerConfNumber(List<Opportunity> newOpportunities){
		Set<Id> oppOwnerIds = new Set<Id> ();
		for(Opportunity oneOpportunity : newOpportunities){
			if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id){
				oppOwnerIds.add(oneOpportunity.OwnerId);
			}
		}
		
		Map<Id, KPIRep__c> mapUserIdKpiReps = new Map<Id, KPIRep__c>();
		if(oppOwnerIds.size()>0){
			List<KPIRep__c> kpiReps = new List<KPIRep__c>([Select Id, User__c, Conf_Number__c from KPIRep__c Where User__c in :oppOwnerIds]);
			for(KPIRep__c oneKpiRep: kpiReps){
				mapUserIdKpiReps.put(oneKpiRep.User__c, oneKpiRep);
			}
		}
		
		// Setting Field Opp Owner Conf_Number__c
		for(Opportunity oneOpportunity : newOpportunities){
			oneOpportunity.Conf_Number__c = (mapUserIdKpiReps.get(oneOpportunity.OwnerId) != null?
												mapUserIdKpiReps.get(oneOpportunity.OwnerId).Conf_Number__c: null);
		} 
	}
	
	//update Dealchicken Market Area Manager opportunity
	private void updateDealChickenMarketAreaManager(List<Opportunity> newOpportunities){
		Set<String> OnlyDealChickenOppMarketRecords = new Set<String>();
		//Loop through all opps 
		for(Opportunity oneOpportunity: newOpportunities){
			//filling map for later use
			if((oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id ||
                oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'DealChicken_Merchandise').Id ||
                oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'SimplyGifted').Id) && 
                oneOpportunity.Market_Record__c != null){
                                 	
                OnlyDealChickenOppMarketRecords.add(oneOpportunity.Market_Record__c);  //filtered more than just dealchicken record type 	
            }
		}
		
		
		//Updating DealChicken related attributes on Opp
		if(OnlyDealChickenOppMarketRecords.size()>0){
			Map<String, Market__c> mapMarkets = new Map<String,Market__c>();
			List<Market__c> lstMarkets = [SELECT Id, Name, DealChicken_Approver__c 
                                                  FROM Market__c
                                                  WHERE Name = :OnlyDealChickenOppMarketRecords];
			
			for(Market__c oneMarket: lstMarkets){
				mapMarkets.put(oneMarket.Name, oneMarket);	
			}   
			                                               
			for(Opportunity oneOpportunity: newOpportunities){
				if(oneOpportunity.Market_Record__c !=null && mapMarkets.get(oneOpportunity.Market_Record__c) !=null){
				 	oneOpportunity.DealChicken_Market__c = mapMarkets.get(oneOpportunity.Market_Record__c).Id; 						 //Setting Field 
				 	oneOpportunity.Market_Area_Manager__c = mapMarkets.get(oneOpportunity.Market_Record__c).DealChicken_Approver__c; //Setting Field 
				}
			} 
		}
	}

    // Getting the count of Opps Owned by user and updating on User Data Object
    private void OppsOwnedBySalesRep(List<Opportunity> newOppList ){
    System.debug('@@@@inOPPSOWNED'+newOppList.size());
            map<id,list<Opportunity>> userWithOppMap = new map<id,list<Opportunity>>();
            map<id,integer> numberofOpportunitiesOwned = new map<id,integer>();
            map<id,integer> numberofOpportunitiesOwning   = new map<id,integer>();
            set<id> newOppownerids            = new  set<id> ();
            Id SMLOpportunityRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SML Opportunity').getRecordTypeId();
            for(Opportunity oppRecord : newOppList){
               
                    string OppOwnerid =(string)oppRecord.Ownerid;
                    if(OppOwnerid.contains('005')){
                        newOppownerids.add(oppRecord.Ownerid);    
                       if(oppRecord.RecordTypeid == SMLOpportunityRecTypeId && (!(oppRecord.StageName.contains('Closed Won') || 
                         oppRecord.StageName.contains('Closed Lost') ||  oppRecord.StageName.contains('Contract Approved by Jumpstart')))){
                         if(userWithOppMap.containsKey(oppRecord.Ownerid)){
                             userWithOppMap.get(oppRecord.Ownerid).add(oppRecord);
                         }
                         else {
                            userWithOppMap.put(oppRecord.Ownerid,new list<Opportunity>{oppRecord});
                         }
                      }
                    }
            }//End of FOR loop
         
         
        map<id,user>      userMap     = new map<id,User>([SELECT id ,name,userRole.name FROM USER WHERE id IN : newOppownerids AND userRoleid!=null]);
         AggregateResult[] oppAggList = [SELECT ownerid,count(id)total FROM Opportunity WHERE StageName Not In ('Closed Won', 'Closed Lost' , 'Contract Approved by Jumpstart') AND RecordTypeid = :SMLOpportunityRecTypeId AND  ownerid IN :userWithOppMap.keySet() and owner.name Not In ('Stale Opportunity') Group By Ownerid];
        for(AggregateResult OppAgr :oppAggList){
            id uid = (id)OppAgr.get('ownerid');
             Integer totalCount = (Integer)OppAgr.get('total');// getting the count of already owned SML Records 
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
     for(Opportunity oppRec : newOppList){
           string oppOwner = (string)oppRec.ownerid;
            if(oppOwner.contains('005') && userMap.containsKey(oppRec.ownerid)){
             User u1 = userMap.get(oppRec.ownerId);
             if(numberofOpportunitiesOwned.containsKey(oppRec.ownerid) && oppRec.RecordTypeid == SMLOpportunityRecTypeId && (!(oppRec.StageName.contains('Closed Won') || oppRec.StageName.contains('Closed Lost') || 
                oppRec.StageName.contains('Contract Approved by Jumpstart')))){
                 
               // Validate the max lead count for Sales Rep  
               if( (u1.userrole.name.startsWith('RAE') ||  u1.userrole.name.startsWith('Acquisition'))
                   &&(!(u1.userrole.name.contains('Mgr') || u1.userrole.name.contains('Manager') || u1.userrole.name.contains('Director')))
                   &&  numberofOpportunitiesOwned.get(oppRec.ownerid)>50){
                   oppRec.addError('The User has reached the maximum limit of 50 open Opportunities in their ownership. Please have the User assign another Opportunity to Stale Opps or contact your manager for assistance.');
               }
                
                //// Validate the max lead count for Sales Analyst Role Users
                if(u1.userrole.name == 'Sales Analyst' && numberofOpportunitiesOwned.get(oppRec.ownerid)>1){
                   oppRec.addError('The User has reached the maximum limit of 1 open Opportunities in their ownership. Please have the User assign another Opportunity to Stale Opps or contact your manager for assistance.');
              
                }
             }
                 
           }
        }//End of Lead FOR loop
        
        
    }//End of Method OppsOwnedBySalesRep
}