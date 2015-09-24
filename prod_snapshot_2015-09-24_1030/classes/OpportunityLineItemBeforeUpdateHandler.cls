/**
 *  @Class Name : OpportunityLineItemBeforeUpdateHandler
    Created By  : Praneeth Kaleru
    Descritpion : To handler the Opportunity Line item before update operations
    Modifed By  : 03/03/2015 Refactored OpportunityLineItem Before Trigger Handler
 */
public class OpportunityLineItemBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        this.setRecordTypeFlag(tp.newList);
        this.setOpportunityLineItemFieldsBeforeUpdate((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
        this.updateOppLineItemProjectReference((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
		this.updateOppLineItemInvoiceFields((Map<Id, OpportunityLineItem>)tp.oldMap, (Map<Id, OpportunityLineItem>)tp.newMap);
		//This will stop Opportunity Trigger Code execution from the updates in After Update OLI Trigger. make sure this is the last line
        VAlidator_BeforeOppProdUpdate_class.setAlreadyDone();
        
       
    }

	public override void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/* 
                        ----------- BEGIN CODE TRANSPLANT -----------------
    */
	//set Opportunity Line Item Fields before update based on fields updates on dependent fields 
	private void setOpportunityLineItemFieldsBeforeUpdate(Map<Id, OpportunityLineItem> oldOpportunityLineItems, Map<Id, OpportunityLineItem> newOpportunityLineItems){
		//Getting Opportunity RecordType Id 
    	Set<Id> oppIds = new Set<Id>();
    	for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems.Values()){
    		oppIds.add(oneOppLineItem.OpportunityId);
    	}
    	
    	Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>(
    												[Select Id, RecordTypeId from Opportunity Where Id IN: oppIds]
    											);
    	//Getting Opportunity RecordType Id 
    	
		//Loop through all Opp Line Items
		for(OpportunityLineItem oneOpportunityLineItem: newOpportunityLineItems.Values()){
			if (oneOpportunityLineItem.Live_Date__c != null && oneOpportunityLineItem.Quantity != null) {
				//Setting Field
				oneOpportunityLineItem.End_Of_Service_Date__c = oneOpportunityLineItem.Live_Date__c.date()
																		.addMonths(oneOpportunityLineItem.Quantity.intValue());
			}else if (oneOpportunityLineItem.Live_Date__c == null || oneOpportunityLineItem.Quantity == null){
				oneOpportunityLineItem.End_Of_Service_Date__c = null; //Setting Field
			}
		
			//If Logged in User is not same as Gannet Local User
			if (UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id && !Validator_DigAMUpdate_class.hasDAMAlreadyDone()) {
				oneOpportunityLineItem.Opp_Owner__c = oneOpportunityLineItem.Opp_Owner_Id__c; //Setting Field
				oneOpportunityLineItem.Dig_Account_Manager__c = oneOpportunityLineItem.Opp_Dig_Acct_Man_Id__c; //Setting Field
				oneOpportunityLineItem.Affl_Sales_Rep__c = oneOpportunityLineItem.Opp_Sales_Rep_Id__c; //Setting Field
	
				if (oneOpportunityLineItem.Live__c == true && oldOpportunityLineItems.get(oneOpportunityLineItem.Id).Live__c == false) {
					oneOpportunityLineItem.Waiting_Status_Descr__c = null; //Setting Field
				}
				if (String.IsBlank(oneOpportunityLineItem.Waiting_Status__c) && oneOpportunityLineItem.Dig_Account_Manager__c != null
					 && mapOpportunities.get(oneOpportunityLineItem.OpportunityId).RecordTypeId != RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id){
					oneOpportunityLineItem.Waiting_Status__c = 'Awaiting OnBoard'; //Setting Field
				}
				if (oneOpportunityLineItem.Waiting_Status__c != oldOpportunityLineItems.get(oneOpportunityLineItem.Id).Waiting_Status__c) {
					oneOpportunityLineItem.Status_Change_Date__c = date.today(); //Setting Field
				}
			}
			
			//DEV-2800 FIP - Back fill Quantity field on OLI with Quantity of Contract months for USCP Opportunity
			if(mapOpportunities.get(oneOpportunityLineItem.OpportunityId).RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id){
				oneOpportunityLineItem.Quantity = oneOpportunityLineItem.Qty_ContractMonths__c;
			}
           		 // DEV 2966 Update the Start date with and End date based on the Live date
            		if(mapOpportunities.get(oneOpportunityLineItem.OpportunityId).RecordTypeId == RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id 
               						&& oneOpportunityLineItem.Live_Date__c != null && oneOpportunityLineItem.Quantity != null)
            		{
                		oneOpportunityLineItem.End_Date__c = oneOpportunityLineItem.Live_Date__c.date()
																		.addMonths(oneOpportunityLineItem.Quantity.intValue());
                		oneOpportunityLineItem.ServiceDate = oneOpportunityLineItem.Live_Date__c.date();
			}
            
		}
	}
	
	//Update Opportunity Line Item with a reference to Project Object
	private void updateOppLineItemProjectReference(Map<Id, OpportunityLineItem> oldOpportunityLineItems, 
												   Map<Id, OpportunityLineItem> newOpportunityLineItems){
		Set<Id> oppLineItemIds = new set<Id>();										   	
		//If Logged in User is not same as Gannet Local User
		if (UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id) {
			//Loop through all Opp Line Items
			for(OpportunityLineItem oneOpportunityLineItem: newOpportunityLineItems.Values()){
				if (oneOpportunityLineItem.Project__c == null) {
					oppLineItemIds.add(oneOpportunityLineItem.Id);
				}	
			}
			
			//Query for Project Objects based on Opp Line Item Ids
			if(oppLineItemIds.size()>0){
				List <Project__c> oppLineItemProjects = [Select Id, Product_Id__c from Project__c Where Product_Id__c in : oppLineItemIds];
				for (Project__c oneProject: oppLineItemProjects) {
					newOpportunityLineItems.get(oneProject.Product_Id__c).Project__c = oneProject.Id;
				}
			}
		}
	}
    // This method handles Product Start of Service Date & Product End of Service Date on OLI for USCP Opportunities based on different products.
    private void updateOppLineItemInvoiceFields(Map<Id, OpportunityLineItem> oldMap,
                                                Map<Id, OpportunityLineItem> newMap){ 
        map<Id, OpportunityLineItem> oliIdWithProductValues = new map<Id, OpportunityLineItem>();
        for(OpportunityLineItem oli : [SELECT Id, Invoice_ServiceEndDate__c, Invoice_ServiceStartDate__c, 
                                                Waiting_Status__c, Qty_ContractMonths__c, 
                                                PricebookEntry.Product2.Invoice_StatusToCreateILI__c,
                                                PricebookEntry.Product2.Invoice_Frequency__c
                                       FROM OpportunityLineItem
                                       WHERE Id In : newMap.keyset()
                                           AND Opportunity.RecordType.Name = 'USCP Opportunity']){
            oliIdWithProductValues.put(oli.Id, oli);    
        }
        for(OpportunityLineItem oli : newMap.values()){
            system.debug('********PricebookEntry.Product2.Invoice_StatusToCreateILI__c************'+oli.PricebookEntry.Product2.Invoice_StatusToCreateILI__c);
            if(oliIdWithProductValues.keyset().contains(oli.id)){
                if(oldMap.get(oli.id).Waiting_Status__c != oli.Waiting_Status__c 
                    && oli.Waiting_Status__c == oliIdWithProductValues.get(oli.Id).PricebookEntry.Product2.Invoice_StatusToCreateILI__c
                    && oliIdWithProductValues.get(oli.Id).PricebookEntry.Product2.Invoice_Frequency__c != 'Two Times'){
                    
                    if(oli.Invoice_ServiceStartDate__c == null && oli.Has_ILI__c == false){
                        oli.Invoice_ServiceStartDate__c = date.today();
                    }
                    
                    if(oli.Invoice_ServiceStartDate__c != null && oli.Has_ILI__c == false && oli.Waiting_Status__c != 'Closed Won'){
                        oli.Invoice_ServiceEndDate__c = ((oli.Invoice_ServiceStartDate__c).addMonths(Integer.valueOf(oli.Qty_ContractMonths__c))).adddays(-1);
                    }
                    
                    if(oli.Invoice_ServiceStartDate__c != null && oli.Has_ILI__c == false && oli.Waiting_Status__c == 'Closed Won'){
                        oli.Invoice_ServiceEndDate__c = oli.Invoice_ServiceStartDate__c;
                    }
                }
                
                if(oldMap.get(oli.id).Waiting_Status__c != oli.Waiting_Status__c
                    && oli.Waiting_Status__c == oliIdWithProductValues.get(oli.Id).PricebookEntry.Product2.Invoice_StatusToCreateILI__c 
                    && oliIdWithProductValues.get(oli.Id).PricebookEntry.Product2.Invoice_Frequency__c == 'Two Times'){
                    
                    if(oli.Invoice_ServiceStartDate__c == null && oli.Has_ILI__c == false)
                        oli.Invoice_ServiceStartDate__c = date.today();
                    
                    oli.Invoice_ServiceEndDate__c = null;
                } 
                
                if(oldMap.get(oli.id).Waiting_Status__c != oli.Waiting_Status__c
                    && oli.Waiting_Status__c == 'Fulfilled-Complete'
                    && oliIdWithProductValues.get(oli.Id).PricebookEntry.Product2.Invoice_Frequency__c == 'Two Times'){
                    
                    if(oli.Invoice_ServiceStartDate__c != null && oli.Invoice_ServiceEndDate__c == null)
                        oli.Invoice_ServiceEndDate__c = date.today();
                    
                } 
            }
        }
    }
	
	private void setRecordTypeFlag(List<OpportunityLineItem> newOpportunityLineItems)
    {
        Map<Id,RecordType> recMap = new Map<id,RecordType>([SELECT id,Name from RecordType where SobjectType = 'Opportunity']);
        Set<id> oppIdLst = new Set<id>();
        for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
           oppIdLst.add(oneOppLineItem.opportunityid);
        }
        Map<id,Opportunity> oppMap = new Map<id,Opportunity>([select id,recordTypeid from opportunity where id =: oppIdLst]);
        for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems)
        {
            Opportunity opp = oppMap.get(oneOppLineItem.opportunityid);
            if(recMap != null && opp.recordTypeid != null){ 
                oneOppLineItem.Record_Type_Name__c = recMap.get(opp.recordTypeid).name;
            }
        }
        
    }
}