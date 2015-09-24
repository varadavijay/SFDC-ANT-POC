/*
	This class call MetadataService methods to update picklist values in salesforce
*/ 
public without sharing class MetadataServiceHelper {
	
	public class MetadataServiceHelperException extends Exception { }
	
	/*
	  Update picklist Values on Account Object using metadata API
	  Account.Account_Primary_Industry__c, Account.Account_Primary_Focus__c
	*/
	public static Map<String, String> updatePrimaryIndustryPiclistValues(String sessionId){
		MetadataService.CustomField customField;
		MetadataService.MetadataPort service = createService();
		if(service.SessionHeader.sessionId == null) {
			if(sessionId == null) {
				System.debug('Please provide sessionId');
				return null;
			}
			service.SessionHeader.sessionId = sessionId;
		}
		
		service.timeout_x = 120000; //Increasing the cumilative timeout to avoud IO Exception read time out error
		System.debug('Session Id >> ' + service.SessionHeader.sessionId );
		
		//AMP Call to query Primary Industry List	
		Map<String,String> listobjs = AMPRestService.getIndustryList();
		
		//Account.Account_PrimaryIndustry__c
		if(listobjs !=null && listobjs.size()>0){
			customField = readCustomField('Account.Account_Primary_Industry__c', service);
			
			System.debug('Custom Field Definition >> ' + customField);
			
			customField.picklist = getIndustryPicklist(listobjs);
			
			MetadataService.SaveResult[] results;
			try{
				//API Call to Update Picklistlist values
				results = service.updateMetadata(new List<MetadataService.Metadata> {customField});
				handleSaveResults(results[0]);
				
				//Setting up recordType Values
				MetadataService.RecordType productInfo = readRecordType('Account.SML_Company', service);
				
				MetadataService.RecordType updateProductInfo = new MetadataService.RecordType();
				updateProductInfo.active = productInfo.active;
				updateProductInfo.fullName = productInfo.fullName;
				updateProductInfo.label = productInfo.label;
				updateProductInfo.description = productInfo.description;
				
				MetadataService.RecordTypePicklistValue recordTypePickList = new MetadataService.RecordTypePicklistValue();
				recordTypePickList.picklist  =  customField.fullName.replace('Account.', '');
				recordTypePickList.values = customField.picklist.picklistValues;
				
				updateProductInfo.picklistValues = new List<MetadataService.RecordTypePicklistValue>{recordTypePickList};
				
				//API Call to update recordType Values 
				results = service.updateMetadata(new List<MetadataService.Metadata> {updateProductInfo});
				handleSaveResults(results[0]);
				
				return listobjs;
			} catch( System.Exception ex) {
		        System.debug('ERROR: '+ ex);
		        ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
															null, 'MetadataServiceHelper', 'updateIndustryPiclistValues', true, ApplicationLogsModel.Loglevel.Error);
			    throw ex;
		    }
			
		} else{
			System.debug('Something went wrong in MetadataServiceHelper.updateIndustryPiclistValues(): Check Application Logs Objects for details ');
	        ApplicationLogsModel.insertApplicationLog('Possible AMP Serive failure', 'Possible AMP Serive failure', null, 
														null, 'MetadataServiceHelper', 'updateIndustryPiclistValues', true, ApplicationLogsModel.Loglevel.Error);
		}
		return null;
	}
	
	/*
	  Update dependent picklist Values on Account Object using metadata API
	  Account.Account_Primary_Focus__c, Account.Account_Primary_Focus__c
	  eg: Auto , 30019
	*/
	public static void updatePrimaryFocusPiclistValues(MAp<String, List<String>> primaryFocusMap, String sessionId){
		MetadataService.CustomField customField;
		MetadataService.MetadataPort service = createService();
		if(service.SessionHeader.sessionId == null) {
			if(sessionId == null) {
				System.debug('Please provide sessionId');
				return;
			}
			service.SessionHeader.sessionId = sessionId;
		}
		
		service.timeout_x = 120000; //Increasing the cumilative timeout to avoud IO Exception read time out error
		System.debug('Session Id >> ' + service.SessionHeader.sessionId );
		
		customField = readCustomField('Account.Account_Primary_Focus__c', service);
		System.debug('Custom Field Definition >> ' + customField);
		
		customField.picklist = getFocusPicklist(primaryFocusMap);
		customField.picklist.controllingField = 'Account_Primary_Industry__c';
			
		MetadataService.SaveResult[] results;
		try{
			//API Call to Update Picklistlist values
			results = service.updateMetadata(new List<MetadataService.Metadata> {customField});
			handleSaveResults(results[0]);
			
			//Setting up recordType Values
			MetadataService.RecordType productInfo = readRecordType('Account.SML_Company', service);
			
			MetadataService.RecordType updateProductInfo = new MetadataService.RecordType();
			updateProductInfo.active = productInfo.active;
			updateProductInfo.fullName = productInfo.fullName;
			updateProductInfo.label = productInfo.label;
			updateProductInfo.description = productInfo.description;
			
			MetadataService.RecordTypePicklistValue recordTypePickList = new MetadataService.RecordTypePicklistValue();
			recordTypePickList.picklist  =  customField.fullName.replace('Account.', '');
			recordTypePickList.values = customField.picklist.picklistValues;
			
			updateProductInfo.picklistValues = new List<MetadataService.RecordTypePicklistValue>{recordTypePickList};
			
			//API Call to update recordType Values 
			results = service.updateMetadata(new List<MetadataService.Metadata> {updateProductInfo});
			handleSaveResults(results[0]);
			
			return;
		}catch( System.Exception ex) {
			System.debug('ERROR: '+ ex);
			ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
															null, 'MetadataServiceHelper', 'updatePrimaryFocusPiclistValues', true, ApplicationLogsModel.Loglevel.Error);
			throw ex;
		}
		return;
	}
	
	//get Focus list from AMP service and returns List of MetadataSerivce.PicklistValue 
	private static MetadataService.Picklist getFocusPicklist(MAp<String, List<String>> primaryFocusMap){
		List<MetadataService.PicklistValue> picklistValues = new list<metadataservice.PicklistValue>();
		for(String industryName: primaryFocusMap.KeySet()){
			List<String> listobjs = primaryFocusMap.get(industryName);
			if(listobjs != null && listobjs.size()>0){
			   	for (String categoryName: listobjs){
			   		metadataservice.PicklistValue picklistValue = new metadataservice.PicklistValue();
			    	picklistValue.fullName= categoryName;
					picklistValue.default_x=false ;
					picklistValue.controllingFieldValues = new List<String>{industryName};
			    	picklistValues.add(picklistValue);
			   	}
			}
		}
		
		MetadataService.Picklist picklist;
		if(picklistValues != null && picklistValues.size()>0){
		 	picklist = new MetadataService.Picklist();
		 	picklist.sorted= true;
		 	picklist.picklistValues = new list<MetadataService.PicklistValue>();
		 	picklist.picklistValues.addall(picklistValues);
		}
		return picklist;
	}
	
	//get Industry list from AMP service and returns List of MetadataSerivce.PicklistValue
	private static MetadataService.Picklist getIndustryPicklist(Map<String, String> listobjs){
		List<MetadataService.PicklistValue> picklistValues;
		
		if(listobjs<>null && listobjs.size()>0){
			picklistValues = new list<metadataservice.PicklistValue>();
		   	for (String categoryId: listobjs.keySet()){
		   		metadataservice.PicklistValue picklistValue = new metadataservice.PicklistValue();
		    	picklistValue.fullName= listobjs.get(categoryId);
				picklistValue.default_x=false ;
		    	picklistValues.add(picklistValue);
		   	}
		}
		
		MetadataService.Picklist picklist;
		if(picklistValues != null && picklistValues.size()>0){
		 	picklist = new MetadataService.Picklist();
		 	picklist.sorted= true;
		 	picklist.picklistValues = new list<MetadataService.PicklistValue>();
		 	picklist.picklistValues.addall(picklistValues);
		}
		
		return picklist;
	}
	
	
	
	//eg: Account.Alt_Direct_Phone__c CustomField
	private static MetadataService.CustomField readCustomField(String fieldName, MetadataService.MetadataPort service){ 
		 MetadataService.CustomField customField = 
					 						(MetadataService.CustomField) service.readMetadata('CustomField', 
														new String[] { fieldName }).getRecords()[0];
		 //returning back if customField is null
		 if(customField == null){
	        ApplicationLogsModel.insertApplicationLog('Couldnot find '+ fieldName +' custom field', 'Couldnot find '+ fieldName +' custom field', null, 
										null, 'MetadataServiceHelper', 'updateIndustryPiclistValues', true, ApplicationLogsModel.Loglevel.Error);
			return null;
		 }
		
		 //returning back if customField is null
		 if(customField.fullName == null){
	        ApplicationLogsModel.insertApplicationLog('Couldnot find '+ fieldName +' custom field', 'Couldnot find '+ fieldName +' custom field', null, 
										null, 'MetadataServiceHelper', 'updateIndustryPiclistValues', true, ApplicationLogsModel.Loglevel.Error);
			return null;
		 }
		 return customField;											
	}
	
	//eg: Account.SML_Company RecordType
	private static MetadataService.RecordType readRecordType(String recordTypeName, MetadataService.MetadataPort service){
		 MetadataService.RecordType recordTypeInfo = 
									(MetadataService.RecordType) service.readMetadata('RecordType', 
											new String[] { recordTypeName }).getRecords()[0]; 
							
		 //returning back if customField is null
		 if(recordTypeInfo == null){
	        ApplicationLogsModel.insertApplicationLog('Couldnot find '+ recordTypeName +' RecordType', 'Couldnot find '+ recordTypeName +' RecordType', null, 
										null, 'MetadataServiceHelper', 'readRecordType', true, ApplicationLogsModel.Loglevel.Error);
			return null;
		 }
		
		 //returning back if customField is null
		 if(recordTypeInfo.fullName == null){
	        ApplicationLogsModel.insertApplicationLog('Couldnot find '+ recordTypeName +' RecordType', 'Couldnot find '+ recordTypeName +' RecordType', null, 
										null, 'MetadataServiceHelper', 'readRecordType', true, ApplicationLogsModel.Loglevel.Error);
			return null;
		 }
		 return recordTypeInfo;							
	}
	
	//Returns instance of MetadataPort(Service object)
	private static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}
	
	/**
	 * Example helper method to interpret a SaveResult, throws an exception if errors are found
	**/
	private static void handleSaveResults(MetadataService.SaveResult saveResult)
	{
		// Nothing to see?
		if(saveResult==null || saveResult.success)
			return;
		// Construct error message and throw an exception
		List<String> messages = new List<String>();
		messages.add(
			(saveResult.errors.size()==1 ? 'Error ' : 'Errors ') + 
				'occured processing component ' + saveResult.fullName + '.');
		for(MetadataService.Error error : saveResult.errors)
			messages.add(
				error.message + ' (' + error.statusCode + ').' + 
				( error.fields!=null && error.fields.size()>0 ? 
					' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
		if(messages.size()>0){
			 MetadataServiceHelperException metadataException = new MetadataServiceHelperException(String.join(messages, ' '));
			 ApplicationLogsModel.insertApplicationLog(metadataException.getMessage(), metadataException.getStackTraceString(), String.valueOf(metadataException.getLineNumber()), 
														null, 'MetadataServiceHelper', 'handleSaveResults', true, ApplicationLogsModel.Loglevel.Error);
			throw metadataException;
		}
	}
}