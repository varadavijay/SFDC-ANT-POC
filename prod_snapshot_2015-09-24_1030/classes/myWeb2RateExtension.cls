public with sharing class myWeb2RateExtension {
	// <deletefile> not being used? 
	public Case newCase {get; set;}
	public String selectSubmitType {get;set;}
	private final Case webcase;
	public String fileName {get;set;}
	public String contentType {get; set;}
	public Blob file {get; set;}
	public Boolean submitted {get;set;}
	public myWeb2RateExtension(ApexPages.StandardController stdController){
		webcase = (Case)stdcontroller.getRecord();
	}
	
	// <refactor> Should not use hard coded ids, possible use Constants class 
	// <refactor> Possibly lazy load the items 
	// <refactor> Need test for this extension 
	public List<SelectOption> getItems(){
		// <refactor> should make None value or SelectOption constant to reference later
		List<SelectOption> options = new List<SelectOption>();options.add(new SelectOption('--None--','Choose One')); 
		// <refactor> Should not use hard coded ids, make use of Constants 
		options.add(new SelectOption('003F000000y4o1V','Not In List'));
		List<Contact> afflcontactList = [Select Id, Name
										 FROM Contact
										 WHERE RecordTypeId = '012F0000000y9gD'
										 AND LastName != 'In List'
										 AND Email != ''
										 AND Web_Submitter__c = True
										 ORDER BY Name limit 997]; // <CC> Why 997 records ? May be large
										 
		// CC Ph2 - Change to iterator
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
		// <bulkify> could refactor this SOQL query, i.e. use IN and Sets 
		List<Account> marketList = [Select Id, Media_Property_List__c
									FROM Account
									WHERE RecordTypeId = '012F0000000y9Wc'
									AND Id != '001F000000n1sGU'
									AND Id != '001A000000QTk0g'
									ORDER BY Media_Property_List__c];
		
		// <refactor> should make None value or SelectOption constant to reference later
		moptions.add(new SelectOption('--None--','Choose One'));
		
		// CC Ph2 - Change to iterator
		for (Integer j=0;j<marketList.size();j++){
			moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));
		}
		// <refactor> Should not use hard coded ids, make use of Constants 
		moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));
		return moptions;
	}
	
	String newCaseId;
	public PageReference saveCase(){
		Database.Saveresult sr;
		try{
			insert(webcase);
			newCaseId = webcase.Id;
		}
		catch(System.DMLException e) {
			ApexPages.addMessages(e);
			return null;
		}
		
		if(fileName != null && fileName != ''){
			Attachment attach = new Attachment();
			attach.Body = file;
			attach.Name = fileName;
			attach.ContentType = contentType;
			attach.parentId = newCaseId;
			sr = Database.insert(attach);
			
			// <refactor> error handling if attachment fails
		}
		
		PageReference p = new PageReference('/ThankYouFromGLSales'); // <refactor> should reference the page object, i.e. Page.ThankYouFromGLSales
		p.setRedirect(true);
		return p;
	}
}