public with sharing class KpiCalenderManager {
	
	public void updateNewFiscalPeriod(){
		Date currentDate = Date.today();
		Integer currentYear = currentDate.year();
		List<Period> periodToday = [select Number
									from Period
									where StartDate <= :currentDate
									and EndDate >= :currentDate
									and Type = 'Month' limit 1];
		if(periodToday == null || periodToday.size() != 1){
			system.debug('Period query didn\'t return expected results ... canceling update operation');
			return;
		}
		Integer intCurrentPeriod = periodToday[0].Number;
		String strCurrentPeriod = intCurrentPeriod < 10 ? 'P0' + String.valueOf(intCurrentPeriod) : 'P' + String.valueOf(intCurrentPeriod);
								 
		// See what the previous value was for any KPICalender record
		List<KPICalender__c> todayCal = [Select CurrentPeriod2__c From KPICalender__c limit 1];
		if(todayCal == null || todayCal.size() != 1){
			system.debug('KPICal for today didn\'t return expected results ... canceling update operation');
			return;
		}
		
		String strPrevUpdatedPeriod = todayCal[0].CurrentPeriod2__c;
		if(strCurrentPeriod == strPrevUpdatedPeriod){
			system.debug('Period is still current. No update necessary');
		}
		else {
			system.debug('CurrentPeriod is changing from ' + strPrevUpdatedPeriod + ' to ' + strCurrentPeriod);
			List<KPICalender__c> KpiCalsToUpdate = new List<KPICalender__c>();
			for(List<KPICalender__c> KpiCalBatch : [Select 	Id,
															Period__c,
															currentPeriod2__c,
															Period_Offset__c,
															Fiscal_Year__c
															From KPICalender__c]){
				for(KPICalender__c KpiCal : KpiCalBatch){
					// Set current Period
					KpiCal.currentPeriod2__c = strCurrentPeriod;
					
					// Now calculate and set the Period Offset
					Integer KpiPeriod = Integer.valueOf(KpiCal.Period__c.right(2));
					
					// Start with some Year+Period as a "zero point" I'll use P01 of 2000, because
					// it's far enough in the past to not conflict with any actual data and it's a nice round number.
					Integer baseYear = 2000;
					Integer totalCurrentPeriods = (currentYear - baseYear)*12 + intCurrentPeriod;
					
					Integer totalKpiPeriods = ((Integer)KpiCal.Fiscal_Year__c - baseYear)*12 + KpiPeriod;
					
					// Period Offset =  Kpi - Current. This makes the sign negative for Kpi periods
					// in the past and positive for Kpi periods in the future
					Integer PeriodOffset = totalKpiPeriods - totalCurrentPeriods;
					
					KpiCal.Period_Offset__c = PeriodOffset;
					KpiCalsToUpdate.Add(KpiCal);
					
					
					
				}
			}
			update KpiCalsToUpdate;
		}
	} // updateNewFiscalPeriod()
	
	public void resetCurrentPeriodForTesting(String periodToSet){
		system.debug('Changing CurrentPeriod to ' + periodToSet);
		List<KPICalender__c> KpiCalsToUpdate = new List<KPICalender__c>();
		for(List<KPICalender__c> KpiCalBatch : [Select 	Id,
														currentPeriod2__c
														From KPICalender__c]){
			for(KPICalender__c KpiCal : KpiCalBatch){
				// Set current Period
				KpiCal.currentPeriod2__c = periodToSet;
				
				KpiCalsToUpdate.Add(KpiCal);
				
				
				
			} // inner for loop
		} // outer for loop
		update KpiCalsToUpdate;
	} // resetCurrentPeriodForTesting() 

}