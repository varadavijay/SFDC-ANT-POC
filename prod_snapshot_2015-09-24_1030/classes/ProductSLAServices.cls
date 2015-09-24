/*
		// Name: ProductSLAServices.cls
		// Date Created: 7/15/2014 (CRM Sprint 1.0.16)
		// Purpose: Summarize the stages for the SLA Reports after an Opportunity Product's status changes to Live OR the Live Date is changed.
		// Objects affected:  Opportunity_Product_History__c & Product_SLA__c
		// Used by: OpportunityLineItemServices

*/
public without sharing class ProductSLAServices {
private static final Double MILLISECONDS_IN_HOURS = (1000*60*60);
private static list <OpportunityLineItem> OLIList;
private static map<ID,integer> OLIDaysToLiveUpdated = new map<ID,integer>();
	private static  BusinessHours bh = [SELECT Id, SundayStartTime, MondayStartTime, TuesdayStartTime, 
											WednesdayStartTime, ThursdayStartTime, FridayStartTime,
											SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime,
											WednesdayEndTime, ThursdayEndTime, FridayEndTime,SaturdayEndTime,
											TimeZoneSidKey   
										FROM BusinessHours 
									  	WHERE IsDefault=true
									  	AND IsActive = true];
	
										
	private static double getBusinessHoursDifference(Datetime FROMDatetime, Datetime toDatetime){
		system.debug('ProductSLAServices: Entering getBusinessHoursDifference');
		return BusinessHours.diff(bh.Id, fromDatetime, toDatetime)/MILLISECONDS_IN_HOURS;
	}
	
	// Get Monday Buisness Hours
	private static decimal mondayBusinessHours(){
		system.debug('ProductSLAServices: Entering mondayBusinessHours');
		Date Monday = Date.newInstance (2014,6,2);
		//Get the Monday Start time and  End time - This will be in the user's time zome
		DateTime MondayBOD = Datetime.newInstance(Monday, bh.MondayStartTime); //Datetime.newInstance(Monday, bh.MondayStartTime);
		DateTime MondayEOD =  Datetime.newInstance(Monday, bh.MondayEndTime); //Datetime.newInstance(Monday, bh.MondayEndTime);
		
		decimal BusHoursDay = Math.Floor((Decimal.valueOf(MondayEOD.getTime()) -  Decimal.valueOf(MondayBOD.getTime()) ) / (MILLISECONDS_IN_HOURS));
		system.debug('BusHoursDay: ' + BusHoursDay); 
		return BusHoursDay;
	}
    
    //Need a synchronous method for Batch processing.
    public static void callProcessLiveOLIforBatch (SET<ID> OLISet){
		processLiveOLI(OLISet);
    }
    
    // Benefits of asynchronous methods for triggers 
    //  1) Doesn't interfere with user operations (more efficient); 
    //  2) Ensures all workflow rules and other synchronous trigger dependencies are executed first.
    @future (callout = true)
    public static void callProcessLiveOLIforTriggers (SET<ID> OLISet){
		processLiveOLI(OLISet);
    }
	
    //Does any clean up required; then gathers information needed for summarizing Opportunity Product History records.
	public static void processLiveOLI (SET<ID> OLISet){
		try {
			// Because the status is in live, we are expecting all the related lists below to be populated.
			system.debug('ProductSLAServices: Entering ProcessLiveOLI');
			List<Product_SLA__c> SLARecordsForCleanUp = [SELECT 	ID
															FROM Product_SLA__c 
															WHERE Opportunity_Product__c in :OLISet];			

			if (SLARecordsForCleanUp.size() > 0){
				Delete SLARecordsForCleanUp;
			}


			system.debug('ProductSLAServices:processLiveOLI: getting relatedOppProdHistories');	
			List<Opportunity_Product_History__c> relatedOppProdHistories = [SELECT 	ID, 
																					Opportunity__c, 
																					Opportunity_Product__c, 
																					OLI_Stage__c, 
																					Time_In__c, 
																					Time_Out__c, 
																					Duration__c,
																					OLI_Project__c, 
																					OLI_Product__c
																			FROM Opportunity_Product_History__c 
																			WHERE Opportunity_Product__c in :OLISet];		
			
			map<ID,Opportunity_Product_History__c[]> relatedOppHistMap = new map<ID,Opportunity_Product_History__c[]>();	
			
			// Associate the OLI with all related Opp Product History in a MAP
			for (Opportunity_Product_History__c relOppHist: relatedOppProdHistories){ 
				//If the related history records already has a Days to go live status, put it in a set and re-process (delete and re-create).
				if (!relatedOppHistMap.containsKey(relOppHist.Opportunity_Product__c)){
					// If OLI is not in the relatedOppHistMap, add the new Opportunity_Product_History__c array with it's first value
					relatedOppHistMap.put(relOppHist.Opportunity_Product__c, new Opportunity_Product_History__c[] {relOppHist});
				}
				else{
					// Otherwise add to the existing array
					relatedOppHistMap.get(relOppHist.Opportunity_Product__c).add(relOppHist);
				}
			}
																			
			system.debug('ProductSLAServices.ProcessLiveOLI: Getting oppLineItemsDb');
			
			OLIList = [SELECT Id, 
							SLA_Product_Type__c, 
							Product_Id__c,
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
							Quantity,
							Product2.SLA_Bus_Days__c,
							Product2.SLA_Product_Type__c,
							Opportunity.Media_Partner_Name__c,
							Opportunity.Media_Partner__r.Partner_Type__c,
							Days_To_Live__c
						FROM OpportunityLineItem 
						WHERE Id in :OLISet];
			map<ID,OpportunityLineItem> oppLineItemsDb = new map<ID,OpportunityLineItem>(OLIList);
			Product_SLA__c[] SLARecordsToInsert = new Product_SLA__c[]{};
			for (ID OLIID: OLISet){
				system.debug('ProductSLAServices.ProcessLiveOLI: Calling summarizeForSLA');			
				// Get a list of Opp Product History to insert by calling the summarizeForSLA method.
				Product_SLA__c OLISummaryRecord = summarizeForSLA(relatedOppHistMap.get(OLIID),oppLineItemsDb.get(OLIID));
				if (OLISummaryRecord != null){
					SLARecordsToInsert.add(OLISummaryRecord);	
				}
			} 
			insert SLARecordsToInsert;
			system.debug('Product SLA inserted: ' + SLARecordsToInsert );
			updateRelatedOLIDaysToLive();
		}
		catch (exception ex) {
			system.debug('ProductSLAServices.ProcessLiveOLI: Caught Exception: ' + ex.getMessage());
		}
															
	}
	
	//Update
	private static void updateRelatedOLIDaysToLive()
	{
		OpportunityLineItem[] OLIToUpdate = new OpportunityLineItem[]{};
		for (OpportunityLineItem oli: OLIList)
		{
			oli.Days_To_Live__c = OLIDaysToLiveUpdated.get(oli.ID);
			OLIToUpdate.add(oli);
		}
		try
		{
			update OLIToUpdate;
		}
		catch (exception ex)
		{
			system.debug('ProductSLAServices.updateRelatedOLIDaysToLive: Caught Exception: ' + ex.getMessage());
		}
	}
	
	
	// Creating the summary objects per OLI
	private static Product_SLA__c summarizeForSLA (Opportunity_Product_History__c[] RelatedOppHist, OpportunityLineItem oli){
		system.debug('ProductSLAServices: Entering summarizeForSLA for Opportunity Product ' + oli.ID);
		
		// Gather List of status and their amounts
		map <String, decimal[]> statusMap = new map<string,decimal[]>();
		datetime LiveDate;
		for (Opportunity_Product_History__c RelHist: RelatedOppHist){
			if (RelHist.OLI_Stage__c == 'Live'|| RelHist.OLI_Stage__c == 'Fulfilled-Complete'|| RelHist.OLI_Stage__c == 'Fulfilled Renewed'|| RelHist.OLI_Stage__c == 'Fulfilled Non-Renewal'){
				if (LiveDate == null){
					LiveDate = RelHist.Time_In__c; 
				}
				else if (RelHist.Time_In__c < LiveDate){
					LiveDate = RelHist.Time_In__c; 
				}
			}			
		}
		if (LiveDate == null)
		{
			system.debug('ProductSLAServices.summarizeForSLA:  Found no Live Status\' info for Opportunity Product '+ oli.ID + '.  Skipping!');
			return null;
		}
				
		for (Opportunity_Product_History__c RelHist: RelatedOppHist){
			//We only want to process Days to Go Live information for status' that have been processed before the live date.
			//Converting to string to compare seconds as well.
			system.debug('RelHist.OLI_Stage__c ' + RelHist.OLI_Stage__c  + ' Time_In__c: ' + RelHist.Time_In__c + ' Time_Out__c: ' + RelHist.Time_Out__c  + ' Live Date' +  LiveDate);
			//Assumes Time in is before time out; and ensures time out is not null
			if (RelHist.Time_In__c < LiveDate ){ 
				if (RelHist.Time_Out__c <= LiveDate ) {
					if (!statusMap.containskey(RelHist.OLI_Stage__c)){
						statusMap.put(RelHist.OLI_Stage__c,new Decimal[] {RelHist.Duration__c});
					}
					else {
						statusMap.get(RelHist.OLI_Stage__c).add(RelHist.Duration__c);
					}
				}
				else if (RelHist.Time_Out__c != null){
					//Get the difference between the Time in and live date 
					double dur = getBusinessHoursDifference(RelHist.Time_In__c,LiveDate);
					if (!statusMap.containskey(RelHist.OLI_Stage__c)){
						statusMap.put(RelHist.OLI_Stage__c,new Decimal[] {dur});
					}
					else{
						statusMap.get(RelHist.OLI_Stage__c).add(dur);
					}
				}
			}
		}//End for related History records


		system.debug('ProductSLAServices.summarizeForSLA - Creating a list of summary records for Opp Product History');
		// For each status, update the related status field on the object
		Product_SLA__c SLARecord = new Product_SLA__c();
		Decimal businessHoursPerDay = mondayBusinessHours();
		Decimal totalSLADuration = 0;
		for (string StatusString: statusMap.Keyset()){
			Decimal stageDuration = 0;
			// Add all durations in a status
			for (decimal dur: statusMap.get(statusString)){
				if (dur!=null){ 
					stageDuration = stageDuration + dur;
				}
			}
			if (StatusString == 'Waiting On Client Approval'){
				SLARecord.Awaiting_Client_Approval_Hours__c = stageDuration;
				SLARecord.Awaiting_Client_Approval__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else if (StatusString == 'Waiting On Client Resource'){
				SLARecord.Awaiting_Client_Asset_Hours__c = stageDuration;
				SLARecord.Awaiting_Client_Asset__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else if (StatusString == 'Awaiting Onboard'){
				SLARecord.Awaiting_On_Board_Hours__c = stageDuration;
				SLARecord.Awaiting_On_Board__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else if (StatusString == 'In Fulfillment'){
				SLARecord.In_Fulfillment_Hours__c = stageDuration;
				SLARecord.In_Fulfillment__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else if (StatusString == 'Closed Won'){
				SLARecord.Closed_Won_Hours__c = stageDuration;
				SLARecord.Closed_Won__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else if (StatusString == 'Pending'){
				SLARecord.Pending_Hours__c = stageDuration;
				SLARecord.Pending__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				totalSLADuration += stageDuration;
			}
			else{
				// For record keeping purposes, record the parts that were ignored by the current way of capturing stage duration.
				
				if (SLARecord.Total_Non_SLA_Status_Hours__c == null){
					SLARecord.Non_SLA_Satus__c = StatusString;
					SLARecord.Total_Non_SLA_Status_Hours__c = stageDuration;
					SLARecord.Total_Non_SLA_Status__c = (stageDuration/BusinessHoursPerDay).setscale(0);
				}
				else {
					SLARecord.Non_SLA_Satus__c += ', ' + StatusString;
					SLARecord.Total_Non_SLA_Status_Hours__c += stageDuration;
					SLARecord.Total_Non_SLA_Status__c = (SLARecord.Total_Non_SLA_Status_Hours__c/BusinessHoursPerDay).setscale(0);
				}
			}//End non-SLA status
		} // End for every status
		SLARecord.SLA__c = oli.Product2.SLA_Bus_Days__c;
		SLARecord.Total_SLA_Status_Hours__c = totalSLADuration;
		SLARecord.Total_SLA_Status__c = (totalSLADuration/BusinessHoursPerDay).setscale(0);		
		SLARecord.Product_Type__c = oli.Product2.SLA_Product_Type__c;
		SLARecord.Media_Partner__c = oli.Opportunity.Media_Partner_Name__c;
		SLARecord.Partner_Type__c = oli.Opportunity.Media_Partner__r.Partner_Type__c; 
		SLARecord.Business_Hours_per_Day__c = BusinessHoursPerDay;
		SLARecord.Opportunity_Product_Create_Date__c = oli.CreatedDate;
		SLARecord.Hours_To_Go_Live__c = getBusinessHoursDifference(oli.CreatedDate,LiveDate);
		SLARecord.Days_To_Go_Live__c = (SLARecord.Hours_To_Go_Live__c/BusinessHoursPerDay).setScale(0);
		if (SLARecord.In_Fulfillment_Hours__c == null || (SLARecord.In_Fulfillment_Hours__c/BusinessHoursPerDay) <= SLARecord.SLA__c){
			SLARecord.SLA_Met__c = 1;
		}
		else{
			SLARecord.SLA_Met__c = 0;
		}
		SLARecord.Live_Date__c = liveDate;
		SLARecord.Opportunity__c = oli.OpportunityId;
		SLARecord.Opportunity_Product__c	= oli.Id;
		SLARecord.Product__c	= oli.Product_Id__c;
		SLARecord.Count__c =1;
     SLARecord.ProjectRef__c = oli.Project__c;
		OLIDaysToLiveUpdated.put(oli.ID,integer.valueof(SLARecord.Total_SLA_Status__c));
		system.debug('ProductSLAServices.summarizeForSLA - Return the newly created Product_SLA__c Record.');
		return SLARecord;
	}
}