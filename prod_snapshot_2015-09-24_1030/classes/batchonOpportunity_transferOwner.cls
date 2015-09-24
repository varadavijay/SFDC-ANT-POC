// Note - when using the start method with QueryLocator, you must define the interface with 
// sObject instead of a specific type
global class batchonOpportunity_transferOwner implements Database.Batchable<sObject>{

	global Database.QueryLocator start(database.batchablecontext BC){
		//Defaults for ages as of 6/18/2014 per conversation with Adam Claypool and Phil Pratt
		Integer minAge = Constants.OPPORTUNITY_TRANSFER_MIN_AGE;
		Integer maxAge = 365;
		  
		// Get the Custom settings for low and high values 
		OwnershipTransferSettings__c opptyMinMaxAge = OwnershipTransferSettings__c.getValues('Opportunity');
		if (opptyMinMaxAge != null)
		{
		  	//Never allow the min age to drop below the defined value! 
		    //Greater than is fine in order to reduce the dataset for older leads
		  	minAge = opptyMinMaxAge.MinDaysNoTouch__c < Constants.OPPORTUNITY_TRANSFER_MIN_AGE
		  				? Constants.OPPORTUNITY_TRANSFER_MIN_AGE
		  				: (Integer)opptyMinMaxAge.MinDaysNoTouch__c;
		  	
		  	maxAge = (Integer)opptyMinMaxAge.MaxDaysNoTouch__c;
		  	
		}
		  
		system.debug('min / mage age = ' + minAge + '/' + maxAge);

		// Exclude LeadGen Profiles
		ID leadGenSpecialist = ProfileCache.getProfile('Lead Generation Specialists').Id;
		ID leadGenSupervisor = ProfileCache.getProfile('Lead Gen Supervisor').Id;
		
		// Get the QueryLocator for the Query
		Database.QueryLocator ql = Database.getQueryLocator(
								[SELECT Id, OwnerId, Owner.Name, Cancel_Reason__c, Previous_Owner__c
								 FROM Opportunity
								 WHERE RecordTypeId != :RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id
								 AND OwnerId != :Constants.STALE_OPPORTUNITY.Id
								 AND Owner.ProfileId NOT IN (:leadGenSpecialist, :leadGenSupervisor)
								 AND IsClosed = False
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

	global void execute(Database.BatchableContext BC, List<Opportunity> scope){
		// <refactor> place this logic in a service class 
		// <refactor> no error handling 
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		for(Opportunity oppty : scope){
			if((oppty.Cancel_Reason__c == Null || oppty.Cancel_Reason__c.Length() == 0)){
				oppty.Cancel_Reason__c = 'Stale Transfer';
			}
			
			oppty.Stale_Transfer__c = Datetime.Now();
			oppty.Previous_Owner__c = oppty.Owner.Name;
			oppty.OwnerId = Constants.STALE_OPPORTUNITY.Id;
			oppsToUpdate.add(oppty);
		} 
		update oppsToUpdate;
	}	
	
	global void finish(Database.BatchableContext info){}
}