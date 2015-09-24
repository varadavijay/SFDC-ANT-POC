public with sharing class myWeb2CareExtension {
	
	private final Case webcase;
	
	public Case newCase {get; set;}
	public String selectSubmitType {get;set;}
	public String fileName {get;set;}
	public String contentType1 {get; set;}
	public String contentType2 {get; set;}
	public Blob file {get; set;}
	public Boolean submitted {get;set;}
	public String fileName2 {get;set;}
	public Blob file2 {get; set;}
	
	public myWeb2CareExtension(ApexPages.StandardController stdController){
		webcase = (Case)stdcontroller.getRecord();
	}

	public List<SelectOption> options = new List<SelectOption>();
    
	// <refactor> Possibly lazy load the items 
    public List<SelectOption> getItems(){
    	// <refactor> should make None value or SelectOption constant to reference later
    	options.add(new SelectOption('--None--','Choose One'));
    	// <refactor> Should not use hard coded ids, make use of Constants 
    	options.add(new SelectOption('003F000000y4o1V','Not In List'));
    	List<Contact> afflcontactList = [Select Id, Name 
								    	 FROM Contact 
								    	 WHERE RecordTypeId = '012F0000000y9gD' 
								    	 AND LastName != 'In List' 
								    	 AND Email != '' 
								    	 AND Web_Submitter__c = True 
								    	 ORDER BY Name limit 997]; // <CC> Why 997 records ? May be large
    	//CC Ph2 - Change to Iterator 
    	for (Integer j=0;j<afflcontactList.size();j++)  {
    		options.add(new SelectOption(afflcontactList[j].Id,afflcontactList[j].Name));
    	}
    	
    	return options;
    }

    // <refactor> Should not use hard coded ids, possible use Constants class 
	// <refactor> Possibly lazy load the items 
	// <refactor> Need test for this extension 
    public List<SelectOption> getItemsm(){
    	List<SelectOption> moptions = new List<SelectOption>();
    	// <string>
    	List<Account> marketList = [Select Id, Media_Property_List__c FROM Account where RecordTypeId = '012F0000000y9Wc' and Id != '001F000000n1sGU' and Id != '001A000000QTk0g' order by Media_Property_List__c];
    	moptions.add(new SelectOption('--None--','Choose One'));
    	// <iterator> 
    	for (Integer j=0;j<marketList.size();j++){
    		moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));
    	}
    	// <refactor> Should not use hard coded ids, make use of Constants 
    	moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));
    	return moptions;
    }
    
    String newCaseId;

	public PageReference saveCase() 
	{
		Database.Saveresult sr;
		try
		{
		insert(webcase);
		newCaseId = webcase.Id;
		}
		catch(System.DMLException e) 
		{
			// <string>
			ApexPages.addMessages(e);return null;
		}
		
		// <refactor> error handling if attachment fails
		if(fileName != null && fileName != ''){
			Attachment attach1 = new Attachment();
			attach1.Body = file;
			attach1.Name = fileName;
			attach1.ContentType = contentType1;
			attach1.parentId = newCaseId;
			sr = Database.insert(attach1);
		}
		if(fileName2 != null && fileName2 != ''){
			Attachment attach2 = new Attachment();
			attach2.Body = file2;
			attach2.Name = fileName2;
			attach2.ContentType = contentType2;
			attach2.parentId = newCaseId;
			sr = Database.insert(attach2);
		}
		
		// <string>
		// <refactor> should reference the page object, i.e. Page.ThankYouFromGLCare
		PageReference p = new PageReference('/ThankYouFromGLCare');p.setRedirect(true);return p;

	}
  	
  	// <testMethod> 
  	// <refactor> why is this see all data ?
    @isTest(SeeAllData=true)
  	static void testDigitalAuditRequest() {
    Case ld = new Case();
    ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(ld);
    myWeb2CareExtension ext = new myWeb2CareExtension(stdController);
    ld.Subject = 'Test';
    ld.Company_Name__c = 'Test';
    ld.Affl_Sales_Rep_Text__c = 'Test';
    ext.saveCase();
    
    // <refactor> no assertions
  }
  
}