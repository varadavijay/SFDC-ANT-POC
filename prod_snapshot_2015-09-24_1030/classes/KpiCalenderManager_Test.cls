/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class KpiCalenderManager_Test {

    static testMethod void testPeriodOffsetCalculation() {
        // The KpiCalenderManager class calculates the offset based on what the period is set to.
        // Therefore, for test data, just use the 15th of the month, which is always going to be in the period 
        // expected for that month.
        
        List<KPICalender__c> KpiCalsToInsert = new List<KPICalender__c>();
        
        for(Integer year = 2005; year < 2018; ++year){
        	for(Integer month = 1; month <=12; ++month){
        		Date dt = Date.newInstance(year, month, 15);
        		KPICalender__c KpiCal = new KPICalender__c();
        		KpiCal.Name = dt.format();
        		KpiCal.Date__c = dt;
        		KpiCal.Fiscal_Year__c = year;
        		KpiCal.Period__c = month < 10 ? 'P0' + String.valueOf(month) : 'P' + String.valueOf(month);
        		
        		KpiCalsToInsert.add(KpiCal);
        	} // months
        } // years
        
        insert KpiCalsToInsert;
        
        Test.startTest();
        	KpiCalenderManager mgr = new KpiCalenderManager();
        	mgr.updateNewFiscalPeriod();
	Test.stopTest();
    	
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
		
		List<KPICalender__c> kpiListShouldBeZero = [Select id, CurrentPeriod2__c
													From KPICalender__c
													Where CurrentPeriod2__c <> :strCurrentPeriod];
		String assertMessage = 'Expected no rows to be returned since all records should have the updated period (' + strCurrentPeriod + ')';
		if( kpiListShouldBeZero.size() != 0){
			assertMessage += ' Sample period from query = ' + kpiListShouldBeZero[0].CurrentPeriod2__c;
		}
		system.AssertEquals(0, kpiListShouldBeZero.size(), assertMessage);
    	
        
        
    }
}