// Note - when using the start method with QueryLocator, you must define the interface with 
// sObject instead of a specific type
global with sharing class batchFixLeadGenOwnershipXfer implements Database.Batchable<sObject>{

	global Database.QueryLocator start(database.batchablecontext BC){
		  
		//Since Last touch was reset and I was doing these over the course of 2 days, it will only be 0 or 1 
		Integer maxAge = 1;
		
		// Include only LeadGen Profiles for the fix
		ID leadGenSpecialist = ProfileCache.getProfile('Lead Generation Specialists').Id;
		ID leadGenSupervisor = ProfileCache.getProfile('Lead Gen Supervisor').Id;
		
		// Get the QueryLocator for the Query
		// <PWP 6/19/2014> Changed the Owener criteria to force it to be User - otherwise the assignment to Former Owner fails
		Database.QueryLocator ql = Database.getQueryLocator(
									[SELECT id, OwnerId, Status_Explanation__c, Former_Owner__c
									FROM Lead
									WHERE RecordTypeId = :RecordTypeCache.getRecordType('Lead', 'SML_Lead').ID
									AND OwnerId = :Constants.OPEN_ACQ_LEADS_QUEUE.Id
									AND Former_Owner__r.ProfileId IN (:leadGenSpecialist, :leadGenSupervisor)
									AND IsConverted = False
									AND Do_Not_Redistribute__c = False
									AND Last_Touch_Age__c <= :maxAge]);
	
		if(ql == null)
		{
			system.debug('QueryLocator was null');
		}
		else
		{
			system.debug('Query used:' + ql.getQuery());
		}
		return ql;
	}

	global void execute(Database.BatchableContext BC, List<Lead> scope){
		// <refactor> place this logic in a service class 
		// <refactor> no error handling 
		try
		{
			List<Lead> leadsToUpdate = new List<Lead>();
				for(Lead curLead : scope){
					
					if(curLead.Status_Explanation__c == 'Stale Transfer'){
						curLead.Status_Explanation__c = 'Lead Gen Transfer corrected';
					}
					curLead.OwnerId = curLead.Former_Owner__c;
					leadsToUpdate.add(curLead);
				} 
				update leadsToUpdate;
		}
		catch(DmlException dmlEx)
		{
			System.debug('DML Exception thrown: ' + dmlEx.getMessage());
		}
		catch(Exception ex)
		{
			System.debug('Exception thrown: ' + ex.getMessage());
		}
	}	
	
	
	global void finish(Database.BatchableContext info){}		

} //class