// Note - when using the start method with QueryLocator, you must define the interface with 
// sObject instead of a specific type
global class batchonLead_transferOwner implements Database.Batchable<sObject>{

	global Database.QueryLocator start(database.batchablecontext BC){
		  
		//Defaults for ages as of 6/18/2014 per conversation with Adam Claypool and Phil Pratt
		Integer minAge = Constants.LEAD_TRANSFER_MIN_AGE;
		Integer maxAge = 365;
		  
		// Get the Custom settings for low and high values 
		OwnershipTransferSettings__c leadMinMaxAge = OwnershipTransferSettings__c.getValues('Lead');
		if (leadMinMaxAge != null)
		{
		  	//Never allow the min age to drop below the defined value! 
		    //Greater than is fine in order to reduce the dataset for older leads
		  	minAge = leadMinMaxAge.MinDaysNoTouch__c < Constants.LEAD_TRANSFER_MIN_AGE
		  				? Constants.LEAD_TRANSFER_MIN_AGE
		  				: (Integer)leadMinMaxAge.MinDaysNoTouch__c;
		  	
		  	maxAge = (Integer)leadMinMaxAge.MaxDaysNoTouch__c;
		  	
		}
		  
		system.debug('min / mage age = ' + minAge + '/' + maxAge);
		
		// Exclude LeadGen Profiles
		ID leadGenSpecialist = ProfileCache.getProfile('Lead Generation Specialists').Id;
		ID leadGenSupervisor = ProfileCache.getProfile('Lead Gen Supervisor').Id;
		
		// Get the QueryLocator for the Query
		// <PWP 6/19/2014> Changed the Owener criteria to force it to be User - otherwise the assignment to Former Owner fails
		Database.QueryLocator ql = Database.getQueryLocator(
									[SELECT id, OwnerId, Status_Explanation__c, Former_Owner__c
									FROM Lead
									WHERE RecordTypeId = :RecordTypeCache.getRecordType('Lead', 'SML_Lead').ID
									AND Owner.Type = 'User'
									AND Owner.ProfileId NOT IN (:leadGenSpecialist, :leadGenSupervisor)
									AND IsConverted = False
									AND Do_Not_Redistribute__c = False
									AND Last_Touch_Age__c >= :minAge
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
					
					if(curLead.Status_Explanation__c == Null || curLead.Status_Explanation__c.Length() == 0){
						curLead.Status_Explanation__c = 'Stale Transfer';
					}
					curLead.Former_Owner__c = curLead.OwnerId;
					curLead.OwnerId = Constants.OPEN_ACQ_LEADS_QUEUE.Id;
					curLead.Stale_Transfer_Date__c = Date.Today();
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