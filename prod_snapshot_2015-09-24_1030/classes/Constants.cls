/*********************************************************************************************
 * This class provides access to anything considered a constant in the system. This includes 
 * "psuedo constants" - Database values which are considered constants for programatic reasons.
 * An example would be a default/dummy User to assign things to. 
 *
 * This Class also provides the load() functionality to get the psuedo constants into the DB.
 *
 * For convenience in looking up Hard-Coded ID's The Production ones are listed here. Note
 * that for RecordTypes and Profiles, They are not using this Constants file as the mechanism,
 * but rather their respective caches, but it's good to have all them in one place while the
 * Test CLass rework is being done.
 *
 * ID					Type				Identifier
 * ------------------	-----------------	--------------------------------
 * 005A0000000cnyO		User				Constants.GANNETT_LOCAL_USER.Id
 * 005A0000001XYV5		User				Constants.GANNETT_LOCAL_USER.Id	//Actually GL Intern - but replace with System above
 * 005A0000001Wlbj		User				Constands.SALESFORCE_ADMINISTRATION.Id //Salesforce Administration
 * 005F0000001yXRe		User				Constants.STALE_OPPORTUNITY.Id
 * 00GF0000002IIl3		Group				Constants.OPEN_ACQ_LEADS_QUEUE.Id
 * 00GA0000000UfcFMAS	Group				Constants.NEW_LEAD_QUEUE.Id
 * 003F000000y4o1V		Contact				Constants.NOT_IN_LIST_CONTACT.id 
 * 001A000000QTk0g		Account				Constants.GANNETT_LOCAL_COMPANY.Id
 * 001F000000gfrcZIAQ	Account				Constants.AZ_REPUBLIC_COMPANY.Id
 * 012F0000000y9gDIAQ	RecordType			RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
 * 012A0000000PKO9IAO	RecordType			RecordTypeCache.getRecordType('Account', 'SML_Company').Id
 * 012F0000000y9WcIAI	RecordType			RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id
 * 012F0000000y9WmIAI	RecordType			RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id
 * 012A0000000PKOI		RecordType			RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id
 * 012F0000000y9rkIAA	RecordType			RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id
 * 012F0000000yFCEIA2	RecordType			RecordTypeCache.getRecordType('Opportunity', 'DealChicken_Merchandise').Id
 * 012F0000000y9lD		RecordType			RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id
 * 012A0000000PKO8IAO	RecordType			RecordTypeCache.getRecordType('Lead', 'SML_Lead').Id
 * 012A0000000PUkx		RecordType			RecordTypeCache.getRecordType('Payment_Processing__c','Credit_Card_Processing').Id
 * 00eA0000000YSjsIAG	Profile				ProfileCache.getProfile('System Administrator').Id
 * a1FF0000000Qq3P		KPIRep__c			Constants.GANNETT_LOCAL_KPI_REP.Id
 * a1GF0000000IzBb		KPICalender__c		Constants.KPI_CAL_20111226.Id	// Dec 26, 2011
 * a1GF0000000IzBb		KPICalender__c		Constants.KPI_CAL_20121031.Id	// Oct 31, 2012
 * a1GF0000000JJya		KPICalender__c		Constants.KPI_CAL_20130605.Id	// Jun 5, 2013
 * 01sA0000000L68a		PriceBook2			Constants.STANDARD_PRICEBOOK.Id
 *
 *********************************************************************************************
 */
 
public with sharing class Constants {

	// This variable is for testing only
	@TestVisible private static Boolean dataAlreadyLoaded = false;


	// True Constants go here
	public static final String GANNETT_LOCAL_SF_USERNAME = 'gl.system@gannett.com';
	public static final String SALESFORCE_ADMINISTRATION_SF_USERNAME = 'neil.wingate@gannett.com'; 
	public static final String STALE_OPPORTUNITY_SF_USERNAME = 'stale.opps@gannett.com';
	public static final String OPEN_ACQ_LEADS_QUEUENAME = 'Open Acq Leads';
	public static final String NEW_LEAD_QUEUENAME = 'New Lead Queue';
	public static final String PROD_ADMIN_PROFILE_NAME = 'Production Administrator';
	public static final String NOT_IN_LIST_CONTACT_NAME = 'Not In List';
	public static final String AZ_REPUBLIC_COMPANY_NAME = 'Arizona Republic, Phoenix AZ';
	//public static final String GANNETT_LOCAL_COMPANY_NAME = 'Gannett Local, Phoenix AZ'; 
	public static final String GO_DIGITAL_COMPANY_NAME = 'G/O Digital, Phoenix AZ'; //Branded version of Gannett Local
	public static final String GANNETT_LOCAL_KPI_NAME = 'Gannett Local';
	public static final String PRODUCTION_ORGID_LONG = '00DA0000000HEOtMAO'; //UserInfo.getOrganizationId() returns this one
	public static final String PRODUCTION_ORGID_SHORT = '00DA0000000HEOt';
	
	public static final String KPI_CAL_20111226_NAME = '12/26/2011';
	public static final String KPI_CAL_20121031_NAME = '10/31/2012';
	public static final String KPI_CAL_20130605_NAME = '6/5/2013';
	public static final String STANDARD_PRICEBOOK_NAME = 'Standard Price Book';
	public static final Integer LEAD_TRANSFER_MIN_AGE = 11; //Rules of Engagement
	public static final Integer OPPORTUNITY_TRANSFER_MIN_AGE = 31;
	
	//Pseudo-constants which query the DB, should be lazy loaded through their get method
	
	// IsProd compares against the Prod OrgId - no lazy loading needed
	public static boolean IS_PRODUCTION {
		get {
			return ( UserInfo.getOrganizationId() == PRODUCTION_ORGID_LONG );
		}
	}
	
	// "Gannett Local" User. Used as a default in places where User can't be determined
	private static User pGANNETT_LOCAL_USER = null;
	
	public static User GANNETT_LOCAL_USER {
		get{
			if (pGANNETT_LOCAL_USER == null){
				try{
					String usernameSearchPattern = GANNETT_LOCAL_SF_USERNAME + '%';
					// UserName is unique
					List<User> gannettLocals = [SELECT id, Name, userName FROM User WHERE userName like :usernameSearchPattern];
					if (gannettLocals != null && gannettLocals.size() > 0){
						pGANNETT_LOCAL_USER = gannettLocals[0];
					}
					else {
						// This shouldn't happen for Users - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load GANNETT_LOCAL_USER - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id, Name, userName FROM User WHERE userName like ' + usernameSearchPattern);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load GANNETT_LOCAL_USER = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed or 
			// we got an exception ... in all cases now we can return the private static
			return pGANNETT_LOCAL_USER;
			
		} // get()
	} // GANNETT_LOCAL_USER property
	
	
	// "Salesforce Administration" User. Used as a default in places where User can't be determined
	private static User pSALESFORCE_ADMINISTRATION = null;
	
	public static User SALESFORCE_ADMINISTRATION {
		get{
			if (pSALESFORCE_ADMINISTRATION == null){
				try{
					String usernameSearchPattern = SALESFORCE_ADMINISTRATION_SF_USERNAME + '%';
					// UserName is unique
					List<User> gannettLocals = [SELECT id, Name, userName FROM User WHERE userName like :usernameSearchPattern];
					if (gannettLocals != null && gannettLocals.size() > 0){
						pSALESFORCE_ADMINISTRATION = gannettLocals[0];
					}
					else {
						// This shouldn't happen for Users - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load SALESFORCE_ADMINISTRATION - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id, Name, userName FROM User WHERE userName like ' + usernameSearchPattern);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load SALESFORCE_ADMINISTRATION = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed or 
			// we got an exception ... in all cases now we can return the private static
			return pSALESFORCE_ADMINISTRATION;
			
		} // get()
	} // SALESFORCE_ADMINISTRATION property
	// 
	private static User pSTALE_OPPORTUNITY = null;
	
	public static User STALE_OPPORTUNITY {
		get{
			if (pSTALE_OPPORTUNITY == null){
				try{
					String usernameSearchPattern = STALE_OPPORTUNITY_SF_USERNAME + '%';
					// UserName is unique
					List<User> staleOpps = [SELECT id, Name, userName FROM User WHERE userName like :usernameSearchPattern];
					if (staleOpps != null && staleOpps.size() > 0){
						pSTALE_OPPORTUNITY = staleOpps[0];
					}
					else {
						// This shouldn't happen for Users - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load STALE_OPPORTUNITY - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id, Name, userName FROM User WHERE userName like ' + usernameSearchPattern);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load STALE_OPPORTUNITY = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed or 
			// we got an exception ... in all cases now we can return the private static
			return pSTALE_OPPORTUNITY;
			
		} // get()
	} // STALE_OPPORTUNITY property
	
	// 
	private static Group pOPEN_ACQ_LEADS_QUEUE = null;
	
	public static Group OPEN_ACQ_LEADS_QUEUE {
		get{
			if (pOPEN_ACQ_LEADS_QUEUE == null){
				try{
					// Assuming Type and Name combo is unique
					List<Group> openAcqLeadsQueue = [SELECT id, Name FROM Group WHERE Type = 'queue' and name = :OPEN_ACQ_LEADS_QUEUENAME];
					if (openAcqLeadsQueue != null && openAcqLeadsQueue.size() > 0){
						pOPEN_ACQ_LEADS_QUEUE = openAcqLeadsQueue[0];
					}
					else {
						// This shouldn't happen for Users - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load OPEN_ACQ_LEADS_QUEUE - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id, Name FROM Group WHERE Type = queue and name = ' + OPEN_ACQ_LEADS_QUEUENAME);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load OPEN_ACQ_LEADS_QUEUE = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed or 
			// we got an exception ... in all cases now we can return the private static
			return pOPEN_ACQ_LEADS_QUEUE;
			
		} // get()
	} // OPEN_ACQ_LEADS_QUEUE property
	
	private static Group pNEW_LEAD_QUEUE = null;
	public static Group NEW_LEAD_QUEUE {
		get{
			if (pNEW_LEAD_QUEUE == null){
				try{
					// Assuming Type and Name combo is unique
					List<Group> openAcqLeadsQueue = [SELECT id, Name FROM Group WHERE Type = 'queue' and name = :NEW_LEAD_QUEUENAME];
					if (openAcqLeadsQueue != null && openAcqLeadsQueue.size() > 0){
						pNEW_LEAD_QUEUE = openAcqLeadsQueue[0];
					}
					else {
						// This shouldn't happen for Users - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load NEW_LEAD_QUEUE - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id, Name FROM Group WHERE Type = queue and name = ' + NEW_LEAD_QUEUENAME);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load NEW_LEAD_QUEUE = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed or 
			// we got an exception ... in all cases now we can return the private static
			return pNEW_LEAD_QUEUE;
			
		} // get()
	} // NEW_LEAD_QUEUE property
	
	// "Gannett Local" KPIRep. Used as a default in places where KPIRep can't be determined. Based on Gannett Local User
	private static KPIRep__c pGANNETT_LOCAL_KPI_REP = null;
	
	public static KPIRep__c GANNETT_LOCAL_KPI_REP {
		get{
			if (pGANNETT_LOCAL_KPI_REP == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<KPIRep__c> gannettLocalKPIReps = [SELECT id, Name FROM KPIRep__c WHERE User__c = :GANNETT_LOCAL_USER.Id];
					if (gannettLocalKPIReps != null && gannettLocalKPIReps.size() > 0){
						System.debug('Found Gannett Local KPIRep in DB ... Returning it');
						pGANNETT_LOCAL_KPI_REP = gannettLocalKPIReps[0];
					}
					else {
						// Data hasn't been loaded in this Org yet. 
						System.debug('Gannett Local KPIRep not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load pGANNETT_LOCAL_KPI_REP = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pGANNETT_LOCAL_KPI_REP;
			
		} // get()
	} // GANNETT_LOCAL_KPI_REP property
	
	// 10/31/2012 KPICalender. Used as a default in places
	private static KPICalender__c pKPI_CAL_20121031 = null;
	
	public static KPICalender__c KPI_CAL_20121031 {
		get{
			if (pKPI_CAL_20121031 == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<KPICalender__c> KPICals = [SELECT id, Name, Date__c, Period__c FROM KPICalender__c WHERE Name = :KPI_CAL_20121031_NAME];
					if (KPICals != null && KPICals.size() > 0){
						System.debug('Found 10/31/2012 KPICalender in DB ... Returning it');
						pKPI_CAL_20121031 = KPICals[0];
					}
					else {
						// Data hasn't been loaded in this Org yet. 
						System.debug('10/31/2012 KPICalender not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load KPI_CAL_20121031 = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pKPI_CAL_20121031;
			
		} // get()
	} // KPI_CAL_20121031 property
	
	// 12/26/2011 KPICalender. Used as a default in places
	private static KPICalender__c pKPI_CAL_20111226 = null; 
	
	public static KPICalender__c KPI_CAL_20111226 {
		get{
			if (pKPI_CAL_20111226 == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<KPICalender__c> KPICals = [SELECT id, Name, Date__c, Period__c FROM KPICalender__c WHERE Name = :KPI_CAL_20111226_NAME];
					if (KPICals != null && KPICals.size() > 0){
						System.debug('Found 12/26/2011 KPICalender in DB ... Returning it');
						pKPI_CAL_20111226 = KPICals[0];
					}
					else {
						// Data hasn't been loaded in this Org yet. 
						System.debug('12/26/2011 KPICalender not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load KPI_CAL_20121031 = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pKPI_CAL_20111226;
			
		} // get()
	} // KPI_CAL_20121031 property
	
	
	// 6/5/2013 KPICalender. Used as a default in places
	private static KPICalender__c pKPI_CAL_20130605 = null;
	
	public static KPICalender__c KPI_CAL_20130605 {
		get{
			if (pKPI_CAL_20130605 == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<KPICalender__c> KPICals = [SELECT id, Name, Date__c, Period__c FROM KPICalender__c WHERE Name = :KPI_CAL_20130605_NAME];
					if (KPICals != null && KPICals.size() > 0){
						System.debug('Found 6/5/2013 KPICalender in DB ... Returning it');
						pKPI_CAL_20130605 = KPICals[0];
					}
					else {
						// Data hasn't been loaded in this Org yet. 
						System.debug('6/5/2013 KPICalender not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load KPI_CAL_20130605 = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pKPI_CAL_20130605;
			
		} // get()
	} // KPI_CAL_20130605 property
	

	// NOT_IN_LIST_CONTACT. Used as a default in places
	private static Contact pNOT_IN_LIST_CONTACT = null;
	
	public static Contact NOT_IN_LIST_CONTACT {
		get{
			if (pNOT_IN_LIST_CONTACT == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<Contact> Contacts = [SELECT id, Name FROM Contact WHERE Name = :NOT_IN_LIST_CONTACT_NAME];
					if (Contacts != null && Contacts.size() > 0){
						System.debug('Found NOT_IN_LIST_CONTACT in DB ... Returning it');
						pNOT_IN_LIST_CONTACT = Contacts[0];
					}
					else {
						// Data hasn't been loaded in this Org yet. 
						System.debug('NOT_IN_LIST_CONTACT not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load NOT_IN_LIST_CONTACT = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pNOT_IN_LIST_CONTACT;
			
		} // get()
	} // NOT_IN_LIST_CONTACT property

	// Standard Price Book
	private static Pricebook2 pSTANDARD_PRICEBOOK  = null;
	
	public static Pricebook2 STANDARD_PRICEBOOK {
		get{
			if (pSTANDARD_PRICEBOOK == null){
				try{
					// UserName is unique accross all orgs, so we are guaranteed to get 1 or 0 results
					List<Pricebook2> pricebooks = [SELECT id,
														  Name,
														  Description,
														  IsStandard,
														  IsActive
												   FROM Pricebook2
												   WHERE Name = :STANDARD_PRICEBOOK_NAME];
					if (pricebooks != null && pricebooks.size() > 0){
						System.debug('Found Standard Price Book in DB ... Returning it');
						pSTANDARD_PRICEBOOK = pricebooks[0];
					}
					else {
						// This shouldn't happen for Pricebook2 - they are pulled down with the refresh
						system.debug(loggingLevel.WARN, 'Failed to load STANDARD_PRICEBOOK - Need to investigate!');
						system.debug(loggingLevel.WARN, 'Query = SELECT id,Name,Description,IsStandard,IsActive FROM Pricebook2 WHERE Name = ' + STANDARD_PRICEBOOK_NAME);
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load STANDARD_PRICEBOOK = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pSTANDARD_PRICEBOOK;
			
		} // get()
	} // STANDARD_PRICEBOOK property
	
	
	// "Az Republic" Company.
	static private Account pAZ_REPUBLIC_COMPANY = null;
	
	public static Account AZ_REPUBLIC_COMPANY {
		get{
			if (pAZ_REPUBLIC_COMPANY == null){
				System.debug('AZ Republic Account, not in cache, trying DB');
				try{
					List<Account> azRepAccts = [SELECT id, Name FROM Account WHERE Name = :AZ_REPUBLIC_COMPANY_NAME];
					if (azRepAccts != null && azRepAccts.size() > 0 ){
						System.debug('Found AZ Republic Comapny in DB ... Returning it');
						pAZ_REPUBLIC_COMPANY = azRepAccts[0];
					}
					else {
						
						// Data hasn't been loaded in this Org yet. 
						System.debug('AZ Republic Comapny not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load AZ_REPUBLIC_COMPANY = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pAZ_REPUBLIC_COMPANY;
			
		} // get()
	} // AZ_REPUBLIC_COMPANY property
	
/***********  Force code that references this to fail
	// "Gannett Local" Company.
	static private Account pGANNETT_LOCAL_COMPANY = null;
	
	public static Account GANNETT_LOCAL_COMPANY {
		get{
			if (pGANNETT_LOCAL_COMPANY == null){
				System.debug('Gannett Local Account, not in cache, trying DB');
				try{
					List<Account> glAccts = [SELECT id, Name FROM Account WHERE Name = :GANNETT_LOCAL_COMPANY_NAME];
					if (glAccts != null && glAccts.size() > 0 ){
						System.debug('Found Gannett Local Comapny in DB ... Returning it');
						pGANNETT_LOCAL_COMPANY = glAccts[0];
					}
					else {
						
						// Data hasn't been loaded in this Org yet. 
						System.debug('Gannett Local Comapny not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load GANNETT_LOCAL_COMPANY = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pGANNETT_LOCAL_COMPANY;
			
		} // get()
	} // GANNETT_LOCAL_COMPANY property
***********/
	
	// "G/O Digital" Company.
	static private Account pGO_DIGITAL_COMPANY = null;
	
	public static Account GO_DIGITAL_COMPANY {
		get{
			if (pGO_DIGITAL_COMPANY == null){
				System.debug('G/O Digital Account, not in cache, trying DB');
				try{
					List<Account> goAccts = [SELECT id, Name FROM Account WHERE Name = :GO_DIGITAL_COMPANY_NAME];
					if (goAccts != null && goAccts.size() > 0 ){
						System.debug('Found G/O Digital Comapny in DB ... Returning it');
						pGO_DIGITAL_COMPANY = goAccts[0];
					}
					else {
						
						// Data hasn't been loaded in this Org yet. 
						System.debug('G/O Digital Comapny not in DB ... Run "Constants.loadData();" from an Execute Anonymous window');
					}
				}
				catch (Exception ex){
					string ErrorMsg = 'Exception Caught while trying to load GO_DIGITAL_COMPANY = ';
					ErrorMsg += ex.getTypeName() + ' : ' + ex.getMessage();
					system.debug(loggingLevel.ERROR, ErrorMsg);
				}
			} // lazy-load null check
			
			// at this point, whether we had to load it or it already existed, or it failed twice or 
			// we got an exception ... in all cases now we can return the private static
			return pGO_DIGITAL_COMPANY;
			
		} // get()
	} // GO_DIGITAL_COMPANY property
	


	// loadData() - This method needs to be kept up to date as psuedo constants are defined above.
	// This method should only be called once.
	public static void loadData(){
		
		
		// Check that the data hasn't already been loaded using the KPIRep
		List<KPIRep__c> testReps = [SELECT id, Name FROM KPIRep__c WHERE User__c = :GANNETT_LOCAL_USER.Id];
		if(testReps.size() == 0){
			dataAlreadyLoaded = false;
			system.debug('Loading Constants Data ... ');
			
			// Load GANNETT_LOCAL_KPI_REP
			KPIRep__c kpiGannettLocal = new KPIRep__c();
			kpiGannettLocal.Name = GANNETT_LOCAL_KPI_NAME;
			kpiGannettLocal.User__c = GANNETT_LOCAL_USER.Id;
			insert kpiGannettLocal;
			
			// Load AZ_REPUBLIC_COMPANY
			Account azRepAcct = new Account();
			azRepAcct.Name = AZ_REPUBLIC_COMPANY_NAME;
			azRepAcct.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
			azRepAcct.OwnerId = GANNETT_LOCAL_USER.id;
			insert azRepAcct;
			
/***** Rebranded to GO Digital
			// Load GANNETT_LOCAL_COMPANY
			Account glAcct = new Account();
			glAcct.Name = GANNETT_LOCAL_COMPANY_NAME;
			glAcct.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
			glAcct.OwnerId = GANNETT_LOCAL_USER.id;
			insert glAcct;
*****/

			// Load GO_DIGITAL_COMPANY
			Account goAcct = new Account();
			goAcct.Name = GO_DIGITAL_COMPANY_NAME;
			goAcct.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
			goAcct.OwnerId = GANNETT_LOCAL_USER.id;
			insert goAcct;
			
			// Load NOT_IN_LIST_CONTACT
			Contact nilContact = new Contact();
			nilContact.FirstName = 'Not';
			nilContact.LastName = 'In List';
			nilContact.RecordTypeId = RecordTypeCache.getRecordType('Contact', 'Affiliated').Id;
			nilContact.AccountId = GO_DIGITAL_COMPANY.Id;
			insert nilContact;
			
			// Load KPI_CAL_20121031
			KPICalender__c kpi20121031 = new KPICalender__c();
			kpi20121031.Name = '10/31/2012';
			kpi20121031.Date__c = Date.newInstance(2012, 10, 31);
			kpi20121031.Period__c = 'P11';
			kpi20121031.Fiscal_Week__c = 45;
			kpi20121031.Fiscal_Year__c = 2012;
			insert kpi20121031;
			
			// Load KPI_CAL_20111226
			KPICalender__c kpi20111226 = new KPICalender__c();
			kpi20111226.Name = '12/26/2011';
			kpi20111226.Date__c = Date.newInstance(2011, 12, 26);
			kpi20111226.Period__c = 'p12';
			kpi20111226.Fiscal_Week__c = 54;
			kpi20111226.Fiscal_Year__c = 2011;
			insert kpi20111226;
			
			
			// Load KPI_CAL_20130605
			KPICalender__c kpi20130605 = new KPICalender__c();
			kpi20130605.Name = '6/5/2013';
			kpi20130605.Date__c = Date.newInstance(2013, 6, 5);
			kpi20130605.Period__c = 'P06';
			kpi20130605.Fiscal_Week__c = 23;
			kpi20130605.Fiscal_Year__c = 2013;
			insert kpi20130605;
			
			// Currently, Pricebook data is not visible when seeAllData=false, even though it 
			// comes over with a refresh, like Profile, User and RecordType, all of which can be
			// seen from testMethods without seeAllData=true. Unfortunately you cannot cerate 
			// the Standard PriceBook programatically, because the IsStandard field isn't writable.
			// Here is the code to create it, if they fix it that way. If they make the StdPB visible,
			// this can be deleated
			// for more info: https://success.salesforce.com/ideaView?id=08730000000j9TpAAI
			
			/**** <PWP>
			if(Test.isRunningTest()){
				Pricebook2 stdPricebook = new Pricebook2();
				stdPricebook.Name = 'Standard Price Book';
				stdPricebook.IsActive = true;
				stdPricebook.IsStandard = true; //Doesn't work currently
				insert stdPricebook;
			}
			**** </PWP> */
			
		} // if testReps.size() == 0
		else{
			dataAlreadyLoaded = true;
			system.debug('Data has already been loaded for this sandbox');
		}
	}
}