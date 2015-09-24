/**
 * 	Class Name			: OpportunityLineItemAfterDeleteHandler
 * 	Created By			: Vijay
 * 	Last Modified By	: Vijay
 * 	Description			: Opportunity Line item trigger handler to handle the old and new opportunity line items
 */
 
 public class OpportunityLineItemAfterDeleteHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        this.updateOpportunityFields((List<OpportunityLineItem>)tp.oldList);
        this.deleteFromOpportunityProductHistoryAndProducSLA((List<OpportunityLineItem>)tp.oldList);
        this.updateOpportunityPasusedOrCancelledDate((List<OpportunityLineItem>)tp.oldList);
    } 
    
    public override void inProgressEntry(TriggerParameters tp) {
        
    } 
    
    /* 
                        ----------- BEGIN CODE TRANSPLANT -----------------
    */
    // Method to handle old and the new oppotunityLineItems
    private void updateOpportunityFields(List<OpportunityLineItem> oldOpportunityLineItems){
        if(UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id){ 
        	Set<Id> opportunityIds = new Set<Id>();
        	for(OpportunityLineItem oneOppLineItem : oldOpportunityLineItems){
        		opportunityIds.add(oneOppLineItem.OpportunityId);
        	}
        	
        	Map<Id, Opportunity> mapOpportunities = new Map<ID, Opportunity>([SELECT Id, (Select Id, Product_Name__c, Social_Media_Notice__c
					                                                           			 FROM OpportunityLineItems ORDER BY Product_Name__c ASC)
					                                                           From Opportunity WHERE Id in : opportunityIds]);
			
			for(OpportunityLineItem oneOppLineItem : oldOpportunityLineItems){
				 //This has a referense to SObjectstoUpdate Map and trigger frameword takes care of updating at the end
				 Opportunity updateOpportunity = (Opportunity)this.getReferenceToSobjectsToUpdateRecord(oneOppLineItem.OpportunityId);		
				 updateOpportunity.Social_Media_Notice__c = this.hasAnyofOpportunityProductsAreSocialMedia(mapOpportunities.get(oneOppLineItem.OpportunityId).OpportunityLineItems);
				 updateOpportunity.Product_List__c = this.formatOpportunityProductNames(mapOpportunities.get(oneOppLineItem.OpportunityId).OpportunityLineItems);
			} 
        }
    }
    
    //Determine if any of the opportunity Line items have Social Media Products
    private Boolean hasAnyofOpportunityProductsAreSocialMedia(List<OpportunityLineItem> opportunityLineItems){
    	Boolean retVal = false;
    	for(OpportunityLineItem oneOppLineItem: opportunityLineItems){ 
    		if(oneOppLineItem.Social_Media_Notice__c == 'Yes'){
    			retVal = true;
    		}
    	}
    	return retVal;
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
	
	//This methods is called to delete records from Opportunity_Product_History__c & Product_SLA__c Objects
	private void deleteFromOpportunityProductHistoryAndProducSLA(List<OpportunityLineItem> oldOpportunityLineItems){
		//Delete associated Opportunity Product Histories
		List<Opportunity_Product_History__c> filteredOppProdHist = OpportunityLineItemServices.processDeletedOpportunityLineItem(oldOpportunityLineItems);	
		if (filteredOppProdHist.size()>0){		
			OpportunityLineItemServices.deleteOpportunityProductHistories(filteredOppProdHist, oldOpportunityLineItems);
		}
		
		//Delete associated Product SLA records 
		List<Product_SLA__c> SLARecToBeDeleted = OpportunityLineItemServices.getSLASummary(oldOpportunityLineItems);
		if (SLARecToBeDeleted.size()>0){
			OpportunityLineItemServices.deleteSLASummaries(SLARecToBeDeleted,oldOpportunityLineItems);
		}
		
		// DEV-939 SR-3282 SF Opp sends incorrect status updates
        // Deleting Orphaned Projects to fix no workflow time action emails are sent to users wrongly
		List<Project__c> projectsToBeDeleted = OpportunityLineItemServices.getProjectsByOpportunityLineItems(oldOpportunityLineItems);
		if (projectsToBeDeleted.size()>0){
			OpportunityLineItemServices.deleteProjects(projectsToBeDeleted,oldOpportunityLineItems);
		}
	}
	
	//This method updates Opportunity Paused or Cancelled date
	private void updateOpportunityPasusedOrCancelledDate(List<OpportunityLineItem> oldOpportunityLineItems){
		List<Opportunity> oppPORDatelist = OppPORCUpdate.calcPORCDate(oldOpportunityLineItems);
		for(Opportunity oneOpportunity : oppPORDatelist){
			 //This has a referense to SObjectstoUpdate Map and trigger frameword takes care of updating at the end
			 Opportunity updateOpportunity = (Opportunity)this.getReferenceToSobjectsToUpdateRecord(oneOpportunity.Id);		
			 updateOpportunity.Opportunity_PorC_Date__c = oneOpportunity.Opportunity_PorC_Date__c;
		}
	}
}