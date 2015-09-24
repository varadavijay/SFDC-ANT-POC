public class OpportunityLineItemServices { 
//updates begin
//1/22/2014 added the Product Id Lookup Field to the pull from the OppLineItem object for the BlueWolf Object destination.....
//....in addition to the other fields they already had in place
//updates end
	@TestVisible 
	public static set<ID> processedOLIStatusChanges = new set<ID>(); // Will be referenced by different runs of this class in a single transaction.
	public static Boolean firstRun = true;	
	public static String CREATED_STAGE_NAME = 'Created';
	public static final Double MILLISECONDS_IN_HOURS = (1000*60*60);
	public static BusinessHours bh = [Select Id, SundayStartTime, MondayStartTime, TuesdayStartTime, 
											WednesdayStartTime, ThursdayStartTime, FridayStartTime,
											SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime,
											WednesdayEndTime, ThursdayEndTime, FridayEndTime,SaturdayEndTime 
											From BusinessHours 
									  Where IsDefault=true];
										
	/*	Action Methods										
	   --------------  */
	   
	// *** On Insert ***
	// Status Changes
	public static List<Opportunity_Product_History__c> processNewOpportunityLineItem(List<OpportunityLineItem> oppLineItems){
		system.debug('OpportunityLineItemServices: entering processNewOpportunityLineItem');
		
		//Remove any OLI that have already had a status update this transaction.
		for (integer i=0;i<oppLineItems.size();i++){
			if (!processedOLIStatusChanges.isempty() && processedOLIStatusChanges.contains(oppLineItems[i].ID)){
				oppLineItems.remove(i);
			}
		}
		
		//Process new inserts
		Map<Id, OpportunityLineItem> oppLineItemsDB = getOpportunityLineItemsFromDB(oppLineItems);
		List<Opportunity_Product_History__c> newOppProdHistories = new List<Opportunity_Product_History__c>();
		for (OpportunityLineItem oppLineItem : oppLineItems){
			Opportunity_Product_History__c newOppProdHist = createOppProdHistory(oppLineItem, oppLineItemsDB);
			if (oppLineItem.Waiting_Status__c != null){
				newOppProdHist.OLI_Stage__c = oppLineItem.Waiting_Status__c;
			}
			else {
				newOppProdHist.OLI_Stage__c = CREATED_STAGE_NAME;
			}
			newOppProdHist.OLI_Product__c = oppLineItem.Product_Id__c;
			newOppProdHistories.add(newOppProdHist);
		}
		
		//Prevent further status-change actions for the same transaction
		processedOLIStatusChanges.addall(oppLineItemsDB.keyset());
		
		return newOppProdHistories; 
	}

	// *** On Update ***
	// Manage Status Changes
	public static List<Opportunity_Product_History__c> ManageStatusChange(List<OpportunityLineItem> oppLineItems, Map<Id, OpportunityLineItem> oppLineItemOldMap){
		// Process Status Updates 
		List<Opportunity_Product_History__c> updatedOppProdHist; // default null
		List<OpportunityLineItem> OLIStatusUpdates = getStatusChange(oppLineItems,oppLineItemOldMap);
		List<Opportunity_Product_History__c> processedOppProdHist = new List<Opportunity_Product_History__c>();
		//The actual processing.
        if (OLIStatusUpdates.size() > 0){
        	//return to do the DML
        	processedOppProdHist = processOpportunityLineItemStatusChanges(OLIStatusUpdates);
        				
			//Prevent further status-change actions for the same transaction
			processedOLIStatusChanges.addall(new map<id,OpportunityLineItem>(OLIStatusUpdates).keyset());
			
			//Enter list of Updated records in the appliation log
			Set<Id>  SFIDSet = new Map<Id, OpportunityLineItem>(OLIStatusUpdates).keyset();
		     List<ID> SFIDList = new List<Id>();
			 SFIDList.addAll(SFIDSet);
			 string errorMsg = 'Status updated for the for the following OLIs: ' + String.join(SFIDList, ';');
			 string methodName = 'ManageStatusChange';
			 String errorStackTrace = 'OpportunityLineItemServices.ManageStatusChange(), line 81';
			 String SFID = '';
			 if (SFIDSet.size()==1){
			 	SFID = SFIDList[0];
			 }
			 ApplicationLogsModel.AddLogs(errorMsg, errorStackTrace, '86', SFID, 'OpportunityLineItemServices', methodName, false, ApplicationLogsModel.Loglevel.Info); 
        }
        
        return processedOppProdHist;
		//return updatedOppProdHist;
	}	
	
	//Does the upsert on OLI History - based on results from ManageStatusChange & processNewOpportunityLineItem
	public static List<Opportunity_Product_History__c> upsertOpportunityProductHistories(List<Opportunity_Product_History__c> oppProdHists, List<OpportunityLineItem> oppLineItems){		
		try{
			upsert oppProdHists;
		}
		catch( DMLException dmlEx ){
			Map<String, OpportunityLineItem> oliMap = new Map<String, OpportunityLineItem>();
			for (OpportunityLineItem oli : oppLineItems){
				oliMap.put(oli.Id, oli);
			}
			for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
				oliMap.get( oppProdHists[ dmlEx.getDmlIndex( i ) ].Opportunity_Product__c ).addError( dmlEx.getDmlMessage( i ) );
			}
		}

		return oppProdHists;
	}

	// *** On delete ***
	// get associated Opportunity Product Histories
	public static List<Opportunity_Product_History__c> processDeletedOpportunityLineItem(List<OpportunityLineItem> oppLineItems){
		Map<Id, OpportunityLineItem> oppLineItemIds = new Map<Id, OpportunityLineItem>(oppLineItems);
		List<Opportunity_Product_History__c> deletedOppProdHistories = [Select Id, Opportunity__c, Opportunity_Product__c, OLI_Product__c 
																		From Opportunity_Product_History__c 
																		Where Opportunity_Product__c in :oppLineItemIds.keySet()];															
		return deletedOppProdHistories; 
	}
	
	// delete associated Opportunity Product Histories from processDeletedOpportunityLineItem
	public static List<Opportunity_Product_History__c> deleteOpportunityProductHistories(List<Opportunity_Product_History__c> oppProdHists, List<OpportunityLineItem> oppLineItems){
		try{
			delete oppProdHists;
		}
		catch( DMLException dmlEx ){
			Map<String, OpportunityLineItem> oliMap = new Map<String, OpportunityLineItem>();
			for (OpportunityLineItem oli : oppLineItems){
				oliMap.put(oli.Id, oli);
			}
			for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
				oliMap.get( oppProdHists[ dmlEx.getDmlIndex( i ) ].Opportunity_Product__c ).addError( dmlEx.getDmlMessage( i ) );
			}
		}
		return oppProdHists;
	}
	
	//get associated Product SLA Records
	public static List<Product_SLA__c> getSLASummary(List<OpportunityLineItem> oppLineItems){
		Map<Id, OpportunityLineItem> oppLineItemIds = new Map<Id, OpportunityLineItem>(oppLineItems);
		List<Product_SLA__c> SLARecordsForCleanUp = [SELECT 	ID,
                                                                Opportunity_Product__c
		                                             FROM Product_SLA__c 
		                                             WHERE Opportunity_Product__c in :oppLineItemIds.keySet()];
		return SLARecordsForCleanUp;		                                             
	}
	
	//delete associated Product SLA Records from getSLASummary
	public static List<Product_SLA__c> deleteSLASummaries( List<Product_SLA__c> SLARecordsForCleanUp, List<OpportunityLineItem> oppLineItems){
		if (SLARecordsForCleanUp.size() > 0){
			Try{
				delete SLARecordsForCleanUp;
			}
			catch( DMLException dmlEx ){
				Map<String, OpportunityLineItem> oliMap = new Map<String, OpportunityLineItem>();
				for (OpportunityLineItem oli : oppLineItems){
					oliMap.put(oli.Id, oli);
				}
				for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
					oliMap.get( SLARecordsForCleanUp[ dmlEx.getDmlIndex( i ) ].Opportunity_Product__c ).addError( dmlEx.getDmlMessage( i ) );
				}
			}
		}
		return SLARecordsForCleanUp;
	}

	// DEV-939 SR-3282 SF Opp sends incorrect status updates
	// Deleting Orphaned Projects to fix no workflow time action emails are sent to users wrongly
	// get associated project records
	public static List<Project__c> getProjectsByOpportunityLineItems(List<OpportunityLineItem> OpptyLineItems){
		Set<Id> delProjectIds = new Set<Id>();
		for(OpportunityLineItem oneOpptyLineItem : OpptyLineItems){
			delProjectIds.add(oneOpptyLineItem.Project__c);
		}
		List<Project__c> deleteProjects = [Select Id,Product_Id__c  from Project__c where Id In: delProjectIds];
		return deleteProjects;
	}
	
	// delete associated project records from getProjectsByOpportunityLineItems
	public static List<Project__c>  deleteProjects(List<Project__c> deleteProjects, List<OpportunityLineItem> oppLineItems){	
		try{
			if(deleteProjects.size()>0){
				delete deleteProjects;
			}
		}
		catch( DMLException dmlEx ){
			Map<String, OpportunityLineItem> oliMap = new Map<String, OpportunityLineItem>();
			for (OpportunityLineItem oli : oppLineItems){
				oliMap.put(oli.Id, oli);
			}
			for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
				oliMap.get( deleteProjects[ dmlEx.getDmlIndex( i ) ].Product_Id__c ).addError( dmlEx.getDmlMessage( i ) );
			}
		}
		return deleteProjects;
	}


	/*	Helper Methods
	   -------------- */
	// Compares trigger.oldMap and the new values to return a list of OLI whose waiting_status__c has changed 
	public static List<OpportunityLineItem> getStatusChange(List<OpportunityLineItem> oppLineItems, Map<Id, OpportunityLineItem> oppLineItemOldMap){
		 //Insert comments here for applciation logs
		 List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
		 String errorMsg = '';
		 String errorStackTrace = 'OpportunityLineItemServices.getStatusChange(), line 116';
		 String methodName = 'getStatusChange';
		 //stops reprocessing of OLI that have already been processed.  Records the previous and new states for OLI that are going to be processed in Application logs.
		 for (integer i=0; i <oppLineItems.size();i++){		 	
		 	if (!processedOLIStatusChanges.isempty() && processedOLIStatusChanges.contains(oppLineItems[i].ID)){
				continue;
			}
			oliList.add(oppLineItems[i]);
		 	errorMsg = ' OLI ID: ' + oppLineItems[i].ID + '; Old status: ' + oppLineItemOldMap.get(oppLineItems[i].ID).Waiting_Status__c + '; New Status: ' + oppLineItems[i].Waiting_Status__c ;
		 	ApplicationLogsModel.AddLogs( errorMsg, errorStackTrace, '209', oppLineItems[i].ID, 'OpportunityLineItemServices', methodName, false, ApplicationLogsModel.Loglevel.Info);
		 }
		 
		 List<OpportunityLineItem> OLIStatusUpdates =  Select.Field.hasChanged( OpportunityLineItem.Waiting_Status__c ).filter( oliList, oppLineItemOldMap );		 
		 return OLIStatusUpdates;
	}
	
	// Returns List of specific OpportunityLineItem fields for a list of IDs 
	private static Map<Id, OpportunityLineItem> getOpportunityLineItemsFromDB(List<OpportunityLineItem> olis){
		// OppLineItem Id to ProductType
		system.debug('OpportunityLineItemServices: Entering getOpportunityLineItemsFromDB');
		Map<Id, OpportunityLineItem> result = new Map<Id, OpportunityLineItem>();
		Set<Id> oppLineItemIds = new Map<Id, OpportunityLineItem>(olis).keySet();
		
		List<OpportunityLineItem> oppLineItemsDb = [Select Id, 
														SLA_Product_Type__c, 
														Product_Id__c,//new line 1/22/2014 for Analytic Snapshot
														Waiting_Status__c, 
														Live_Date__c, 
														Bus_Days_SLA__c, 
														Project__c, 
														Project__r.Project_Status__c
													From OpportunityLineItem Where Id in :oppLineItemIds];
		system.debug('OpportunityLineItemServices: getOpportunityLineItemsFromDB - Retrieved oppLineItemsDb successfuly');
		for (OpportunityLineItem oliDb: oppLineItemsDb){
			result.put(oliDb.Id, oliDb);
		}
		return result;
	}

	public static Double getBusinessHoursDifference(Datetime fromDatetime, Datetime toDatetime){
		system.debug('OpportunityLineItemServices: Entering getBusinessHoursDifference');
		return BusinessHours.diff(bh.Id, fromDatetime, toDatetime)/MILLISECONDS_IN_HOURS;
	}
	
	public static Boolean acceptableBusinessHoursDifference(Double duration, Integer acceptableDifference){
		return (Math.abs(duration) <= acceptableDifference);
	}
	
	public static Opportunity_Product_History__c createOppProdHistory(OpportunityLineItem oli, Map<Id, OpportunityLineItem> oppLineItemsDb){
		system.debug('OpportunityLineItemServices: entering createOppProdHistory - Time In: ' + oli.LastModifiedDate);
		Opportunity_Product_History__c newOppProdHistory = new Opportunity_Product_History__c();
		newOppProdHistory.Opportunity_Product__c = oli.Id;
		newOppProdHistory.Opportunity__c = oli.OpportunityId;
		newOppProdHistory.Product_Live_Date__c = oli.Live_Date__c;
		newOppProdHistory.Product_Days_To_Go_Live__c = oli.Days_To_Go_Live__c;
		newOppProdHistory.OLI_Project__c = oli.Project__c; 
		newOppProdHistory.OLI_Stage__c = oli.Waiting_Status__c;
		newOppProdHistory.OLI_Product__c = oli.Product_Id__c;//new line 1/22/2014 for Analytic Snapshot
		newOppProdHistory.Notes__c = oli.Waiting_Status_Descr__c;
		newOppProdHistory.Time_In__c = oli.LastModifiedDate;
		newOppProdHistory.Time_Out__c = null;
		
		if (oppLineItemsDb.containsKey(oli.Id)){
			newOppProdHistory.Opportunity_Product_Type__c = oppLineItemsDb.get(oli.Id).SLA_Product_Type__c;
		}
		
		return newOppProdHistory;
	}
	//updates the OLI log with new time out/duration
	public static Opportunity_Product_History__c updateOppProdHistory(OpportunityLineItem oli, Opportunity_Product_History__c oppProdHist){
		system.debug('OpportunityLineItemServices: entering updateOppProdHistory - oli.LastModifiedDate: ' + oli.LastModifiedDate);
		oppProdHist.Time_Out__c = oli.LastModifiedDate; 
		oppProdHist.OLI_Project__c = oli.Project__c;
		oppProdHist.OLI_Product__c = oli.Product_Id__c;//added 1/27/2014 to allow for direct reference of product SLA 
		if (oppProdHist.Time_Out__c != null && oppProdHist.Time_In__c != null){
			// https://cs10.salesforce.com/01mA0000000L1kN : Make sure business hours are set... 
			oppProdHist.Duration__c = getBusinessHoursDifference(oppProdHist.Time_In__c, oppProdHist.Time_Out__c);
		}
		return oppProdHist;
	}
	
	//updates the last OLI log with new time out/duration,  and creates a new OLI Log record for the new status.  If live - creates Product SLA records
	public static List<Opportunity_Product_History__c> processOpportunityLineItemStatusChanges(List<OpportunityLineItem> oppLineItems){
		system.debug('OpportunityLineItemServices: entering processOpportunityLineItemStatusChanges');
		List<Opportunity_Product_History__c> processedOppProdHistories = new List<Opportunity_Product_History__c>();
		Map<Id, OpportunityLineItem> oppLineItemsDB = getOpportunityLineItemsFromDB(oppLineItems);
		
		Map<Id, OpportunityLineItem> oppLineItemIds = new Map<Id, OpportunityLineItem>(oppLineItems);
		
		List<Opportunity_Product_History__c> latestOppProdHistories = [SELECT 	ID, 
																				Opportunity__c, 
																				Opportunity_Product__c, 
																				OLI_Stage__c, 
																				Time_In__c, 
																				Time_Out__c, 
																				OLI_Project__c, 
																				OLI_Product__c
																		FROM Opportunity_Product_History__c 
																		WHERE Time_Out__c = NULL 
																		AND Opportunity_Product__c in :oppLineItemIds.keySet()];
		
		map<Id, Opportunity_Product_History__c> latestOppProdHistoryMap = new map<Id, Opportunity_Product_History__c>();
		set<Id> LiveOppProdHistory = new set<Id>();		
		for (Opportunity_Product_History__c lastOppProdHist : latestOppProdHistories){
			latestOppProdHistoryMap.put(lastOppProdHist.Opportunity_Product__c, lastOppProdHist);
		}
							
		for (OpportunityLineItem currentOLI : oppLineItems){
			if (!latestOppProdHistoryMap.containsKey(currentOLI.Id)){
				system.debug('OpportunityLineItemServices.processOpportunityLineItemStatusChanges: Calling Create for new OLI');
				Opportunity_Product_History__c newOppProdHist = createOppProdHistory(currentOLI, oppLineItemsDB);
				processedOppProdHistories.add(newOppProdHist);
			}
			else {	
				system.debug('OpportunityLineItemServices.processOpportunityLineItemStatusChanges: Calling update for changed stages ' + currentOLI.Waiting_Status__c);
				Opportunity_Product_History__c lastOppProdHist = updateOppProdHistory(currentOLI, latestOppProdHistoryMap.get(currentOLI.Id));
				processedOppProdHistories.add(lastOppProdHist);
				
				system.debug('OpportunityLineItemServices.processOpportunityLineItemStatusChanges: Calling create after a stage update');
				Opportunity_Product_History__c newOppProdHist = createOppProdHistory(currentOLI, oppLineItemsDB);
				processedOppProdHistories.add(newOppProdHist);
				
				if(currentOLI.Waiting_Status__c == 'Live'|| currentOLI.Waiting_Status__c == 'Fulfilled-Complete'|| currentOLI.Waiting_Status__c == 'Fulfilled Renewed'|| currentOLI.Waiting_Status__c == 'Fulfilled Non-Renewal'){		
					LiveOppProdHistory.add(currentOLI.Id);
				}
			}
		}
		if (LiveOppProdHistory.size()>0){
			system.debug('OpportunityLineItemServices.processOpportunityLineItemStatusChanges: Processing Live Opp Prod Hist');
			ProductSLAServices.callProcessLiveOLIforTriggers(LiveOppProdHistory);
		}
		return processedOppProdHistories;
	}
	
	private class applicationException extends Exception {}
	
}