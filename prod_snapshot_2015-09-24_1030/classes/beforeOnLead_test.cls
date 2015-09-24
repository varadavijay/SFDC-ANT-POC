@isTest(SeeallData=true)
public  class beforeOnLead_test {
 static testMethod void testLead(){
     list<user> ulist  =[select id,name,email from user where isactive=true and UserType='Standard' and userrole.name LIKE '%Manager%' limit 1];
     list<lead> insertLeadList = new list<lead>();
     list<lead> insertLeaddataList = new list<lead>();
     for(integer i =0;i<100;i++){
         Lead l = new Lead();
         l.LastName                      = 'Ameda Test'+i;
         l.Company                       = 'test Company' +i;
         l.Status                        = 'Uncontracted-New';
         l.Industry_AffiliatedMarkets__c = 'Education';
         l.Industry_Specific__c          = 'High School';
         l.OwnerId                       = ulist[0].id;
         l.RecordTypeId                  = RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id;
         insertLeadList .add(l);
      }
      insert insertLeadList ;
     
     for(integer i =0;i<50;i++){
         Lead l = new Lead();
         l.LastName                      = 'Ameda Test 2'+i;
         l.Company                       = 'test Company 2'+i;
         l.Status                        = 'Uncontracted-New';
         l.Industry_AffiliatedMarkets__c = 'Education';
         l.Industry_Specific__c          = 'High School';
         l.OwnerId                       = ulist[0].id;
         l.RecordTypeId                  = RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id;
         insertLeaddataList .add(l);
      }
      Test.starttest();
      insert insertLeaddataList ;
      list<lead> leadtestValidate = [select id   from lead where (id in :insertLeaddataList or id In: insertLeadList) ];
      system.assertEquals(leadtestValidate.size(),150);
      test.stopTest();
     
 }
 static testMethod void testBulkLead(){
      string s='%Manager%';
     list<user> ulist  =[select id,name,email from user where isactive=true and UserType='Standard' and userrole.name LIKE '%Manager%' limit 3];
     system.assertEquals(ulist.size(),3);
     list<lead> insertLeadList = new list<lead>();
     for(integer i =0;i<200;i++){
         Lead l = new Lead();
         l.LastName                      = 'Ameda Test'+i;
         l.Company                       = 'test Company' +i;
         l.Status                        = 'Uncontracted-New';
         l.Industry_AffiliatedMarkets__c = 'Education';
         l.Industry_Specific__c          = 'High School';
         l.OwnerId                       = ulist[0].id;
         l.RecordTypeId                  = RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id;
         insertLeadList .add(l);
      }
      for(integer i =0;i<10;i++){
         Lead l = new Lead();
         l.LastName = 'Ameda'+i;
         l.Company = 'testCompany' +i;
         l.Status = 'Uncontracted-New';
         l.Industry_AffiliatedMarkets__c = 'Education';
         l.Industry_Specific__c = 'High School';
         l.OwnerId = ulist[1].id;
         l.RecordTypeId = RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id;
         insertLeadList .add(l);
      }
         insert insertLeadList ;
         list<lead> leadtestValidate1 = [select id  from lead where id in :insertLeadList ];
         //system.assertEquals(leadtestValidate1.size(),210);
          list<lead> updateLeadList = new list<lead>();
          for(integer i=0;i<100;i++){
               Lead l =insertLeadList[i];
               l.ownerid =ulist[1].id;
               updateLeadList.add(l);
          }
          for(integer i=101;i<150;i++){
               Lead l =insertLeadList[i];
               l.ownerid =ulist[2].id;
               updateLeadList.add(l);
          }
         test.starttest();
         update updateLeadList ;
         list<lead> leadtestValidate = [select id  from lead where id in :updateLeadList];
         system.assertEquals(leadtestValidate.size(),149);
         test.stoptest();
   }//End of method testBulkLead
}