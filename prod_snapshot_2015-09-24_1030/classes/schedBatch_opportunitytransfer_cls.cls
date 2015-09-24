// This class schedules the Batch job: batchonOpportunity_transferOwner
// It includes schedule() and abort() methods used by the ApexJobManager class to
// stop and start all jobs which are managed by that class

global class schedBatch_opportunitytransfer_cls implements Schedulable{
	public static String jobName {
		get{ return 'LaunchOppTransfer'; }
	}
	
	// For Cron string reference: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
	public static String cronString {
		// Schedule: Daily at 1:00 AM
		get{ return '0 0  1  * * ?'; }
	}
	
	public static void schedule(){
		try{
			system.schedule(jobName, cronString, new schedBatch_opportunitytransfer_cls());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + jobName + ' Message = ' + ex.getMessage());
		}

	} //schedule()
	
	public static void abort(){
		try{
			List<CronTrigger> cronTriggers = [Select State, Id, CronJobDetail.JobType, CronJobDetail.Name, CronExpression
											  From CronTrigger
											  where CronJobDetail.JobType = '7'
											  and CronJobDetail.Name = :jobName];
	
			if(cronTriggers.size() == 1){
				system.abortJob(cronTriggers[0].Id);
			}
			else{
				system.debug('Job: ' + jobName + ' returned ' + cronTriggers.size() + ' results. There should have been exactly 1');
			}
		}
		catch (Exception ex){
			system.debug('Exception trying to abort Job: ' + jobName + ' Message = ' + ex.getMessage());
		}
	} //abort()
	
	// Schedulable interface
	global void execute(SchedulableContext SC){
		batchonOpportunity_transferOwner batchapex = new batchonOpportunity_transferOwner();
		
		// The scope parameter should be left out, so that the batch size defaults to 200,
		// however this isn't possible until the Opportunity Trigger has been refactored
		id batchprocessid = Database.executebatch(batchapex, 30);
		system.debug('Process ID: ' + batchprocessid);
	}
}