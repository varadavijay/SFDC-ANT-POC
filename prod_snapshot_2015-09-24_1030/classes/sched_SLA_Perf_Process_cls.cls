global class sched_SLA_Perf_Process_cls implements Schedulable {	
	public static String jobName {
		get{ return 'LaunchSLAProcessing'; }
	}
// For Cron String Reference: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
	public static void schedule(){
		String cronString = '00 55 23 * * ?';
		try{
			system.schedule(jobName, cronString, new sched_SLA_Perf_Process_cls());
		}
		catch(Exception ex){
			system.debug('Exception trying to schedule Job: ' + jobName + ' Message = ' + ex.getMessage());
		}
	}
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

	global void execute(SchedulableContext ctx){
	//Datetime LiveDate = datetime.now()-14;
	system.debug('starting  HistToProcess Query');
	List<Opportunity_Product_History__c> HistToProcess = [SELECT Id, 
																 Duration__c, 
																 OLI_Stage__c, 
																 Opportunity_Product__c, 
																 Opportunity_Product_Type__c, 
																 Product_Days_To_Go_Live__c, 
																 Product_Live_DateTime__c,
																 OLI_Product_SLA__c,
																 OLI_Product_SLA_Type__c,
																 Sell_Type__c,
																 SLA_Performance_Query__c
																 //Current_Product_Stage__c, 
																 //Time_In__c, 
																 //Time_Out__c 
																 //Product_Live_Date__c,
																 //Opportunity__c,
																 //OLI_Project__c,
																 //Notes__c,
														  FROM Opportunity_Product_History__c 
														  WHERE SLA_Performance_Query__c = true
//Above WHERE clause replaces the below WHERE clause
														  //WHERE Product_Live_DateTime__c != Null 
														  //AND Time_Out__c != Null
														  //AND Current_Product_Stage__c 
														  //IN('Live','Fulfilled Renewed','Fulfilled Non-Renewal','Fulfilled-Complete')
														  ORDER BY Opportunity_Product__c, OLI_Stage__c];


	system.debug('ending  HistToProcess Query Size = ' + HistToProcess.size());
	
	List<SLA_Performance__c> SLAsToUpsert = new List<SLA_Performance__c>();
	
	String OppProjHistSumRec;
	Integer roundCount = HistToProcess.size();
	Integer x = 1;
	String CheckDupeIdStage_O = '';
	//New Values For Comparison Loop
	Datetime OLI_LiveStamp_N;
	String OLI_ProdType_N;
	String Sell_Type_N;
	Double OLI_ProdSLA_N;
	String OLI_ProdSLA_Type_N;
	Double ClosedWonTime_N;
	Double AwaitOnBoardTime_N;
	Double PendingTime_N;
	Double InFulfillTime_N;
	Double LiveTime_N;
	Double FulfilledTime_N;
	Double WaitingApproveTime_N;
	Double WaitingResourceTime_N;
	//Old Values For Comparison Loop
	Datetime OLI_LiveStamp_O;
	String OLI_ProdType_O;
	String Sell_Type_O;
	Double OLI_ProdSLA_O;
	String OLI_ProdSLA_Type_O;
	Double ClosedWonTime_O;
	Double AwaitOnBoardTime_O;
	Double PendingTime_O;
	Double InFulfillTime_O;
	Double LiveTime_O;
	Double FulfilledTime_O;
	Double WaitingApproveTime_O;
	Double WaitingResourceTime_O;
	
	for(Opportunity_Product_History__c tempCon1 : HistToProcess){
	
		String CheckDupeIdStage_N = tempCon1.Opportunity_Product__c;
		OppProjHistSumRec = tempCon1.Opportunity_Product__c;
		OLI_ProdType_N = tempCon1.Opportunity_Product_Type__c;
		OLI_ProdSLA_Type_N = tempCon1.OLI_Product_SLA_Type__c;
		Sell_Type_N = tempCon1.Sell_Type__c;
		OLI_ProdSLA_N = tempCon1.OLI_Product_SLA__c;
		OLI_LiveStamp_N = tempCon1.Product_Live_DateTime__c;
		system.debug('...****OLI Item Characteristics****... OppProjHistSumRec = '+OppProjHistSumRec+', OLI_ProdType_N = '+OLI_ProdType_N+', OLI_ProdSLA_N = '+OLI_ProdSLA_N+', OLI_LiveStamp_N = '+OLI_LiveStamp_N);
		system.debug('TOGETORNOTTOGET='+tempCon1.SLA_Performance_Query__c);
		//set and clear variables for getting new values
		ClosedWonTime_N=0;
		AwaitOnBoardTime_N=0;
		PendingTime_N=0;
		InFulfillTime_N=0;
		LiveTime_N=0;
		FulfilledTime_N=0;
		WaitingApproveTime_N=0;
		WaitingResourceTime_N=0;

		//apply Duration Value to Variable For Assignment To Correct Field
		if(tempCon1.Duration__c == Null){tempCon1.Duration__c=0;}
		if(tempCon1.OLI_Stage__c == 'Closed Won'){ClosedWonTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'Awaiting Onboard'){AwaitOnBoardTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'Pending'){PendingTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'In Fulfillment'){InFulfillTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'Waiting On Client Resource'){WaitingResourceTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'Waiting On Client Approval'){WaitingApproveTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c == 'Live'){LiveTime_N=tempCon1.Duration__c;}
		else if(tempCon1.OLI_Stage__c.startsWith('Fulfilled')){FulfilledTime_N=tempCon1.Duration__c;}
		else{}
		
		//GROUP 1 - FIRST RECORD, AND NOT LAST RECORD - 
		//if first record to be reviewed and not the last one as well, then do nothing, variables are already set in the section above
		if((CheckDupeIdStage_O == '') && (x <= (roundCount - 1))){
			System.debug('GROUP 1 - do nothing if record is the FIRST record AND NOT THE LAST record ');
			//do nothing if record is the FIRST record AND NOT THE LAST record
			ClosedWonTime_O = ClosedWonTime_N;
			AwaitOnBoardTime_O = AwaitOnBoardTime_N;
			PendingTime_O = PendingTime_N;
			InFulfillTime_O = InFulfillTime_N;
			LiveTime_O = LiveTime_N;
			WaitingApproveTime_O = WaitingApproveTime_N;
			WaitingResourceTime_O = WaitingResourceTime_N;
			FulfilledTime_O = FulfilledTime_N;
			OLI_LiveStamp_O = OLI_LiveStamp_N;
		}
		//GROUP 2 - IF NOT FIRST RECORD AND NOT LAST RECORD EITHER
		else if((CheckDupeIdStage_O != '') && (x <= (roundCount - 1))){
			System.debug('GROUP 2 - IF NOT FIRST AND NOT LAST Object O = '+CheckDupeIdStage_O+'Object N = '+CheckDupeIdStage_N+' Stage = '+tempCon1.OLI_Stage__c);
			//GROUP 2A - IF NOT FIRST RECORD, NOT LAST RECORD, AND THE Opp Prod Line Item Is New/not same as last one
			if(CheckDupeIdStage_O != CheckDupeIdStage_N){
				//Create New SLA Record With Updated Values For Upsert
				SLA_Performance__c SLAUpsert = new SLA_Performance__c(
					Summary_Id__c = CheckDupeIdStage_O,
					Name = OLI_ProdSLA_Type_O,
					Sell_Type__c = Sell_Type_O,
					Product_SLA__c = OLI_ProdSLA_O,
					Period_Live_Date__c = OLI_LiveStamp_O,
					Closed_Won__c = ClosedWonTime_O,
					Awaiting_OnBoard__c = AwaitOnBoardTime_O,
					Pending__c = PendingTime_O,
					In_Fulfillment__c = InFulfillTime_O,
					Live__c = LiveTime_O,
					Waiting_On_Approval__c = WaitingApproveTime_O,
					Waiting_On_Resource__c = WaitingResourceTime_O,
					Fulfilled__c = FulfilledTime_O
				);
				SLAsToUpsert.add(SLAUpsert);
				//Clear out old values and save new values for next round
				CheckDupeIdStage_O = CheckDupeIdStage_N;
				OLI_ProdType_O = OLI_ProdType_N;
				Sell_Type_O = Sell_Type_N;
				OLI_ProdSLA_O = OLI_ProdSLA_N;
				OLI_ProdSLA_Type_O = OLI_ProdSLA_Type_N;
				OLI_LiveStamp_O = OLI_LiveStamp_N;
				ClosedWonTime_O = ClosedWonTime_N;
				AwaitOnBoardTime_O = AwaitOnBoardTime_N;
				PendingTime_O = PendingTime_N;
				InFulfillTime_O = InFulfillTime_N;
				LiveTime_O = LiveTime_N;
				WaitingApproveTime_O = WaitingApproveTime_N;
				WaitingResourceTime_O = WaitingResourceTime_N;
				FulfilledTime_O = FulfilledTime_N;
				OLI_LiveStamp_O = OLI_LiveStamp_N;
			}
			//GROUP 2B - IF NOT FIRST RECORD, NOT LAST RECORD, AND THE Opp Prod Line Item IS The Same As The Last One
			else if(CheckDupeIdStage_O==CheckDupeIdStage_N){
				//if current record is the same as the previous record OLI, then add values to each
				CheckDupeIdStage_O = CheckDupeIdStage_N;
				OLI_ProdType_O = OLI_ProdType_N;
				OLI_ProdSLA_Type_O = OLI_ProdSLA_Type_N;
				Sell_Type_O = Sell_Type_N;
				OLI_ProdSLA_O = OLI_ProdSLA_N;
				OLI_LiveStamp_O = OLI_LiveStamp_N;
				ClosedWonTime_O = ClosedWonTime_O + ClosedWonTime_N;
				AwaitOnBoardTime_O = AwaitOnBoardTime_O + AwaitOnBoardTime_N;
				PendingTime_O = PendingTime_O + PendingTime_N;
				InFulfillTime_O = InFulfillTime_O + InFulfillTime_N;
				LiveTime_O = LiveTime_O + LiveTime_N;
				WaitingApproveTime_O = WaitingApproveTime_O + WaitingApproveTime_N;
				WaitingResourceTime_O = WaitingResourceTime_O + WaitingResourceTime_N;
				FulfilledTime_O = FulfilledTime_O + FulfilledTime_N;
				OLI_LiveStamp_O = OLI_LiveStamp_N;
			}
			else{}
		}
		else if((CheckDupeIdStage_O == '') && (x == roundCount)) {
			System.debug('GROUP 3 - IF FIRST RECORD AND ALSO LAST RECORD ');
			//GROUP 3 - FIRST RECORD AND ALSO LAST RECORD OF LIST.....would likely never happen
			//put current values in record for upsert
			SLA_Performance__c SLAUpsert = new SLA_Performance__c(
				Summary_Id__c = CheckDupeIdStage_N,
				Name = OLI_ProdSLA_Type_N,
				Sell_Type__c = Sell_Type_N,
				Product_SLA__c = OLI_ProdSLA_N,
				Period_Live_Date__c = OLI_LiveStamp_N,
				Closed_Won__c = ClosedWonTime_N,
				Awaiting_OnBoard__c = AwaitOnBoardTime_N,
				Pending__c = PendingTime_N,
				In_Fulfillment__c = InFulfillTime_N,
				Live__c = LiveTime_N,
				Waiting_On_Approval__c = WaitingApproveTime_N,
				Waiting_On_Resource__c = WaitingResourceTime_N,
				Fulfilled__c = FulfilledTime_N
			);
			SLAsToUpsert.add(SLAUpsert);
		}
		else if((CheckDupeIdStage_O != '') && (x == roundCount)) {
			//GROUP 4 - IF NOT THE FIRST RECORD AND IS THE LAST RECORD OF THE LIST
			System.debug('GROUP 4 - IF NOT THE FIRST RECORD AND IS THE LAST RECORD ');
			//IF NOT THE FIRST RECORD AND IS THE LAST RECORD
			//if this is the LAST record and NOT the FIRST record
			//put current values in record for upsert
			//....AND the Summary Record id is not the same as the former one, then get old values and add to new object for upsert
			if(CheckDupeIdStage_O != CheckDupeIdStage_N){
			//if second to last NOT same object as last, then add the second to last first......
				SLA_Performance__c SLAUpsert = new SLA_Performance__c(
					Summary_Id__c = CheckDupeIdStage_O,
					Name = OLI_ProdSLA_Type_O,
					Sell_Type__c = Sell_Type_O,
					Product_SLA__c = OLI_ProdSLA_O,
					Period_Live_Date__c = OLI_LiveStamp_O,
					Closed_Won__c = ClosedWonTime_O,
					Awaiting_OnBoard__c = AwaitOnBoardTime_O,
					Pending__c = PendingTime_O,
					In_Fulfillment__c = InFulfillTime_O,
					Live__c = LiveTime_O,
					Waiting_On_Approval__c = WaitingApproveTime_O,
					Waiting_On_Resource__c = WaitingResourceTime_O,
					Fulfilled__c = FulfilledTime_O
				);
				SLAsToUpsert.add(SLAUpsert);
				//.....then add last record next
				SLA_Performance__c SLAUpsert2 = new SLA_Performance__c(
					Summary_Id__c = CheckDupeIdStage_N,
					Name = OLI_ProdSLA_Type_N,
					Sell_Type__c = Sell_Type_N,
					Product_SLA__c = OLI_ProdSLA_N,
					Period_Live_Date__c = OLI_LiveStamp_N,
					Closed_Won__c = ClosedWonTime_N,
					Awaiting_OnBoard__c = AwaitOnBoardTime_N,
					Pending__c = PendingTime_N,
					In_Fulfillment__c = InFulfillTime_N,
					Live__c = LiveTime_N,
					Waiting_On_Approval__c = WaitingApproveTime_N,
					Waiting_On_Resource__c = WaitingResourceTime_N,
					Fulfilled__c = FulfilledTime_N
				);
				SLAsToUpsert.add(SLAUpsert2);
			}
			else if(CheckDupeIdStage_O==CheckDupeIdStage_N){
			//IF CURRENT RECORD IS LAST RECORD BUT NOT THE FIRST RECORD AND....
			//if current record is the same as the previous record OLI, then COMBINE values BEFORE upserting
					    
				SLA_Performance__c SLAUpsert = new SLA_Performance__c();
				SLAUpsert.Summary_Id__c = CheckDupeIdStage_N;
				SLAUpsert.Name = OLI_ProdSLA_Type_N;
				SLAUpsert.Sell_Type__c = Sell_Type_N;
				SLAUpsert.Product_SLA__c = OLI_ProdSLA_N;
				SLAUpsert.Period_Live_Date__c = OLI_LiveStamp_N;
				SLAUpsert.Closed_Won__c = ClosedWonTime_O + ClosedWonTime_N;
				SLAUpsert.Awaiting_OnBoard__c = AwaitOnBoardTime_O + AwaitOnBoardTime_N;
				SLAUpsert.Pending__c = PendingTime_O + PendingTime_N;
				SLAUpsert.In_Fulfillment__c = InFulfillTime_O + InFulfillTime_N;
				SLAUpsert.Live__c = LiveTime_O + LiveTime_N;
				SLAUpsert.Waiting_On_Approval__c = WaitingApproveTime_O + WaitingApproveTime_N;
				System.debug('still alive after waiting approval OLD = '+WaitingResourceTime_O+' NEW = '+WaitingResourceTime_N);
				SLAUpsert.Waiting_On_Resource__c = WaitingResourceTime_O + WaitingResourceTime_N;
				System.debug('still alive after waiting resource....');
				SLAUpsert.Fulfilled__c = FulfilledTime_O + FulfilledTime_N;
				System.debug('still alive after fulfilled....');
				SLAsToUpsert.add(SLAUpsert);
				System.debug('right after that last upsert in group 4......');
			}
			else{}
		}//END OF GROUP 4	
		x = x+1;
		CheckDupeIdStage_O=tempCon1.Opportunity_Product__c;
		OLI_ProdType_O=tempCon1.Opportunity_Product_Type__c;
		OLI_ProdSLA_Type_O=tempCon1.OLI_Product_SLA_Type__c;
		Sell_Type_O=tempCon1.Sell_Type__c;
		OLI_ProdSLA_O=tempCon1.OLI_Product_SLA__c;
		OLI_LiveStamp_O=tempCon1.Product_Live_DateTime__c;
		System.debug('INSIDE FOR LOOP '+SLAsToUpsert.size());
	}//for loop - forOpportunity_Product_History__c tempCon1
	System.debug('AFTER FOR LOOP '+SLAsToUpsert.size());
	upsert SLAsToUpsert Summary_Id__c;
	}
}