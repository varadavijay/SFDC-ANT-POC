@isTest
public with sharing class beforeonOpportunity_test {
 static testMethod void testOpportunity(){
    constants.loaddata();
     list<user> ulist  =[select id,name,userrole.name from user where isactive=true and UserType='Standard' and userrole.name LIKE '%Manager%' limit 1];
     list<Opportunity> insertOppList = new list<Opportunity>();
     list<Opportunity> insertOppdataList = new list<Opportunity>();
      Account a = new Account();
      a.Name = 'Sample Account';
      insert a;
     for(integer i =0;i<10;i++){
         Opportunity opp = new Opportunity();
         opp.Name  = 'Test Opportunity'+i;
         opp.AccountId = a.Id;
         opp.StageName = 'Booked Appointment';
         opp.CloseDate = date.today().addDays(2);
         opp.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
         opp.OwnerId      = ulist[0].id;
         insertOppList .add(opp);
      }
      
     
      
     for(integer i =0;i<10;i++){
         Lead l = new Lead();
         Opportunity opp = new Opportunity();
         opp.Name  = 'Test Opportunity 2'+i;
         opp.AccountId = a.Id;
         opp.StageName = 'Booked Appointment';
         opp.CloseDate = date.today().addDays(2);
         opp.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
         opp.OwnerId      = ulist[0].id;
         insertOppdataList .add(opp);
      }
      Test.starttest();
      insert insertOppList ;
      insert insertOppdataList ;
      list<Opportunity> opptestValidate = [select id   from Opportunity where (id in :insertOppdataList or id In: insertOppList) ];
      system.assertEquals(opptestValidate.size(),20);
      test.stopTest();
     
 }
 static testMethod void testBulkLead(){
     constants.loaddata();
     string s='%Manager%';
     list<user> ulist  =[select id,name,email from user where isactive=true and UserType='Standard' and userrole.name LIKE '%Manager%' limit 3];
     system.assertEquals(ulist.size(),3);
     list<Opportunity> insertOppList = new list<Opportunity>();
     Account a = new Account();
      a.Name = 'Sample Account';
      insert a;
       Id SMLOpportunityRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SML Opportunity').getRecordTypeId();
       Id SMLExtOpportunityRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SML Extension').getRecordTypeId();
           
         for(integer i =0;i<10;i++){
             Opportunity opp = new Opportunity();
             opp.Name  = 'Test Opportunity'+i;
             opp.AccountId = a.Id;
             opp.StageName = 'Booked Appointment';
             opp.CloseDate = date.today().addDays(2);
             opp.RecordTypeId = SMLOpportunityRecTypeId ;
             opp.OwnerId      = ulist[0].id;
             insertOppList .add(opp);

      }
      for(integer i =0;i<10;i++){
         Opportunity opp = new Opportunity();
         opp.Name  = 'Test Opportunity 2'+i;
         opp.AccountId = a.Id;
         opp.StageName = 'Booked Appointment';
         opp.CloseDate = date.today().addDays(2);
         opp.RecordTypeId = SMLOpportunityRecTypeId;
         opp.OwnerId      = ulist[0].id;
         insertOppList .add(opp);

      }
       for(integer i =0;i<10;i++){
         Opportunity opp = new Opportunity();
         opp.Name  = 'Test Opportunity 2'+i;
         opp.AccountId = a.Id;
         opp.StageName = 'Booked Appointment';
         opp.CloseDate = date.today().addDays(2);
         opp.RecordTypeId = SMLExtOpportunityRecTypeId ;
         opp.OwnerId      = ulist[0].id;
         insertOppList .add(opp);

      }
         insert insertOppList ;
         list<Opportunity> opptestValidate1 = [select id  from Opportunity where id in :insertOppList and StageName Not In ('Closed Won', 'Closed Lost' , 'Contract Approved') AND recordtypeId = :SMLOpportunityRecTypeId AND   owner.name Not In ('Stale Opportunity')  ];
        
         list<Opportunity> updateOppList = new list<Opportunity>();
         list<user> userlist  =[select id,name,email from user where isactive=true and UserType='Standard' and userrole.name LIKE '%Manager%' and  id Not IN : ulist and name Not In ('Stale Opportunity') limit 2];

          for(integer i=0;i<10;i++){
               Opportunity opp =insertOppList[i];
               opp.stagename ='Needs Analysis';
               opp.RecordTypeId = SMLOpportunityRecTypeId ;
               if(opp.ownerid !=userlist  [1].id){
                   opp.ownerid =userlist  [1].id;
                   updateOppList.add(opp);
               }
               else{
                  opp.ownerid =userlist  [0].id;
                  updateOppList.add(opp);
               }
               
          }
          for(integer i=10;i<20;i++){
               Opportunity opp =insertOppList[i];
               opp.stagename ='Needs Analysis';
                  opp.RecordTypeId = SMLOpportunityRecTypeId ;
                if(opp.ownerid !=userlist  [1].id){
                   opp.ownerid =userlist  [1].id;
                   updateOppList.add(opp);
               }
               else{
                  opp.ownerid =userlist  [0].id;
                  updateOppList.add(opp);
               }
               
          }
          for(integer i=20;i<30;i++){
               Opportunity opp =insertOppList[i];
               opp.stagename ='Needs Analysis';
               opp.RecordTypeId = SMLOpportunityRecTypeId ;
                
                   updateOppList.add(opp);
              
               
         }
         test.starttest();
         update updateOppList ;
         list<Opportunity> OpptestValidate = [select id  from Opportunity where id in :updateOppList];
        // system.assertEquals(OpptestValidate.size(),149);
         test.stoptest();
   }//End of method testBulkLead
}