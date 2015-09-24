/**
 * 	Class Name			: OpportunityLineItemAfterUpdateHandler
 * 	Created By			: Praneeth
 * 	Last Modified By	: Vijay Varada
 * 	Description			: Opportunity Line item trigger handler to handle the old and new opportunity line items
 *	Modifed History		: 03/12/2015 Refactored OpportunityLineItem After Trigger Handler
 */
public class OpportunityLineItemAfterUpdateHandler extends TriggerHandlerBase{
	
	public override void mainEntry(TriggerParameters tp) {
		this.updateOpportunityFields((List<OpportunityLineItem>)tp.newList);
		this.updateOpportuntyPausedOrCancelled((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
		this.CreatePPCOpportunityLineItemSchedule((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);		
		this.upsertProjectObject((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
		this.insertOrUpdateIntoOpportunityProductHistory((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
		this.updateOpportunityPasusedOrCancelledDate((List<OpportunityLineItem>)tp.newList);
	} 
	
	public override void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/* 
						----------- BEGIN CODE TRANSPLANT -----------------
	*/
	// Method to handle old and the new oppotunityLineItems
	private void updateOpportunityFields(List<OpportunityLineItem> newOpportunityLineItems){
        if(UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id){ 
        	Set<Id> opportunityIds = new Set<Id>();
        	for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
        		opportunityIds.add(oneOppLineItem.OpportunityId);
        	}
        	
        	Map<Id, Opportunity> mapOpportunities = new Map<ID, Opportunity>([SELECT Id, (Select Id, Product_Name__c
					                                                           			 FROM OpportunityLineItems ORDER BY Product_Name__c ASC)
					                                                           From Opportunity WHERE Id in : opportunityIds]);
			
			/* Begin retrieving OpportunityLineItemScheulde */
			Set<Id> oppLineItemIds = new Set<Id>();
			for (Opportunity oneOpportunity : mapOpportunities.Values()){
				oppLineItemIds.addAll((new Map<Id, OpportunityLineItem>(oneOpportunity.OpportunityLineItems)).KeySet());
			}
			
			Map<Id, List<OpportunityLineItemSchedule>>  mapOpportunitySchedules = new Map<Id, List<OpportunityLineItemSchedule>>();
			List<OpportunityLineItem>  OppLineItemSchedules = [Select Id, OpportunityId,
																(SELECT Id, ScheduleDate FROM OpportunityLineItemSchedules)
                                               			 	  FROM OpportunityLineItem WHERE Id in : oppLineItemIds];
                                               			 	  
			for(OpportunityLineItem oneOppLineItem : OppLineItemSchedules){
				List<OpportunityLineItemSchedule> lstOppLineItemSchedule = mapOpportunitySchedules.get(oneOppLineItem.OpportunityId);
				if(lstOppLineItemSchedule != null){
				    lstOppLineItemSchedule.addAll(oneOppLineItem.OpportunityLineItemSchedules);
				}else{
					lstOppLineItemSchedule = oneOppLineItem.OpportunityLineItemSchedules;
				}
				mapOpportunitySchedules.put(oneOppLineItem.OpportunityId, lstOppLineItemSchedule);
			} 
			/* End retrieving OpportunityLineItemScheulde */
			
			for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
				 //This has a referense to SObjectstoUpdate Map and trigger frameword takes care of updating at the end
				 Opportunity updateOpportunity = (Opportunity)this.getReferenceToSobjectsToUpdateRecord(oneOppLineItem.OpportunityId);		
				 Date lastScheduledBillingDate = this.getLastScheduledBillDate(mapOpportunitySchedules.get(oneOppLineItem.OpportunityId));
				 if(lastScheduledBillingDate != null){
				 	updateOpportunity.Last_Schedule_Bill_Date__c = lastScheduledBillingDate;
				 }
			} 
        }
    }
    
    //Update Opportunity Paused_Or_Canceled__c to 'Cancelled' Based on Opp Line Items Criteria
    private void updateOpportuntyPausedOrCancelled(Map<Id, OpportunityLineItem> oldOpportunityLineItems, 
                                                   Map<Id, OpportunityLineItem> newOpportunityLineItems){
        //If Logged in User is not same as Gannet Local User
        if (UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id && !Validator_DigAMUpdate_class.hasDAMAlreadyDone()) {
            Map<Id, OpportunityLineItem> onlyOppIdsWithCancelledOlis = new Map<Id, OpportunityLineItem>();   //Opportunities for which the OLI is marked Cancelled
            //Loop through all Opp Line Items
            for(OpportunityLineItem oneOpportunityLineItem: newOpportunityLineItems.Values()){
                if((oneOpportunityLineItem.Waiting_Status__c == 'Cancelled' || oneOpportunityLineItem.Waiting_Status__c == 'Hard Cancel')
                    && oneOpportunityLineItem.Waiting_Status__c != oldOpportunityLineItems.get(oneOpportunityLineItem.Id).Waiting_Status__c){
                    onlyOppIdsWithCancelledOlis.put(oneOpportunityLineItem.OpportunityId, oneOpportunityLineItem);      
                }
            }
            
            if(onlyOppIdsWithCancelledOlis.size()>0){
                //The query returns opportunities that are not cancelled with opportunity Line Items List
                //The Opportunity Line Items list is empty if all Olis are cancelled if not it will contains non cancelled status olis
                Map<Id, Opportunity> mapOpportunities = new Map<ID, Opportunity>([SELECT Id,  Paused_Or_Canceled__c,
                                                                                        (Select Id, Product_Name__c, Waiting_Status__c, 
                                                                                                Live__c, UnitPrice
                                                                                         FROM OpportunityLineItems 
                                                                                         Where Waiting_Status__c != 'Cancelled' AND  Waiting_Status__c != 'Hard Cancel')
                                                                                  From Opportunity WHERE Id in :onlyOppIdsWithCancelledOlis.KeySet() 
                                                                                  and Paused_Or_Canceled__c != 'Cancelled' AND Paused_Or_Canceled__c != 'Hard Cancel']);
                System.debug('Map of Opportunities >> ' + mapOpportunities);                                                                                            
                List<Opportunity> sObjectsToUpdate = new List<Opportunity>();
                for(Opportunity oneOpportunity : mapOpportunities.values()) {  
                    if(!(oneOpportunity.OpportunityLineItems != null && oneOpportunity.OpportunityLineItems.size() > 0)){
                        //Trigger Framework takes care of updating Opportunites that are fectched from getReferenceToSobjectsToUpdateRecord method
                        Opportunity newOpportunity =(Opportunity)this.getReferenceToSobjectsToUpdateRecord(oneOpportunity.Id); 
                        newOpportunity.Paused_Or_Canceled__c = onlyOppIdsWithCancelledOlis.get(oneOpportunity.Id).Waiting_Status__c; 
                        newOpportunity.P_Or_C_Reason__c = onlyOppIdsWithCancelledOlis.get(oneOpportunity.Id).Waiting_Status_Descr__c; 
                    }
                }
            }   
        }                                       
    }
    
    //Create PPC Opportunity Line Item Schedule where product waiting status turns to "Live" and Product Category is "PPC"
	private void CreatePPCOpportunityLineItemSchedule(Map<Id, OpportunityLineItem> oldOpportunityLineItems, 
												   Map<Id, OpportunityLineItem> newOpportunityLineItems){
	   
	   System.debug('OpportunityLineItemAfterUpdateHandler.CreatePPCOpportunityLineItemSchedule Method');
	   Map<String, Id> onlyLivePPCOppProducts = new Map<String, Id>();
	   for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems.Values()){
	   	  if (oneOppLineItem.Waiting_Status__c != oldOpportunityLineItems.get(oneOppLineItem.Id).Waiting_Status__c 
	   	  	  && oneOppLineItem.Waiting_Status__c == 'Live' && oneOppLineItem.Product_Category__c == 'PPC') {
	   	  	 	onlyLivePPCOppProducts.put(String.ValueOf(oneOppLineItem.Id).substring(0, 15), oneOppLineItem.Id);
   	  	  }
	   }
		
       if(onlyLivePPCOppProducts.size()>0){
       	    List<PPCOrderDetail__c>  listPPCOrderDetails = [SELECT Id, OpportunityLineItemId__c FROM PPCOrderDetail__c 
    														WHERE FulfillmentStatus__c = 'AMP' and OpportunityLineItemId__c in :onlyLivePPCOppProducts.KeySet()
    														and OLI18DigitId__c in : onlyLivePPCOppProducts.Values()];
			if(listPPCOrderDetails != null && listPPCOrderDetails.size()>0){
				Map<Id, OpportunityLineItem> mapOppLineItem = new Map<Id, OpportunityLineItem>(
																[Select Id, Quantity, Live_Date__c, UnitPrice,
																	Opportunity.RecordTypeId,
																  	(SELECT Id FROM OpportunityLineItemSchedules)
																 	from OpportunityLineItem where Id In : onlyLivePPCOppProducts.Values()]
															  );
															  
				for(PPCOrderDetail__c onePPCOrder : listPPCOrderDetails){
					Id oppLineItem18Id = onlyLivePPCOppProducts.get(String.ValueOf(onePPCOrder.OpportunityLineItemId__c));
					if(oppLineItem18Id!=null){
						OpportunityLineItem oneOppLineItem = mapOppLineItem.get(oppLineItem18Id);
						
						Date oppLineItemLiveDate; 
						if(oneOppLineItem.Live_Date__c != null){
							oppLineItemLiveDate = oneOppLineItem.Live_Date__c.Date();
						}else{					
							oppLineItemLiveDate = Date.today();
						}
						
						if(oneOppLineItem != null 
							&& oneOppLineItem.Opportunity.RecordTypeId != RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id 
							&& oneOppLineItem.OpportunityLineItemSchedules.size() == 0){
							//Only if there are no Opp Line Item Schedules, Creates new ones
							for(Integer i=0; i < oneOppLineItem.Quantity; i++){
								OpportunityLineItemSchedule newOppLineItemSchedule = new  OpportunityLineItemSchedule();
								newOppLineItemSchedule.OpportunityLineItemId = oneOppLineItem.Id;
								newOppLineItemSchedule.ScheduleDate = oppLineItemLiveDate.addMonths(i);
								newOppLineItemSchedule.Revenue = oneOppLineItem.UnitPrice;
								newOppLineItemSchedule.Type = 'Revenue';
								this.sObjectsToInsert.add(newOppLineItemSchedule);
							}	
						}
					}
				}
			}    														 	  
       } 					   	
   }
   
   //upset project__c 
    private void upsertProjectObject(Map<Id, OpportunityLineItem> oldOpportunityLineItems,
    									Map<Id, OpportunityLineItem> newOpportunityLineItems){
    	if(UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id){
    		Map<Id, Id> mapOppLineItemIdAndProjectId = new Map<Id,Id>();
    		for(Project__c oneProject :[Select Id, Product_Id__c from Project__c Where Product_Id__c in :newOpportunityLineItems.KeySet()]){
    			mapOppLineItemIdAndProjectId.put(oneProject.Product_Id__c, oneProject.Id);
    		}
    		
    		List<Project__c> upsertProjects = new List<Project__c>();
    		for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems.Values()){
    			Project__c oneProject = new Project__c();
    			if(mapOppLineItemIdAndProjectId.get(oneOppLineItem.Id) != null){
					oneProject.Id = mapOppLineItemIdAndProjectId.get(oneOppLineItem.Id); 
				}
				
				
				
    			oneProject.Cancellation_Category__c = oneOppLineItem.Cancellation_Category__c;
    			oneProject.Cancelled__c = oneOppLineItem.Canceled__c;
				oneProject.Cancellation_Reason__c = oneOppLineItem.Cancellation_Reason__c;
                		oneProject.Cancellation_Detail__c = oneOppLineItem.Cancellation_Detail__c;
				oneProject.OppProd__c = String.ValueOf(oneOppLineItem.OpportunityId) + String.ValueOf(oneOppLineItem.Id);
				oneProject.Product_Id__c = oneOppLineItem.Id;
				oneProject.Opportunity__c = oneOppLineItem.OpportunityId;
				oneProject.Account__c = oneOppLineItem.Account__c;
				oneProject.Related_Product__c = oneOppLineItem.Product2Id;
				oneProject.Waiting_Status_Descr_Last_Set__c = oneOppLineItem.Waiting_Status_Descr__c;
				oneProject.Status_Notes__c = oneOppLineItem.Waiting_Status_Descr__c;
				
				if(oneOppLineItem != null && oneOppLineItem.Waiting_Status__c != oldOpportunityLineItems.get(oneOppLineItem.Id).Waiting_Status__c){
					oneProject.Waiting_Since_Date__c = datetime.now();
				}else{
					oneProject.Waiting_Since_Date__c = oneOppLineItem.Status_Change_Date__c;
				}
								
				oneProject.Project_Status__c = oneOppLineItem.Waiting_Status__c;
				oneProject.Product_Name__c = oneOppLineItem.Product_Name__c;
				oneProject.Notify_Email_1__c = oneOppLineItem.Notify_Email_1__c;
				oneProject.Notify_Email_2__c = oneOppLineItem.Notify_Email_2__c;
				oneProject.Notify_Email_3__c = oneOppLineItem.Notify_Email_3__c;
				oneProject.Affl_Sales_Rep__c = oneOppLineItem.Affl_Sales_Rep__c;
				oneProject.Digital_Account_Manager__c = oneOppLineItem.Dig_Account_Manager__c;
				oneProject.Live_Date__c = oneOppLineItem.Live_Date__c;
				oneProject.Media_Partner__c = oneOppLineItem.Media_Partner__c;
				oneProject.Sell_Type__c = oneOppLineItem.Sell_Type__c;
				oneProject.Invoice_CancelDate__c = oneOppLineItem.Invoice_CancelDate__c;
				oneProject.Invoice_ServiceStartDate__c = oneOppLineItem.Invoice_ServiceStartDate__c;
				oneProject.Invoice_ServiceEndDate__c = oneOppLineItem.Invoice_ServiceEndDate__c;
				oneProject.Qty_ContractMonths__c = oneOppLineItem.Qty_ContractMonths__c;
				oneProject.UnitPrice__c = oneOppLineItem.UnitPrice;
			    oneProject.Invoice_Units__c = oneOppLineItem.Invoice_Units__c;
			    oneProject.Mgmt_Fee_Percent__c = oneOppLineItem.Mgmt_Fee_percent__c;
		        oneProject.Invoice_PriceVariable__c = oneOppLineItem.Invoice_PriceVariable__c;
		        oneProject.TotalMonthlyCharge__c = oneOppLineItem.TotalMonthlyCharge__c;
                oneProject.Fulfillment_Specialist__c = oneOppLineItem.Fulfillment_Specialist__c;
				upsertProjects.add(oneProject);
    		}
    		
    		//We have to do an upsert here which is not inline with trigger architecture guideline because
    		//Opportunity_Product_History__c is expecting the data to be saved in project__c
    		if(upsertProjects.size()>0){
    			upsert upsertProjects;
    		}
    	}
    }
    
    //This methods is called to insert records in to Opportunity_Product_History__c Object
	private void insertOrUpdateIntoOpportunityProductHistory(Map<Id, OpportunityLineItem> oldOpportunityLineItems, 
														Map<Id, OpportunityLineItem> newOpportunityLineItems){
		// Adding Debug Info Logs to ApplicationLogs Object
		for (OpportunityLineItem oneOppLineItem: newOpportunityLineItems.Values()){
			String errorMsg = ' OLI ID: ' + oneOppLineItem.Id + 
							   '; Old status: '	+ oldOpportunityLineItems.get(oneOppLineItem.Id).Waiting_Status__c + 
							   '; New Status: '	+ oneOppLineItem.Waiting_Status__c ;
		 	ApplicationLogsModel.AddLogs(errorMsg, 'OpportunityLineItemAfterUpdateHandler.insertIntoOpportunityProductHistory, line 148', '148', 
		 									oneOppLineItem.ID, 'OpportunityLineItemAfterUpdateHandler', 'insertIntoOpportunityProductHistory', false, ApplicationLogsModel.Loglevel.Info);
		}
		
        if (ApplicationLogsModel.numUnCommittedLogs>0){
        	ApplicationLogsModel.InsertLogList(); //Insert uncommitted logs
        }
        // Adding Debug Info Logs to ApplicationLogs Object
        															
		List<Opportunity_Product_History__c> newListOppProdHistory = 
					OpportunityLineItemServices.ManageStatusChange(newOpportunityLineItems.Values(), oldOpportunityLineItems);
		for(Opportunity_Product_History__c oneOppProdHistory :newListOppProdHistory){
			if(oneOppProdHistory.Id == null){
				this.sObjectsToInsert.add(oneOppProdHistory);
			}else{
				//These Opportunity Product History Objects are updated later by the trigger architecture framework
				this.addSObjectForUpdate(oneOppProdHistory.Id, oneOppProdHistory);
			}
		}
	}
	
	//This method updates Opportunity Paused or Cancelled date
	private void updateOpportunityPasusedOrCancelledDate(List<OpportunityLineItem> newOpportunityLineItems){
		List<Opportunity> oppPORDatelist = OppPORCUpdate.calcPORCDate(newOpportunityLineItems);
		for(Opportunity oneOpportunity : oppPORDatelist){
			 //This has a referense to SObjectstoUpdate Map and trigger frameword takes care of updating at the end
			 Opportunity updateOpportunity = (Opportunity)this.getReferenceToSobjectsToUpdateRecord(oneOpportunity.Id);		
			 updateOpportunity.Opportunity_PorC_Date__c = oneOpportunity.Opportunity_PorC_Date__c;
		}
	}	
	
	//This method derives the Last_Schedule_Bill_Date__c billdate from Opp Line Items 
	private Date getLastScheduledBillDate(List<OpportunityLineItemSchedule> mapOpportunitySchedules){
		Date dateMax;
		for(OpportunityLineItemSchedule oneOppLineItem : mapOpportunitySchedules){
			dateMax = oneOppLineItem.ScheduleDate;
			if(oneOppLineItem.ScheduleDate > dateMax){
				dateMax = oneOppLineItem.ScheduleDate;
			}
		}
		return dateMax;
	}
}