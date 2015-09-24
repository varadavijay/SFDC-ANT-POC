trigger leadSurveyUpdater on Lead (after update) {
	
	// CC Ph2 - Iterator
	for(integer x = 0; x < Trigger.new.size(); x++)
	{
		if(Trigger.new[x].IsConverted==True && Trigger.old[x].IsConverted==False){
			String ConvLeadId = Trigger.new[x].Id;
			List<Case> CasesToMove = [SELECT Id, AccountId, Opportunity__c FROM Case WHERE Digital_Lead__c = :ConvLeadId];
			for(Case updateCase : CasesToMove){
				updateCase.AccountId = Trigger.new[x].ConvertedAccountId;
				updateCase.Opportunity__c = Trigger.new[x].ConvertedOpportunityId;
			}
			
			// CC Ph2 - Bulkify
			update CasesToMove;
		}
	}
/**
   List<Survey_Results__c> lstSurvey = new List<Survey_Results__c>();
   //List<OpportunityLineItem> NewLineItems = new List<OpportunityLineItem>();
   
   for( Lead lead : System.Trigger.new)
   {
		if(lead.ConvertedContactId != null)
		{
			    //get the survery result
			    List<Survey_Results__c> survey =[SELECT Id,Contact__c FROM Survey_Results__c WHERE Lead__c =: lead.Id];
			    
			    if(!survey.isEmpty())
			    {
			    	for (Survey_Results__c eSurvey : survey) {
			    		
			    	 	eSurvey.Contact__c = lead.ConvertedContactId;
			    	 	lstSurvey.add(eSurvey);
			    	}
					
			    }     
		}

		if(lead.ConvertedOpportunityId != null)
		{
			String NewOppId = lead.ConvertedOpportunityId;
			String NewAccId = lead.ConvertedAccountId;
					
			if(lead.RecordTypeId == '012F0000000y9rfIAA')
			{
			
					OpportunityLineItem NewDCProd = new OpportunityLineItem(
					OpportunityId = NewOppId,
					PricebookEntryId = '01uA0000004QsseIAC',
					UnitPrice = 0,
					Quantity = 1,
					ServiceDate = date.today(),
					End_Date__c = date.today().addDays(90)
					);
					insert NewDCProd;
			}
			
			Integer ProdsToMove = [SELECT count() from MarketProducts__c WHERE Lead__c =: lead.Id];
			
			if(ProdsToMove > 0)
			{
				List<MarketProducts__c> MPsToAdd =[Select m.Market_Product_List__r.Id , m.Market_Product_List__r.Digital_Product__r.Id, m.Lead__c, m.Number__c, m.Time__c, m.Total_Amount__c, m.Comments__c FROM MarketProducts__c m WHERE Lead__c =: lead.Id];
				Integer NewProdsCnt = MPsToAdd.size();

				for (Integer i = 0; i < NewProdsCnt; i++)
				{
					String ProductRef = MPsToAdd[i].Market_Product_List__r.Digital_Product__r.Id;
					PricebookEntry PriceRecord = [select id from PricebookEntry where Pricebook2Id = '01sA0000000L68aIAC' and Product2Id = : ProductRef limit 2];
					
					OpportunityLineItem NewProdsEntry = new OpportunityLineItem(
					OpportunityId = NewOppId,
					PricebookEntryId = PriceRecord.Id,
					UnitPrice = MPsToAdd[i].Total_Amount__c,
					Quantity = MPsToAdd[i].Time__c,
					ServiceDate = date.today(),
					End_Date__c = date.today().addDays(90)
					);
					
					NewLineItems.add(NewProdsEntry);
					//comment testing
					String CommentToMake = NewOppId + ';' + MPsToAdd[i].Market_Product_List__r.Digital_Product__r.Id + ';' + MPsToAdd[i].Total_Amount__c + ';' + MPsToAdd[i].Time__c;
					MPsToAdd[0].Comments__c = CommentToMake;
					update MPsToAdd;
				}
				if(NewLineItems.size() > 0)
				{
					insert NewLineItems;
				}
			}
			Integer ContsToMove = [SELECT count() from Contact WHERE Lead__c =: lead.Id];    
			if(ContsToMove > 0)
			{
				List<Contact> ContactsToMove = [SELECT Id, AccountId FROM Contact WHERE Lead__c =: lead.Id];
				
				for(Contact tempContact : ContactsToMove)	
				{
					tempContact.AccountId = NewAccId;
				}
				
				update ContactsToMove;

			}
		}

   }
   if(!lstSurvey.isEmpty())
   {
   		Update lstSurvey;
   }
   
   **/
}