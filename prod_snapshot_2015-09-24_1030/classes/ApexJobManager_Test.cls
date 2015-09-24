/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ApexJobManager_Test {

    static testMethod void testScheduleJobs() {
        
        // This also tests the individual schedule() functions on the scheduled classes
        ApexJobManager.scheduleJobs();
        
		List<CronTrigger> cronTriggers = [Select Id, State, CronJobDetail.JobType, CronJobDetail.Name, CronExpression
										  From CronTrigger
										  where CronJobDetail.JobType = '7'];
		
		Integer apexJobCount = cronTriggers.size();
		
		// system.abortJob() just takes the CronTrigger ID, but what we know is the name,
		// so set up a map with all Apex Jobs with the name as the key
		
		Map<String, CronTrigger> apexJobs = new Map<String, CronTrigger>();
		for (CronTrigger job : cronTriggers){
			apexJobs.Put(job.CronJobDetail.Name, job);
		}
		
		// Now check that all Schedulers that we know about can be found - this will aso test their get properties
		// schedBatch_opportunitytransfer_cls
		// schedBatch_leadtransfer_cls
		// schedBatch_contactupdatekpi_cls
		// schedBatch_yipitupdatemarket
		// sched_SLA_Perf_Process_cls

		CronTrigger cronTrig = null;

		cronTrig = apexJobs.get(schedBatch_contactupdatekpi_cls.jobName);
		if(cronTrig != null){
			system.debug(cronTrig.CronJobDetail.Name + ' Cron String = ' + cronTrig.CronExpression);
			system.assertEquals(schedBatch_contactupdatekpi_cls.cronString, cronTrig.CronExpression, 'schedBatch_contactupdatekpi_cls cron string doesn\'t match' );
		}
		else{
			system.assert(false, schedBatch_contactupdatekpi_cls.jobName + ' Not Found');
		}
		
		cronTrig = apexJobs.get(schedBatch_yipitupdatemarket.jobName);
		if(cronTrig != null){
			system.debug(cronTrig.CronJobDetail.Name + ' Cron String = ' + cronTrig.CronExpression);
			system.assertEquals(schedBatch_yipitupdatemarket.cronString, cronTrig.CronExpression, 'schedBatch_yipitupdatemarket cron string doesn\'t match' );
		}
		else{
			system.assert(false, schedBatch_yipitupdatemarket.jobName + ' Not Found');
		}
		
		// Since these haven't really been scheduled, we need to call the abort() function in the same context, or they won't exist
		ApexJobManager.abortJobs();
		
		// Now we query again, and we should have 5 fewer than the count we saved.
		List<CronTrigger> cronTriggersPostAbort = [	Select Id, State, CronJobDetail.JobType, CronJobDetail.Name, CronExpression
										  			From CronTrigger
										  			where CronJobDetail.JobType = '7'];
		
		Integer apexJobCountPostAbort = cronTriggersPostAbort.size();
		
		system.assertEquals(apexJobCount - ApexJobManager.managedJobCount, apexJobCountPostAbort, 'There should be ' + ApexJobManager.managedJobCount + ' fewer jobs than when we checked after the schedude');
		
        
    } // testScheduleJobs()
}