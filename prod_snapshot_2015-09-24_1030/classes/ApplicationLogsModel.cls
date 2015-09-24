/*
ApplicationLogs__c is the object to store and track error logs.  Because that there is no default salesforce logging mechanism to custom object.
We have to have a custom object to troubleshoot errors that comeup in production.

There is workflow rule created to notify users when there is an error caused in production.

There is a view created to list all application logs created for today.
*/
public without sharing class ApplicationLogsModel {
   
   /**
   	* inserts application log record in to Application_Log__c object
   	*
   	* @param errorMessage - errorMessage 
   	* @param errorStackTrace - errorStackTrace gives more details on cause of error 
   	* @param className - className where the error originated
   	* @param methodName - methodName where the error originated
   	* @param sendEmail - sends email from workflow
   	* @param logLevel - set the loglevel for log entry
    */
   @TestVisible
   public enum Loglevel { Error , Warn, Info }	
   public static list<ApplicationLogs__c> logList = new list<ApplicationLogs__c>(); //public to support the new trigger architechture
   public static integer numUnCommittedLogs = 0;  
   private static string transactionID = '';
   
   //Used for single inserts
   public static void insertApplicationLog(String errorMessage, String errorStackTrace, String lineNumber, 
 											  String SalesforceId, String className, String methodName, 
 											  Boolean sendEmail, Loglevel logLevel){
   	   ApplicationLogs__c newApplicationLog = createApplicationLog(errorMessage,errorStackTrace,lineNumber, 
				 											  SalesforceId, className, methodName, 
				 											  sendEmail, logLevel);
	   insert newApplicationLog;
   }
   
   /**
   	* create application log record , usefull to bulkify insert operations.
   	*
   	* @param errorMessage - errorMessage 
   	* @param errorStackTrace - errorStackTrace gives more details on cause of error 
   	* @param className - className where the error originated
   	* @param methodName - methodName where the error originated
   	* @param sendEmail - sends email from workflow
   	* @param logLevel - set the loglevel for log entry
    */
   private static ApplicationLogs__c createApplicationLog(String errorMessage, String errorStackTrace, String lineNumber, 
				 											  String SalesforceId, String className, String methodName, 
				 											  Boolean sendEmail, Loglevel logLevel){
		ApplicationLogs__c newApplicationLog = new ApplicationLogs__c();
		newApplicationLog.Error_Message__c = errorMessage;	 											  	
   	    newApplicationLog.StackTrace__c = errorStackTrace;
   	    newApplicationLog.Line_Number__c = lineNumber;
   	    newApplicationLog.SalesforceId__c = SalesforceId;
   	    newApplicationLog.Class_Name__c = className;
   	    newApplicationLog.Method_Name__c = methodName;
   	    newApplicationLog.Send_Email__c = sendEmail;
   	    if(logLevel!=null){
   	    	newApplicationLog.Log_Level__c = logLevel.name();
   	    }
   	    newApplicationLog.TransactionID__c = getTransactionID();
   	    return newApplicationLog;
   } 
   
   //Used to compile a list of Application Logs.
   public static void addLogs(String errorMessage, String errorStackTrace, String lineNumber, 
 											  String SalesforceId, String className, String methodName, 
 											  Boolean sendEmail, Loglevel logLevel){
   	   ApplicationLogs__c newApplicationLog = createApplicationLog(errorMessage,errorStackTrace,lineNumber, 
				 											  SalesforceId, className, methodName, 
				 											  sendEmail, logLevel);
	   logList.add(newApplicationLog);
	   numUnCommittedLogs = logList.size();	   
   }
   
   //Used to insert a pre-compiled list of Application Logs. Returns error message or 'Success'.
   public static string insertLogList(){
   	string message = '';
   	if (numUnCommittedLogs != 0)	{
   		try{
   			insert logList;
   			message = 'Success';
         //reset once inserted.
            numUnCommittedLogs = 0;
        	logList.clear();
   		}
   		catch (exception ex){
   			system.debug('ApplicationLogsModel.InsertLogList: Exception caught while inserting application log list' + ex.getMessage());
   			message = ex.getMessage();
   		}
   	}
   	else{
   		message = 'No logs found to insert';
   	}
   	return message;
   }
   
   //Set a transactionID if not yet set & returns the generated transaction id
   public static string getTransactionID()
   {
   		if (transactionID == ''){
   			Blob aes = Crypto.generateAesKey(128);
			transactionID = EncodingUtil.convertToHex(aes);
   		}
   	return transactionID;
   }
}