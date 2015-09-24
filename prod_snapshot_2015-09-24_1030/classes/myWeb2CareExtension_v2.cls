public with sharing class myWeb2CareExtension_v2 {
	
	// <CC> In general, commented out lines of code should be removed 
	
	private final Case webcase;
	public Case newCase {get; set;}
	public String selectSubmitType {get;set;}
	public String includeSalesReps {get;set;}
	public String includeLetter {get;set;}
	public String includeNotify {get;set;}
  	public String Notify1 {get;set;}
  	public String Notify2 {get;set;}
  	public String Notify3 {get;set;}
  	
  	public String fileName {get;set;}
  	public String fileName2 {get;set;}
  	public String contentType {get; set;}
  	public Blob file {get; set;}
  	public Blob file2 {get; set;} 
  	public Boolean submitted {get;set;}

    public List<SelectOption> getItems1() 
    {
        List<SelectOption> alpha = new List<SelectOption>();
        // <string> 
        alpha.add(new SelectOption('','-'));alpha.add(new SelectOption('A','A'));alpha.add(new SelectOption('B','B'));alpha.add(new SelectOption('C','C'));alpha.add(new SelectOption('D','D'));alpha.add(new SelectOption('E','E'));alpha.add(new SelectOption('F','F'));alpha.add(new SelectOption('G','G'));alpha.add(new SelectOption('H','H'));alpha.add(new SelectOption('I','I'));alpha.add(new SelectOption('J','J'));alpha.add(new SelectOption('K','K'));alpha.add(new SelectOption('L','L'));alpha.add(new SelectOption('M','M'));alpha.add(new SelectOption('N','N'));alpha.add(new SelectOption('O','O'));alpha.add(new SelectOption('P','P'));alpha.add(new SelectOption('Q','Q'));alpha.add(new SelectOption('R','R'));alpha.add(new SelectOption('S','S'));alpha.add(new SelectOption('T','T'));alpha.add(new SelectOption('U','U'));alpha.add(new SelectOption('V','V'));alpha.add(new SelectOption('W','W'));alpha.add(new SelectOption('X','X'));alpha.add(new SelectOption('Y','Y'));alpha.add(new SelectOption('Z','Z'));
        return alpha;
    }
	
	// <string> 
	public myWeb2CareExtension_v2(ApexPages.StandardController stdController){this.newCase = (Case)stdController.getRecord();}
	//
   
	// <string> <refactor> could use RecordTypeCache here 
  public List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name];Integer Cons = contactList.size();
  public List<SelectOption> salesRepOptions {
    get {
      if (salesRepOptions == null) {
        salesRepOptions = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('A')){
            		salesRepOptions.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions;
    }
    private set;
    }
    // <bulkify> <refactor> sales rep options should be bulkified to get all options at once 
  public List<SelectOption> salesRepOptions2 {
    get {
      if (salesRepOptions2 == null) {
        salesRepOptions2 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions2.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions2.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('B')){
            		salesRepOptions2.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions2;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions3 {
    get {
      if (salesRepOptions3 == null) {
        salesRepOptions3 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions3.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions3.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('C')){
            		salesRepOptions3.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions3;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions4 {
    get {
      if (salesRepOptions4 == null) {
        salesRepOptions4 = new List<SelectOption>();
       		 // <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions4.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions4.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('D')){
            		salesRepOptions4.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions4;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions5 {
    get {
      if (salesRepOptions5 == null) {
        salesRepOptions5 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions5.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions5.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('E')){
            		salesRepOptions5.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions5;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions6 {
    get {
      if (salesRepOptions6 == null) {
        salesRepOptions6 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions6.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions6.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('F')){
            		salesRepOptions6.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions6;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions7 {
    get {
      if (salesRepOptions7 == null) {
        salesRepOptions7 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions7.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions7.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('G')){
            		salesRepOptions7.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions7;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions8 {
    get {
      if (salesRepOptions8 == null) {
        salesRepOptions8 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions8.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions8.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('H')){
            		salesRepOptions8.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions8;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions9 {
    get {
      if (salesRepOptions9 == null) {
        salesRepOptions9 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions9.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions9.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('I')){
            		salesRepOptions9.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions9;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions10 {
    get {
      if (salesRepOptions10 == null) {
        salesRepOptions10 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions10.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions10.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('J')){
            		salesRepOptions10.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions10;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions11 {
    get {
      if (salesRepOptions11 == null) {
        salesRepOptions11 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions11.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions11.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('K')){
            		salesRepOptions11.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions11;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions12 {
    get {
      if (salesRepOptions12 == null) {
        salesRepOptions12 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions12.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions12.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('L')){
            		salesRepOptions12.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions12;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions13 {
    get {
      if (salesRepOptions13 == null) {
        salesRepOptions13 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection  
            salesRepOptions13.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions13.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('M')){
            		salesRepOptions13.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions13;
    }
    private set;
    }
  public List<SelectOption> salesRepOptions14 {
    get {
      if (salesRepOptions14 == null) {
        salesRepOptions14 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions14.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions14.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('N')){
            		salesRepOptions14.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions14;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions15 {
    get {
      if (salesRepOptions15 == null) {
        salesRepOptions15 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions15.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions15.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('O')){
            		salesRepOptions15.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions15;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions16 {
    get {
      if (salesRepOptions16 == null) {
        salesRepOptions16 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions16.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions16.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('P')){
            		salesRepOptions16.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions16;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions17 {
    get {
      if (salesRepOptions17 == null) {
        salesRepOptions17 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions17.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions17.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('Q')){
            		salesRepOptions17.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions17;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions18 {
    get {
      if (salesRepOptions18 == null) {
        salesRepOptions18 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions18.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions18.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('R')){
            		salesRepOptions18.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions18;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions19 {
    get {
      if (salesRepOptions19 == null) {
        salesRepOptions19 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions19.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions19.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('S')){
            		salesRepOptions19.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions19;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions20 {
    get {
      if (salesRepOptions20 == null) {
        salesRepOptions20 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions20.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions20.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('T')){
            		salesRepOptions20.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions20;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions21 {
    get {
      if (salesRepOptions21 == null) {
        salesRepOptions21 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions21.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions21.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('U')){
            		salesRepOptions21.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions21;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions22 {
    get {
      if (salesRepOptions22 == null) {
        salesRepOptions22 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions22.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions22.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('V')){
            		salesRepOptions22.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions22;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions23 {
    get {
      if (salesRepOptions23 == null) {
        salesRepOptions23 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions23.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions23.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('W')){
            		salesRepOptions23.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions23;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions24 {
    get {
      if (salesRepOptions24 == null) {
        salesRepOptions24 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions24.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions24.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('X')){
            		salesRepOptions24.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions24;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions25 {
    get {
      if (salesRepOptions25 == null) {
        salesRepOptions25 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions25.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions25.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('Y')){
            		salesRepOptions25.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions25;
    }
    private set;
    }
    public List<SelectOption> salesRepOptions26 {
    get {
      if (salesRepOptions26 == null) {
        salesRepOptions26 = new List<SelectOption>();
        	// <refactor> should not reference hard coded ids 
        	// <CC> appears to be relying on actual data records for choice selection 
            salesRepOptions26.add(new SelectOption('003F000000y4o1V','Choose One'));
            salesRepOptions26.add(new SelectOption('003F000000y4o1V','Not In List'));
            //List<Contact> contactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 997];Integer Cons = contactList.size();
            Integer Rnd = 0;String CheckFirst;
            for(Contact c : contactList){
            	CheckFirst = c.Name;
            	if(CheckFirst.startswith('Z')){
            		salesRepOptions26.add(new SelectOption(c.Id,c.Name));
            	}
            }
      }
      return salesRepOptions26;
    }
    private set;
    }
   
   
   
	// <string>
    // <refactor> should not reference hard coded ids 
    // <refactor> could use RecordTypeCache here 
    public List<SelectOption> getItemsm(){List<SelectOption> moptions = new List<SelectOption>();List<Account> marketList = [Select Id, Media_Property_List__c FROM Account where RecordTypeId = '012F0000000y9Wc' and Id != '001F000000n1sGU' and Id != '001A000000QTk0g' order by Media_Property_List__c];moptions.add(new SelectOption('--None--','Choose One'));for (Integer j=0;j<marketList.size();j++){moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));}moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));return moptions;}

	public PageReference saveCase() 
	{
		if(Notify1 != null && Notify1 != ''){newCase.Notify_Email_1__c = Notify1;}
		if(Notify2 != null && Notify2 != ''){newCase.Notify_Email_2__c = Notify2;}
		if(Notify3 != null && Notify3 != ''){newCase.Notify_Email_3__c = Notify3;}
		
		Database.Saveresult sr;
		try
		{
			newCase.Affl_Sales_Rep__c = includeLetter;
			insert(newCase);
			if(fileName != null && fileName != ''){
			Attachment attach = new Attachment();
			attach.Body = file;
			attach.Name = fileName;
			attach.ContentType = contentType;
			attach.parentId = newCase.Id;
			sr = Database.insert(attach);
		}
		
		if(fileName2 != null && fileName2 != ''){
			Attachment attach2 = new Attachment();
			attach2.Body = file2;
			attach2.Name = fileName2;
			attach2.ContentType = contentType;
			attach2.parentId = newCase.Id;
			sr = Database.insert(attach2);
		}
		}
		catch(System.DMLException e) 
		{
			ApexPages.addMessages(e);return null;
		}

		// <string> <refactor> should reference pages by object, Page.ThankYouFromGLCare
		PageReference p = new PageReference('/ThankYouFromGLCare');	p.setRedirect(true);return p;}
	//
      public List<SelectOption> yesNoOptions {
      get {
        if (yesNoOptions == null) {
          yesNoOptions = new List<SelectOption>();
            //yesNoOptions.add(new SelectOption('','Choose One'));
            yesNoOptions.add(new SelectOption('false','No'));
            yesNoOptions.add(new SelectOption('true','Yes'));
            
        }
        
        return yesNoOptions;
      }
      private set;
      
    }
  
  	// <testMethod> <refactor> does not need SeeAllData 
    @isTest(SeeAllData=true)
  	static void testDigitalAuditRequest() {
  		// <refactor> test data creation utility should be used to create test data
    Case ld = new Case();
    ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(ld);
    myWeb2CareExtension_v2 ext = new myWeb2CareExtension_v2(stdController);
   	// <CC> Where are the following List<SelectOption> lines referenced 
    List<SelectOption> salesReps = ext.salesRepOptions;
    List<SelectOption> salesReps2 = ext.salesRepOptions2;
    List<SelectOption> salesReps3 = ext.salesRepOptions3;
    List<SelectOption> salesReps4 = ext.salesRepOptions4;
    List<SelectOption> salesReps5 = ext.salesRepOptions5;
    List<SelectOption> salesReps6 = ext.salesRepOptions6;
    List<SelectOption> salesReps7 = ext.salesRepOptions7;
    List<SelectOption> salesReps8 = ext.salesRepOptions8;
    List<SelectOption> salesReps9 = ext.salesRepOptions9;
    List<SelectOption> salesReps10 = ext.salesRepOptions10;
    List<SelectOption> salesReps11 = ext.salesRepOptions11;
    List<SelectOption> salesReps12 = ext.salesRepOptions12;
    List<SelectOption> salesReps13 = ext.salesRepOptions13;
    List<SelectOption> salesReps14 = ext.salesRepOptions14;
    List<SelectOption> salesReps15 = ext.salesRepOptions15;
    List<SelectOption> salesReps16 = ext.salesRepOptions16;
    List<SelectOption> salesReps17 = ext.salesRepOptions17;
    List<SelectOption> salesReps18 = ext.salesRepOptions18;
    List<SelectOption> salesReps19 = ext.salesRepOptions19;
    List<SelectOption> salesReps20 = ext.salesRepOptions20;
    List<SelectOption> salesReps21 = ext.salesRepOptions21;
    List<SelectOption> salesReps22 = ext.salesRepOptions22;
    List<SelectOption> salesReps23 = ext.salesRepOptions23;
    List<SelectOption> salesReps24 = ext.salesRepOptions24;
    List<SelectOption> salesReps25 = ext.salesRepOptions25;
    List<SelectOption> salesReps26 = ext.salesRepOptions26;
    List<SelectOption> yesNo = ext.yesNoOptions;
    ld.Subject = 'Test';
    ld.Company_Name__c = 'Test';
    ld.Affl_Sales_Rep_Text__c = 'Test';
    // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
    ext.saveCase();
    
    // <refactor> need assertions w/ messages 
    
  }
  
  
}