/*
		// Name: BatchProductSLARecalculation.cls
		// Date Created: 9/22/2014 (CRM Sprint 1.0.21)
		// Purpose: Built to update Product SLA in batches
		// Objects affected: Product_SLA__c
		// Used by: Execute Annonymous
		
		
		Usage: 
			
			//Before running this, take backup of related ProductSLA records if applicable, 
			// Deactivate Canceled Project Alert: https://na10.salesforce.com/01QF0000000Q7oQ
			
			//To only recalculate the product SLA for certain OLI.
			string query = 'Select id from OpportunityLineItem where ID in (\'00kM0000006vltEIAQ\',\'00kM0000006vFu2IAE\')';
			system.debug('Execute Annonymous: ' + query);
			integer batchsize = 10;
			ID batchInstanceId = Database.executeBatch(new batchProductSLARecalculation(query),batchsize); 
			system.debug('ID: ' + batchInstanceId );
			
			OR
			
			//Execute the following after setting the Custom Settings for SLA_Related_Filters__c.name = 'BatchProductSLARecalculationFilters'
			batchProductSLARecalculation processSLAusingCustomSettings = new batchProductSLARecalculation();
			integer batchsize = 10; 
			ID batchInstanceId = Database.executeBatch(processSLAusingCustomSettings,batchsize);						
			system.debug('ID: ' + batchInstanceId );
*/

//This is built to be called from Execute Annonymous right now, but can be scheduled later.
// This is used to recalculate a list of Product SLA records.  Contructors are overloaded to:
//					1. Retrieve a list of OLI based on Custom Settings & Recalcuate the related ProductSLA
//					2. Retrieve a list of OLI based on a user-defined query & Recalcualte the related Product SLA
public class BatchProductSLARecalculation implements Database.Batchable<sObject>{
private string stringForQueryLocator;	
public final LIST<OpportunityLineItem> OLIListToUpdate;
public final SLA_Related_Filters__c filterSettings;

	/* 		Overloaded Constructors 		
			------------------------
	*/		
	// 1. Constructor to Retrieve a list of OLI based on Custom Settings & Recalcuate the related ProductSLA
	public BatchProductSLARecalculation()
	{
		system.debug('BatchProductSLARecalculation: Entering batchProductSLARecalculation()');
		try
		{
			//Get the filter settings from the custom settings.
			list<SLA_Related_Filters__c> filterSettingsList = [	SELECT 	Live_After__c, 
																		Live_Before__c,
																		Live_Status__c,
																		Opportunity_Product_Created_After__c,
																		Opportunity_Product_Created_Before__c,
																		Product_Filters__c 
																 FROM SLA_Related_Filters__c
																 WHERE Name = 'BatchProductSLARecalculationFilters'
																 AND   Is_Active__c = true];
			system.debug('BatchProductSLARecalculation.batchProductSLARecalculation(): Number of custom settings found: ' + filterSettingsList.size());
				if (filterSettingsList.size()== 0 || filterSettingsList == null)
				{
                    throw new notFoundException('No active filters found named BatchProductSLARecalculationFilters for SLA Related Filters');
                }
				filterSettings = filterSettingsList[0];						
				LIST<string> liveStatusFilterString = new LIST<string>();
				if (filterSettings.Live_Status__c != null)
				{
					filterSettings.Live_Status__c = filterSettings.Live_Status__c.replace(', ', ',');
			        filterSettings.Live_Status__c = filterSettings.Live_Status__c.replace(' ,', ',');
			        liveStatusFilterString = filterSettings.Live_Status__c.split(',',100000);	
				}					
				LIST<string> productIDs = new LIST<string>();
				if ( filterSettings.Product_Filters__c != null)
				{
					filterSettings.Product_Filters__c = filterSettings.Product_Filters__c.replace(', ', ',');
			        filterSettings.Product_Filters__c = filterSettings.Product_Filters__c.replace(' ,', ',');
			        productIDs = filterSettings.Product_Filters__c.split(',',100000);
				}						
				string query = 		'SELECT ID ';
				query += 			'FROM OpportunityLineItem  ';
				query += 			'WHERE Waiting_Status__c IN ';
				for (integer i=0;i<liveStatusFilterString.size();i++)
				{
					if (i==0)
					{
						query += 	'(\'' + liveStatusFilterString[i] ;
					}
					else
					{
						query += 	'\',\'' + liveStatusFilterString[i] ;
					}
				}
				query += 	'\')';
				if (filterSettings.Live_After__c != null)
				{
					query += 			'AND Live_Date__c >= ' + string.valueof(filterSettings.Live_After__c) + 'T00:00:00z ';
				}
				if (filterSettings.Live_Before__c != null)
				{
					query += 			'AND Live_Date__c <= ' + string.valueof(filterSettings.Live_Before__c) + 'T00:00:00z ';
				}
				if (filterSettings.Opportunity_Product_Created_After__c != null)
				{
					query += 			'AND CreatedDate >= ' + string.valueof(filterSettings.Opportunity_Product_Created_After__c) + 'T00:00:00z ';
				}
				if (filterSettings.Opportunity_Product_Created_Before__c != null)
				{
					query += 			'AND CreatedDate <= ' + string.valueof(filterSettings.Opportunity_Product_Created_Before__c) + 'T00:00:00z ';
				}
				if (productIDs.size() > 0)
				{
					query += 			'AND Product2Id in  ';
					for (integer i=0;i<productIDs.size();i++)
					{
						if (i==0)
						{
							query += 	'(\'' + productIDs[i] ;
						}
						else
						{
							query += 	'\',\'' + productIDs[i] ;
						}
					}
					query += 	'\')';
				}
				system.debug('BatchProductSLARecalculation.batchProductSLARecalculation: Query built: ' + query);
				getRelatedOLIList(query);
		}
		catch (Exception ex)
		{
			system.debug('BatchProductSLARecalculation.batchProductSLARecalculation() Exception: ' + ex.getMessage());
		}
	}
	
	// 2. Constructor to retrieve a list of OLI based on a user-defined query & Recalcualte the related Product SLA
	public BatchProductSLARecalculation(string query)
	{
		system.debug('BatchProductSLARecalculation: Entering batchProductSLARecalculation with Query: ' + query);
		getRelatedOLIList(query);
	}	
	
	/* 		constructor action methods 		
			---------------------------
	*/
	
	// Executes query set by Constructor the constructors
	private void getRelatedOLIList (string query)
	{
		system.debug('BatchProductSLARecalculation: Entering getRelatedOLIList with query: ' + query);
		stringForQueryLocator = query;		
	}

	
	/* 		Batch Functions
			---------------
	*/
	// Sets the scope for execution.
	public Database.QueryLocator start(Database.BatchableContext bc)
	{ 
		system.debug('BatchProductSLARecalculation: Entering start.');
		Database.QueryLocator ql = Database.getQueryLocator(stringForQueryLocator); 
		system.debug('BatchProductSLARecalculation.start: Returning # of records: ');
       	return ql; 
   	} 
   	
   	// Calls the recalcualtion process for the OLI List set in the constructors
   	public void execute (Database.BatchableContext bc, LIST<OpportunityLineItem> scope)
   	{
   		system.debug('BatchProductSLARecalculation: Entering start.');
   		set<ID> OLISet = new set<ID>(); 
   		for (opportunityLineItem oli: scope)
   		{
   			OLISet.add(oli.ID);
   		}   		
   		ProductSLAServices.callProcessLiveOLIforBatch(OLISet);
   	}
   	
   	// Once finished, set custom settings to inactive so it won't be accidentally picked up next time.
   	public void finish (Database.BatchableContext bc)
   	{
   		//If the batch job used custom settings, reset the isActive flag to 'No'.
   		if (filterSettings != null)
   		{
   			try 
   			{   		
	   			filterSettings.Is_Active__c = false;
	   			update filterSettings;
   			}
   			catch (exception ex)
	   		{
	   			system.debug('BatchProductSLARecalculation.finish: ' + ex.getMessage());
	   		}
   		}
   		
   	}
    
    //Throw exceptions when queries don't return records needed for further processing.
    public class notFoundException extends Exception{}
	
}