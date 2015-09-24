public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {
		this.callExternalCode();
		this.updateCompanyAccountManager(tp.oldMap, tp.newMap);
		this.updateOpportunityProductsForDigAM((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
		this.sendEmailNotificationOnDigAMChanges((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap); 
		//if the opp was updated as part of a market approver change then skip all
    	if(!Validator_MarketUpdate_class.hasAlreadyDone() &&
	        !VAlidator_BeforeOppProdUpdate_class.hasAlreadyDone() &&
	        !Validator_BeforeOppProdInsert_class.hasAlreadyDone()){
			this.updateTrackApporvedAndRunDate((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			if(!VAlidator_BeforeOppProdUpdate_class.hasAlreadyDone()){
				this.insertIntoOpportunityTrackingObject((Map<Id, Opportunity>)tp.oldMap, (Map<Id, Opportunity>)tp.newMap);
			}
        }
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/* 
						----------- BEGIN CODE TRANSPLANT -----------------
	*/
	
	private void callExternalCode() {
	
		if (Trigger.isAfter){
					
			List<Opportunity> filteredOpportunitiesWithClosedWon = OpportunityServices.filterOpportunitiesWithClosedWon((List<Opportunity>)Trigger.new, (Map<Id, Opportunity>)Trigger.oldMap);
	
			if (!filteredOpportunitiesWithClosedWon.isEmpty()){
				
				List<OpportunityLineItem> processedOLIs = OpportunityServices.processOpportunitiesWithClosedWon(filteredOpportunitiesWithClosedWon);
				
				// Set and Reset DAM flag to not update opporuntity from another trigger 
				Validator_DigAMUpdate_class.setDAMAlreadyDone();
				List<OpportunityLineItem> updatedOLIs = OpportunityServices.updateOpportunityProductsWithClosedWon(processedOLIs, (Map<Id, Opportunity>)Trigger.newMap);
				Validator_DigAMUpdate_class.resetDAMAlreadyDone();
					
			}
		}
	}
	
	//DEV-627 Update Account Manager on Company Record with Digital Account Manager
	// on updates to opportunity regardless of anyother opportunity field criteria 
	private void updateCompanyAccountManager(Map<Id, sObject> oldOpportunities,
												 Map<Id, sObject> newOpportunities){
												 	
		for(Opportunity newOpportunity : (List<Opportunity>)newOpportunities.Values()){
			Opportunity oldOpporunity = (Opportunity)oldOpportunities.get(newOpportunity.Id);
			if (newOpportunity <> oldOpporunity &&	String.IsNotBlank(newOpportunity.Dig_Account_Manager__c)){
				//This is a reference to sObjectsToUpdate hence this gets updated to salesforce at the end
				Account newAccount =(Account)this.getReferenceToSobjectsToUpdateRecord(newOpportunity.AccountId);
				newAccount.Account_Manager__c = newOpportunity.Dig_Account_Manager__c;
		 	}
		}
	}
	
	//Scenario #1
	//update Opportunity Products When there are updates on Digital Account Manager
	private void updateOpportunityProductsForDigAM(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		Set<Id> seletedOpportunityIds = new set<Id>();
		
		for(Opportunity oneOpportunity: newOpportunities.values()){
			if (oneOpportunity.Dig_Account_Manager__c != oldOpportunities.get(oneOpportunity.Id).Dig_Account_Manager__c){
				seletedOpportunityIds.add(oneOpportunity.Id);
			}	
		}
		
		if(seletedOpportunityIds.size()>0){
			Validator_DigAMUpdate_class.setDAMAlreadyDone();
		    List<OpportunityLineItem> OppProds = [SELECT Id, Waiting_Status__c, Status_Change_Date__c,   
                                                         Dig_Account_Manager__c, Affl_Sales_Rep__c, OpportunityId
                                                  FROM OpportunityLineItem
                                                  WHERE OpportunityId in :seletedOpportunityIds];
			
			for(OpportunityLineItem oneOpptyLineItem : OppProds){
                // - BEGIN - !!!DIGITAL ACCOUNT MANAGER & STATUS UPDATE!!! - BEGIN
                //THIS SECTION PULLS THE OPPORTUNITY LINE ITEMS AND UPDATES THE STATUS ON THOSE IN THE EVENT OF THE FIRST ASSIGNMENT....
                //....OF AN ACCOUNT MANAGER....PROVIDED THAT THE OLI DOES NOT ALREADY HAVE A STATUS
                //ALSO....IT UPDATES THE ACCOUNT MANAGER FIELD ON THE PRODUCT
                
                //newOppLineItem is returned by reference from sObjectsToUpdate. hence saves all field changes. 
                OpportunityLineItem newOppLineItem = (OpportunityLineItem) this.getReferenceToSobjectsToUpdateRecord(oneOpptyLineItem.Id);
                newOppLineItem.Dig_Account_Manager__c = newOpportunities.get(oneOpptyLineItem.OpportunityId).Dig_Account_Manager__c;
               
                //If Dig_Account_Manager__c is blank to begin with in Old Map
                if (String.IsBlank(oldOpportunities.get(oneOpptyLineItem.OpportunityId).Dig_Account_Manager__c)
                	&& newOpportunities.get(oneOpptyLineItem.OpportunityId).RecordTypeId != RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id){   
                    if(oneOpptyLineItem.Waiting_Status__c == null){
                    	newOppLineItem.Waiting_Status__c = 'Awaiting Onboard';
                        newOppLineItem.Status_Change_Date__c = date.today(); 
                    }
                }
                
                if(newOpportunities.get(oneOpptyLineItem.OpportunityId).Sales_Rep__c 
                		!= oldOpportunities.get(oneOpptyLineItem.OpportunityId).Sales_Rep__c){
                    newOppLineItem.Affl_Sales_Rep__c = newOpportunities.get(oneOpptyLineItem.OpportunityId).Sales_Rep__c;
                }
            }                                                  
		}
	}   
	
	
		
	//Scenario #2
	//Send Email Notification When there are updates on Digital Account Manager Field
	// - BEGIN - !!!SETUP DATA FOR AND THEN SEND EMAIL IF APPLICABLE!!! - BEGIN
    //IF THE ACCOUNT MANAGER CHANGED COLLECT INFO AND SEND EMAIL IF NEEDED
    //....IF A DIGITAL FULFILLMENT OPPORTUNITY.........
	private void sendEmailNotificationOnDigAMChanges(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();
		Map<Id, Id>  sendEmailOpportunityIds = new Map<Id, Id>(); // map of Opp Id, Opp Media_Partner__c
		
		for(Opportunity oneOpportunity: newOpportunities.values()){
			if (oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id
					&& oneOpportunity.Dig_Account_Manager__c != oldOpportunities.get(oneOpportunity.Id).Dig_Account_Manager__c
					&& oneOpportunity.Dig_Account_Manager__c != null){
						
				If(oneOpportunity.Sales_Rep__c == null){
					oneOpportunity.Sales_Rep__c.addError('Please assign an Affiliated Sales Rep in order for email notifications to be sent.');
					return;
				}
				
				If(oneOpportunity.Affl_Sales_Rep_Email__c == null){
					oneOpportunity.Sales_Rep__c.addError('Please assign an email address for the selected affiliated Sales Rep in order for email notifications to be sent.');
					return;
				}
				
				if(oneOpportunity.Media_Partner__c != null){
					sendEmailOpportunityIds.put(oneOpportunity.Id, oneOpportunity.Media_Partner__c); // filtering list of opps that requires an email notification to be sent
				}
			}
		}
		
		if(sendEmailOpportunityIds.size()>0){
			Map<Id, String[]> mapCCListOfEmails = new Map<Id, String[]>();
			mapCCListOfEmails = this.getEmailCCcontactListByAccounts(sendEmailOpportunityIds);
			
			
			for(Id oneOppId : sendEmailOpportunityIds.Keyset()){
				Messaging.SingleEmailMessage oneEmailMessage  = 
						getOpportunityEmailMessageforDigAM(newOpportunities.get(oneOppId), 
								mapCCListOfEmails.get(sendEmailOpportunityIds.get(oneOppId)));  
				if(oneEmailMessage != null){
					emailNotifications.add(oneEmailMessage);
				}
			}
		}
		
		//This is where we send emailNotifications to the List of Messaging.SingleEmailMessage
		if(emailNotifications.size()>0 
		        && !Test.isRunningTest()){
		        	
            Messaging.sendEmail(emailNotifications);
            Validator_afterAwaitingOnboardEmail.setAlreadyDone();
        }
	}
	
	//Preparing Messaging.SingleEmailMessage for each Opportunity Based on Opportunity
	private Messaging.SingleEmailMessage getOpportunityEmailMessageforDigAM(Opportunity oneOpportunity, String[] ccMediaPartnerList){
		Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
		
		String ProjectStatus = 'Awaiting Onboard';
		String StatusDisplay = 'Awaiting Onboard';
		String DateToPrint = Date.today().format();
		String CommentToAdd;
		
		String[] toAddresses = new String[]{};
        String[] ccAddresses = new String[] {};
		//Get Comments If Any
        if(oneOpportunity.Waiting_Status_Descr_Last_Set__c != Null){
            CommentToAdd = oneOpportunity.Waiting_Status_Descr_Last_Set__c;
        }
        else{
            CommentToAdd = 'No Notes';
        }
        
        String oppProductName = '';
        if(oneOpportunity.Product_List__c != null){
        	oppProductName = oneOpportunity.Product_List__c.replaceAll('\n', '<br/>');
        }
                    
		String htmlBody = '<br/>' + oneOpportunity.AfflRep_FirstName__c + ', <br/>';
                htmlBody += '<br/> This email is to alert you that an Account Manager has been assigned and that the G/O Digital product/s<br/>';
                htmlBody += '<br/><strong>' + oppProductName + '</strong>';
                htmlBody += '<br/><br/> is/are <br/><br/><strong>' + StatusDisplay + '<br/>Notes: ' + CommentToAdd + '<br/></strong>';
                htmlBody += '<br/><br/> as of <br/><br/><strong>'+ DateToPrint + '</strong>';
                htmlBody += '<br/><br/>If you have any questions regarding this project please contact your G/O Digital Account Manager, noted below.<br/>';
                htmlBody += '<br/>Opportunity Name : <strong>' + oneOpportunity.Name + '</strong>';
                htmlBody += '<br/>Sold Date : <strong>' + oneOpportunity.CloseDate + '</strong>';
                htmlBody += '<br/>Digital AM : <strong>' + oneOpportunity.Dig_AM_Name__c + '</strong>';
                htmlBody += '<br/>Sales Rep : <strong>' + oneOpportunity.Sales_Rep_Name__c + '</strong>';
                htmlBody += '<br/>Customer : <strong>' + oneOpportunity.Opp_Account_Name__c + '</strong>';
                htmlBody += '<br/>Media Partner : <strong>' + oneOpportunity.Media_Partner_Name__c + '</strong>';
                htmlBody += '<br/><br/>Thank You,<br/><br/>Your G/O Digital Team<br/><br/><br/>';
        
        if(oneOpportunity.Sales_Rep__c != null){
        	toAddresses.add(oneOpportunity.Affl_Sales_Rep_Email__c);
        } 
        
        if(oneOpportunity.Dig_AM_Email__c != null){
        	ccAddresses.add(oneOpportunity.Dig_AM_Email__c);
        }
        
        if(oneOpportunity.Media_Partner__c != null && ccMediaPartnerList != null){
        	ccAddresses.addall(ccMediaPartnerList);  
        }
        
        //Also grab the notify email fields...this is at risk of redundancy, 
        //as many I have seen are already marked as Manager contacts on the 
        //Media Partner and are marked to receive these anyway...
        //....i believe Salesforce only sends one email though
        if(oneOpportunity.Notify_Email_1__c != Null){
            ccAddresses.add(oneOpportunity.Notify_Email_1__c);
        }
        if(oneOpportunity.Notify_Email_2__c != Null){
            ccAddresses.add(oneOpportunity.Notify_Email_2__c);
        }
        if(oneOpportunity.Notify_Email_3__c != Null){
            ccAddresses.add(oneOpportunity.Notify_Email_3__c);
        }    
        
        singleEmailMessage.setHtmlBody(htmlBody);
        singleEmailMessage.setToAddresses(toAddresses); 
        singleEmailMessage.setCcAddresses(ccAddresses);
        
        singleEmailMessage.setReplyTo(oneOpportunity.Dig_AM_Email__c);
        //FOR THIS SEE ORGANIZATION-WIDE ADDRESSES
        singleEmailMessage.setOrgWideEmailAddressId('0D2F00000004DSL');//G/O DIGITAL BRANDING UPDATE NEEDED
        singleEmailMessage.setSaveAsActivity(True);
        singleEmailMessage.setWhatId(oneOpportunity.Id);
        singleEmailMessage.setSubject('Account Manager Assigned & Project Status Update - ' + ProjectStatus);
        
        //Do Not Send Email If Send Box is Unchecked Or Email Has Already Been Sent Or DigAM is Blank
        if (!(oneOpportunity.Send_DigAM_Notification__c == true
        		&& !Validator_afterAwaitingOnboardEmail.hasAlreadyDone()
	        	&& oneOpportunity.Dig_Account_Manager__c != Null))
        {	
        	singleEmailMessage =null; // nullifying the object
        }
        return singleEmailMessage;
	}
	
	//CC Contacts list based on Media_Partner__c on Opportunity 
	private Map<Id, String[]> getEmailCCcontactListByAccounts(Map<Id, Id> sendEmailOpportunityIds){
		Map<Id, String[]> mapCCListOfEmails = new Map<Id, String[]>();
		Map<Id, Account> mapCCListOfAccounts = new Map<Id, Account>();
        mapCCListOfAccounts = new Map<ID, Account>(
        						[Select Id, (SELECT Id, Email, FirstName, LastName, 
        								Status_Alert_Options__c, Auto_Email_AM_Assignment_Alert__c
				                        FROM Contacts
				                        WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
				                        AND Email != Null
				                        AND (Status_Alert_Options__c != Null
				                        OR
		                        		Auto_Email_AM_Assignment_Alert__c = True))
		                        	 From Account
				                     Where Id in : sendEmailOpportunityIds.Values()]);
                        
		
		Map<Id, Boolean> mapIsAwaitingOnboard = new Map<Id, Boolean>();
		mapIsAwaitingOnboard = this.getAwaitingOnboardOppsByOLIStatus(sendEmailOpportunityIds.KeySet());
		
		for(Id oneOppId : sendEmailOpportunityIds.KeySet()){
			Account oneAccount = mapCCListOfAccounts.get(sendEmailOpportunityIds.get(oneOppId));
			if(oneAccount !=null){
				String[] ccAddresses = new String[] {};
				for(Contact oneContact : oneAccount.contacts){
		            String statusmulti = oneContact.Status_Alert_Options__c;
		            if(statusmulti == Null){ 
		            	statusmulti=''; 
		            }
		            
		            Boolean hasStatusSelect = statusmulti.contains('Awaiting OnBoard');
		            Boolean thisIsStatusChange = mapIsAwaitingOnboard.get(oneOppId);  // OLI status change from null to awaiting onboard
		             
		            if(oneContact.Auto_Email_AM_Assignment_Alert__c){ 
		                ccAddresses.add(oneContact.Email);
		            }else if(hasStatusSelect && thisIsStatusChange){   
		            	ccAddresses.add(oneContact.Email);
		            } 
				}
				mapCCListOfEmails.put(oneAccount.Id, ccAddresses);
			}
		}
        return mapCCListOfEmails;                       
	}
	
	//get List of Opportunities that have Opportunity Line Items with null Status
	private Map<Id, Boolean> getAwaitingOnboardOppsByOLIStatus(Set<Id> newOppIds){
		Map<Id, Boolean> mapIsAwaitingOnboard = new Map<Id, Boolean>();
		Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>();
		mapOpportunities = new Map<Id, Opportunity>([Select Id, (Select Id from OpportunityLineItems Where Waiting_Status__c = null) 
													 	From Opportunity
													 	Where Id in :newOppIds]);
		for(Id oneOppId : newOppIds){
			if(mapOpportunities.get(oneOppId).OpportunityLineItems != null
				&&	mapOpportunities.get(oneOppId).OpportunityLineItems.size() > 0){
				mapIsAwaitingOnboard.put(oneOppId, true);
			}else{
				mapIsAwaitingOnboard.put(oneOppId, false);
			}
		}		
		
		return mapIsAwaitingOnboard;										 	
	}
	
	//Update Track Approved & Run Date On Agreements& Proposals For Email Trigger  
	private void updateTrackApporvedAndRunDate(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
		Set<Id> oppIdsMatchCriteria = new Set<Id>();
		for(Opportunity oneOpportunity : newOpportunities.Values()){
			if ((oneOpportunity.Track_Approved__c == true && oldOpportunities.get(oneOpportunity.Id).Track_Approved__c == false)
				|| oneOpportunity.DC_Run_Date__c != oldOpportunities.get(oneOpportunity.Id).DC_Run_Date__c
				&& oneOpportunity.Track_Signed__c == true){
				 oppIdsMatchCriteria.add(oneOpportunity.Id);
			}	
		}
		
		if(oppIdsMatchCriteria.size()>0){
			List<echosign_dev1__SIGN_Agreement__c> attachedAgreements 
							= [SELECT Id, DC_Track_Approved__c, DC_Run_Date__c, echosign_dev1__Opportunity__c,
										DC_Run_Date_New__c, Recipient_Email__c, echosign_dev1__More_Recipients__c
								 FROM echosign_dev1__SIGN_Agreement__c
								 WHERE echosign_dev1__Opportunity__c in :oppIdsMatchCriteria
									 AND echosign_dev1__Status__c = 'Signed'
								 ORDER BY echosign_dev1__DateSent__c DESC];
								 
			//Updating echoSign agreements
			Boolean agreementFound = false;
			if(attachedAgreements != null && attachedAgreements.size()>0){
				//I am not sure why its only updating the first record skipping all others	
				echosign_dev1__SIGN_Agreement__c oneAgreement = attachedAgreements[0];
                if((oneAgreement.DC_Track_Approved__c == false 
                		|| oneAgreement.DC_Run_Date_New__c != newOpportunities.get(oneAgreement.echosign_dev1__Opportunity__c).DC_Run_Date__c)
                		&& agreementFound == false){
					agreementFound = true;                			
                	echosign_dev1__SIGN_Agreement__c newAgreement = (echosign_dev1__SIGN_Agreement__c) this.getReferenceToSobjectsToUpdateRecord(oneAgreement.Id);
                	newAgreement.DC_Track_Approved__c = true;
                	newAgreement.DC_Run_Date_New__c = newOpportunities.get(oneAgreement.echosign_dev1__Opportunity__c).DC_Run_Date__c; 
                	if(oneAgreement.echosign_dev1__More_Recipients__c != null){
                		newAgreement.Recipient_Email__c = oneAgreement.echosign_dev1__More_Recipients__c.replace(',','');
                	}
                }
            }
            
            List<tinderbox__Proposal__c> attachedProposals = [SELECT Id, DC_Track_Approved__c, DC_Run_Date__c,
            										 				 DC_Run_Date_New__c, Recipient_Email__c, tinderbox__Opportunity__c
		            											  FROM tinderbox__Proposal__c
		            											  WHERE tinderbox__Opportunity__c = :oppIdsMatchCriteria
		            											  AND tinderbox__Status__c = 'Accepted'
		            											  ORDER BY LastModifiedDate DESC];
		   //updating tinderbox proposals
		   Boolean proposalFound = false; 
		   for(tinderbox__Proposal__c oneProposal : attachedProposals){
		   		if(oneProposal.DC_Track_Approved__c == false
                	   || oneProposal.DC_Run_Date_New__c != newOpportunities.get(oneProposal.tinderbox__Opportunity__c).DC_Run_Date__c
                	   && proposalFound == false){
                	proposalFound = true;
					tinderbox__Proposal__c newProposal = (tinderbox__Proposal__c) this.getReferenceToSobjectsToUpdateRecord(oneProposal.Id);
                	newProposal.DC_Track_Approved__c = true;
                	newProposal.DC_Run_Date_New__c = newOpportunities.get(oneProposal.tinderbox__Opportunity__c).DC_Run_Date__c;
				}
		   }
	            											  
		}
	}
	
	//Insert into Opportunity Tracking Objects
	private void insertIntoOpportunityTrackingObject(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities){
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
        
        //Call insertIntoOppTrackingForDealChickenAndGLAssist 
        this.insertIntoOppTrackingForDealChickenAndGLAssist(oldOpportunities, newOpportunities,
        													   kpiCalfdcId, kpiRepsfdcId);
        //Call insertIntoOpportunityTrackingObjectByOppStageName 
        this.insertIntoOpportunityTrackingObjectByOppStageName(oldOpportunities, newOpportunities,
        													   kpiCalfdcId, kpiRepsfdcId);
	}
	
	//Insert into Opportunity Tracking Object For Deal Chicken and GL_Assisting_Rep__c
	//Though this is named as Dealchicken this may also work for other record types
	private void insertIntoOppTrackingForDealChickenAndGLAssist(Map<Id, Opportunity> oldOpportunities, 
																   Map<Id, Opportunity> newOpportunities,
																   Id kpiCalfdcId, Id kpiRepsfdcId){
		final Map<String, String>  mapDealChickenUpdateToEventStatus 
								= new Map<String, String> { 
										'DC Submitted' 		 => 'Submitted',
										'DC Approved'  	 	 => 'Approved',
										'DC Rejected' 	 	 => 'Rejected',
										'Approved & Signed'  => 'Approved & Signed'
								};
																								   	
    	//GL Assist
    	for(Opportunity oneOpportunity : newOpportunities.Values()){
    		if(oneOpportunity.RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id
    			&& oneOpportunity.GL_Assisting_Rep__c != oldOpportunities.get(oneOpportunity.Id).GL_Assisting_Rep__c
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
		for(Opportunity oneOpportunity : newOpportunities.Values()){	
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
		for(Opportunity oneOpportunity : onlyDealChickenOpps.Values()){
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
			if ((oneOpportunity.Contract_Attached__c == true 
					&& oldOpportunities.get(oneOpportunity.Id).Contract_Attached__c != true) 
					||(oneOpportunity.DC_Parent_Opp__c != null && oldOpportunities.get(oneOpportunity.Id).DC_Parent_Opp__c == null)){

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
			if(oneOpportunity.StageName != oldOpportunities.get(oneOpportunity.Id).StageName 		//'DC Submitted'
				&& oneOpportunity.StageName == 'DC Submitted' && !isAlreadySubmitted) { 
				deriveMapKeyName = oneOpportunity.StageName; 
			}else if ((oneOpportunity.StageName != oldOpportunities.get(oneOpportunity.Id).StageName //'DC Approved'
						&& oneOpportunity.StageName == 'DC Approved')
						|| (oneOpportunity.Track_Approved__c == true && isAlreadySubmitted && !isAlreadyApproved)) { 
				deriveMapKeyName = 'DC Approved'; //oneOpportunity.StageName; 
				isAlreadyApproved = true; 
			}else if (oneOpportunity.StageName != oldOpportunities.get(oneOpportunity.Id).StageName //'DC Rejected'
				&& oneOpportunity.StageName == 'DC Rejected' && !isAlreadyRejected) { 
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
	private void insertIntoOpportunityTrackingObjectByOppStageName(Map<Id, Opportunity> oldOpportunities, 
																   Map<Id, Opportunity> newOpportunities,
																   Id kpiCalfdcId, Id kpiRepsfdcId){
		final Map<String, String>  mapStageNameToEventStatus 
									= new Map<String, String> {
											'Booked Appointment' => 'Booked Appointment',
											'Pitched'  	 	 	 => 'Pitched',
											'Contract Sent' 	 => 'Contract Sent',
											'Contract Sent to Customer' 	 => 'Contract Sent to Customer',
											'Closed Won'  	 	 => 'Won',
											'Closed Lost' 	 	 => 'Lost'
									};
		
		for(Opportunity oneOpportunity : newOpportunities.Values()){
			if(oneOpportunity.StageName != oldOpportunities.get(oneOpportunity.Id).StageName
				&& mapStageNameToEventStatus.get(oneOpportunity.StageName) != null){
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