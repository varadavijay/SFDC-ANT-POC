trigger afteronAgreement_trigger on echosign_dev1__SIGN_Agreement__c (after update, before update) {
   for (echosign_dev1__SIGN_Agreement__c agree : Trigger.new){
   		if(Trigger.isBefore){
   			agree.Market__c = agree.Opp_Market__c;
	    	agree.Opp_Record_Type_II__c = agree.Opp_Record_Type__c;
   		}
   		if (Trigger.isAfter){
	    	datetime themoment = datetime.now();
	    	date DateOf = date.today();
	    	String TROppId = agree.echosign_dev1__Opportunity__c;
	    	String TREvent = agree.echosign_dev1__Status__c;
	    	String OppOwnerId = agree.Opp_Owner_Id__c;
	    	String OppOwnerRole = agree.Opp_Owner_Role__c;
	    	if(TREvent == 'Out for Signature'){TREvent = 'Sent';}
	    	//KPI Reference
			// <bulkify>
			Integer KPICount = [SELECT Count() FROM KPIRep__C WHERE User__c = : OppOwnerId];
			String currKPIRec = '';
			If (KPICount >=1){
				// <bulkify>
			    KPIRep__c currKPIRecord = [SELECT Id from KPIRep__c WHERE User__c = : OppOwnerId limit 1];
				currKPIRec = currKPIRecord.Id;
			}
			//CalenderReference
			// <bulkify>
			Integer CalCount = [SELECT Count() FROM KPICalender__c WHERE Date__c = : DateOf];
			String currCalRec = '';
			If (CalCount >=1){
				// <bulkify>
			    KPICalender__c currKPIRecord = [SELECT Id from KPICalender__c WHERE Date__c = : DateOf limit 1];
			    currCalRec = currKPIRecord.Id;
			}	
			// <bulkify>
			List<Opp_Tracking_Report__c> CheckTR =[select Opportunity__c, Event__c, Time_Stamp__c
												   from Opp_Tracking_Report__c
												   where Opportunity__c =:TROppId AND Event__c = 'Sent'];

	   		if(agree.echosign_dev1__Opportunity__c != null &&
	   		   agree.echosign_dev1__Status__c == 'Out for Signature' &&
	   		   agree.Opp_Record_Type__c == '012F0000000y9rk'){
	   		   	
	   			String OppOnAgree = agree.echosign_dev1__Opportunity__c;
	   			Opp_Tracking_Report__c NewTR = new Opp_Tracking_Report__c(
				Opportunity__c = OppOnAgree,
				Event__c = 'Sent',
				Time_Stamp__c = themoment,
	   			Action_Owner__c = OppOwnerId,
	   			Action_Owner_Role__c = OppOwnerRole,
	   			KPI_Rep__c = currKPIRec,
	   			GL_Calender__c = currCalRec
				);
				if (CheckTR.size() == 0)
				{
				// <bulkify>
				insert NewTR;
				}
	   		}
			// <bulkify>
	   		List<Opp_Tracking_Report__c> CheckTR1 =[select Opportunity__c, Event__c, Time_Stamp__c
	   												from Opp_Tracking_Report__c
	   												where Opportunity__c =:TROppId AND Event__c = 'Signed'];
	   		
	   		if(agree.echosign_dev1__Opportunity__c != null &&
	   		   (agree.echosign_dev1__Status__c == 'Waiting for Counter-Signature' || agree.echosign_dev1__Status__c == 'Signed') &&
	   		   agree.Opp_Record_Type__c == '012F0000000y9rk'){
	   		  	
	   			String OppOnAgree = agree.echosign_dev1__Opportunity__c;
	   			
				// <bulkify>
				List<Opportunity> OppToUpdate =[SELECT Id, Track_Signed__c, Track_Approved__c, StageName
												FROM Opportunity WHERE Id =:OppOnAgree];
	   			for(Opportunity tempOTU : OppToUpdate){
	   				tempOTU.Track_Signed__c = True;
	   				if(tempOTU.Track_Approved__c == True){tempOTU.StageName = 'Closed - Appr & Sign';}
	   				else {tempOTU.StageName = 'DC Signed';}
	   			}
				// <bulkify>
	   			update OppToUpdate;
	   			
	   			Opp_Tracking_Report__c NewTR = new Opp_Tracking_Report__c(
				Opportunity__c = OppOnAgree,
				Event__c = 'Signed',
				Time_Stamp__c = themoment,
	   			Action_Owner__c = OppOwnerId,
	   			Action_Owner_Role__c = OppOwnerRole,
	   			KPI_Rep__c = currKPIRec,
	   			GL_Calender__c = currCalRec
				);
				if (CheckTR1.size() == 0)
				{
					// <bulkify>
					insert NewTR;
				}
	   		}
   		} // if isAfter
   } // For each agreement in trigger
}