public class OpportunityAfterInsertTriggerHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		this.updateCompanyAccountManager((List<Opportunity>)tp.newList);
		this.insertIntoOpportunityTrackingObject((List<Opportunity>)tp.newList);
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/* 
		----------- BEGIN CODE TRANSPLANT -----------------
	*/
	//DEV-627 Update Account Manager on Company Record with Digital Account Manager
	// on newly Created Opportunity 
	private void updateCompanyAccountManager(List<Opportunity> newOpportunities){
		for(Opportunity oneOpportunity: newOpportunities){
			if (String.IsNotBlank(oneOpportunity.Dig_Account_Manager__c)){
				Account newAccount = (Account) this.getReferenceToSobjectsToUpdateRecord(oneOpportunity.AccountId); 
				newAccount.Account_Manager__c = oneOpportunity.Dig_Account_Manager__c;
			}
		}
	}	 
	
	//Insert into Opportunity Tracking Objects
	private void insertIntoOpportunityTrackingObject(List<Opportunity> newOpportunities){
		//Retrieve KPICalender__c record : expected to be single record for todays date
        Id kpiCalfdcId; // Use this Id in all places required 
        List<KPICalender__c> todayKPIRecords = [SELECT Id, Date__c FROM KPICalender__c WHERE Date__c = :date.today()];
        if(todayKPIRecords != null && todayKPIRecords.size()>0){
        	kpiCalfdcId = todayKPIRecords[0].Id;
        }else{
        	System.debug('Something wrong with data setup in KPICalender__c objects >> We should always have a record with today date in KPICalender__c object');
        	kpiCalfdcId = Constants.KPI_CAL_20121031.Id;
        }
        
        //Retrieve KPIRep__c record : expected to be single record for the user logged in 
    	Id kpiRepsfdcId;
        List<KPIRep__c> kpiRepRecords = [SELECT Id, User__c FROM KPIRep__c WHERE User__c = :UserInfo.GetUserId()];
        
        if(kpiRepRecords != null && kpiRepRecords.size()>0){
        	kpiRepsfdcId = kpiRepRecords[0].Id;
        }else{
        	System.debug('Something wrong with data setup in KPIRep__c object >> There is no record for user logged in KPIRep__c object');
        	kpiRepsfdcId = Constants.GANNETT_LOCAL_KPI_REP.id;
        }
        
        for(Opportunity oneOpportunity: newOpportunities){
			Opp_Tracking_Report__c newOppTrackRecord = new Opp_Tracking_Report__c();
			newOppTrackRecord.Opportunity__c = oneOpportunity.Id;
			newOppTrackRecord.Action_Owner__c = oneOpportunity.OwnerId;
			newOppTrackRecord.Action_Owner_Role__c = oneOpportunity.Opp_Owner_Role__c;
			newOppTrackRecord.KPI_Rep__c = kpiRepsfdcId;
			newOppTrackRecord.GL_Calender__c = kpiCalfdcId;
			newOppTrackRecord.Event__c = 'Created';
        	this.sObjectsToInsert.add(newOppTrackRecord);
        }
        
        //Call insertIntoOppTrackingForDealChickenAndGLAssist 
        this.insertIntoOppTrackingForDealChickenAndGLAssist(newOpportunities,
        													   kpiCalfdcId, kpiRepsfdcId);
        //Call insertIntoOpportunityTrackingObjectByOppStageName 
        this.insertIntoOpportunityTrackingObjectByOppStageName(newOpportunities,
        													   kpiCalfdcId, kpiRepsfdcId);
	}
	
	//Insert into Opportunity Tracking Object For Deal Chicken and GL_Assisting_Rep__c
	//Though this is named as Dealchicken this may also work for other record types
	private void insertIntoOppTrackingForDealChickenAndGLAssist(List<Opportunity> newOpportunities,
																   Id kpiCalfdcId, Id kpiRepsfdcId){
		final Map<String, String>  mapDealChickenUpdateToEventStatus 
								= new Map<String, String> { 
										'DC Submitted' 		 => 'Submitted',
										'DC Approved'  	 	 => 'Approved',
										'DC Rejected' 	 	 => 'Rejected',
										'Approved & Signed'  => 'Approved & Signed'
								};
																								   	
    	//GL Assist
    	for(Opportunity oneOpportunity : newOpportunities){
    		if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id
    			&& oneOpportunity.GL_Assisting_Rep__c != null){
				Opp_Tracking_Report__c newOppTrackRecord = new Opp_Tracking_Report__c();
				newOppTrackRecord.Opportunity__c = oneOpportunity.Id;
				newOppTrackRecord.Action_Owner__c = oneOpportunity.GL_Assisting_Rep__c;  // Assigning Rep as Action Owner not sure Why?, also not assigning owner role
				newOppTrackRecord.KPI_Rep__c = kpiRepsfdcId;
				newOppTrackRecord.GL_Calender__c = kpiCalfdcId;
				newOppTrackRecord.Event__c = 'GL Assist';
	        	this.sObjectsToInsert.add(newOppTrackRecord);
			}
    	}
    			
		//DealChicken history entries
		Map<Id, Opportunity> onlyDealChickenOpps = new Map<Id, Opportunity>();
		for(Opportunity oneOpportunity : newOpportunities){	
			if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id){
				onlyDealChickenOpps.put(oneOpportunity.Id, oneOpportunity);
			}
		}	
		
		//Preparing Map of Opportunity with its corresponding Opportunity History Event Statuses
		Map<Id, Set<String>> oppHistoryRecordsEventStatuses = new Map<Id, Set<String>>();
		if(onlyDealChickenOpps.size()>0){
			List<Opp_Tracking_Report__c> oppHistoryRecords = [SELECT Id, Event__c, Opportunity__c from Opp_Tracking_Report__c
   						   												WHERE Opportunity__c in :onlyDealChickenOpps.KeySet()]; 
			for(Opp_Tracking_Report__c oneOppHistoryRecord : oppHistoryRecords){
				Set<String> oppHistEventStatuses = oppHistoryRecordsEventStatuses.get(oneOppHistoryRecord.Opportunity__c);
				if(oppHistEventStatuses != null){
					oppHistEventStatuses.add(oneOppHistoryRecord.Event__c);
				}else{
					oppHistEventStatuses = new Set<String>();
					oppHistEventStatuses.add(oneOppHistoryRecord.Event__c);
					oppHistoryRecordsEventStatuses.put(oneOppHistoryRecord.Opportunity__c, oppHistEventStatuses); 
				}
			}
		}	
		
		//Only DealChicken Opps
		for(Opportunity oneOpportunity : onlyDealChickenOpps.values()){
			String deriveMapKeyName;
			Boolean isAlreadySubmitted = false;
			Boolean isAlreadyApproved = false;
			Boolean isAlreadyApprovedNSigned = false; 
			Boolean isAlreadySigned = false; 
			Boolean isAlreadySent = false; 
			Boolean isAlreadyRejected = false;
			
			Set<String> oppHistEventStatuses = oppHistoryRecordsEventStatuses.get(oneOpportunity.Id);
			if(oppHistEventStatuses!=null){
				isAlreadySubmitted = oppHistEventStatuses.contains('Submitted');
				isAlreadyApproved = oppHistEventStatuses.contains('Approved');
				isAlreadyApprovedNSigned = oppHistEventStatuses.contains('Approved & Signed');
				isAlreadySigned = oppHistEventStatuses.contains('Signed');
				isAlreadySent = oppHistEventStatuses.contains('Sent');
				isAlreadyRejected = oppHistEventStatuses.contains('Rejected');
			}
			
			System.debug('Opportunity Tracking Report Record Statuses Map >> ' + oppHistEventStatuses);
			
			//#1 Logic should be in sequence
			if (oneOpportunity.Contract_Attached__c == true || oneOpportunity.DC_Parent_Opp__c != null){

				if(isAlreadyApproved && !isAlreadySent){	
					this.insertOppHistoryTracking(oneOpportunity, 'Sent', kpiCalfdcId, kpiRepsfdcId);
					isAlreadySent = true;
				}
					
				if(isAlreadyApproved && !isAlreadySigned){	
					this.insertOppHistoryTracking(oneOpportunity, 'Signed', kpiCalfdcId, kpiRepsfdcId);
					isAlreadySigned = true;
				}
				
				if(isAlreadyApproved && !isAlreadyApprovedNSigned){	
					this.insertOppHistoryTracking(oneOpportunity, 'Approved & Signed', kpiCalfdcId, kpiRepsfdcId);
					isAlreadyApprovedNSigned = true;
				}	   	
   		    }
   		    
			//#2 Logic for deriving Key Name to get the event status 
			// 'DC Submitted', 'DC Approved', 'DC Rejected'
			if(oneOpportunity.StageName == 'DC Submitted' && !isAlreadySubmitted) { 	//'DC Submitted' 
				deriveMapKeyName = oneOpportunity.StageName; 
			}else if (oneOpportunity.StageName == 'DC Approved'
						|| (oneOpportunity.Track_Approved__c == true && isAlreadySubmitted && !isAlreadyApproved)) { //'DC Approved'
				deriveMapKeyName = 'DC Approved'; //oneOpportunity.StageName; 
				isAlreadyApproved = true; 
			}else if (oneOpportunity.StageName == 'DC Rejected' && !isAlreadyRejected) {  //'DC Rejected'
				deriveMapKeyName = oneOpportunity.StageName; 
			}
			
			//Adding History Record for Deal Chicken Approvals 
			if(mapDealChickenUpdateToEventStatus.get(deriveMapKeyName) != null){
				this.insertOppHistoryTracking(oneOpportunity, mapDealChickenUpdateToEventStatus.get(deriveMapKeyName),
								kpiCalfdcId, kpiRepsfdcId);	 
	        }
	        
	        //#3 Adding History Record for Deal Chicken 'Approved & Signed' Separetly after the status changes above
	        if(isAlreadyApproved && isAlreadySigned && !isAlreadyApprovedNSigned){
				this.insertOppHistoryTracking(oneOpportunity, mapDealChickenUpdateToEventStatus.get('Approved & Signed'),
								kpiCalfdcId, kpiRepsfdcId);
	        } 
		}
    }
	
	//Insert into Opportunity Tracking Object by Opportnity Status
	//This doesnot depend on any other fields except Opportunity Stage Only 
	private void insertIntoOpportunityTrackingObjectByOppStageName(List<Opportunity> newOpportunities,
																   Id kpiCalfdcId, Id kpiRepsfdcId){
		final Map<String, String>  mapStageNameToEventStatus 
									= new Map<String, String> {
											'Booked Appointment' 		 => 'Booked Appointment',
											'Pitched'  	 	 	 		 => 'Pitched',
											'Contract Sent' 	 		 => 'Contract Sent',
											'Contract Sent to Customer'  => 'Contract Sent to Customer',
											'Closed Won'  	 	 		 => 'Won',
											'Closed Lost' 	 	 		 => 'Lost'
									};
		
		for(Opportunity oneOpportunity : newOpportunities){
			if(mapStageNameToEventStatus.get(oneOpportunity.StageName) != null){
				this.insertOppHistoryTracking(oneOpportunity, mapStageNameToEventStatus.get(oneOpportunity.StageName),
												kpiCalfdcId, kpiRepsfdcId);
			}
        }
	}
	
	//insertOppHistoryTracking
	private void insertOppHistoryTracking(Opportunity oneOpportunity, String eventStatus,
											Id kpiCalfdcId, Id kpiRepsfdcId){
		Opp_Tracking_Report__c newOppTrackRecord = new Opp_Tracking_Report__c();
		newOppTrackRecord.Opportunity__c = oneOpportunity.Id;
		newOppTrackRecord.Action_Owner__c = oneOpportunity.OwnerId;
		newOppTrackRecord.Action_Owner_Role__c = oneOpportunity.Opp_Owner_Role__c;
		newOppTrackRecord.KPI_Rep__c = kpiRepsfdcId;
		newOppTrackRecord.GL_Calender__c = kpiCalfdcId;
		newOppTrackRecord.Event__c = eventStatus;
    	this.sObjectsToInsert.add(newOppTrackRecord);
	}
}