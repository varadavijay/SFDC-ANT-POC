trigger beforeonTask_Trigger on Task (before delete, before insert, before update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        for(integer x = 0; x < Trigger.new.size(); x++)
        {
            if(Trigger.new[x].Description != Null)
            {
                Integer StrLen = Trigger.new[x].Description.length();
                if (StrLen <= 255){StrLen = StrLen;}
                else{StrLen = 255;}
                Trigger.new[x].Blog__c = Trigger.new[x].Description.substring(0, StrLen);
            }
            if(Trigger.new[x].Call_Completed__c != Null)
            {
                Trigger.new[x].Subject = 'Call Completed - ' + Trigger.new[x].Call_Completed__c;
            }
            if(Trigger.new[x].Is_Contract_Send__c == 'Yes'){
                //
                String OppOwnerId = Trigger.new[x].OwnerId;
                system.debug('OwnerId = ' + OppOwnerId + ': Subject = ' + Trigger.new[x].Subject + '::');
                String OppOwnerRole = Trigger.new[x].Owner.UserRole.Name;
                String OppOnAgree = Trigger.new[x].WhatId;
                String OppRecType;
                datetime themoment = datetime.now();
                date DateOf = date.today();
                //Create Tracking Record List To Add When Done
                List<Opp_Tracking_Report__c> NewTRList = new List<Opp_Tracking_Report__c>();
                List<Opportunity> OppToUpdate = new List<Opportunity>();
                //setup count variables for tracking
                Integer DCCreateCnt=0;Integer DCSentCnt=0;Integer DCSignCnt=0;Integer DCSubmCnt=0;Integer DCApprCnt=0;Integer DCAanSCnt=0;Integer WonCnt=0;
                List<Opp_Tracking_Report__c> TrackingList = new List<Opp_Tracking_Report__c>();
                //compile counts of tracking records per event for further additions if parent Opp or contract signed event is checked
                TrackingList = [SELECT Id, Event__c FROM Opp_Tracking_Report__c WHERE Opportunity__c = : OppOnAgree];
                for(Opp_Tracking_Report__c tempTR : TrackingList){
                    if(tempTR.Event__c == 'Created'){DCCreateCnt = DCCreateCnt + 1;}
                    if(tempTR.Event__c == 'Sent'){DCSentCnt = DCSentCnt + 1;}
                    if(tempTR.Event__c == 'Signed'){DCSignCnt = DCSignCnt + 1;}
                    if(tempTR.Event__c == 'Submitted'){DCSubmCnt = DCSubmCnt + 1;}
                    if(tempTR.Event__c == 'Approved'){DCApprCnt = DCApprCnt + 1;}
                    if(tempTR.Event__c == 'Approved & Signed'){DCAanSCnt = DCAanSCnt + 1;}
                    if(tempTR.Event__c == 'Won'){WonCnt = WonCnt + 1;}
                }
                //add Sent TR to List (any record type)
                if(DCSentCnt < 1){
                    
                    //KPI Reference
                    String currKPIRec = '';
                    List<KPIRep__c> currKPIRepList = [SELECT Id from KPIRep__c WHERE User__c = : OppOwnerId limit 1];
                    for(KPIRep__c tempcurrKPIRepList : currKPIRepList){
                        currKPIRec = tempcurrKPIRepList.Id;
                    }
                    //
                    //CalenderReference
                    String currCalRec = '';
                    List<KPICalender__c> currKPIRecordList = [SELECT Id from KPICalender__c WHERE Date__c = : DateOf limit 1];
                    for(KPICalender__c tempcurrKPIRecordList : currKPIRecordList){
                        currCalRec = tempcurrKPIRecordList.Id;
                    }
                    //Get Opp Record for further updates on either sent or signed events
                    OppToUpdate = [SELECT Id, Track_Signed__c, Track_Approved__c, StageName, RecordTypeId, OwnerId FROM Opportunity WHERE Id =:OppOnAgree];
                    for(Opportunity tempOppToUpdate : OppToUpdate){
                        OppRecType = tempOppToUpdate.RecordTypeId;
                    }
                
                    system.debug('::currKPIRec = ' + currKPIRec + ': currCalRec = ' + currCalRec + ': OppRecType = ' + OppRecType + '::');
                    Opp_Tracking_Report__c NewTR = new Opp_Tracking_Report__c(
                    Opportunity__c = OppOnAgree,
                    Event__c = 'Sent',
                    Time_Stamp__c = themoment,
                    Action_Owner__c = OppOwnerId,
                    Action_Owner_Role__c = OppOwnerRole,
                    KPI_Rep__c = currKPIRec,
                    GL_Calender__c = currCalRec
                    );
                    NewTRList.add(NewTR);
                    for(Opportunity tempOTU : OppToUpdate){
                        if(OppRecType=='012F0000000y9rkIAA'){tempOTU.StageName='DC Out For Sign';}
                        if(OppRecType=='012A0000000PKOIIA4'){tempOTU.StageName='Contract Sent to Customer';}
                        if(OppRecType=='012F0000000yErGIAU'){tempOTU.StageName='SG Sent';}
                    }   
                }
            update OppToUpdate;
            insert NewTRList;
            }
        }
    }
    if(Trigger.isDelete){
        for (Task TA : Trigger.old){
            String pid = UserInfo.GetProfileId();
            String uid = UserInfo.GetUserId();
            String rid = TA.Owner.UserRoleId;
            if(pid != '00eA0000000YSjsIAG' && TA.OwnerId != uid && rid == '00EF0000000VKpX' && TA.IsClosed == True){
                TA.addError('You cannot delete a task you do not own.');
            }
            else{}
        }
    }
    /**if(Trigger.isInsert)
    {
        for(integer y = 0; y < Trigger.new.size(); y++)
        {
            if(Trigger.new[y].WhoId != Null)
            {
                String ParentOfTask = Trigger.new[y].WhoId;
                Integer IsLeadParent = [SELECT count() from Lead WHERE Id = :ParentOfTask];
                if(IsLeadParent > 0)
                {
                    Lead[] LeadsToUpdate = [SELECT id, Last_Activity_Datetime__c FROM Lead WHERE Id = :ParentOfTask];
                    LeadsToUpdate[0].Last_Activity_Datetime__c = Datetime.Now();
                    update LeadsToUpdate;
                }
            }
        }
    }**/
}