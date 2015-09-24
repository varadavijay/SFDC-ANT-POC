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
private class OppPusherTests {
	private static sObject[] OpptyList; // <refactor> no active references 
	private static List<Opportunity> testOpptys = new List<Opportunity>();

    static testMethod void myOppUnitTest() {
        
        // create an oppty <comment> unnecessary comments 
        // <refactor> test data creation utility should be used to create test data 
        Opportunity oTestOppty=createOppty('testOppty');
        
        // change the month pushcount+1 <comment> unnecessary comments 
        oTestOppty.CloseDate=date.newinstance(2009,12,11);

        //Opportunity oTestUpdateOppty=[select Id from Opportunities where Id=oTestOppty.Id] <comment> unnecessary comments 
		update oTestOppty;

        Opportunity oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c); // <CC> are debug statements needed ?
        System.assert(oReadOppty.PushCount__c==1); // <refactor> need assertion message

        // make it later this month, no change 
        oTestOppty.CloseDate=date.newinstance(2009,12,31);
        update oTestOppty;

        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c); // <CC> are debug statements needed ?
        System.assert(oReadOppty.PushCount__c==1); // <refactor> need assertion message

        // make it next year, but an earlier month, pushcount+1
        oTestOppty.CloseDate=date.newInstance(2010, 1,1);
        update oTestOppty;

        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c); // <CC> are debug statements needed ?
        System.assertEquals(oReadOppty.PushCount__c, 2); // <refactor> need assertion message

        // don't change the date, no change
        oTestOppty.CloseDate=date.newInstance(2010,1,1);
        update oTestOppty;

		oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c); // <CC> are debug statements needed ?
        System.assertEquals(oReadOppty.PushCount__c,2); // <refactor> need assertion message
        
        // test bulk update <comment> unnecessary comments 
        // <PWP> This tests nothing
        integer i;
        for(i=1;i<199;i++){
        		
        }
        
        //clean up <CC> unnecessary comment
        cleanOpptys(); // is this necessary to delete after testMethod ?  
    }
    
    // <refactor> could put this in a test data creation utility for test data 
    private static Opportunity createOppty(String sOppName) {
    	Opportunity oNewOpp= new Opportunity(name= sOppName,closedate= date.newinstance(2009,11,11),stagename='Prospecting');
    	// <comment>
    //	List<Opportunity> testLocalOpptys = new List<Opportunity>();
    //	testLocalOpptys=(List<Opportunity>)OpptyList;
    //	testLocalOpptys.add(oNewOpp);
    //	OpptyList=testLocalOpptys;
    	insert oNewOpp;
    	testOpptys.add(oNewOpp); // <refactor> seperate this logic away from test data creation 
    	return oNewOpp;
    }
    
    
    private static void cleanOpptys() {
    	// <refactor> why is this deleting one at a time if this is necessary
    	for(Opportunity oIterator : testOpptys) {
    		delete oIterator;
    	}
    	testOpptys.clear();
    }
    
    // <comment>
    	/**static testMethod void myUnitTest2() {
    	Double OTMPre;
    	Double OTMPost;
    		
    	//Double OTMNum1 = [Select count() from Opp_Tracking_Report__c where Opportunity__c = '005A0000000cnyO'];
		OTMPre = 0;
		
		Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
		Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'test2_SMLAdded';
        o.StageName = 'New';
        o.CloseDate = date.today();
        o.RecordTypeId = '012F0000000y9rkIAA';
        o.Market_Record__c = 'St Louis, MO';
        //o.OwnerId = '005A0000000cnyO';
        insert o;
        
        Opportunity DCOpp = [select Id, StageName from Opportunity where Id = :o.Id];
        DCOpp.StageName = 'Closed - Appr & Sign';
        update DCOpp;
        
        Double OTMNum2 = [Select count() from Opp_Tracking_Report__c where Opportunity__c = :o.Id];
		OTMPost = OTMNum2;
		
		Double OTMDif = OTMPost - OTMPre;
	        
	    System.assertEquals(3, OTMDif);
	    
    	}**/
/**static testMethod void myUnitTest3() {
		
		Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
		Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'test3_SMLAdded';
        o.StageName = 'New';
        o.CloseDate = date.today();
        o.RecordTypeId = '012F0000000y9rkIAA';
        o.Market_Record__c = 'St Louis, MO';
        o.OwnerId = '005A0000000cnyO';
        insert o;
        
        Opportunity DCOpp = [select Id, StageName, Track_Signed__c from Opportunity where Id = :o.Id];
        DCOpp.StageName = 'DC Approved';
        DCOpp.Track_Signed__c = True;
        update DCOpp;
	        
	    Opportunity DCOpp2 = [select Id, StageName, CloseDate, Track_Date_Approved_Signed__c from Opportunity where Id = :o.Id];    
	        
		
	    System.assertEquals('Closed - Appr & Sign', DCOpp2.StageName);
	    System.assertEquals(date.today(), DCOpp2.Track_Date_Approved_Signed__c.date());
	    System.assertEquals(date.today(), DCOpp2.CloseDate);
    	}**/
       
} //class