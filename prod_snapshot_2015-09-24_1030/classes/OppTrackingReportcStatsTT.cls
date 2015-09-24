@isTest
private class OppTrackingReportcStatsTT {
   // <refactor> appears to be a flow test
   static testMethod void testTrigger() {
      try {
          Opp_Tracking_Report__c o = new Opp_Tracking_Report__c();
          insert o;
		  // <logic> this will never be false, assert expected behavior from trigger  
          System.assertNotEquals(null, o);
      }
      catch(Exception e) { // <logic> trying to catch INSERT DML exceptions, (catch DMLException e) 
          List<Opp_Tracking_Report__c> l = [SELECT Id from Opp_Tracking_Report__c LIMIT 1];
          update l;
          // <logic> this will never be false, assert expected behavior from trigger  
          // <refactor> needs an errror message to describe the problem 
          System.assertNotEquals(null, l);
      }
   }
}