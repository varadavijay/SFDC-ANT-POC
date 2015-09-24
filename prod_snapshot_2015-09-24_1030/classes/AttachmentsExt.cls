//Handling Multiple Attachments
public without sharing class AttachmentsExt 
{
	public  Id AttachmentId {get; set;}
	public  String AttachmentName {get; set;}
	public  transient String AttachmentBody {get; set;}
	public  String AttachmentcontentType {get; set;}
	public  String AttachmentDescription {get; set;}
	public  Id ParentId {get; set;}
	public  String siteAttachmentsParentRecordName = 'OnBoardFormAttachments-' + String.ValueOf(system.today());
	public void uploadAttachment()
	{
		//Create a site attachment parent record if there is none 
		//This parent record is used by all onboard form request to attach files as a placeholder until the form is submitted.
		//Once the form is submitted all attachment are reparented to onboardformmodel and delete the corresponding attchment here.
		//We may need to create a batch process to cleanup orphan site attachments with some criteria.
		if(ParentId == null){
			List<SiteAttachment__c> siteAttachParentRecords = [Select Id, Name from SiteAttachment__c Where Name =: siteAttachmentsParentRecordName];
			if(siteAttachParentRecords <> null && siteAttachParentRecords.size()>0){
				ParentId = siteAttachParentRecords[0].Id;
			}else{
				SiteAttachment__c siteAttachParentRecord = new SiteAttachment__c();
				siteAttachParentRecord.Name = siteAttachmentsParentRecordName;
				upsert siteAttachParentRecord;
				ParentId = siteAttachParentRecord.Id;
			}
		}
		System.debug('AttachmentsExt.uploadAttachment()  >> '+ this);
		//Attaching file to siteattachment
		If(parentId <>null){
			if (String.IsBlank(AttachmentName) 
				|| String.IsBlank(AttachmentBody)){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a file to attach', ''));
				return;
			}
            Attachment att = new Attachment(); 
            att.Name=AttachmentName;
            att.ContentType=AttachmentcontentType;
            att.Body = EncodingUtil.base64Decode(AttachmentBody);
            att.Description = AttachmentDescription;
			att.ParentId = ParentId;
			
			if(AttachmentId != null && String.IsNotBlank(AttachmentId)){
				//Validating if the Attachment Id exists or not - DE655
				List<Attachment> siteAttachments = [Select Id from Attachment Where Id =: AttachmentId];
				if(siteAttachments.size()>0){
					att.Id = AttachmentId;
				}
			}
			upsert att; 
			AttachmentId = att.Id;
			AttachmentBody=null;
			System.debug('What is the newly attached attachment Id >> ' + att.Id);
		}
	}
}