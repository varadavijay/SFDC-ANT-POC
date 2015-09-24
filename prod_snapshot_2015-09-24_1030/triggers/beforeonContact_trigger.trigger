trigger beforeonContact_trigger on Contact (before insert, before update) {
	for (Contact cIterator : Trigger.new) {
		if(cIterator.KPI_Refresh__c == True){
			if(!Validator_beforeonContact_class.hasAlreadyDone()){
				if(Trigger.isUpdate){
					Validator_beforeonContact_class.setAlreadyDone();
					List<Lead> sumLeads = [SELECT Id, RecordTypeId, SalesRep__c, Status, IsConverted FROM Lead WHERE SalesRep__c =:cIterator.Id];	
					List<Opportunity> sumOpps = [SELECT Id, RecordTypeId, Sales_Rep__c, StageName, IsWon, Amount FROM Opportunity WHERE IsWon = True AND Sales_Rep__c = :cIterator.Id];
					cIterator.KPI_Dig_Audit_Requests__c = 0;
					cIterator.KPI_Dig_Audit_Converts__c = 0;
					cIterator.KPI_Dig_Audit_Closed__c = 0;
					cIterator.KPI_Dig_Audit_Won_Value__c = 0;
					for(Lead tempLead1 : sumLeads){
						cIterator.KPI_Dig_Audit_Requests__c = cIterator.KPI_Dig_Audit_Requests__c + 1;
						if(tempLead1.IsConverted == True){
							cIterator.KPI_Dig_Audit_Converts__c = cIterator.KPI_Dig_Audit_Converts__c + 1;
						}
					}		
					for(Opportunity tempOpp1 : sumOpps){
							cIterator.KPI_Dig_Audit_Closed__c = cIterator.KPI_Dig_Audit_Closed__c + 1;
							cIterator.KPI_Dig_Audit_Won_Value__c = cIterator.KPI_Dig_Audit_Won_Value__c + tempOpp1.Amount;
					}
						/******* BEGIN BULK COMMENT 11/18/13 - if not needed, delete after 01/01/14 **********
						
						Set<String> AfflRepList = new Set<String>();
						String ConIdToAdd;
						Datetime DateCheck = datetime.now() - 1;
						Date DateNow = date.today();
						String MediaProp = cIterator.AccountId;
						List<Contact> masterAFFLCON = [SELECT Id, KPI_Dig_Audit_Closed__c, KPI_Dig_Audit_Converts__c, KPI_Dig_Audit_Requests__c, KPI_Dig_Audit_Won_Value__c FROM Contact Where RecordTypeId = '012F0000000y9gDIAQ' AND AccountId = :MediaProp AND LastModifiedDate <= :DateCheck limit 10];
						for(Contact tempCon1 : masterAFFLCON){
							ConIdToAdd = tempCon1.Id;
							AfflRepList.add(ConIdToAdd);
						}
						List<Lead> sumLeads = [SELECT Id, RecordTypeId, SalesRep__c, Status, IsConverted FROM Lead Where SalesRep__c IN :AfflRepList order by CreatedDate];	
						List<Opportunity> sumOpps = [SELECT Id, RecordTypeId, Sales_Rep__c, StageName, IsWon, Amount FROM Opportunity Where Sales_Rep__c IN :AfflRepList order by CreatedDate];
						for(Contact tempCon2 : masterAFFLCON){
							tempCon2.KPI_Dig_Audit_Requests__c = 0;
							tempCon2.KPI_Dig_Audit_Converts__c = 0;
							tempCon2.KPI_Dig_Audit_Closed__c = 0;
							tempCon2.KPI_Dig_Audit_Won_Value__c = 0;
							for(Lead tempLead1 : sumLeads){
								if(tempLead1.SalesRep__c == tempCon2.Id){
									tempCon2.KPI_Dig_Audit_Requests__c = tempCon2.KPI_Dig_Audit_Requests__c + 1;
									if(tempLead1.IsConverted == True){
										tempCon2.KPI_Dig_Audit_Converts__c = tempCon2.KPI_Dig_Audit_Converts__c + 1;
									}
								}
							}
							for(Opportunity tempOpp1 : sumOpps){
								if(tempOpp1.Sales_Rep__c == tempCon2.Id && tempOpp1.IsWon == True){
									tempCon2.KPI_Dig_Audit_Closed__c = tempCon2.KPI_Dig_Audit_Closed__c + 1;
									tempCon2.KPI_Dig_Audit_Won_Value__c = tempCon2.KPI_Dig_Audit_Won_Value__c + tempOpp1.Amount;
								}
							}
						Double AuditRequests;
						Double AuditConverts;
						Double AuditCloses;
						Double AuditValue;
						List<Contact> masterAFFLCON2 = new List<Contact>();
						for(Contact tempCon3 : masterAFFLCON){
							if(tempCon3.Id == cIterator.Id){
								AuditRequests = tempCon3.KPI_Dig_Audit_Requests__c;
								AuditConverts = tempCon3.KPI_Dig_Audit_Converts__c;
								AuditCloses = tempCon3.KPI_Dig_Audit_Closed__c;
								AuditValue = tempCon3.KPI_Dig_Audit_Won_Value__c;
								
							}
							else {masterAFFLCON2.add(tempCon3);}
						}
						cIterator.KPI_Dig_Audit_Requests__c = AuditRequests;
						cIterator.KPI_Dig_Audit_Converts__c = AuditConverts;
						cIterator.KPI_Dig_Audit_Closed__c = AuditCloses;
						cIterator.KPI_Dig_Audit_Won_Value__c = AuditValue;
						cIterator.KPI_Refresh__c = False;
						update masterAFFLCON2;
						}
						
						****** END BULK COMMENT 11/18/13 - if not needed, delete after 01/01/14 ************/
						
				} // if Trigger.isUpdate
			} // if(!Validator_beforeonContact_class.hasAlreadyDone())
				
				//Validator_beforeonContact_class.setAlreadyDone();
		} //cIterator.KPI_Refresh__c == True
	} // For (Trgger.new)
} //trigger