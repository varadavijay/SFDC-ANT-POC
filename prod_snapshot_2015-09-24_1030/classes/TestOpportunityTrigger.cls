@isTest(SeeAllData=True)

public class TestOpportunityTrigger {
	
	// these are the different picklist values and are subject to change
	final static String OPP_STAGE_NAME_CLOSED_WON =  'Closed Won';
	final static String OLI_STAGE_NAME_CLOSED_WON =  'Closed Won';
	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	private static Account testAccount;
	
	static {
		
		testAccount = TestingUtils.createAccounts(1, true)[0];
		
	}
	
	public static List<OpportunityLineItem> setupOLIs(Opportunity testOppClosedWon, Opportunity testOpp){
		
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		Product2 testProd2 = TestingUtils.createProduct('test prod2', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		PriceBookEntry testPbe2 = TestingUtils.createPriceBookEntry(testProd2.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLI(testPbe.Id, testOppClosedWon.Id, false); 
		OpportunityLineItem testOLI2 = TestingUtils.createOLI(testPbe2.Id, testOppClosedWon.Id, false); 
		OpportunityLineItem testOLI3 = TestingUtils.createOLI(testPbe2.Id, testOpp.Id, false); 
		OpportunityLineItem testOLI4 = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false); 
		testOLI.ServiceDate = Date.today().addDays(2);
		testOLI2.ServiceDate = Date.today().addDays(2);
		testOLI3.ServiceDate = Date.today().addDays(2);
		testOLI4.ServiceDate = Date.today().addDays(2);
		
		return new List<OpportunityLineItem>{testOLI,testOLI2,testOLI3,testOLI4};
		
		
	}
	
	public static testMethod void testUpdateOpportunitiesWithClosedWon() {

		final Integer TOTAL_EXPECTED_OLI = 4;

		List<Opportunity> testOppList = TestingUtils.createOpportunities(2, 'test opp', testAccount.Id, false);
		for (Opportunity o : testOppList){
			o.StageName = OPP_STAGE_NAME_1;
			o.CloseDate = Date.today().addDays(1);
		}
		Opportunity testOppClosedWon = testOppList[0];
		Opportunity testOpp = testOppList[1];
		
		insert testOppList;
		
		List<OpportunityLineItem> testOLIList = setupOLIs(testOppClosedWon, testOpp);
		
		insert testOLIList;
		
		Set<OpportunityLineItem> testOLISet = new Set<OpportunityLineItem>(testOLIList);

		testOppClosedWon.StageName = OPP_STAGE_NAME_CLOSED_WON;
		testOppClosedWon.Signature_Override__c = true;

		Test.startTest();
			update testOppList;
		Test.stopTest();
		
		List<OpportunityLineItem> actualClosedWonOLIS = [Select Id, OpportunityId, Waiting_Status__c From OpportunityLineItem 
														WHERE Id in :testOLISet];
										
		System.assertEquals(TOTAL_EXPECTED_OLI, actualClosedWonOLIS.size(), 'We expect to get back the correct number of Opportunity Products for each Opportunity that is Closed Won');
		for (OpportunityLineItem oli : actualClosedWonOLIS){
			if (oli.OpportunityId == testOppClosedWon.Id){
				System.assertEquals(OLI_STAGE_NAME_CLOSED_WON, oli.Waiting_Status__c, 'We expect to have the correct waiting status for opportunity products with opportunity that are closed won');
			}
			else if (oli.OpportunityId == testOpp.Id){
				System.assertEquals(null, oli.Waiting_Status__c, 'We expect to have the correct waiting status for opportunity products with opportunity that are closed won');
			}
			
		}
    
    }

}