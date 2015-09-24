/*******************************************
 * This class manages the Scheduled Apex Jobs. It consists of two methods, one to stop jobs and one to start them.
 * These 2 methods will need to be maintained as scheduled jobs are added, removed or modified.
 * 
 * Please comment the intended schedule above the cron string used. This will aid in code reviews, as well as
 * be more convenient for other developers to quickly understand the intent without looking up the cron strings
 *
 * For reference on the cron string or scheduling jobs in general, see:
 * http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
 *
 *********************************************/

public with sharing class ApexJobManager {

	//Change this when you add or remove a job to these methods - used in test method:
	public static Integer managedJobCount {
		get { return 4; }
	}
	
	// uncomment when all schedulers have been updated with schedule() methods 
	public static void scheduleJobs(){
		schedBatch_contactupdatekpi_cls.schedule();
		schedBatch_yipitupdatemarket.schedule();
		sched_SLA_Perf_Process_cls.schedule();
		Sched_UpdateFiscalPeriod.schedule();
	}
	
	// uncomment when all schedulers have been updated with abort() methods 
	public static void abortJobs(){
		schedBatch_contactupdatekpi_cls.abort();
		schedBatch_yipitupdatemarket.abort();
		sched_SLA_Perf_Process_cls.abort();
		Sched_UpdateFiscalPeriod.abort();
	}
	
	// Get a run-once Cron String given a datetime
	public static String dateTimeToCronString(DateTime dateTimeToConvert){
		
		List<String> formatParams = new List<String>();
		formatParams.add(String.valueOf(dateTimeToConvert.second()));
		formatParams.add(String.valueOf(dateTimeToConvert.minute()));
		formatParams.add(String.valueOf(dateTimeToConvert.hour()));
		formatParams.add(String.valueOf(dateTimeToConvert.day()));
		formatParams.add(String.valueOf(dateTimeToConvert.month()));
		formatParams.add(String.valueOf(dateTimeToConvert.year()));
		
		String cronNow = String.format('{0} {1} {2} {3} {4} ? {5}',	formatParams);
		return cronNow;
		
	}
	
	// Abort a job based on name
	public static void abort(String jobName){
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
	}
	

	// Keep around for reference, but rename to scheduleJobsOldWay(). This method doesn't require the scheduled jobs to be modified to add the shedule() and abort() methods
	public static void scheduleJobsOldWay(){
		String cronString = '';
		String scheduledJobName = '';
		String jobId = '';
		
		// Schedulable class:	schedBatch_contactupdatekpi_cls
		// Schedule:			Daily at 2:49 PM
		cronString = '0 49 14 * * ?';
		scheduledJobName = 'LaunchContactUpdate';
		try{
			jobId = system.schedule(scheduledJobName, cronString, new schedBatch_contactupdatekpi_cls());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + scheduledJobName + ' Message = ' + ex.getMessage());
		}
		
		
		// Schedulable class:	schedBatch_yipitupdatemarket
		// Schedule:			Daily at 4:45 PM
		cronString = '0 45 16 * * ?';
		scheduledJobName = 'LaunchYipitMarketUpdate';
		try{
			jobId = system.schedule(scheduledJobName, cronString, new schedBatch_yipitupdatemarket());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + scheduledJobName + ' Message = ' + ex.getMessage());
		}
	
	} // scheduleJobs()
	
	// Keep around for reference. This method doesn't require the scheduled jobs to be modified to add the shedule() and abort() methods
	public static void abortJobsOldWay(){
		List<CronTrigger> cronTriggers = [Select State, Id, CronJobDetail.JobType, CronJobDetail.Name, CronExpression
										  From CronTrigger
										  where CronJobDetail.JobType = '7'];
		
		// system.abortJob() just takes the CronTrigger ID, but what we know is the name,
		// so set up a map with all Apex Jobs with the name as the key
		
		Map<String, ID> apexJobs = new Map<String, ID>();
		for (CronTrigger job : cronTriggers){
			apexJobs.Put(job.CronJobDetail.Name, job.Id);
		}
		
		// One might be tempted to just stop all Apex Jobs here, but that is dangerous in this context, because this class
		// Should only know about those jobs which scheduleJobs() has created. If someone has manually created a job,
		// Then we don't want to abort it here. It's better that the depoloyment fails and they are directed to this class 
		// to add it to both methods
		
		// Add the abort calls below - seperate try blocks are used, because the most common exception is
		// when the job doesn't exist - in which case, good, but lets keep going to delete the rest, rather than 
		// stop there.
		ID cronTriggerId;
		String jobName;
		
		try{
			jobName = 'LaunchContactUpdate';
			cronTriggerId = apexJobs.get(jobName);
			if(cronTriggerId != null){
				system.abortJob(cronTriggerId);
			}
			else{
				system.debug('Job: ' + jobName + ' doesn\'t exist');
			}
		}
		catch (Exception ex){
			system.debug('Exception trying to abort Job: ' + jobName + ' Message = ' + ex.getMessage());
		}
		
		try{
			jobName = 'LaunchYipitMarketUpdate';
			cronTriggerId = apexJobs.get(jobName);
			if(cronTriggerId != null){
				system.abortJob(cronTriggerId);
			}
			else{
				system.debug('Job: ' + jobName + ' doesn\'t exist');
			}
		}
		catch (Exception ex){
			system.debug('Exception trying to abort Job: ' + jobName + ' Message = ' + ex.getMessage());
		}
	} // abortJobs()

}