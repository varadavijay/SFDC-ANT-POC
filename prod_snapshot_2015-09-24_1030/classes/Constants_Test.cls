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
private class Constants_Test {

    static testMethod void isProdTest() {
        String prodShortId = Constants.PRODUCTION_ORGID_SHORT;
        String prodLongId = Constants.PRODUCTION_ORGID_LONG;
        String currentOrgId = UserInfo.getOrganizationId();
        Boolean isProd = Constants.IS_PRODUCTION;        
        
        if(currentOrgId == prodShortId || currentOrgId == prodLongId){
            system.assert(Constants.IS_PRODUCTION == true);
        }
        else{
            system.assert(Constants.IS_PRODUCTION == false);
        }
    } //isProdTest()
    
    //Test the Company Constant - Need to see all data for this one because of the Gannett user
    @isTest(seeAllData = true)
    static void testPseudoConstants(){

    	Account acct = Constants.AZ_REPUBLIC_COMPANY;
    	if(acct != null){
    		system.assertEquals(acct.Name, Constants.AZ_REPUBLIC_COMPANY_NAME);
    	}
    	else{
    		system.debug('AZ Republic Company is null, Data needs to be loaded');
    	}
     	
     	KPIRep__c kpi = Constants.GANNETT_LOCAL_KPI_REP;
    	if(kpi != null){
    		//system.assertEquals(kpi.Name, Constants.GANNETT_LOCAL_KPI_NAME);
    	}
    	else{
    		system.debug('Gannett Local KPIRep is null, Data needs to be loaded');
    	}
     	

	}
	
	@isTest(seeAllData = true)
	static void testRerunLoadData(){
		// This should test the path where the data is already loaded, since we are looking at the data
		// If this test fails in a sandbox, then the Constants.loadData() method needs to be run in that environment.
		Constants.loadData();
		system.assert(Constants.dataAlreadyLoaded);
	}
	@isTest(seeAllData = false)
	static void testFirstrunLoadData(){
		//This should test the path where the data is NOT already loaded, since we are NOT looking at the data
		Constants.loadData();
		system.assert(!Constants.dataAlreadyLoaded);
	}
}