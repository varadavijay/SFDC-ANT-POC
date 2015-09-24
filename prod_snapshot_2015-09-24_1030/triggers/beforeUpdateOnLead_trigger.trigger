trigger beforeUpdateOnLead_trigger on Lead (before insert, before update) {

	List<string> ownerId = new list<string>();
	for(Lead lead : Trigger.new){
		ownerId.add(lead.ownerId);
	}
	
	Map<id,User> idToDiv = new Map<id,user>([select Division from user where id in : ownerId]);
	
	for( Lead lead : Trigger.new){
	
		if(lead.SalesRep__c != Null && Trigger.isInsert){
		
			// <Bulkify>
			Contact AfflSalesRepAcctPre = [SELECT Id, AccountId, Market__c, Channel__c FROM Contact WHERE Id = :lead.SalesRep__c];
			String AfflSalesRepAcct = AfflSalesRepAcctPre.AccountId;
			String AfflSalesRepMrkt = AfflSalesRepAcctPre.Market__c;
			String AfflSalesRepChnl = AfflSalesRepAcctPre.Channel__c + ' ' + 'Channel';
			if(AfflSalesRepChnl == 'GL Channel'){
				AfflSalesRepChnl = 'GL';
			}
			if(lead.Related_Company__c == null && AfflSalesRepAcct != null)
			{
				lead.Related_Company__c = AfflSalesRepAcct;
			}
			if(lead.Gannett_Market__c == null && AfflSalesRepMrkt != null)
			{
				lead.Gannett_Market__c = AfflSalesRepMrkt;
			}
			if(lead.Marketing_Source__c == null)
			{
				lead.Marketing_Source__c = AfflSalesRepChnl;
			}
		}
		if(Trigger.isUpdate && lead.Record_Type_Change_To__c == 'DealChicken'){
			lead.RecordTypeId = '012F0000000y9rf';
			lead.Record_Type_Change_To__c = '';
		}
		if(Trigger.isUpdate && lead.Record_Type_Change_To__c == 'SML Lead'){
			lead.RecordTypeId = '012A0000000PKO8';
			lead.Record_Type_Change_To__c = '';
		}

	   	//this is there to clear the workflow when in a conversion process...to allow for the time based reassignment tool to work
	   	//if(lead.isConvert != null)
	   	//{
	   	//	lead.Cancel_Workflow__c = True;
	   	//	update lead;
	   	//}

	   	lead.Lead_Owner__c = null;
	   	
	   	// <PWP> Hard-coded SF Ids - no clue what the intent is here
	   	if(lead.owner.type != 'Name' && 
	   	   lead.OwnerId != '00GF0000002I1mz' &&
	   	   lead.OwnerId != '00GF0000002IDIW' &&
	   	   lead.OwnerId != '00GF0000002IDdA' &&
	   	   lead.OwnerId != '00GF0000002IE6t' &&
	   	   lead.OwnerId != '005F0000001zC4r' &&
	   	   lead.OwnerId != '00GF0000002ISxG' &&
	   	   lead.OwnerId != '00GF0000002IVki' &&
	   	   lead.OwnerId != '00GF0000002Ip33' &&
	   	   lead.OwnerId != '00GF0000002JOk5'){
			
			if (lead.Lead_Owner__c != lead.OwnerId &&
				lead.OwnerId != '00GA0000000UfcF'  &&
				lead.OwnerId != '00GF0000002HzvQ'  &&
				lead.OwnerId != '00GF0000002IIl3'){
					
				lead.Lead_Owner__c = lead.OwnerId;
				lead.Owner_Division__c = (idToDiv.get(lead.ownerId)).Division;
		   	
			   	/**for(User tempUser : LeadOwnerList){
			   		if(tempUser.Id == lead.OwnerId){
			   			lead.Owner_Division__c = tempUser.Division;
			   		}
			   	}**/
			   	
			   	//User MarketAMId = [SELECT Id, Division FROM User WHERE Id = :lead.OwnerId limit 1];
			   	//String MarketAMId2 = MarketAMId.Division;
			   	//lead.Owner_Division__c = MarketAMId2;
			}
	   	}
	   	
	} // for each Lead in trigger.new
} // Trigger