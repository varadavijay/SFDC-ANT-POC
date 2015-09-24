trigger LeadSummaryUpdate on Task (after insert, after update) {

/************ BEGIN WHOLE CLASS COMMENT *************


	
	Set<String> leadSet = new Set<String>();
	Map<Id, Task> master_task_map = new Map<Id, Task>();
	Map<Id, Lead> master_lead_map = new Map<Id, Lead>();
	
	String isBulk = 'False';
	
	for(Task startTask : Trigger.new){
		
		String tempSummary = startTask.Subject;
		
		if(tempSummary.contains('Call Dialer Initiative') && startTask.Ready_To_Archive__c == false){
			if(leadSet.contains(startTask.WhoId) == false){
		  		leadSet.add(startTask.WhoId);
			}
		}
	}
	
	
	if(isBulk == 'False' && leadSet.size() > 0 ){
		//execute future method
		if(!Validator_class.hasAlreadyDone()){
			FutureLeadSummaryUpdate.updateLeadSummary(leadSet);
			Validator_class.setAlreadyDone();
		}
	}
	//comment out DID place here - else{
/*	
	
	//get list of leads from the input task set
	List<Lead> masterLeads = [SELECT ID, Call_Count__c, Connected_Count__c, Max_Call_Duration__c, Total_Talk_Time__c, Last_Call_Date__c, Last_Connected_Call_Date__c FROM Lead Where Id IN :leadSet ];
	
	//find all Call Dialer initiative task for the Lead set
	List<Task> allTasks = [SELECT ID, Subject, CallDurationInSeconds, WhoId, CreatedDate, qbdialer__Call_Date_Time__c FROM Task WHERE WhoId IN:leadSet AND Subject LIKE '%Call Dialer Initiative%'];
	
	System.debug('Number of script statements used so far : ' +  Limits.getDmlStatements());
	
	if(masterLeads.size() > 0){
		
		//found at least one lead
		
		for(Lead tempLead : masterLeads){
			
			//roll through leads
			Integer callCount = 0;
			Integer connectedCount = 0;
			Integer maxDuration = 0;
			Integer totalTime = 0;
			Date lastConnectedDate;
			Date lastCallDate;
			
			if(allTasks.size() > 0){
				//at least one task found
				for(Task tempTasks : allTasks){
					
					//roll through tasks
					
					
					if(tempTasks.WhoId == tempLead.Id){
						
						// task matches current Lead
						
						Date d = Date.newInstance(tempTasks.qbdialer__Call_Date_Time__c.year(),tempTasks.qbdialer__Call_Date_Time__c.month(),tempTasks.qbdialer__Call_Date_Time__c.day());
						
						//if(tempTasks.Subject.contains('Call Dialer Initiative')){
						
							Integer tempDuration = tempTasks.CallDurationInSeconds;
				
							if(tempDuration == null){
					
								tempDuration = 0;
								
								if(lastCallDate == null || d > lastCallDate){
									
									lastcallDate = d;
								}
							}
						
							callCount = callCount + 1;
							totalTime = totalTime + tempDuration;
					
							if(tempDuration > 0){
						
								connectedCount = connectedCount + 1;						
						 
								if(lastCallDate == null || d > lastCallDate){
									
									lastcallDate = d;
								}
								
								if(lastConnectedDate == null || d > lastConnectedDate){
									
									lastConnectedDate = d;
								}
							}
					
							if(tempDuration > maxDuration){
						
								maxDuration = tempDuration;
						
							}
						
						//}
						
					}
				
				}
			}
			
			tempLead.Call_Count__c = callCount;
			tempLead.Connected_Count__c = connectedCount;
			tempLead.Max_Call_Duration__c = maxDuration;
			tempLead.Total_Talk_Time__c = totalTime;
			tempLead.Last_Call_Date__c = lastcalldate;
			tempLead.Last_Connected_Call_Date__c = lastConnectedDate;
			
			
			
			
		}
		
		
	
	
		//update leads
		try{
				Database.SaveResult[] update_lead_result = Database.update(masterLeads, false);
				  	for(Database.SaveResult sr:update_lead_result){
  			 		if(!sr.isSuccess())System.debug('@@@@@@@ '+sr.getErrors()[0]);
				}
				
			}catch (System.DmlException e) {
    			for (Integer i = 0; i < e.getNumDml(); i++) {
        			System.debug('@@@@@@@@@@ Error: '+e.getDmlMessage(i)); 
    			}		
			}//end try catch of update lead
	
		
	}
	

	   
	}
	
 ********** END WHOLE CLASS COMMENT *************/
}