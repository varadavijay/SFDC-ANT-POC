// A description of the purpose of this class 

global class schedBatch_yipitupdatemarket implements Schedulable{
	public static String jobName {
		get{ return 'LaunchYipitMarketUpdate'; }
	}
	
	// For Cron string reference: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
	public static String cronString {
		// Schedule: Daily at 4:45 PM
		get{ return '0 45 16 * * ?'; }
	}
	
	public static void schedule(){
		try{
			system.schedule(jobName, cronString, new schedBatch_yipitupdatemarket());
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
		batchonYipit_updateMarket batchapex = new batchonYipit_updateMarket();
		id batchprocessid = Database.executebatch(batchapex);
		system.debug('Process ID: ' + batchprocessid);
	}
}