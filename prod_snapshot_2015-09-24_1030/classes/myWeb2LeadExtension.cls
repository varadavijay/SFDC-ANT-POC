public with sharing class myWeb2LeadExtension {
	private final Lead weblead;
	
	public myWeb2LeadExtension(ApexPages.StandardController stdController){
		webLead = (Lead)stdcontroller.getRecord();
	}
	
	// <refactor> Should not use hard coded ids, possible use Constants class 
	// <refactor> Possibly lazy load the items 
	// <refactor> Need test for this extension, may have been addressed in Version 2
	
    public List<SelectOption> getItems(){
    	List<SelectOption> options = new List<SelectOption>();
    	// <refactor> should make None value or SelectOption constant to reference later
    	options.add(new SelectOption('--None--','Choose One'));
    	options.add(new SelectOption('003F000000y4o1V','Not In List'));
    	List<Contact> afflcontactList = [SELECT Id, Name 
    									 FROM Contact
    									 WHERE RecordTypeId = '012F0000000y9gD'
    									 AND LastName != 'In List'
    									 ORDER BY Name];
    	
    	// CC Ph2 - Change to itterator
    	for (Integer j=0; j<afflcontactList.size(); j++){
    		options.add(new SelectOption(afflcontactList[j].Id,afflcontactList[j].Name));
    	}
    	
    	return options;
    }
    
    
    // <PWP> why is this items-m and m-options ... Why is different than above?
    // <refactor> Should not use hard coded ids, possible use Constants class 
	// <refactor> Possibly lazy load the items 
	// <refactor> Need test for this extension, may have been addressed in Version 2
    public List<SelectOption> getItemsm(){
    	List<SelectOption> moptions = new List<SelectOption>();
    	// <bulkify> could refactor this SOQL query, i.e. use IN and Sets 
    	List<Account> marketList = [SELECT Id, Media_Property_List__c 
    								FROM Account
    								WHERE RecordTypeId = '012F0000000y9Wc'
    								AND Id != '001F000000n1sGU' 
    								AND Id != '001A000000QTk0g'
    								ORDER BY Media_Property_List__c];
    	
    	moptions.add(new SelectOption('--None--','Choose One'));
    	
    	// CC Ph2 - Change to itterator
    	for (Integer j=0;j<marketList.size();j++){
    		moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));
    	}
    	// <refactor> Should not use hard coded ids
    	moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));
    	return moptions;
    }



	String newAccountId; // <refactor> no reference 
	public PageReference saveLead() {
		try{
			insert(weblead);
		}
		catch(System.DMLException e){
			ApexPages.addMessages(e);
			return null;
		}
		PageReference p = Page.ThankYouAudit;
		p.setRedirect(true);
		return p;
	}
}