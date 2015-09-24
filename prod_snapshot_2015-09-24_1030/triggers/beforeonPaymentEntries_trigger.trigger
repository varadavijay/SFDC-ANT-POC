trigger beforeonPaymentEntries_trigger on Payment_Entries__c (before delete, before insert, before update) {
	if(Trigger.isInsert || Trigger.isUpdate){
		
		//Start Bulkifying KPICalender__c SOQL
		Set<Date> paymentDates = new Set<Date>();
		List<KPICalender__c> masterKPIList = new List<KPICalender__c>();
		Map<Date, KPICalender__c> mapKPICalendar = new Map<Date, KPICalender__c>();
		
		for (Payment_Entries__c pe_Iterator : Trigger.new) { 
			paymentDates.add(pe_Iterator.Date__c);
		}
		if(paymentDates.size()>0){
			masterKPIList = [SELECT Id, Date__c FROM KPICalender__c Where Date__c in :paymentDates order by Date__c];
			for(KPICalender__c oneKPICal : masterKPIList){
				mapKPICalendar.put(oneKPICal.Date__c, oneKPICal);
			}
		}
		//Stop Bulkifying KPICalender__c SOQL
		
		for (Payment_Entries__c pe_Iterator : Trigger.new) { 
			if (Trigger.isInsert){
				pe_Iterator.DigAccountManager__c = pe_Iterator.Dig_Acct_Man_Id__c;
				if(mapKPICalendar.get(pe_Iterator.Date__c) != null){
					pe_Iterator.KPI_Calender__c = mapKPICalendar.get(pe_Iterator.Date__c).Id;
				}
			}
			
			if(Trigger.isUpdate){
				Boolean OldCompleted = System.Trigger.oldMap.get(pe_Iterator.Id).Completed__c;
				Boolean NewCompleted = pe_Iterator.Completed__c;
				Boolean OldDeclined = System.Trigger.oldMap.get(pe_Iterator.Id).Declined__c;
				Boolean NewDeclined = pe_Iterator.Declined__c;
				String CurrentUser = System.Userinfo.getUserId();
				//
				pe_Iterator.DigAccountManager__c = pe_Iterator.Dig_Acct_Man_Id__c;
				if((OldCompleted == False && NewCompleted == True) || (NewDeclined == True && OldDeclined == False))
				{
					pe_Iterator.Processor__c = CurrentUser;
				}
				
				if(mapKPICalendar.get(pe_Iterator.Date__c) != null){
					pe_Iterator.KPI_Calender__c = mapKPICalendar.get(pe_Iterator.Date__c).Id;
				}
			}
		}
	}
	else if (Trigger.isDelete){}
	else {}
}