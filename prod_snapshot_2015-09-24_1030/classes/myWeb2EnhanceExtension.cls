public with sharing class myWeb2EnhanceExtension {
	// <CC> general identitation and code formatting could be better 
	private final Case pecase;
	public Case newCase {get; set;}
	public String selectSubmitType {get;set;}
  	public String includeLetter {get;set;}
  	public String fileName {get;set;}
  	public String fileName2 {get;set;}
  	public String contentType {get; set;}
  	public Blob file {get; set;}
  	public Blob file2 {get; set;} 
  	public Boolean submitted {get;set;}
  	public String fieldRequestTypeResult {get;set;}
  	public String fieldCompetitorResult {get;set;}
	
	// <string>
	public myWeb2EnhanceExtension(ApexPages.StandardController stdController){this.newCase = (Case)stdController.getRecord();}
  
  // <string>
  // <refactor> should not use hard coded ids / could possibly use RecordTypeCache here
  public List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and Product_Enhancement_Requestor__c = True ORDER BY Name ASC];
  public List<SelectOption> salesRepOptions {
    get {
      if (salesRepOptions == null) {
        salesRepOptions = new List<SelectOption>();
            salesRepOptions.add(new SelectOption('',''));
            for(Contact c : contactList){
            		salesRepOptions.add(new SelectOption(c.Id,c.Name));
            }
      }
      return salesRepOptions;
    }
    private set;
    }
      public List<SelectOption> fieldRequestType {
      get {
        if (fieldRequestType == null) {
            fieldRequestType = new List<SelectOption>();
            fieldRequestType.add(new SelectOption('none','--Choose One--'));
            fieldRequestType.add(new SelectOption('exist','Existing Product Enhancement'));
            fieldRequestType.add(new SelectOption('new','New Product Request'));   
        }
        return fieldRequestType;
      }
      private set; 
    }
  public List<SelectOption> fieldCompetitor {
    get {
      if (fieldCompetitor == null) {
        fieldCompetitor = new List<SelectOption>();
        fieldCompetitor.add(new SelectOption('No','No'));
      	fieldCompetitor.add(new SelectOption('Yes','Yes'));
      	
      }
      return fieldCompetitor;
    }
    private set;
    }
    
// <string>
public List<SelectOption> getItemsm(){List<SelectOption> moptions = new List<SelectOption>();List<Account> marketList = [Select Id, Media_Property_List__c FROM Account where RecordTypeId = '012F0000000y9Wc' and Id != '001F000000n1sGU' and Id != '001A000000QTk0g' order by Media_Property_List__c];moptions.add(new SelectOption('--None--','Choose One'));for (Integer j=0;j<marketList.size();j++){moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));}moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));return moptions;}

	public PageReference saveCase() 
	{	
		// <string>
		if(fieldRequestTypeResult != null && fieldRequestTypeResult != ''){if(fieldRequestTypeResult=='exist'){newCase.PE_Reason_Type__c = 'Existing Product Enhancement';}else{newCase.PE_Reason_Type__c = 'New Product Request';}}
		if(fieldCompetitorResult != null && fieldCompetitorResult != ''){newCase.PE_Competitor_Offers__c = fieldCompetitorResult;}
		
		newCase.ContactId = includeLetter;	
		Database.Saveresult sr;
		try
		{
			insert(newCase);
			if(fileName != null && fileName != ''){ // <CC> code readability
			Attachment attach = new Attachment();
			attach.Body = file;
			attach.Name = fileName;
			attach.ContentType = contentType;
			attach.parentId = newCase.Id;
			sr = Database.insert(attach);
			// <refactor> error handling if attachment fails 
		}
		
		if(fileName2 != null && fileName2 != ''){
			Attachment attach2 = new Attachment();
			attach2.Body = file2;
			attach2.Name = fileName2;
			attach2.ContentType = contentType;
			attach2.parentId = newCase.Id;
			sr = Database.insert(attach2);
			// <refactor> error handling if attachment fails 
		}
		}
		catch(System.DMLException e) 
		{
			// <string>
			ApexPages.addMessages(e);return null;
		}
		
		// <string>
		// <refactor> should reference page by object, i.e. Page.ProductEnhanceThankYou
		PageReference p = new PageReference('/ProductEnhanceThankYou');p.setRedirect(true);return p;}
	//
      public List<SelectOption> yesNoOptions{
      get {
        if (yesNoOptions == null) {
          yesNoOptions = new List<SelectOption>();
            //yesNoOptions.add(new SelectOption('','Choose One')); <comment>
            yesNoOptions.add(new SelectOption('No','No'));
            yesNoOptions.add(new SelectOption('Yes','Yes'));
            
        }
        
        return yesNoOptions;
      }
      private set;
      
    }
  	
  	// <testMethod> 
  	// <refactor> is SeeAllData needed here ? 
    @isTest(SeeAllData=true)
  	static void testDigitalAuditRequest() { // <CC> code readability
  	// <refactor> test data creation utility should be used to create test data
    Case ld = new Case();
    ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(ld);
    myWeb2EnhanceExtension ext = new myWeb2EnhanceExtension(stdController);
    // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
    List<SelectOption> yesNo = ext.yesNoOptions;
    ld.Subject = 'Test';
    ld.Company_Name__c = 'Test';
    ld.Affl_Sales_Rep_Text__c = 'Test';
    ext.saveCase();
    // <refactor> need assertions w/ messages
    
  }
}