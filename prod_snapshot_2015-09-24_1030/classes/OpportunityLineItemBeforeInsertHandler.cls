/**
 *  @Class Name   : OpportunityLineItemBeforeInsertHandler
    Created By    : Praneeth Kaleru
    Descritpion   : To handler the Opportunity Line item before insert operations
    Modifications : 03/04/2015 Refactored 
 */
public class OpportunityLineItemBeforeInsertHandler extends TriggerHandlerBase {
     
    public override void mainEntry(TriggerParameters tp) {
        this.setOpportunityLineItemFieldsBeforeInsert(tp.newList);
        setRecordTypeFlag(tp.newList);
    }
    
    public override void inProgressEntry(TriggerParameters tp) {
        
    }
    
    /* 
                    ----------- BEGIN CODE TRANSPLANT -----------------
    */
    //set Opportunity Fields before insert based on other field data
    private void setOpportunityLineItemFieldsBeforeInsert(List<OpportunityLineItem> newOpportunityLineItems) {
    	//Getting Opportunity RecordType Id 
    	Set<Id> oppIds = new Set<Id>();
    	for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
    		oppIds.add(oneOppLineItem.OpportunityId);
    	}
    	
    	Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>(
    												[Select Id, RecordTypeId from Opportunity Where Id IN: oppIds]
    											);
    	//Getting Opportunity RecordType Id 
    	
        if(UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id ){//compare the two to check for gl account and skip if so
            for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems){
                oneOppLineItem.Opp_Owner__c             =   oneOppLineItem.Opp_Owner_Id__c;
                oneOppLineItem.Dig_Account_Manager__c   =   oneOppLineItem.Opp_Dig_Acct_Man_Id__c;
                oneOppLineItem.Affl_Sales_Rep__c        =   oneOppLineItem.Opp_Affl_Sales_Rep__c;
                oneOppLineItem.Account__c               =   oneOppLineItem.Opp_Acct_Id__c;
                System.debug('Opportunity RecordTypeId from OLI Trigger >> ' + oneOppLineItem.Opportunity.RecordTypeId);
                if((oneOppLineItem.Waiting_Status__c == '' || oneOppLineItem.Waiting_Status__c == Null) 
                    && oneOppLineItem.Opp_Dig_Acct_Man_Id__c != Null
                    && mapOpportunities.get(oneOppLineItem.OpportunityId).RecordTypeId != RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id){
                    oneOppLineItem.Waiting_Status__c='Awaiting Onboard';
                }
				if(mapOpportunities.get(oneOppLineItem .OpportunityId).RecordTypeId  == RecordTypeCache.getRecordType('Opportunity', 'USCP_Opportunity').Id){
                oneOppLineItem.Quantity = oneOppLineItem.Qty_ContractMonths__c;
				}
            }
        }
       
    }
    
    private void setRecordTypeFlag(List<OpportunityLineItem> newOpportunityLineItems)
    {
         Map<Id,RecordType> recMap = new Map<id,RecordType>([SELECT id,Name from RecordType where SobjectType = 'Opportunity']);
       
        Set<id> oppIdLst = new Set<id>();
        for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems)
           oppIdLst.add(oneOppLineItem.opportunityid);
        Map<id,Opportunity> oppMap = new Map<id,Opportunity>([select id,recordTypeid from opportunity where id =: oppIdLst]);
        for(OpportunityLineItem oneOppLineItem : newOpportunityLineItems)
        {
           Opportunity opp = oppMap.get(oneOppLineItem.opportunityid);
           if(recMap != null && opp.recordTypeid != null) 
           oneOppLineItem.Record_Type_Name__c = recMap.get(opp.recordTypeid).name;
            
          /* if(opp.recordTypeid == rec.id)
             oneOppLineItem.Record_Type_Name__c = '0';
           else
             oneOppLineItem.Record_Type_Name__c = '1';  */
        }
        
    }
}