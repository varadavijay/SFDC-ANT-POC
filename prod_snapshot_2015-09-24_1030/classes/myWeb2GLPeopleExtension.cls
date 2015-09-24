public without sharing class myWeb2GLPeopleExtension {
	public Contact newContact {get; set;}
	
	public myWeb2GLPeopleExtension(ApexPages.StandardController ctl) {
		this.newContact = (Contact)ctl.getRecord();
	}
	
	// CC Ph2 - a spelling error get propagated through the code, rather than fixed?
	// <refactor> Should not use hard coded ids, possible use Constants class 
	// <refactor> Possibly lazy load the items 
	public List<SelectOption> getItemsm(){
	 	List<SelectOption> moptions = new List<SelectOption>();
	 	List<Account> marketList = [Select Id, Media_Property_List__c
	 								FROM Account
	 								WHERE RecordTypeId = '012F0000000y9Wc'
	 								AND Id != '001F000000n1sGU'
	 								AND Id != '001A000000QTk0g'
	 								ORDER BY Media_Property_List__c];
	 	
	 	moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));
	 	
	 	// CC Ph2 - Change to itterator
	 	for (Integer j=0;j<marketList.size();j++){
	 		moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));
	 	}
	 	
	 	return moptions;
	}
	
	public PageReference saveContact() {
		try {
			insert newContact;
		}
		catch(System.DMLException e){
			ApexPages.addMessages(e);
			return null;
		}
		PageReference p = new PageReference('/ThankYouFromGLPeople'); // <refactor> should reference the page object by Page.ThankYouFromGLPeople
		p.setRedirect(true);
		return p;
	}
  
  // <testMethod> 
  @isTest(SeeAllData=true)
  static void testmyWeb2GLPeopleExtension() {
  	Contact ld = new Contact(); 
	ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(ld);
    myWeb2GLPeopleExtension ext = new myWeb2GLPeopleExtension(ctl);
    // <comment>
    //List<SelectOption> salesReps = ext.salesRepOptions;
    //List<SelectOption> media = ext.mediaPartnerOptions;
    //List<SelectOption> yesNo = ext.yesNoOptions;
    ld.Lastname = 'Last';
    //ld.LastName = 'Test';
    // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
    ext.saveContact();
    // <refactor> no assertions in test
  }
}