public class OppPORCUpdate{
// Code to update the PORC Date
	public static set<ID> processedOLIPorCChanges = new set<ID>(); // Will be referenced by different runs of this class in a single transaction.
	
    public static List<Opportunity> calcPORCDate(List<OpportunityLineItem> listOpportunityLineItems) {
        List<Opportunity> lineItemParentRecords =   new List<Opportunity>();
        List<OpportunityLineItem> listLineItems =   new List<OpportunityLineItem>();
        Set<String> parentIds   =   new Set<String>();
        
        for (integer i=0;i<listOpportunityLineItems.size();i++){
        	//Remove any OLI that have already had a status update this transaction.
        	if (!processedOLIPorCChanges.isempty() && processedOLIPorCChanges.contains(listOpportunityLineItems[i].ID)){
				continue;
			}
            if(listOpportunityLineItems[i].OpportunityId != null ) {
                parentIds.add(listOpportunityLineItems[i].OpportunityId);
            }
        }
        
        if (parentIds.size()>0)
        {
            lineItemParentRecords   =   [SELECT Id, Opportunity_PorC_Date__c FROM Opportunity WHERE Id IN :parentIds];
            listLineItems   =   [SELECT Id, Waiting_Status__c,OpportunityId  FROM OpportunityLineItem WHERE OpportunityId IN :lineItemParentREcords];
            for(Opportunity objOpportunity : lineItemParentRecords) {
                for(OpportunityLineItem objLineItem : listLineItems) {
                    if(objLineItem.OpportunityId == objOpportunity.Id) {
                        if(objLineItem.Waiting_Status__c == 'Cancelled' || objLineItem.Waiting_Status__c == 'Hard Cancel' || objLineItem.Waiting_Status__c == 'Paused:Billing' || objLineItem.Waiting_Status__c == 'Paused:No Contact') {
                            if(objOpportunity.Opportunity_PorC_Date__c == null ){
                                objOpportunity.Opportunity_PorC_Date__c = System.today();
                                processedOLIPorCChanges.add(objLineItem.Id);
                            }
                            break;
                        } else {
                            if(objOpportunity.Opportunity_PorC_Date__c == null){
                                processedOLIPorCChanges.add(objLineItem.Id);
                            }
                            else{
                                objOpportunity.Opportunity_PorC_Date__c = null;
                            }
                        } 
                    }
                }
            }
            
            //Prevent further POC Date updates for associated OLI in this transaction
            // Commented for updating date after workflow updatation
            //processedOLIPorCChanges.addall(new map<id,opportunityLineItem>(listLineItems).keyset());
        }
		return lineItemParentRecords;
    }
}