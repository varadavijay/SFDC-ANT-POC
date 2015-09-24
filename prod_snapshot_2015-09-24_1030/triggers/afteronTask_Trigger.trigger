trigger afteronTask_Trigger on Task (after delete, after insert, after undelete, after update) {
/************ BEGIN WHOLE CLASS COMMENT *************


//this handles two things.
//it markes leads according to the creation of a 30 second comercial
//it adds follow up tasks for the account managers
	if(Trigger.isInsert || Trigger.isUpdate){
		Set<String> leadSet = new Set<String>();
		Map<String, String> map1 = new Map<String, String>();
		String ThisTaskRT = '';
		Integer x = 0;
		String LeadOfTask = Trigger.new[x].WhoId;
		for(Task startTask : Trigger.new){
			
			if((Trigger.new[x].RecordTypeId == '012K00000004Hbl') || (Trigger.new[x].RecordTypeId == null) || (Trigger.new[x].RecordTypeId == '012F0000000y9On') || (Trigger.new[x].RecordTypeId == '012F0000000y9OnIAI')){
				ThisTaskRT = 'NotFollupUp';
				String tempSummary = startTask.Subject;
				if((leadSet.contains(startTask.WhoId) == false)  && ((startTask.Subject.contains('30 sec') || startTask.Subject.contains('30 Sec')))){
				  	//leadSet.add(startTask.WhoId);
					map1.put(startTask.WhoId, startTask.OwnerId);
				}
				leadSet = map1.keySet();
			}
			if(Trigger.isUpdate && (Trigger.new[x].RecordTypeId == '012K00000004Hbq' || Trigger.new[x].RecordTypeId == '012F0000000y9Os')){
			String UseRT = '';	
				if(Trigger.new[x].RecordTypeId == '012K00000004Hbq'){
					UseRT = '012K00000004Hbq';
				}
				else{UseRT = '012F0000000y9Os';}
					
				String amNew = Trigger.new[x].Status;
				String amOld = Trigger.old[x].Status;
				String companyId = Trigger.new[x].WhatId;
				Account[] companyrec = [select Id, Name from account where Id = : companyId];
				String companyName;
				if(companyrec.size() != 0){
					companyName = 'FollowUp Call - ' + companyrec[0].Name;
				}
				else
				{
					companyName = 'FollowUp Call - ';
				}
			
				if(amNew == 'Completed' && amOld != 'Completed'){
					
					String currPerson = UserInfo.getUserId();
					User currUserRecord = [SELECT Id, AM_Follow_Up_Tasks__c from User WHERE Id = : currPerson];
					String currAMFU = currUserRecord.AM_Follow_Up_Tasks__c;
					if(currAMFU != 'No'){
						Task fuTask = new Task(OwnerId = currPerson, Subject = companyName, RecordTypeId = UseRT, ActivityDate = Date.today() + 14, Status = 'Not Started', ReminderDateTime = Datetime.now() + 13.95, IsReminderSet = True, WhatId = companyId);
						insert fuTask;
					}
				}
			}

		x = x + 1;	
		}
		if(ThisTaskRT == 'NotFollowUp'){
			List<Lead> masterLeads = [SELECT ID, Has_30_Second__c, Last_Created_Activity_Date__c, Last_Act_Owner__c FROM Lead Where Id = : LeadOfTask];//IN :LeadSet ];
			
			for(Lead tempLead : masterLeads){
				tempLead.Has_30_Second__c = True;
				tempLead.Last_Created_Activity_Date__c = Datetime.now();
				tempLead.Last_Act_Owner__c = map1.get(tempLead.Id);//UserInfo.getUserId();
			}
			
			update masterLeads;
		}
	}
 ********** END WHOLE CLASS COMMENT *************/
}