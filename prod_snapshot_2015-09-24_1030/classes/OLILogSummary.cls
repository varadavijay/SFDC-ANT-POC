/*
		// Name: OLILogSummary.cls
		// Date Created: 6/6/2014 (CRM Sprint 1.0.15)
		// Purpose: Summarize the stages for the SLA Reports after a live record is created asynchronously
		// Objects affected:  Opportunity_Product_History__c & OLI_Log_Summary__c
		

*/
public with sharing class OLILogSummary {
private static String D2GL_STAGE_NAME = 'Days To Go Live';
	private static final Double MILLISECONDS_IN_HOURS = (1000*60*60);
	private static  BusinessHours bh = [SELECT Id, SundayStartTime, MondayStartTime, TuesdayStartTime, 
											WednesdayStartTime, ThursdayStartTime, FridayStartTime,
											SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime,
											WednesdayEndTime, ThursdayEndTime, FridayEndTime,SaturdayEndTime 
										FROM BusinessHours 
									  	WHERE IsDefault=true
									  	AND IsActive = true];
										
										
	private static double getBusinessHoursDifference(Datetime FROMDatetime, Datetime toDatetime){
		system.debug('OppProdHistStatusSummary: Entering getBusinessHoursDifference');
		return BusinessHours.diff(bh.Id, fromDatetime, toDatetime)/MILLISECONDS_IN_HOURS;
	}
	
	// Get Monday Buisness Hours
	private static double mondayBusinesHours()
	{
		system.debug('OppProdHistStatusSummary: Entering mondayBusinesHours');
		Date Monday = Date.newInstance (2014,6,2);
		DateTime MondayBOD = Datetime.newInstance(Monday, bh.MondayStartTime);
		DateTime MondayEOD = Datetime.newInstance(Monday, bh.MondayEndTime);
		return BusinessHours.diff(bh.Id, MondayBOD, MondayEOD)/MILLISECONDS_IN_HOURS;
	}
	
	@future (callout = true)
	public static void processLiveOLI (SET<ID> OLISet)
	{
		try 
		{
			// Because the status is in live, we are expecting all the related lists below to be populated.
			system.debug('OppProdHistStatusSummary: Entering ProcessLiveOLI');
			system.debug('OppProdHistStatusSummary.processLiveOLI: getting relatedOppProdHistories');	
			List<Opportunity_Product_History__c> relatedOppProdHistories = [SELECT 	ID, 
																					Opportunity__c, 
																					Opportunity_Product__c, 
																					OLI_Stage__c, 
																					Time_In__c, 
																					Time_Out__c, 
																					Duration__c,
																					OLI_Project__c, 
																					OLI_Product__c,
																					Product_Live_Date__c
																			FROM Opportunity_Product_History__c 
																			WHERE Opportunity_Product__c in :OLISet];		
			
			map<ID,Opportunity_Product_History__c[]> relatedOppHistMap = new map<ID,Opportunity_Product_History__c[]>();
			map<Opportunity_Product_History__c,ID> DaysToGoLiveHistOLIMap = new map<Opportunity_Product_History__c,ID>();		
			
			// Associate the OLI with all related Opp Product History in a MAP
			for (Opportunity_Product_History__c relOppHist: relatedOppProdHistories)
			{ 
				//If the related history records already has a Days to go live status, put it in a set and re-process (delete and re-create).
				if (relOppHist.OLI_Stage__c == 'Days To Go Live')
				{
					DaysToGoLiveHistOLIMap.put(relOppHist,relOppHist.Opportunity_Product__c);
				}
				//Since we're going to delete the exisitng days to go live, don't add it to the RelatedOppHist used to calculate the summary records
				else
				{
					if (!relatedOppHistMap.containsKey(relOppHist.Opportunity_Product__c))
					{
						// If OLI is not in the relatedOppHistMap, add the new Opportunity_Product_History__c array with it's first value
						relatedOppHistMap.put(relOppHist.Opportunity_Product__c, new Opportunity_Product_History__c[] {relOppHist});
					}
					else
					{
						// Otherwise add to the existing array
						relatedOppHistMap.get(relOppHist.Opportunity_Product__c).add(relOppHist);
					}
				}
			}
			
			//First check if we have the stage or the summary object for the specified OLI.
			if (DaysToGoLiveHistOLIMap.size() > 0)
			{
				cleanUpD2GLRecords(DaysToGoLiveHistOLIMap);
			}	
																			
			system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Getting oppLineItemsDb');
			map<ID,OpportunityLineItem> oppLineItemsDb = new map<ID,OpportunityLineItem>();
			list <OpportunityLineItem> OLIList = [SELECT Id, 
														SLA_Product_Type__c, 
														Product_Id__c,//new line 1/22/2014 for Analytic Snapshot
														Waiting_Status__c, 
														Waiting_Status_Descr__c,
														Live_Date__c, 
														Bus_Days_SLA__c, 
														Project__c, 
														Project__r.Project_Status__c,
														OpportunityId,
														Days_To_Go_Live__c,
														CreatedDate,
														TotalPrice,
														Quantity
													FROM OpportunityLineItem 
													WHERE Id in :OLISet];
													
			for (opportunityLineItem OLI: OLIList)
			{
				oppLineItemsDB.put(OLI.ID, OLI);
			}
			
			// The sum is calculated before creating the Days To Go Live stage 																
			system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Getting SumDurationResults');																
			AggregateResult[] SumDurationResults = [	SELECT 	SUM(Duration__c) Totaltime, 
																Opportunity_Product__c
														FROM Opportunity_Product_History__c 
														WHERE Opportunity_Product__c in :OLISet
														GROUP BY Opportunity_Product__c ];
					
			system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Creating the Duration Maps');		
			Map<Id, Decimal> TotalDurationMap = new Map<Id, Decimal>();
			for (AggregateResult ar : SumDurationResults)  
			{
				TotalDurationMap.put((string)ar.get('Opportunity_Product__c'), (decimal)ar.get('Totaltime'));
			} 
			
			
			OLI_Log_Summary__c[] OPHSummaryToInsert = new OLI_Log_Summary__c[]{};
			Opportunity_Product_History__c[] OPHToInsert = new Opportunity_Product_History__c[]{};
			for (ID OLIID: OLISet)
			{
				boolean StageExists = true;			
				// Creating the summary object first so it includes the 'Days To Go Live' Status.
				system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Calling createD2GLStage for ');	
				
				// Create and Get a list of the D2GL status' to insert by calling the createD2GLStage method.
				Opportunity_Product_History__c D2GLStage = new Opportunity_Product_History__c();
				D2GLStage = createD2GLStage(oppLineItemsDb.get(OLIID), TotalDurationMap.get(OLIID));
				relatedOppHistMap.get(OLIID).add(D2GLStage);
				OPHToInsert.add(D2GLStage);	
				
				system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Calling createStatusSummary for ');			
				// Get a list of Opp Product History to insert by calling the createStatusSummary method.
				OPHSummaryToInsert.addAll( createStatusSummary (D2GLStage,relatedOppHistMap.get(OLIID),oppLineItemsDb.get(OLIID)) );
				
			} 
			insert OPHToInsert;	
			insert OPHSummaryToInsert;
		}
		catch (exception ex) 
		{
			system.debug('OppProdHistStatusSummary.ProcessLiveOLI: Caught Exception: ' + ex.getMessage());
		}
															
	}
	
	//Delete old Days To Go Live History and Summary records
	private static void cleanUpD2GLRecords (Map<Opportunity_Product_History__c,id> HistOLIMapToDelete)
	{
		system.debug ('OppProdHistStatusSummary: Entering cleanUpD2GLRecords');
		
		try
		{
			Opportunity_Product_History__c[] histToDelete = [SELECT 	ID
															 FROM Opportunity_Product_History__c
															 WHERE ID IN :HistOLIMapToDelete.keyset()];
			
			//Get Summary records to delete
			OLI_Log_Summary__c[] SummaryToDelete = [SELECT 		ID 
													FROM OLI_Log_Summary__c 
													WHERE Opportunity_Product__c in:HistOLIMapToDelete.values()];				
			//Delete Summary Records
			if (SummaryToDelete.size() > 0)
			{
				delete SummaryToDelete;			
			}
			
			//Delete History Records
			delete histToDelete;
		}		
		catch (exception ex) 
		{
			system.debug ('OppProdHistStatusSummary.cleanUpD2GLRecords: Error while cleaning up old Days To Go Live records - ' + ex.getMessage());			
		}
	}
	
	// Creating the summary objects
	private static OLI_Log_Summary__c[] createStatusSummary (Opportunity_Product_History__c D2GLOppProdHist, Opportunity_Product_History__c[] RelatedOppHist, OpportunityLineItem oli)
	{
		system.debug('OppProdHistStatusSummary: Entering createStatusSummary');
		OLI_Log_Summary__c[] SummaryList = new OLI_Log_Summary__c[]{};
		
		// Gather List of status and their amounts
		map <String, decimal[]> statusMap = new map<string,decimal[]>();	
		for (Opportunity_Product_History__c RelHist: RelatedOppHist)
		{
			//We only want to process Days to Go Live information for status' that have been processed before the live date.
			if (RelHist.Product_Live_Date__c == null || RelHist.Time_In__c < RelHist.Product_Live_Date__c)
			{
				if (!statusMap.containskey(RelHist.OLI_Stage__c))
				{
					statusMap.put(RelHist.OLI_Stage__c,new Decimal[] {RelHist.Duration__c});
				}
				else 
				{
					statusMap.get(RelHist.OLI_Stage__c).add(RelHist.Duration__c);
				}
			}
		}
		system.debug('OppProdHistStatusSummary.createStatusSummary - Creating a list of summary records for Opp Product History');
		// For each status, enter a new summary record in the OLI_Log_Summary__c object
		for (string StatusString: statusMap.Keyset())
		{
			OLI_Log_Summary__c newHistStatusSummary = new OLI_Log_Summary__c();
			Decimal stageDuration = 0;
			// Add all durations in a status
			for (decimal dur: statusMap.get(statusString))
			{
				if (dur!=null)
				{ 
					stageDuration = stageDuration + dur;
				}
			}
			system.debug('Opportunity Product: ' + D2GLOppProdHist.Opportunity_Product__c + ' Status: ' + StatusString + ' Stage Duration: ' + stageDuration);
			// The summary record 
			NewHistStatusSummary.H2GL__c 				= D2GLOppProdHist.H2GL__c;
			NewHistStatusSummary.Live_Date__c			= oli.Live_Date__c;
			if (D2GLOppProdHist.H2GL__c != NULL)	
			{
				NewHistStatusSummary.D2GL__c 			= D2GLOppProdHist.H2GL__c /MondayBusinesHours(); //Sum of all durations
			}
			NewHistStatusSummary.Opportunity__c 		= D2GLOppProdHist.Opportunity__c;
			NewHistStatusSummary.Product__c 			= D2GLOppProdHist.OLI_Product__c;
			NewHistStatusSummary.Opportunity_Product__c = D2GLOppProdHist.Opportunity_Product__c;
			if (oli.TotalPrice != NULL && oli.quantity != NULL ) 
			{
				NewHistStatusSummary.Monthly_spend__c 	= oli.TotalPrice/oli.quantity;
			}
			NewHistStatusSummary.OLI_Stage__c 			= statusString; 
			
			if (stageDuration != NULL ) 
			{
				NewHistStatusSummary.Duration__c 			= stageDuration;
				NewHistStatusSummary.Duration_In_Days__c 	= stageDuration/MondayBusinesHours();
			}
			SummaryList.add(newHistStatusSummary);
		}
		system.debug('OppProdHistStatusSummary.createStatusSummary - Return a list of newly created OLI_Log_Summary__c Records');
		return summaryList;
	}
	
	// Creating a new status
	private static Opportunity_Product_History__c createD2GLStage (OpportunityLineItem oli, Decimal TotalDuration){
		system.debug('OppProdHistStatusSummary: Entering createD2GLStage');												
		// Information populated from the opportunity line item
		Opportunity_Product_History__c newOppProdHistory = new Opportunity_Product_History__c();
		
		newOppProdHistory.OLI_Stage__c 				= D2GL_STAGE_NAME;
		newOppProdHistory.Opportunity_Product__c 	= oli.Id;
		newOppProdHistory.Opportunity__c 			= oli.OpportunityId;
		newOppProdHistory.Product_Live_Date__c 		= oli.Live_Date__c;
		newOppProdHistory.Product_Days_To_Go_Live__c = oli.Days_To_Go_Live__c;
		newOppProdHistory.OLI_Project__c 			= oli.Project__c; 
		newOppProdHistory.OLI_Product__c 			= oli.Product_Id__c;
		newOppProdHistory.Notes__c 					= oli.Waiting_Status_Descr__c;
		// Time in and out always consistent with create date / live date
		// Assumption is that a product can only go live once so this process is only called once too.
		newOppProdHistory.Time_In__c 				= oli.CreatedDate;
		newOppProdHistory.Time_Out__c 				= oli.Live_Date__c;
		// Duration__c: Span of the duration between Create Date and Live Date
		IF (newOppProdHistory.Time_In__c!= NULL &&  newOppProdHistory.Time_Out__c != NULL)
		{
			newOppProdHistory.Duration__c 			= getBusinessHoursDifference(newOppProdHistory.Time_In__c, newOppProdHistory.Time_Out__c);
		}		
		// H2GL__c: Sum of all Duration
		newOppProdHistory.H2GL__c			 		= TotalDuration; 
		newOppProdHistory.Opportunity_Product_Type__c = oli.SLA_Product_Type__c;
		
		return newOppProdHistory;
		
	}
}