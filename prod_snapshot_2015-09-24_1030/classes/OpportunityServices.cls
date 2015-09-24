public class OpportunityServices {
	
	public static void setGOAssistEmail(List<opportunity> newOpps) {
		set<ID> GOAssistUserIDs = new set<ID>();
		User[] emailAddresses = new User[]{}; 
		for (Opportunity Opp: newOpps){
			// Gather needed emails
			system.debug('Current values for the rep and email fields: Opp.GL_Assisting_Rep__c =' + Opp.GL_Assisting_Rep__c  + 'Opp.GL_Assisting_Rep_Email__c =' + Opp.GL_Assisting_Rep_Email__c);
			if (Opp.GL_Assisting_Rep__c != null &&  (Opp.GL_Assisting_Rep_Email__c == ''||Opp.GL_Assisting_Rep_Email__c == null)){
				GOAssistUserIDs.add(opp.GL_Assisting_Rep__c);
			}
			system.debug('Current values for the rep and email fields: Opp.GL_Assist_Rep_2__c =' + Opp.GL_Assist_Rep_2__c  + 'Opp.GL_Assisting_Rep_2_Email__c =' + Opp.GL_Assisting_Rep_2_Email__c);
			 if (Opp.GL_Assist_Rep_2__c != null && (Opp.GL_Assisting_Rep_2_Email__c == ''|| Opp.GL_Assisting_Rep_2_Email__c == null)){
			 	GOAssistUserIDs.add(opp.GL_Assist_Rep_2__c);
			}
			
			//Reset emails if GO Assist fields have been cleared
			system.debug('Opp.GL_Assisting_Rep__c =' + Opp.GL_Assisting_Rep__c  + '; Opp.GL_Assisting_Rep_Email__c='+ Opp.GL_Assisting_Rep_Email__c );
			system.debug('Opp.GL_Assist_Rep_2__c =' + Opp.GL_Assist_Rep_2__c  + '; Opp.GL_Assisting_Rep_2_Email__c='+ Opp.GL_Assisting_Rep_Email__c );
            if (Opp.GL_Assisting_Rep__c == null && Opp.GL_Assisting_Rep_Email__c != null){
                Opp.GL_Assisting_Rep_Email__c = null;
            } 
            if (opp.GL_Assist_Rep_2__c == null && Opp.GL_Assisting_Rep_2_Email__c!= null){
                Opp.GL_Assisting_Rep_2_Email__c = null;
            }
		}
		system.debug('Number of users to update emails for: ' + GOAssistUserIDs.size());
		if (GOAssistUserIDs.size()>0)
		{
			//Get & set missing emails on GO Assist fields
			emailAddresses = [SELECT id, email from user where id in :GOAssistUserIDs];
			map<id,user>userEmails = new map<id,user>(emailAddresses);
			for (Opportunity Opp: newOpps){
	            if ((Opp.GL_Assisting_Rep_Email__c == ''||Opp.GL_Assisting_Rep_Email__c == null) && userEmails.containsKey(opp.GL_Assisting_Rep__c)){
	                Opp.GL_Assisting_Rep_Email__c = userEmails.get(opp.GL_Assisting_Rep__c).Email;
	            }
	             if ((Opp.GL_Assisting_Rep_2_Email__c == ''|| Opp.GL_Assisting_Rep_2_Email__c == null) && userEmails.containsKey(opp.GL_Assist_Rep_2__c)){
	                Opp.GL_Assisting_Rep_2_Email__c = userEmails.get(opp.GL_Assist_Rep_2__c).Email;
	            }
	        }
		}
	}
	
	
	public static List<Opportunity> filterOpportunitiesWithClosedWon(List<Opportunity> opportunities, Map<Id, Opportunity> opportunitiesOldMap){                        
		return Select.Field.isEqual('StageName', 'Closed Won').filter(
			Select.Field.hasChanged( Opportunity.StageName ).filter( opportunities, opportunitiesOldMap ));		
	}
	
	
	public static List<OpportunityLineItem> processOpportunitiesWithClosedWon(List<Opportunity> filteredOpportunities){
		Map<Id, Opportunity> filteredOpps = new Map<Id, Opportunity>(filteredOpportunities);
        List<OpportunityLineItem> prcoessedOLIs = new List<OpportunityLineItem>(); 	
		for (OpportunityLineItem oli : [Select Id, 
                                        		OpportunityId, 
                                        		Waiting_Status__c 
                                        From OpportunityLineItem 
										Where OpportunityId in :filteredOpps.keySet()
                                          and Waiting_Status__c = ''
                                       ])
        {
			oli.Waiting_Status__c = 'Closed Won';
			prcoessedOLIs.add(oli);
		}
		return prcoessedOLIs;

	}
	
	public static List<OpportunityLineItem> updateOpportunityProductsWithClosedWon(List<OpportunityLineItem> processedOLIs, Map<Id, Opportunity> opportunityMap){		
		SafeDML oppProductsToUpdate = new SafeUpdate();
		ErrorHandling.AddErrorsToTriggerNew errorHandling = new ErrorHandling.AddErrorsToTriggerNew( opportunityMap,'OpportunityId' );
		oppProductsToUpdate.queue( processedOLIs, errorHandling );
		oppProductsToUpdate.doDML();
		return processedOLIs;
	}
	
	
}