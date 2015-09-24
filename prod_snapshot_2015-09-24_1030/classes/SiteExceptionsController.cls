/**
 * 	Class Name			: SiteExceptionsController
 * 	Created By			: Vijay
 * 	Last Modified By	: Vijay
 * 	Description			: To Log site exceptions when redirected to CustomErrorPage VF
 */
public class SiteExceptionsController {
	
	/*
		Constructor Where we call 
	*/
	public SiteExceptionsController(){
		
	}
	
	/*
	   doLogError
	*/
	public void doLogError(){
		try{
			this.logSiteExceptions();
		}
		catch(Exception ex){
			System.debug('Handling exception to avoid any further redirection');
		}	
	}
	
	/*
	  Logs Site Variables
	  Logs UserInfo Variables
	  Logs HttpHeader Variables
	*/
	private void logSiteExceptions(){
		Map<String, String> siteApexVariables = new Map <String, String>();
		String errorStackTrace;
		
		//Site Apex Variables
		siteApexVariables.put('Site.getBaseUrl', Site.getBaseUrl());
		siteApexVariables.put('Site.getBaseCustomUrl', Site.getBaseCustomUrl());
		siteApexVariables.put('Site.getDomain', Site.getDomain());
		siteApexVariables.put('Site.getErrorDescription', Site.getErrorDescription());
		siteApexVariables.put('Site.getErrorMessage', Site.getErrorMessage());
		siteApexVariables.put('Site.getName', Site.getName());
		siteApexVariables.put('Site.getPathPrefix', Site.getPathPrefix());
		siteApexVariables.put('Site.getTemplate', String.ValueOf(Site.getTemplate()));
		siteApexVariables.put('Site.isLoginEnabled', String.ValueOf(Site.isLoginEnabled()));
		siteApexVariables.put('Site.isPasswordExpired', String.ValueOf(Site.isPasswordExpired()));
		siteApexVariables.put('Site.isRegistrationEnabled', String.ValueOf(Site.isRegistrationEnabled())); 
		
		errorStackTrace = JSON.serializePretty(siteApexVariables);
		siteApexVariables.clear();
		
		//User Variables
		siteApexVariables.put('UserInfo.getFirstName', UserInfo.getFirstName());
		siteApexVariables.put('UserInfo.getLastName', UserInfo.getLastName()); 
		siteApexVariables.put('UserInfo.getName', UserInfo.getName());
		siteApexVariables.put('UserInfo.getOrganizationName', UserInfo.getOrganizationName());
		siteApexVariables.put('UserInfo.getProfileId', UserInfo.getProfileId()); 
		siteApexVariables.put('UserInfo.getSessionId', UserInfo.getSessionId()); 
		siteApexVariables.put('UserInfo.getUserId', UserInfo.getUserId());
		siteApexVariables.put('UserInfo.getUserName', UserInfo.getUserName());
		siteApexVariables.put('UserInfo.getUserRoleId', UserInfo.getUserRoleId());
		siteApexVariables.put('UserInfo.getUserType', UserInfo.getUserType()); 
		
		errorStackTrace = errorStackTrace + '\n' + JSON.serializePretty(siteApexVariables);
		siteApexVariables.clear();
		
		//HTTP header Variables
		Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();
		siteApexVariables.put('HttpHeaders - Accept', mapHeaders.get('Accept'));
		siteApexVariables.put('HttpHeaders - Accept-Encoding', mapHeaders.get('Accept-Encoding'));
		siteApexVariables.put('HttpHeaders - Accept-Language', mapHeaders.get('Accept-Language'));
		siteApexVariables.put('HttpHeaders - Cache-Control', mapHeaders.get('Cache-Control'));
		siteApexVariables.put('HttpHeaders - CipherSuite', mapHeaders.get('CipherSuite'));
		siteApexVariables.put('HttpHeaders - Connection', mapHeaders.get('Connection'));
		siteApexVariables.put('HttpHeaders - Host', mapHeaders.get('Host'));
		siteApexVariables.put('HttpHeaders - Referer', mapHeaders.get('Referer'));
		siteApexVariables.put('HttpHeaders - User-Agent', mapHeaders.get('User-Agent'));
		siteApexVariables.put('HttpHeaders - X-Salesforce-Forwarded-To', mapHeaders.get('X-Salesforce-Forwarded-To'));  
		siteApexVariables.put('HttpHeaders - X-Salesforce-SIP', mapHeaders.get('X-Salesforce-SIP'));		
		
		errorStackTrace = errorStackTrace + '\n' + JSON.serializePretty(siteApexVariables);
		siteApexVariables.clear();
		
		ApplicationLogsModel.insertApplicationLog('\n Site Error Message : ' + Site.getErrorMessage() +
		                                          '\n Site Error Description : ' + Site.getErrorDescription(), 
												  errorStackTrace, 
												  '60', 
												  null, 'SiteExceptionsController', 
												  'logSiteExceptions', true, 
												  ApplicationLogsModel.Loglevel.Error);
	}
}