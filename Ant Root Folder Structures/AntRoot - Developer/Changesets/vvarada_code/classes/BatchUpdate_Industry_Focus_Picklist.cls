// Note - when using the start method with QueryLocator, you must define the interface with 
// sObject instead of a specific type 

global class BatchUpdate_Industry_Focus_Picklist 
						implements Database.Batchable<sObject>, Database.AllowsCallouts, 
									Database.Stateful{
	public String sessionId;
    private List<sObject> applicationLogs;
    private Map<String, List<String>> primaryFocusMap; 
    private boolean hasAmpCallFailed = false;
    public String sObjectName;
	public String primaryIndustryAPIField;
	public String primaryFocusAPIField;
	public Set<String> recordTypeAPINames ;
	
    global class MetadataAPIBatchException extends Exception { }
     
   	global BatchUpdate_Industry_Focus_Picklist(){
   		
   	}
   
   	global List<sObject> start(Database.BatchableContext BC){
   		System.debug('Inside BatchUpdate_Industry_Focus_Picklist Start method '  + applicationLogs);
   		
   		//Handle session = null to proceed furthur
   		if(this.sessionId == null){
   			System.debug ('SessionId is blank, Please provide session Id to the batch constructor ');
   			this.hasAmpCallFailed=true;
			MetadataAPIBatchException metadataException = new MetadataAPIBatchException('SessionId is blank, Please provide session Id to the batch constructor ');
	   		throw metadataException;
			return null;
   		}
   		
   		//Metadata API to update picklist values and corresponding recordtype values for primary Industry
   		MetadataServiceHelper.sObjectName = sObjectName;
   		MetadataServiceHelper.primaryIndustryAPIField = primaryIndustryAPIField;
   		MetadataServiceHelper.primaryFocusAPIField = primaryFocusAPIField;
   		MetadataServiceHelper.recordTypeAPINames = recordTypeAPINames;
   		
   		Map<String, String> primaryIndustryMap = MetadataServiceHelper.updatePrimaryIndustryPiclistValues(this.sessionId);
			
		if(!(primaryIndustryMap != null && primaryIndustryMap.size()>0)){
			System.debug ('Something went wrong and primary industry list is blank >> ' + primaryIndustryMap);
			this.hasAmpCallFailed=true;
			MetadataAPIBatchException metadataException = new MetadataAPIBatchException('Something went wrong and primary industry list is blank >> ' + primaryIndustryMap);
	   		throw metadataException;
			return null;
		}
		
		this.applicationLogs = new List<sObject>();	
		for(String industryId: primaryIndustryMap.keySet()){
		    ApplicationLogs__c oneApplicationLog = new ApplicationLogs__c();
		    oneApplicationLog.Name = primaryIndustryMap.get(industryId) + '_' + industryId;
			this.applicationLogs.add(oneApplicationLog);    
		}
		
		System.debug('Here is the list of application Logs created based on Industry List >> '  + applicationLogs);
		return this.applicationLogs;
   	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope){
	   	System.debug('** Start BatchUpdate_Industry_Focus_Picklist execute method **' + scope);
	   	
	   	if (!(scope !=null && scope.size()>0)){
	   		//returning back as the scope in empty
	   		return;
	   	}
	   	
	   	//Batch Size of more than 1 are not allowed
	   	if(scope.size()>1){
	   		this.hasAmpCallFailed=true;
	   		MetadataAPIBatchException metadataException = new MetadataAPIBatchException('Batche size more than 1 arenot allowed');
	   		throw metadataException;
	   		return;
	   	}
	   	
	   	for(ApplicationLogs__c applicationLog : (List<ApplicationLogs__c>) scope){
		   	String[] splitString = applicationLog.Name.split('_');	   
		    applicationLog.Log_Level__c = ApplicationLogsModel.Loglevel.Info.name();
		   	applicationLog.Class_Name__c = 'BatchUpdate_Industry_Focus_Picklist';
		   	applicationLog.Method_Name__c = 'execute method';
		   	applicationLog.Error_Message__c = 'Refreshed Primary Focus Picklist from AMP sucessfully for >> ' + applicationLog.Name;
		   	
		   	if(this.primaryFocusMap==null){
		   		this.primaryFocusMap = new Map<String, List<String>>();
		   	}
		  
		   	//AMP Call to query Primary Focust List	
			Map<String,String> listobjs = AMPRestService.getFocusByIndustry(splitString[1]);
			if(!(listobjs!=null && listobjs.size()>0)){
				this.hasAmpCallFailed=true;
				MetadataAPIBatchException metadataException = new MetadataAPIBatchException('AMP Service call failed to retrive primary focus list for category >> ' + applicationLog.Name);
		   		throw metadataException;
		   		return;
			}
			
			//Ignore if the atleast 1 execute call fails with exception
			if(!this.hasAmpCallFailed){
				this.primaryFocusMap.put(splitString[0], listobjs.values());
			}
	   	}
		insert scope;
		
	   	System.debug('** End BatchUpdate_Industry_Focus_Picklist execute method **');
   	}

   	global void finish(Database.BatchableContext BC){
   		System.debug('Has AMP Call failes atleast once to retrieve primary focus >> ' + this.hasAmpCallFailed);
   		if(!this.hasAmpCallFailed){
   			System.debug ('Map of Primary Focus Values >> ' + this.primaryFocusMap);
   			//Metadata API Call to update picklist values and corresponding recordtype values for primary focus
   			MetadataServiceHelper.sObjectName = sObjectName;
	   		MetadataServiceHelper.primaryIndustryAPIField = primaryIndustryAPIField;
	   		MetadataServiceHelper.primaryFocusAPIField = primaryFocusAPIField;
   			MetadataServiceHelper.recordTypeAPINames = recordTypeAPINames;
	   		MetadataServiceHelper.updatePrimaryFocusPiclistValues(this.primaryFocusMap, this.sessionId);
   		}
   		System.debug ('Finished Processing all Bacthes ');
   	}
}