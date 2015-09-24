trigger afteronMarket_trigger on Market__c (after insert, after update) 
{
  
	//Bulk trigger handler so that you can mass update opportunities and this fires for all'
	for (Market__c mIterator : Trigger.new) { 
    	if ((Trigger.isUpdate || Trigger.isInsert) && mIterator.DealChicken_Approver__c != Null){
      		String NewApprover = mIterator.DealChicken_Approver__c;
      		String Market = mIterator.Id;Date DCRunDate = date.today();
      		String OldApprover = Null;
      		if(Trigger.isUpdate){
        		OldApprover = System.Trigger.oldMap.get(mIterator.Id).DealChicken_Approver__c;
    
        		if(NewApprover != OldApprover && OldApprover != Null){
          			
          			// <Bulkify>
          			List<Opportunity> UpdateMarketApprover =
	          			[SELECT Id, Market_Area_Manager__c
			          	 FROM Opportunity
			          	 WHERE (DealChicken_Market__c = : Market AND Market_Area_Manager__c != : NewApprover)
			          	 AND Track_Approved__c = False
			          	 AND(
			          			(IsWon = True AND(DC_Run_Date__c = Null OR DC_Run_Date__c > : DCRunDate))
			          			OR IsClosed = False
			          		)
			          	AND (RecordTypeId = '012F0000000y9rkIAA' OR RecordTypeId = '012F0000000yFCEIA2')];
          
					for(Opportunity tempOpp : UpdateMarketApprover){
						tempOpp.Market_Area_Manager__c = NewApprover;
					}
					Validator_MarketUpdate_class.setAlreadyDone();
          			// <Bulkify>
					update UpdateMarketApprover;
				}
				else if (NewApprover != OldApprover && OldApprover == Null){
          			// <Bulkify>
          			List<Opportunity> UpdateMarketApprover =
	          			[SELECT Id, Market_Area_Manager__c
	          			 FROM Opportunity
	          			 WHERE (DealChicken_Market__c = : Market AND Market_Area_Manager__c != : NewApprover)
	          			 AND Track_Approved__c = False
	          			 AND IsClosed = False
	          			 AND (RecordTypeId = '012F0000000y9rkIAA' OR RecordTypeId = '012F0000000yFCEIA2')];
					
					for(Opportunity tempOpp : UpdateMarketApprover){
						tempOpp.Market_Area_Manager__c = NewApprover;
					}
					Validator_MarketUpdate_class.setAlreadyDone();
          			// <Bulkify>
					update UpdateMarketApprover;  
				}
				else{}
			} // if (trigger.isUpdate)
		} // if trigger is update or insert and there's a DealChicken approver
	} // foreach Market in Trigger
} // Trigger