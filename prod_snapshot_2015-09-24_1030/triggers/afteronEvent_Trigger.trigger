trigger afteronEvent_Trigger on Event (after delete, after insert, after undelete, after update) {
	
	
	
	if(Trigger.isInsert || Trigger.isUpdate){
		
		Set<String> leadSet = new Set<String>();
		Map<Id, Event> master_event_map = new Map<Id, Event>();
		Map<Id, Lead> master_lead_map = new Map<Id, Lead>();
		
		for(Event startEvent : Trigger.new){
			
			String tempSummary = startEvent.Subject;
			
			if((leadSet.contains(startEvent.WhoId) == false)  && ((startEvent.Subject.startswith('FA') || startEvent.Subject.startswith('fa')))){
			  		leadSet.add(startEvent.WhoId);
			}
		}
		
		List<Lead> masterLeads = [SELECT ID, Has_First_Appoint__c, Last_Created_Activity_Date__c, Last_Act_Owner__c
								  FROM Lead
								  Where Id IN :LeadSet ];
		
		for(Lead tempLead : masterLeads){
			tempLead.Has_First_Appoint__c = True;
			tempLead.Last_Created_Activity_Date__c = Datetime.now();
			tempLead.Last_Act_Owner__c = UserInfo.getUserId();
		}
		
		update masterLeads;
	
	
	}
}