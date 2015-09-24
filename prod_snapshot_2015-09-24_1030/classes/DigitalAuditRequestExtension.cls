public without sharing class DigitalAuditRequestExtension {
    public Lead newLead {get; set;}
    public String includeDigitalAudit {get;set;}
    public String includeLetter {get;set;}
    public String includeSalesReps {get;set;}
    public String includeWebsiteQuote {get;set;}
    public String includeWebsiteType {get;set;}//full or lead capture
    public String includeEmailCount {get;set;}
    public String includeCallRequest {get;set;}
    //public String landingTypeOptions {get;set;}
    public String leadCaptureTypeOptions {get;set;}
    public String fullPageTypeOptions {get;set;}
    public String includeNotify {get;set;}
    public String includeAttach {get;set;}
    public String Notify1 {get;set;}
    public String Notify2 {get;set;}
    public String Notify3 {get;set;}
    
    //attachements
    public String contentType {get; set;}
    public String fileName {get;set;}
    public Blob file {get; set;}
    public Boolean submitted {get;set;}
    public String fileName2 {get;set;}
    public Blob file2 {get; set;}
    public String fileName3 {get;set;}
    public Blob file3 {get; set;}

    //public String inputParent {get; set;}
    public String newCaseId;
    public List<String> selectedMediaPartners {
        get {
            if (selectedMediaPartners == null) {
                selectedMediaPartners = new List<String>();
            }
            return selectedMediaPartners;
        }
        
        set;
    }
    //dependent sales rep list section
    public List<SelectOption> getItems1() 
    {
            List<SelectOption> alpha = new List<SelectOption>();
            alpha.add(new SelectOption('','-'));alpha.add(new SelectOption('A','A'));alpha.add(new SelectOption('B','B'));alpha.add(new SelectOption('C','C'));alpha.add(new SelectOption('D','D'));alpha.add(new SelectOption('E','E'));alpha.add(new SelectOption('F','F'));alpha.add(new SelectOption('G','G'));alpha.add(new SelectOption('H','H'));alpha.add(new SelectOption('I','I'));alpha.add(new SelectOption('J','J'));alpha.add(new SelectOption('K','K'));alpha.add(new SelectOption('L','L'));alpha.add(new SelectOption('M','M'));alpha.add(new SelectOption('N','N'));alpha.add(new SelectOption('O','O'));alpha.add(new SelectOption('P','P'));alpha.add(new SelectOption('Q','Q'));alpha.add(new SelectOption('R','R'));alpha.add(new SelectOption('S','S'));alpha.add(new SelectOption('T','T'));alpha.add(new SelectOption('U','U'));alpha.add(new SelectOption('V','V'));alpha.add(new SelectOption('W','W'));alpha.add(new SelectOption('X','X'));alpha.add(new SelectOption('Y','Y'));alpha.add(new SelectOption('Z','Z'));
            return alpha;
    }
    Public string select1{get; set;}

    /**
    * @description
    */

    public DigitalAuditRequestExtension(ApexPages.StandardController ctl) {
        this.newLead = (Lead)ctl.getRecord();
        //newLead.Website_Page_Map__c = Label.DefaultWebsitePageMap;
    }
    
    /**
    * @description
    */
    public List<Contact> contactList = [Select Id, Name
                                        FROM Contact
                                        where RecordTypeId = '012F0000000y9gD'
                                        and LastName != 'In List'
                                        and Email != ''
                                        and Web_Submitter__c = True
                                        order by Name];
    Integer Cons = contactList.size();
    
    // <refactor> These 26 blocks of code are identical other than the StartsWith letter ... 1 for each letter A-Z
    // I didn't even bother cleaning it up for Ph1 because this should be replaced with a function 
    public List<SelectOption> salesRepOptions {
    get {
      if (salesRepOptions == null) {
        salesRepOptions = new List<SelectOption>();
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
  public List<SelectOption> salesRepOptions2 {
    get {
      if (salesRepOptions2 == null) {
        salesRepOptions2 = new List<SelectOption>();
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
    // </refactor>




//********************************************************************************Testing New List Area
    
    public List<SelectOption> getItemsm(){
        List<SelectOption> moptions = new List<SelectOption>();
        List<Account> marketList = [Select Id, Media_Property_List__c
                                    FROM Account
                                    where RecordTypeId = '012F0000000y9Wc'
                                    and Id != '001F000000n1sGU'
                                    and Id != '001A000000QTk0g'
                                    order by Media_Property_List__c];
        moptions.add(new SelectOption('--None--','Choose One'));
        for (Integer j=0; j<marketList.size(); j++){
            moptions.add(new SelectOption(marketList[j].Id, marketList[j].Media_Property_List__c));
        }
        moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));
        return moptions;
    }

//*********************************************************************************    
        
    
    public List<SelectOption> mediaPartnerOptions {
        get {
            if (mediaPartnerOptions == null) {
                mediaPartnerOptions = new List<SelectOption>();
                  
                List<Account> marketList = [SELECT Id, Name, Media_Property_List__c 
                                            FROM Account 
                                            WHERE RecordTypeId = '012F0000000y9Wc' 
                                            //AND Id != '001F000000n1sGU' 
                                            AND Id != '001A000000QTk0g' 
                                            ORDER BY Media_Property_List__c];
                  
                for (Account a : marketList) {
                    mediaPartnerOptions.add(new SelectOption(a.id, a.Media_Property_List__c));
                }
            } 
            return mediaPartnerOptions;
        }
        private set;
    }

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
    public List<SelectOption> pageTypeOptions {
        get {
            if (pageTypeOptions == null) {
                pageTypeOptions = new List<SelectOption>();
                pageTypeOptions.add(new SelectOption('','Choose One'));
                pageTypeOptions.add(new SelectOption('full','Full Site'));
                pageTypeOptions.add(new SelectOption('lead capture','Lead Capture Page'));
            }
            
            return pageTypeOptions;
        }
        private set;
    
    }
    public List<SelectOption> leadCapturePageType {
        get {
            if (leadCapturePageType == null) {
                leadCapturePageType = new List<SelectOption>();
                leadCapturePageType.add(new SelectOption('','Choose One'));
                leadCapturePageType.add(new SelectOption('single','Single'));
                leadCapturePageType.add(new SelectOption('premium','Premium'));
                leadCapturePageType.add(new SelectOption('signature','Signature'));
            }
            
            return leadCapturePageType;
        }
    private set;
    
    }
    public List<SelectOption> yesNoTempOptions {
        get {
            if (yesNoTempOptions == null) {
                yesNoTempOptions = new List<SelectOption>();
                yesNoTempOptions.add(new SelectOption('','Choose One'));
                yesNoTempOptions.add(new SelectOption('true','Yes'));
                yesNoTempOptions.add(new SelectOption('false','No'));
                yesNoTempOptions.add(new SelectOption('false','Template'));
            }
            
            return yesNoTempOptions;
        }
        private set;
    
    }
    public List<SelectOption> fullPageOptions {
        get {
            if (fullPageOptions == null) {
                fullPageOptions = new List<SelectOption>();
                fullPageOptions.add(new SelectOption('','Choose One'));
                //fullPageOptions.add(new SelectOption('four','4 Page Template'));
                //fullPageOptions.add(new SelectOption('eight','8 Page Template'));
                fullPageOptions.add(new SelectOption('WebStart','Website - Start'));
                fullPageOptions.add(new SelectOption('WebProfessional','Website - Professional'));
                fullPageOptions.add(new SelectOption('WebMobile','Website - Mobile-Only'));
            //Option is not longer a viable option and is to be removed - 02/26/14
            //fullPageOptions.add(new SelectOption('eightmod','8 Page Template With Add-Ons'));
                fullPageOptions.add(new SelectOption('custom','Full Custom Site'));
            }
        
            return fullPageOptions;
        }
        private set;
    
    }
    
    //<comment>
    /**public List<SelectOption> empWebContr_list {
    get {
    if (empWebContr_list == null) {
    empWebContr_list = new List<SelectOption>();
    empWebContr_list.add(new SelectOption('','Choose One'));
    empWebContr_list.add(new SelectOption('true','Yes'));
    empWebContr_list.add(new SelectOption('false','No'));
    }
    
    return empWebContr_list;
    }
    private set;
    
    }
    **/
   /**
  * @description
  */
  
    //****************************************************************************************
    //Get Things Into Place
    //****************************************************************************************
    public PageReference saveRequest() {            
        String firstMediaPartner;
        Database.Saveresult sr;
        try {
           If (!(includeWebsiteQuote == 'true' || includeEmailCount == 'true' || includeDigitalAudit == 'true' || includeCallRequest == 'true'))
           {
               ApexPages.addMessage (new ApexPages.message(ApexPages.severity.Error, 'Please Select at Least One (1) Audit type'));
                 Return null;
           }
        
            List<String> mpIds;
            //if (selectedMediaPartners != null && selectedMediaPartners.size() > 0)
            firstMediaPartner = newlead.Related_Company__c;//selectedMediaPartners[0];
            //newlead.Related_Company__c = firstMediaPartner;
            String NEmail1;String NEmail2;String NEmail3;
            if (includeNotify == 'true'){if(Notify1 != Null){NEmail1 = Notify1;}if(Notify2 != Null){NEmail2 = Notify2;}if(Notify3 != Null){NEmail3 = Notify3;}}else{NEmail1 = Null;NEmail2 = Null;NEmail3 = Null;}
            
            //make sure digital audit values are blank if they chose not to fill out a digital audit
            if (includeDigitalAudit != 'true') {
                newLead.Website = null;
                newLead.Win_1__c = null;
                newLead.Win_2__c = null;
                newLead.List_Products_Services__c = null;
                newLead.Budget_Range__c = null;
                newLead.Geog_Serv_Area__c = null;
                newLead.Comp_1__c = null;
                newLead.Comp_2__c = null;
                newLead.Comp_3__c = null;
                newLead.Avg_Cust_Val__c = null;
                newLead.Curr_Adv__c = null;
                newLead.BestWhy__c = null;
                newLead.General_Notes__c = null;
            }
            
            //make sure email count values are blank if they chose not to fill out an email count
            if (includeEmailCount != 'true') {
                newLead.Email_Count_Request_Notes__c = null;
                newLead.EC_Target_Geographics__c = null;
                newLead.EC_Email_Budget__c = null;
                newLead.EC_Email_Quantity__c = null;
                newLead.EC_Target_Demographic__c = null;
            }
            
            //make sure website quote values are blank if they chose not to fill out a website quote
            if (includeWebsiteQuote != 'true') {
                newLead.Website_Quote__c = false;
                newLead.ECommerce_Website__c = null;
                newLead.Custom_Website_Budget__c = null;
                newLead.Website_Comp_Time__c = null;
                newLead.Write_Content__c = null;
                newLead.Website_New_Or_Redesign__c = null;
                newLead.Redesign_URL__c = null;
                newLead.Redesign_Changes__c = null;
                newLead.Is_There_A_Logo__c = null;
                newLead.Registered_Domain__c = null;
                newLead.Existing_Artwork__c = null;
                newLead.Existing_Artwork_Format__c = null;
                newLead.Website_Images__c = null;
                newLead.Website_Search_Rank__c = null;
                newLead.Website_Rank_Categories__c = null;
                newLead.Website_Examples__c = null;
                newLead.Website_Competitors__c = null;
                newLead.Company_Competitive_Advantage__c = null;
                newLead.Target_Audience__c = null;
                newLead.Employee_Website_Contribution__c = null;
                newLead.Website_Special_Features__c = null;
                newLead.Website_Page_Map__c = null;
                newLead.Custom_Website_Description__c = null;
                newLead.Redesign_Changes__c = null;
                newLead.Goal_Generate_Leads__c = null;
                newLead.Goal_Generate_Leads__c = null;
                newLead.Goal_Communicate_Offerings__c = null;
                newLead.Goal_Communicate_Contact_Info__c = null;
                newLead.Goal_Communicate_Portfolio__c = null;
                newLead.Goal_Communicate_Client_Case_Studies__c = null;
                newLead.Goal_Collect_Data_on_Visitors__c = null;
                newLead.Goal_Self_Service__c = null;
                newLead.Goal_Educate__c = null;
                newLead.Goal_Sell_Products__c = null;
                newLead.Goal_Other_Option__c = null;
                newLead.Goal_Other__c = null;
                newLead.Website_Attachments__c = False;
            }
            else {
                //newLead.Website_Quote__c = true;
            }
            newLead.SalesRep__c = includeLetter;
            newLead.Status = 'Awaiting Close';
            insert newLead;
            
            //Populate media partners
            List<Dig_Aud_Prop__c> links = new List<Dig_Aud_Prop__c>();
            if (selectedMediaPartners != null && selectedMediaPartners.size() > 0){
                for (String mpId : selectedMediaPartners) {
                    Dig_Aud_Prop__c link = new Dig_Aud_Prop__c(Account__c = mpId, Digital_Audit__c=newLead.id);
                    links.add(link);
                }
            } 
            
            insert links;
            //Create Call Request Case
            //if Call Request Selected Store Values for Case
            if (includeCallRequest == 'true') {
                Case callRequest = new Case(Description = 'Sales Call Request',
                                            RecordTypeId = '012F0000000yDth',
                                            Digital_Lead__c = newLead.Id,
                                            Media_Partner__c = firstMediaPartner,
                                            Company_Name__c = newLead.Company,
                                            Contact_Phone__c = newLead.Phone,
                                            Contact_Name__c = newLead.Name,
                                            Affl_Sales_Rep__c = includeLetter,
                                            Affl_Sales_Rep_Text__c = newLead.Affiliated_Sales_Rep__c,
                                            CR_Addl_Info__c = newLead.CR_Addl_Info__c,
                                            CR_Call_Direction__c = newLead.CR_Call_Direction__c,
                                            CR_Call_Format__c = newLead.CR_Call_Format__c,
                                            CR_Call_Outcome__c = newLead.CR_Call_Outcome__c,
                                            CR_Client_Dig_Spend__c = newLead.CR_Client_Dig_Spend__c,
                                            CR_Client_Emphasis_Points__c = newLead.CR_Client_Emphasis_Points__c,
                                            CR_Client_Knowledge__c = newLead.CR_Client_Knowledge__c,
                                            CR_Client_Products__c = newLead.CR_Client_Products__c,
                                            CR_Client_Sensitivities__c = newLead.CR_Client_Sensitivities__c,
                                            CR_Client_Spend_Type__c = newLead.CR_Client_Spend_Type__c,
                                            CR_Conf_Number_Login__c = newLead.CR_Conf_Numb_Login__c,
                                            CR_Call_Date__c = newLead.CR_Call_Date__c,
                                            CR_Call_Time__c = newLead.CR_Call_Time__c,
                                            CR_Call_Zone__c = newLead.CR_Call_Zone__c,
                                            Notify_Email_1__c = NEmail1,
                                            Notify_Email_2__c = NEmail2,
                                            Notify_Email_3__c = NEmail3);
                insert callRequest;
            }
            
            //Create Digital Audit Case
            //if Digital Audit Request Selected Store Values for Case
            if (includeDigitalAudit == 'true') {
                
                // <comment>
                /*
                if (newLead.SalesRep__c != '003F000000y4o1V'){
                }
                else if(newLead.Affl_Sales_Rep_2__c != '003F000000y4o1V'){
                    newLead.SalesRep__c = newLead.Affl_Sales_Rep_2__c;
                }
                else if(salesRepOptions14 != '003F000000y4o1V'){
                    newLead.SalesRep__c = salesRepOptions14;
                }
                else {}
                */
                // </comment>
                
                //if(inputParent == Null){inputParent = '';}
                
                Case digaudRequest = new Case(Description = 'Digital Audit Request',
                                            RecordTypeId = '012F0000000yE7e',
                                            Digital_Lead__c = newLead.Id,
                                            Media_Partner__c = firstMediaPartner,
                                            Company_Name__c = newLead.Company,
                                            Contact_Phone__c = newLead.Phone,
                                            Contact_Name__c = newLead.LastName,
                                            Affl_Sales_Rep__c = includeLetter,//newLead.SalesRep__c,
                                            Affl_Sales_Rep_Text__c = newLead.Affiliated_Sales_Rep__c,//Dig Audit Specific Info
                                            DA_Website__c = newLead.Website,
                                            DA_Win_1__c = newLead.Win_1__c,
                                            DA_Win_2__c = newLead.Win_2__c,
                                            DA_List_Products_Services__c = newLead.List_Products_Services__c,
                                            DA_Budget_Range__c = newLead.Budget_Range__c,
                                            DA_Geog_Serv_Area__c = newLead.Geog_Serv_Area__c,
                                            DA_Comp_1__c = newLead.Comp_1__c,
                                            DA_Comp_2__c = newLead.Comp_2__c,
                                            DA_Comp_3__c = newLead.Comp_3__c,
                                            DA_Select_New_Products__c = newLead.Select_New_Products__c,
                                            DA_Select_Other_Products__c = newLead.Select_Other_Products__c,
                                            DA_Avg_Cust_Value__c = newLead.Avg_Cust_Val__c,
                                            DA_Current_Adv__c = newLead.Curr_Adv__c,
                                            DA_Best_Medium__c = newLead.BestWhy__c,
                                            DA_General_Notes__c = newLead.General_Notes__c,
                                            Industry_General__c = newLead.Industry_AffiliatedMarkets__c,
                                            Notify_Email_1__c = NEmail1,
                                            Notify_Email_2__c = NEmail2,
                                            Notify_Email_3__c = NEmail3
                                            //ParentId = inputParent
                                            );
                insert digaudRequest;
            }
            
            //Create Email Count Case
            //if Call Request Selected Store Values for Case
            if (includeEmailCount == 'true') {       
                Case ECountRequest = new Case(Description = 'Email Count Request',
                                            RecordTypeId = '012F0000000yE7o',
                                            Digital_Lead__c = newLead.Id,
                                            Media_Partner__c = firstMediaPartner,
                                            Company_Name__c = newLead.Company,
                                            Contact_Phone__c = newLead.Phone,
                                            Contact_Name__c = newLead.Name,
                                            Affl_Sales_Rep__c = includeLetter,
                                            Affl_Sales_Rep_Text__c = newLead.Affiliated_Sales_Rep__c,
                                            EC_Email_Budget__c = newLead.EC_Email_Budget__c,
                                            EC_Email_Quantity__c = newLead.EC_Email_Quantity__c,
                                            EC_Target_Demographic__c = newLead.EC_Target_Demographic__c,
                                            EC_Target_Geographics__c = newLead.EC_Target_Geographics__c,
                                            EC_General_Notes__c = newLead.Email_Count_Request_Notes__c,
                                            Industry_General__c = newLead.Industry_AffiliatedMarkets__c,
                                            Notify_Email_1__c = NEmail1,
                                            Notify_Email_2__c = NEmail2,
                                            Notify_Email_3__c = NEmail3);
                insert ECountRequest;
            }                                               
            
            //Create Website Audit Case
            if (includeWebsiteQuote == 'true') {
                String fullPageCheck = Null;
                String siteCheck = Null;
                String landingCheck = Null;
                
                if(includeWebsiteType == 'full'){
                    fullPageCheck = 'Full Page';
                    
                     if(fullPageTypeOptions == 'four'){
                 		   siteCheck = 'Four Page Template';
	                	}
		                else if(fullPageTypeOptions == 'eight'){
		                    siteCheck = 'Eight Page Template';
		                }
		                else if(fullPageTypeOptions == 'custom'){
		                    siteCheck = 'Full Custom Site';
		                }
		                else if(fullPageTypeOptions == 'eightmod'){
		                    siteCheck = '8 Page Template With Add-Ons';
		                }
		                else if(fullPageTypeOptions == 'WebStart'){
		                    siteCheck = 'Website - Start';
		                }
		                else if(fullPageTypeOptions == 'WebProfessional'){
		                    siteCheck = 'Website - Professional';
		                }
		                else if(fullPageTypeOptions == 'WebMobile'){
		                    siteCheck = 'Website - Mobile-only';
		                }
		                else{}
                }
                else if(includeWebsiteType == 'lead capture'){
                    fullPageCheck = 'Lead Capture Page';
                    if(leadCaptureTypeOptions == 'single'){
                 		   landingCheck = 'Lead Capture Pages – Single';
	                	}
		                else if(leadCaptureTypeOptions == 'premium'){
                 		   landingCheck = 'Lead Capture Pages – Premium';
	                	}
		                else if(leadCaptureTypeOptions == 'signature'){
                 		   landingCheck = 'Lead Capture Pages – Signature';
	                	}
		                else{}
                }
                else{}
                
                
                
                Case WebsiteRequest = new Case(Description = 'Website Quote Request',
                                                RecordTypeId = '012F0000000yEUf',
                                                Digital_Lead__c = newLead.Id,
                                                Media_Partner__c = firstMediaPartner,
                                                Company_Name__c = newLead.Company,
                                                Contact_Phone__c = newLead.Phone,
                                                Contact_Name__c = newLead.Name,
                                                Affl_Sales_Rep__c = includeLetter,
                                                Affl_Sales_Rep_Text__c = newLead.Affiliated_Sales_Rep__c,
                                                GLW_Web_Page_Type__c = fullPageCheck,//Overall Page Type - Full Site Or Lead Capture
                                                GLW_Landing_Page_Type__c = landingCheck,//Landing Page Type - Single, Premium or Signature
                                                GLW_Full_Page_Type__c = siteCheck,//Full Page Type - Templates Or Custom
                                                GLW_ECommerce_Site__c = newLead.ECommerce_Website__c,
                                                GLW_Website_Budget__c = newLead.Custom_Website_Budget__c,
                                                GLW_Website_Compl_Time__c = newLead.Website_Comp_Time__c,
                                                GLW_Write_Content__c = newLead.Write_Content__c,
                                                GLW_Website_New_Or_Redesign__c = newLead.Website_New_Or_Redesign__c,
                                                GLW_Redesign_URL__c = newLead.Redesign_URL__c,
                                                GLW_Redesign_Changes__c = newLead.Redesign_Changes__c,
                                                GLW_Is_There_A_Reg_Domain__c = newLead.Registered_Domain__c,
                                                GLW_Existing_Artwork__c = newLead.Existing_Artwork__c,
                                                GLW_Exist_Artwork_Format__c = newLead.Existing_Artwork_Format__c,
                                                GLW_Website_Images__c = newLead.Website_Images__c,
                                                GLW_Example_Websites__c = newLead.Website_Examples__c,
                                                GLW_Target_Audience__c = newLead.Target_Audience__c,
                                                GLW_Website_Special_Features__c = newLead.Website_Special_Features__c,
                                                GLW_Website_Page_Map__c = newLead.Website_Page_Map__c,
                                                Industry_General__c = newLead.Industry_AffiliatedMarkets__c,
                                                GLW_Template_Additions__c = newLead.Website_Template_Additions__c,
                                                Notify_Email_1__c = NEmail1,
                                                Notify_Email_2__c = NEmail2,
                                                Notify_Email_3__c = NEmail3,
                                                GLW_Attachments__c = newLead.Website_Attachments__c,
                                                DA_LeadDefinition__c= newLead.LeadDefinition__c);
                insert WebsiteRequest;
                newCaseId = WebsiteRequest.Id;
                if(fileName != null && fileName != '')
                {
                    Attachment attach = new Attachment();
                    attach.Body = file;
                    attach.Name = fileName;
                    attach.ContentType = contentType;
                    attach.parentId = newCaseId;
                    sr = Database.insert(attach);
                }
                if(fileName2 != null && fileName2 != '')
                {
                    Attachment attach2 = new Attachment();
                    attach2.Body = file2;
                    attach2.Name = fileName2;
                    attach2.ContentType = contentType;
                    attach2.parentId = newCaseId;
                    sr = Database.insert(attach2);
                }
                if(fileName3 != null && fileName3 != '')
                {
                    Attachment attach3 = new Attachment();
                    attach3.Body = file3;
                    attach3.Name = fileName3;
                    attach3.ContentType = contentType;
                    attach3.parentId = newCaseId;
                    sr = Database.insert(attach3);
                }
            }  //if (includeWebsiteQuote == 'true')
        }
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }

        PageReference p = new PageReference('/DigitalAuditThankYou');
        p.setRedirect(true);
        return p;

    } //saveRequest()
        
/**
    //<testmethod>
    @isTest(SeeAllData=true)
    static void testDigitalAuditRequest() 
    {
        Lead ld = new Lead();
        ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(ld);
        DigitalAuditRequestExtension ext = new DigitalAuditRequestExtension(ctl);
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
        List<SelectOption> media = ext.mediaPartnerOptions;
        List<SelectOption> yesNo = ext.yesNoOptions;
        ld.LastName = 'Test';
        ld.Company = 'Test';
        ld.Affiliated_Sales_Rep__c = 'Test';
        if (media.size() > 0) {
            SelectOption opt = media[0];
            ext.selectedMediaPartners.add(opt.getValue());
        }
        
        ext.saveRequest();
        
    } **/
}