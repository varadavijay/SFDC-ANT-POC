trigger MoveSignedAgreement on Attachment (after insert, after update) {
	Map<Id,Attachment> attachments = new Map<Id,Attachment>();
	Map<Id,List<Attachment>> attachmentsMap = new Map<Id,List<Attachment>>();
	
	for( Attachment attachment : Trigger.new ) {
		//If the attachment parent id is not set, skip this attachment
		if( attachment.ParentId == null ) {
			continue;
		}
		
		//If the attachment was updated but the parent id is the same, skip this attachment
		if( Trigger.oldMap != null ) {
			Attachment oldAttachment = Trigger.oldMap.get(attachment.Id);
			if( oldAttachment != null && (oldAttachment.ParentId == attachment.ParentId) ) {
				continue;
			}
		}
		
		//Save the list of attachments associated with each agreement
		List<Attachment> curAttachments = attachmentsMap.get(attachment.ParentId);
		if( curAttachments == null ) {
			curAttachments = new List<Attachment>();
			attachmentsMap.put(attachment.ParentId, curAttachments);
		}
		
		curAttachments.add(attachment);
		
		//Save attachments keyed off it id
		attachments.put(attachment.Id,attachment);
	}
	
	//Query the attachments again to get fresh data, required, otherwise the body/content of the agreement cloned to the opp was empty
	attachments = new Map<Id,Attachment>([SELECT Id,Name,Description,ParentId,Body,BodyLength,ContentType,OwnerId FROM Attachment WHERE Id IN :attachments.keySet()]);

	//For each agreement create a new econtract record and link it to the agreement
	Map<Id,EContract__c> contractsMap = new Map<Id,EContract__c>();
	
	List<echosign_dev1__SIGN_Agreement__c> agreements = [Select Id,echosign_dev1__Status__c,echosign_dev1__Account__c,echosign_dev1__Opportunity__c from echosign_dev1__SIGN_Agreement__c where Id IN :attachmentsMap.keySet()];
	for( echosign_dev1__SIGN_Agreement__c agreement : agreements ) {
		//If the agreement status value is not set or is not signed or not declined, skip this agreement
		if( agreement.echosign_dev1__Status__c == null || (agreement.echosign_dev1__Status__c != 'Signed' && agreement.echosign_dev1__Status__c != 'Cancelled / Declined') ) {
			continue;
		}
		
		EContract__c contract = new EContract__c();
		contract.Agreement__c = agreement.Id;
		contract.Opportunity__c = agreement.echosign_dev1__Opportunity__c;
		contract.Account__c = agreement.echosign_dev1__Account__c; 
		
		contractsMap.put(agreement.Id, contract);
	}
	
	//Create the new contracts
	insert contractsMap.values();
	
	//Costruct attachements to remove from the agreement and create a clone under the econtract
	List<Attachment> deleteAttachments = new List<Attachment>();
	List<Attachment> insertAttachments = new List<Attachment>();
	for( Id id : contractsMap.keySet() ) {
		List<Attachment> curAttachments = attachmentsMap.get(id);
		EContract__c contract = contractsMap.get(id);
		for( Attachment attachment : curAttachments ) {
			Attachment newAttachment = attachments.get( attachment.Id ).clone(false, true);
			newAttachment.ParentId = contract.Id;
			
			Attachment oldAttachment = new Attachment(Id=attachment.Id);
			
			deleteAttachments.add(oldAttachment);
			insertAttachments.add(newAttachment);
		}
	}
	
	//delete deleteAttachments;	
	insert insertAttachments;
}