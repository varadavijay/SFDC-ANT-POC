//Class Entirely commented out. will it ever be needed?


public class FutureLeadSummaryUpdate {
	// <comment>
	// <deletefile>
	// <CC> the only calling code is LeadSummaryUpdate.trigger which is also entire commented out. 
	//  no *active* calls to this commented out code 
	//  appears to update lead call log information </CC>
	/******** BEGIN FULL CLASS COMMENT *************************
	//if(!Validator_class.hasAlreadyDone()){
	public FutureLeadSummaryUpdate(){
  	
  	}
	
	// <refactor> Set<Id> LeadIds ? 
	// <refactor> use helper methods to break large methods into more managable and testable blocks of code
	
  	@future public static void updateLeadSummary(Set<String> LeadIds){

  	//Validator_class.setAlreadyDone();
  
    //get list of leads from the input task set
    // <string>
    List<Lead> masterLeads = [SELECT ID, Call_Count__c, Connected_Count__c, Max_Call_Duration__c, Total_Talk_Time__c, Last_Call_Date__c, Last_Connected_Call_Date__c, Has_30_Second__c, Has_First_Appoint__c FROM Lead Where Id IN :LeadIds ];
  
    //find all Call Dialer initiative task for the Lead set
    // <string>
    //List<Task> allTasks = [SELECT ID, Subject, CallDurationInSeconds, WhoId, CreatedDate, qbdialer__Call_Date_Time__c FROM Task WHERE WhoId IN:LeadIds AND Subject LIKE '%Call Dialer Initiative%' AND Ready_To_Archive__c = false ORDER BY qbdialer__Call_Date_Time__c ASC];
    // <string>
    List<Task> allTasks = [SELECT ID, Subject, CallDurationInSeconds, WhoId, CreatedDate, qbdialer__Call_Date_Time__c FROM Task WHERE WhoId IN:LeadIds AND Ready_To_Archive__c = false ORDER BY qbdialer__Call_Date_Time__c ASC];
    System.debug('Number of script statements used so far : ' +  Limits.getDmlStatements());
  
    if(masterLeads.size() > 0){
    
      //found at least one lead
    
      for(Lead tempLead : masterLeads){
      
        //roll through leads
        Double callCount = 0;
        Double connectedCount = 0;
        Double maxDuration = 0;
        Double totalTime = 0;
        Date lastConnectedDate;
        Date lastCallDate;
        
        //start new task update code
        
        
        if(tempLead.Call_Count__c != null){
          callCount = tempLead.Call_Count__c;
        }
        
        if(tempLead.Connected_Count__c != null){
          connectedCount = tempLead.Connected_Count__c;
        }
        
        if(tempLead.Max_Call_Duration__c != null){
          maxDuration = tempLead.Max_Call_Duration__c;
        }
        
        if(tempLead.Total_Talk_Time__c != null){
          totalTime = tempLead.Total_Talk_Time__c;
        }
        
        if(tempLead.Last_Connected_Call_Date__c != null){
          lastConnectedDate = tempLead.Last_Connected_Call_Date__c;
        }
        
        if(tempLead.Last_Call_Date__c != null){
          lastCallDate = tempLead.Last_Call_Date__c;
        }
        //End task update code
        
        Boolean HasThirty;
        Boolean HasFirst;
        
        if(allTasks.size() > 0){
          //at least one task found
          for(Task tempTasks : allTasks){
          
            //roll through tasks
          
          
            if(tempTasks.WhoId == tempLead.Id){
            
              // task matches current Lead
              
              if(tempTasks.Subject.contains('30 second')){
                HasThirty = True;
              }
              if(tempTasks.Subject.startswith('FA')){
                HasFirst = True;
              }
            
              Date d = Date.newInstance(tempTasks.CreatedDate.year(),tempTasks.CreatedDate.month(),tempTasks.CreatedDate.day());
              
              if(tempTasks.qbdialer__Call_Date_Time__c != null){
                 d = Date.newInstance(tempTasks.qbdialer__Call_Date_Time__c.year(),tempTasks.qbdialer__Call_Date_Time__c.month(),tempTasks.qbdialer__Call_Date_Time__c.day());
              }
              
              //if(tempTasks.Subject.contains('Call Dialer Initiative')){
            
                Integer tempDuration = tempTasks.CallDurationInSeconds;
          
                if(tempDuration == null || tempDuration == 0){
          
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
            
                tempTasks.Ready_To_Archive__c = true;
            
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
        tempLead.Has_30_Second__c = HasThirty;
        tempLead.Has_First_Appoint__c = HasFirst;      
      
      
      
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
        
      //update tasks
      try{
          Database.SaveResult[] update_task_result = Database.update(allTasks, false);
              for(Database.SaveResult sr:update_task_result){
               if(!sr.isSuccess())System.debug('@@@@@@@ '+sr.getErrors()[0]);
          }
        
        }catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug('@@@@@@@@@@ Error: '+e.getDmlMessage(i)); 
            }    
        }//end try catch of update task
    
    
    }









  		}
	//}
	
	******** END FULL CLASS COMMENT ************/
}