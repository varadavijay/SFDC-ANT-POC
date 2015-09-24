global class batchonContact_updatekpi implements Database.Batchable<Contact>{
	// <comment>
	//Datetime CodeTime = datetime.now().addHours(-1);
	//List<Account> PropsToUpdate = [SELECT Id, Last_Rep_Summary__c FROM Account WHERE RecordTypeId = '012F0000000y9WcIAI' AND Last_Rep_Summary__c < :CodeTime AND Last_Rep_Sum_Run__c = True];
	//String AccIdToAdd;
	//Set<String> MedPropList = new Set<String>();
	//for(Account tempAcc1 : PropsToUpdate){
	//	AccIdToAdd = tempAcc1.Id;
	//	MedPropList.add(AccIdToAdd);
	//}
	
	// <string>
	// <refactor> should not use hard coded ids 
	// <refactor> move this query into the start method and this query can be returned via a query locator
	//  <CC> this currently does not take advantage of the Batchable class 
	// <refactor> no test for this batch
		
	List<Contact> ConsToUpdate = [SELECT Id, KPI_Dig_Audit_Closed__c, KPI_Dig_Audit_Converts__c, KPI_Dig_Audit_Requests__c, KPI_Dig_Audit_Won_Value__c, KPI_Avg_Time_To_Close__c, KPI_Dig_Audit_Closed_30__c, KPI_Dig_Audit_Requests_30__c FROM Contact Where RecordTypeId = '012F0000000y9gDIAQ'];
	global Iterable<Contact> start(database.batchablecontext Conkpi){
		return (ConsToUpdate);
	}
	global void execute(Database.BatchableContext Conkpi, List<Contact> scope){

		Set<String> AfflRepList = new Set<String>();
		String ConIdToAdd;
		//List<Contact> masterAFFLCON = [SELECT Id, KPI_Dig_Audit_Closed__c, KPI_Dig_Audit_Converts__c, KPI_Dig_Audit_Requests__c, KPI_Dig_Audit_Won_Value__c FROM Contact Where RecordTypeId = '012F0000000y9gDIAQ' AND AccountId = '001F000000gfrcZ'];
		for(Contact tempCon1 : scope){
			ConIdToAdd = tempCon1.Id;
			AfflRepList.add(ConIdToAdd);
		}
		// <string>
		// <refactor> should not use hard coded ids 
		List<Lead> sumLeads = [SELECT Id, RecordTypeId, SalesRep__c, Status, IsConverted, ConvertedOpportunityId, ConvertedAccountId, CreatedDate FROM Lead Where SalesRep__c IN :AfflRepList AND RecordTypeId = '012F0000000y9lDIAQ'];
		Set<String> ConvOppList = new Set<String>();
		String OppIdToAdd;
		for(Lead tempLead1 : sumLeads){
			// <String>
			if(tempLead1.IsConverted == True){OppIdToAdd = tempLead1.ConvertedOpportunityId;ConvOppList.add(OppIdToAdd);}}
			//
			List<Opportunity> OppsToUpdate = new List<Opportunity>();	
		List<Opportunity> sumOpps = [SELECT Id, RecordTypeId, Sales_Rep__c, StageName, IsWon, Amount, CloseDate, KPI_Time_To_Close__c FROM Opportunity Where Sales_Rep__c IN :AfflRepList AND Id IN :ConvOppList];
		for(Contact tempCon2 : scope){
			// <string>
			tempCon2.KPI_Dig_Audit_Requests__c = 0;tempCon2.KPI_Dig_Audit_Converts__c = 0;tempCon2.KPI_Dig_Audit_Closed__c = 0;tempCon2.KPI_Dig_Audit_Won_Value__c = 0;tempCon2.KPI_Dig_Audit_Requests_30__c = 0;tempCon2.KPI_Dig_Audit_Closed_30__c = 0;tempCon2.KPI_Dig_Audit_Won_Value_30__c=0;
			Double TotalCloseTime = 0;
			Double OppCount = 0;
			// <String>
			Double ThisCloseTime = 0;Date ThirtyDaysBack = date.today() - 90;
			for(Lead tempLead1 : sumLeads){
				// <String>
				if(tempLead1.SalesRep__c == tempCon2.Id && tempLead1.CreatedDate >= ThirtyDaysBack){tempCon2.KPI_Dig_Audit_Requests_30__c = tempCon2.KPI_Dig_Audit_Requests_30__c + 1;}
				// <String>
				if(tempLead1.SalesRep__c == tempCon2.Id){tempCon2.KPI_Dig_Audit_Requests__c = tempCon2.KPI_Dig_Audit_Requests__c + 1;}
				if(tempLead1.IsConverted == True){
					// <String>
					tempCon2.KPI_Dig_Audit_Converts__c = tempCon2.KPI_Dig_Audit_Converts__c + 1;}
					// <String>
					for(Opportunity tempOpp0 : sumOpps){if(tempOpp0.IsWon == True && tempOpp0.Id == tempLead1.ConvertedOpportunityId){Datetime CDate1 = tempLead1.CreatedDate;Date CDate2 = CDate1.date();OppCount = OppCount + 1;ThisCloseTime = CDate2.daysBetween(tempOpp0.CloseDate);tempOpp0.KPI_Time_To_Close__c = ThisCloseTime;TotalCloseTime = TotalCloseTime + ThisCloseTime;OppsToUpdate.add(tempOpp0);}}
			}
			for(Opportunity tempOpp1 : sumOpps){
				// <String>
				if(tempOpp1.Sales_Rep__c == tempCon2.Id && tempOpp1.IsWon == True){tempCon2.KPI_Dig_Audit_Closed__c = tempCon2.KPI_Dig_Audit_Closed__c + 1;tempCon2.KPI_Dig_Audit_Won_Value__c = tempCon2.KPI_Dig_Audit_Won_Value__c + tempOpp1.Amount;}
				// <String>
				if(tempOpp1.Sales_Rep__c == tempCon2.Id && tempOpp1.IsWon == True && tempOpp1.CloseDate > date.today()-91){tempCon2.KPI_Dig_Audit_Closed_30__c = tempCon2.KPI_Dig_Audit_Closed_30__c + 1;tempCon2.KPI_Dig_Audit_Won_Value_30__c = tempCon2.KPI_Dig_Audit_Won_Value_30__c + tempOpp1.Amount;}
			}
			// <String>
			if(OppCount > 0){tempCon2.KPI_Avg_Time_To_Close__c = TotalCloseTime/OppCount;}else{tempCon2.KPI_Avg_Time_To_Close__c = 0;}
		}
		// <String>
		update scope;update OppsToUpdate;//(OppsToUpdate.Id,OppsToUpdate.KPI_Time_To_Close__c);
	}
global void finish(Database.BatchableContext info){}
}