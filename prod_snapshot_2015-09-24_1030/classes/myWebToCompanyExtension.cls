public with sharing class myWebToCompanyExtension {
	private final Account webaccount;
	public Boolean submitted {get;set;}
	public String fileName {get;set;}
	public String fileName2 {get;set;}
	public String contentType {get; set;}
	public Blob file {get; set;}
	public Blob file2 {get; set;}
  
	public myWebToCompanyExtension(ApexPages.StandardController stdController){
		webaccount = (Account)stdcontroller.getRecord();
	}
    // <refactor> Possibly lazy load the items 
	// <refactor> Need test for this extension 
    public List<SelectOption> getItems(){
    	List<SelectOption> options = new List<SelectOption>();
    	List<Market__c> marketList = [Select Id, Name
    								  FROM Market__c
    								  where (Active_BC__c = True OR Active_CP__c = True)
    								  order by Name];
    	options.add(new SelectOption('--None--','--None--')); // <refactor> should make None value or SelectOption constant to reference later
	 	
	 	// CC Ph2 - Change to itterator
    	for (Integer j=0;j<marketList.size();j++){
    		options.add(new SelectOption(marketList[j].Id,marketList[j].Name));
    	}
    	return options;
    }
 
	String newAccountId;
	public PageReference saveCompany() {
		Database.Saveresult sr;
		try{insert(webaccount); // <string>
			newAccountId = webaccount.Id;
		}
		catch(System.DMLException e) {
			ApexPages.addMessages(e);
			return null;
		}
		
		// <refactor> could use service class that attaches Attachments to Accounts 
		// <refactor> should have error handling if attaching Attachment causes problems 
		if(fileName != null && fileName != ''){ // <logic> could use String.isBlank for simplification 
			Attachment attach = new Attachment();
			attach.Body = file;
			attach.Name = fileName;
			attach.ContentType = contentType;
			attach.parentId = newAccountId;
			sr = Database.insert(attach);
		}
		// <refactor> could use service class that attaches Attachments to Accounts 
		// <refactor> should have error handling if attaching Attachment causes problems 
		if(fileName2 != null && fileName2 != ''){ // <logic> could use String.isBlank for simplification 
			Attachment attach = new Attachment();
			attach.Body = file2;
			attach.Name = fileName2;
			attach.ContentType = contentType;
			attach.parentId = newAccountId;
			sr = Database.insert(attach);
		}
	    PageReference p = new PageReference('/ThankYou'); // <refactor> should use reference to page object, Page.ThankYou 
	    p.setRedirect(true);
	    return p;
	} //public PageReference saveCompany()
} // Class