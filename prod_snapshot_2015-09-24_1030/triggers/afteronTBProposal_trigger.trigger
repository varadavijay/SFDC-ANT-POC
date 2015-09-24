trigger afteronTBProposal_trigger on tinderbox__Proposal__c (after delete, after insert, after undelete, after update) {
    if (Trigger.isUpdate){
    for (tinderbox__Proposal__c propose : Trigger.new){
        if (Trigger.isUpdate){
            String dOldStatus = System.Trigger.oldMap.get(propose.Id).tinderbox__Status__c;
            if(dOldStatus != 'Accepted' && propose.tinderbox__Status__c == 'Accepted'){
                
                //get the previous status on the proposal
                String OppOwnerId = propose.Opp_Owner_Id__c;//propose.tinderbox__Opportunity__r.OwnerId;//'005A0000000cnyO';//
                String OppOwnerRole = propose.Opp_Owner_Role__c;//'Executive Director';//
                String OppOnAgree = propose.tinderbox__Opportunity__c;
                String OppRecType = propose.Opp_RecordType_Id__c;//'012F0000000y9rkIAA';//
                Datetime themoment = datetime.now();
                Date DateOf = date.today();
                
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
                if(DCSignCnt < 1){
                   
                    //KPI Reference
                    String currKPIRec = '';
                    
                    //Id TestId = OppOwnerId.substring(0,14);
                    String CurrUser = Userinfo.getUserId();
                    
                    List<KPIRep__c> currKPIRepList = new List<KPIRep__c>();
                    currKPIRepList = [SELECT Id FROM KPIRep__c WHERE UserId__c = :OppOwnerId];//:CurrUser];//:OppOwnerId];//:OppOwnerId limit 1];//'005F0000001ybyTIAQ'];//
                    
                    for(KPIRep__c tempcurrKPIRepList : currKPIRepList){
                        currKPIRec = tempcurrKPIRepList.Id;
                        if(currKPIRec == Null || currKPIRec == ''){
                        	currKPIRec = Constants.GANNETT_LOCAL_KPI_REP.Id;
                        }
                    }

                    //CalendarReference
                    String currCalRec;
                    List<KPICalender__c> currKPIRecordList = [SELECT Id, Date__c FROM KPICalender__c WHERE IsToday__c = 'Yes' limit 1];
                    for(KPICalender__c tempcurrKPIRecordList : currKPIRecordList){
                        currCalRec = tempcurrKPIRecordList.Id;
                        if(currCalRec == Null || currCalRec == ''){
                        	currCalRec = Constants.KPI_CAL_20130605.Id;
                        }
                    }

                    //Get Opp Record for further updates on either sent or signed events
                    OppToUpdate =[SELECT Id, Track_Signed__c, Track_Approved__c, StageName, RecordTypeId FROM Opportunity WHERE Id =:OppOnAgree];
                    
                    Opp_Tracking_Report__c NewTR = new Opp_Tracking_Report__c();
                    NewTR.Opportunity__c = OppOnAgree;
                    NewTR.Event__c = 'Signed';
                    NewTR.Time_Stamp__c = themoment;
                    NewTR.Action_Owner__c = OppOwnerId;
                    NewTR.Action_Owner_Role__c = OppOwnerRole;
                    NewTR.KPI_Rep__c = currKPIRec;
                    NewTR.GL_Calender__c = currCalRec;

                    NewTRList.add(NewTR);
                    for(Opportunity tempOTU : OppToUpdate){
                        if(OppRecType=='012F0000000y9rkIAA'){tempOTU.StageName='DC Signed';}
                        if(OppRecType=='012F0000000yErGIAU'){tempOTU.StageName='SG Signed';}
                        if(OppRecType=='012A0000000PKOIIA4'){tempOTU.StageName='Closed Won';}
                    }
                        //check DC Opp checkboxes For further updates if needed and set Track Signed to True
                        //
                    for(Opportunity tempOTU : OppToUpdate){
                        tempOTU.Track_Signed__c = True;
                        if(tempOTU.Track_Approved__c == True && (tempOTU.RecordTypeId == '012F0000000y9rkIAA' || tempOTU.RecordTypeId == '012F0000000yErGIAU'))
                        {
                            if(tempOTU.RecordTypeId == '012F0000000y9rkIAA'){tempOTU.StageName = 'Closed - Appr & Sign';}
                            else{tempOTU.StageName = 'SG Approved & Signed';}
                            if(DCAanSCnt < 1){
                                Opp_Tracking_Report__c NewTR2 = new Opp_Tracking_Report__c(
                                Opportunity__c = OppOnAgree,
                                Event__c = 'Approved & Signed',
                                Time_Stamp__c = themoment,
                                Action_Owner__c = OppOwnerId,
                                Action_Owner_Role__c = OppOwnerRole,
                                KPI_Rep__c = currKPIRec,
                                GL_Calender__c = currCalRec//'a1GF0000000JJya'//
                                );
                                NewTRList.add(NewTR2);
                            }
                        }
                        else if(tempOTU.Track_Approved__c == False && (tempOTU.RecordTypeId == '012F0000000y9rkIAA' || tempOTU.RecordTypeId == '012F0000000yErGIAU'))
                        {
                            if(tempOTU.RecordTypeId == '012F0000000y9rkIAA'){tempOTU.StageName = 'DC Signed';}
                            else{tempOTU.StageName = 'SG Signed';}
                        }
                        else {}
                    } // for(Opportunity tempOTU : OppToUpdate) 
                } // if(DCSignCnt < 1)
            update OppToUpdate;
            insert NewTRList;
            }
        } // inner if IsUpdate
    } // For each proposal in trigger.New
    } // outer if IsUpdate
}