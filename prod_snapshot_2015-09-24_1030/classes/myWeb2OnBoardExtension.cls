public with sharing class myWeb2OnBoardExtension {
	// <CC> will contain a lot of the same cleanup from other extension classes after the <string> is addressed 
	// <string>
	public Case newCase {get; set;}	public String selectSubmitType {get;set;}public String includenotify {get;set;} public String includerepdash {get;set;} private final Case webcase;public String fileName {get;set;}public String fileName2 {get;set;}public String contentType {get; set;}public Blob file {get; set;}public Blob file2 {get; set;}public Boolean submitted {get;set;}public myWeb2OnBoardExtension(ApexPages.StandardController stdController){webcase = (Case)stdcontroller.getRecord();}public List<SelectOption> getItems(){List<SelectOption> options = new List<SelectOption>();options.add(new SelectOption('--None--','Choose One'));options.add(new SelectOption('003F000000y4o1V','Not In List'));List<Contact> afflcontactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' and Web_Submitter__c = True order by Name limit 998];for (Integer j=0;j<afflcontactList.size();j++)  {options.add(new SelectOption(afflcontactList[j].Id,afflcontactList[j].Name));}return options;}
	// <string>
	public List<SelectOption> yesNoOptions {get{if (yesNoOptions == null) {yesNoOptions = new List<SelectOption>();yesNoOptions.add(new SelectOption('false','No'));yesNoOptions.add(new SelectOption('true','Yes'));}return yesNoOptions;}private set;}
    // <string>
    public List<SelectOption> getnotifies(){List<SelectOption> notify = new List<SelectOption>();notify.add(new SelectOption('003F000000y4o1V','Choose One'));List<Contact> afflcontactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' order by Name limit 998];for (Integer j=0;j<afflcontactList.size();j++)  {notify.add(new SelectOption(afflcontactList[j].Id,afflcontactList[j].Name));}return notify;} public List<SelectOption> getItemsm(){List<SelectOption> moptions = new List<SelectOption>();List<Account> marketList = [Select Id, Media_Property_List__c FROM Account where RecordTypeId = '012F0000000y9Wc' and Id != '001F000000n1sGU' and Id != '001A000000QTk0g' order by Media_Property_List__c];moptions.add(new SelectOption('--None--','Choose One'));for (Integer j=0;j<marketList.size();j++){moptions.add(new SelectOption(marketList[j].Id,marketList[j].Media_Property_List__c));}moptions.add(new SelectOption('001A000000QTk0g','G/O Digital'));return moptions;}String newCaseId;public PageReference saveCase(){Database.Saveresult sr;try{if (includenotify != 'true'){webcase.Notify_Email_1__c=null;webcase.Notify_Email_2__c=null;webcase.Notify_Email_3__c=null;}insert(webcase);newCaseId = webcase.Id;}catch(System.DMLException e) {ApexPages.addMessages(e);return null;}if(fileName2 != null && fileName2 != ''){Attachment attach = new Attachment();attach.Body = file2;attach.Name = fileName2;attach.ContentType = contentType;attach.parentId = newCaseId;sr = Database.insert(attach);}if(fileName != null && fileName != ''){Attachment attach = new Attachment();attach.Body = file;attach.Name = fileName;attach.ContentType = contentType;attach.parentId = newCaseId;sr = Database.insert(attach);}PageReference p = new PageReference('/ThankYouFromGLOnBoard');p.setRedirect(true);return p;}
	//public List<SelectOption> getnotifies(){List<SelectOption> notify = new List<SelectOption>();notify.add(new SelectOption('003F000000y4o1V','Choose One'));notify.add(new SelectOption('003F000000y4o1V','Not In List'));List<Contact> afflcontactList = [Select Id, Name FROM Contact where RecordTypeId = '012F0000000y9gD' and LastName != 'In List' and Email != '' order by Name limit 998];for (Integer j=0;j<afflcontactList.size();j++)  {notify.add(new SelectOption(afflcontactList[j].Id,afflcontactList[j].Name));}return notify;}
}