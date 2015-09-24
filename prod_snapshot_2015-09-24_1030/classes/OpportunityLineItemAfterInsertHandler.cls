/**
 * 	Class Name			: OpportunityLineItemAfterInsertHandler
 * 	Created By			: Praneeth
 * 	Last Modified By	: Vijay
 * 	Description			: Opportunity Line item trigger handler to handle the old and new opportunity line items
 */
public class OpportunityLineItemAfterInsertHandler extends TriggerHandlerBase{
	public override void mainEntry(TriggerParameters tp) {
		 this.updateOpportunityFields((List<OpportunityLineItem>)tp.newList);
		 this.upsertProjectObject((List<OpportunityLineItem>)tp.newList);
		 this.insertOrUpdateIntoOpportunityProductHistory((List<OpportunityLineItem>)tp.newList);
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
				 updateOpportunity.Print_Products_Notice__c = (oneOppLineItem.Print_Product__c == 'Yes'? true: false);
				 updateOpportunity.Digital_Products_Notice__c = (oneOppLineItem.Digital_Product__c == 'Yes'? true: false);
				 updateOpportunity.Social_Media_Notice__c = (oneOppLineItem.Social_Media_Notice__c == 'Yes'? true: false);		
				 updateOpportunity.Product_List__c = this.formatOpportunityProductNames(mapOpportunities.get(oneOppLineItem.OpportunityId).OpportunityLineItems);
				 
				 Date lastScheduledBillingDate = this.getLastScheduledBillDate(mapOpportunitySchedules.get(oneOppLineItem.OpportunityId));
				 if(lastScheduledBillingDate != null){
				 	updateOpportunity.Last_Schedule_Bill_Date__c = lastScheduledBillingDate;
				 }
			} 
        }
    }
    
    //upset project__c 
    private void upsertProjectObject(List<OpportunityLineItem> newOpportunityLineItems){
    	if(UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id){
    		//getting new Opportunity LineItem Ids
    		Set<Id> newOppLineItemIds = new Map<Id, OpportunityLineItem>(newOpportunityLineItems).KeySet();
    		Map<Id, Id> mapOppLineItemIdAndProjectId = new Map<Id,Id>();
    		for(Project__c oneProject :[Select Id, Product_Id__c from Project__c Where Product_Id__c in :newOppLineItemIds]){
    			mapOppLineItemIdAndProjectId.put(oneProject.Product_Id__c, oneProject.Id);
    		}
    		
    		List<Project__c> upsertProjects = new List<Project__c>();
    		for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
    			Project__c oneProject = new Project__c();
    			if(mapOppLineItemIdAndProjectId.get(oneOppLineItem.Id) != null){
					oneProject.Id = mapOppLineItemIdAndProjectId.get(oneOppLineItem.Id); 
				}
    			oneProject.Cancellation_Category__c = oneOppLineItem.Cancellation_Category__c;
				oneProject.Cancellation_Reason__c = oneOppLineItem.Cancellation_Reason__c;
                		oneProject.Cancellation_Detail__c = oneOppLineItem.Cancellation_Detail__c;
				oneProject.OppProd__c = String.ValueOf(oneOppLineItem.OpportunityId) + String.ValueOf(oneOppLineItem.Id);
				oneProject.Product_Id__c = oneOppLineItem.Id;
				oneProject.Opportunity__c = oneOppLineItem.OpportunityId;
				oneProject.Account__c = oneOppLineItem.Account__c;
				oneProject.Related_Product__c = oneOppLineItem.Product2Id;
				oneProject.Waiting_Status_Descr_Last_Set__c = oneOppLineItem.Waiting_Status_Descr__c;
				oneProject.Status_Notes__c = oneOppLineItem.Waiting_Status_Descr__c;
				oneProject.Waiting_Since_Date__c = oneOppLineItem.Status_Change_Date__c;
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
				upsertProjects.add(oneProject);
    		}
    		
    		//We have to do an upsert here which is not inline with trigger architecture guideline because
    		//Opportunity_Product_History__c is expecting the data to be saved in project__c
    		if(upsertProjects.size()>0){
    			upsert upsertProjects;
    		}
                  list<OpportunityLineItem> olilist = new list<OpportunityLineItem>();
            for(Project__c proj : upsertProjects){
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.id = (Id) proj.Product_Id__c;
                oli.Project__c = proj.Id;
                olilist.add(oli);
                
            }
            if(olilist.size()>0){
                update olilist;
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
	
	//This methods is called to insert records in to Opportunity_Product_History__c Object
	private void insertOrUpdateIntoOpportunityProductHistory(List<OpportunityLineItem> newOpportunityLineItems){
		List<Opportunity_Product_History__c> newListOppProdHistory = 
					OpportunityLineItemServices.processNewOpportunityLineItem(newOpportunityLineItems);
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