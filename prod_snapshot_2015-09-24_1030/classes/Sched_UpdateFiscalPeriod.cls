public with sharing class Sched_UpdateFiscalPeriod implements Schedulable {
	
	// Must not conflict with any other Job Names
	public static final String jobName = 'Update KPICalender Fiscal Period';

	// For Cron string reference: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
	// 12:15am every Monday
	public static final String cronString = '0 15 0 ? * MON *';

	// When testing it is useful to be able to schedule the job immediately. It's name should noty conflict with the
	// regular name, but it should be easy to tie it back to the regular job		
	public static final String jobNameNow = jobName + ' - Now';
	
	public static void schedule(){
		try{
			system.schedule(jobName, cronString, new Sched_UpdateFiscalPeriod());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + jobName + ' Message = ' + ex.getMessage());
		}

	}
	
		
	// Schedule for 30 seconds from now - one time	
	public static void scheduleNow(){
		Integer offsetSeconds = 30;
		Datetime NowPlusOffset = Datetime.now().addSeconds(offsetSeconds);
		
		List<String> formatParams = new List<String>();
		formatParams.add(String.valueOf(nowPlusOffset.second()));
		formatParams.add(String.valueOf(nowPlusOffset.minute()));
		formatParams.add(String.valueOf(nowPlusOffset.hour()));
		formatParams.add(String.valueOf(nowPlusOffset.day()));
		formatParams.add(String.valueOf(nowPlusOffset.month()));
		formatParams.add(String.valueOf(nowPlusOffset.year()));
		
		String cronNow = String.format('{0} {1} {2} {3} {4} ? {5}',	formatParams);	
		system.debug('Cronstring = ' + cronNow);	
		
		try{
			system.schedule(jobNameNow, cronNow, new Sched_UpdateFiscalPeriod());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + jobNameNow + ' Message = ' + ex.getMessage());
		}

	}
	
	
	public static void abort(){
		abort(jobName);
	}
	
	public static void abortNow(){
		abort(jobNameNow);
	}
	
	// Centralize the abort() functionality - future enhancement would be to move this function to the ApexJobManager
	private static void abort(String eitherJobName){
		try{
			List<CronTrigger> cronTriggers = [Select State, Id, CronJobDetail.JobType, CronJobDetail.Name, CronExpression
											  From CronTrigger
											  where CronJobDetail.JobType = '7'
											  and CronJobDetail.Name = :eitherJobName];
	
			if(cronTriggers.size() == 1){
				system.abortJob(cronTriggers[0].Id);
			}
			else{
				system.debug('Job: ' + eitherJobName + ' returned ' + cronTriggers.size() + ' results. There should have been exactly 1');
			}
		}
		catch (Exception ex){
			system.debug('Exception trying to abort Job: ' + eitherJobName + ' Message = ' + ex.getMessage());
		}
	}
	
	// Schedulable interface
	public void execute(SchedulableContext ctx){
		system.debug('Inside Schedulable.execute()');
		KpiCalenderManager KpiMgr = new KpiCalenderManager();
		KpiMgr.updateNewFiscalPeriod();
	}

}