public class UpdateAgreementCntrl {
    private OpportunityLineItem oliRecord;
	/*public OpportunityLineItem oli {
		set;
		get;
	}
	public OpportunityLineItem olistd {
		set;
		get;
	}*/
	public String sellType {
		set;
		get;
	}
	
	public UpdateAgreementCntrl(ApexPages.StandardController stdController) {
		oliRecord = (OpportunityLineItem) stdController.getRecord();
		oliRecord.Qty_ContractMonths__c = 4;
	}
	
	public PageReference save() {
		OpportunityLineItem existingOLI = [SELECT Id, Waiting_Status__c,
												Record_Type_Name__c,
												Discount, OpportunityId,
												Description, Product2ID, ProductCode, Name, UnitPrice,
												Opp_Owner__c, Qty_ContractMonths__c,
												Dig_Account_Manager__c,
												Affl_Sales_Rep__c,
												Notify_Email_1__c,
												Notify_Email_2__c,
												Notify_Email_3__c,
												ServiceDate,
												PricebookEntryId,
												Quantity,
												Cancellation_Category__c,
												Cancellation_Reason__c,
												Sell_Type__c,
												Invoice_CancelDate__c,
												Waiting_Status_Descr__c,
												NumberOfLocations__c, NumberOfHours__c, Invoice_ServiceStartDate__c, Invoice_ServiceEndDate__c, Invoice_CancelFeePercent__c,
												Qty_LineItems__c, Email_Recipients_Qty__c, Mgmt_Fee_Percent__c
											FROM OpportunityLineItem WHERE Id = : oliRecord.Id];
		 
		OpportunityLineItem newOLI = new OpportunityLineItem();

		newOLI.Record_Type_Name__c = existingOLI.Record_Type_Name__c;
		newOLI.Waiting_Status__c = 'Closed Won';
		newOLI.Discount = existingOLI.Discount;
		newOLI.Description = existingOLI.Description;
		newOLI.PricebookEntryId = existingOLI.PricebookEntryId;
		//retrieving Qty_ContractMonths__c from controller oli record
		newOLI.Qty_ContractMonths__c = oliRecord.Qty_ContractMonths__c;
		//newOLI.Quantity = existingOLI.Quantity;
		newOLI.OpportunityId = existingOLI.OpportunityId;
		newOLI.UnitPrice = existingOLI.UnitPrice;
		newOLI.Opp_Owner__c = existingOLI.Opp_Owner__c;
		newOLI.Dig_Account_Manager__c = existingOLI.Dig_Account_Manager__c;
		newOLI.Affl_Sales_Rep__c = existingOLI.Affl_Sales_Rep__c;
		newOLI.Notify_Email_1__c = existingOLI.Notify_Email_1__c;
		newOLI.Notify_Email_2__c = existingOLI.Notify_Email_2__c;
		newOLI.Notify_Email_3__c = existingOLI.Notify_Email_3__c;
		newOLI.Mgmt_Fee_Percent__c = existingOLI.Mgmt_Fee_Percent__c;
		newOLI.Email_Recipients_Qty__c = existingOLI.Email_Recipients_Qty__c;
		newOLI.Qty_LineItems__c = existingOLI.Qty_LineItems__c;
		newOLI.Invoice_CancelFeePercent__c = existingOLI.Invoice_CancelFeePercent__c;
		
		if (existingOLI.Invoice_ServiceStartDate__c != null) {
			newOLI.Invoice_ServiceStartDate__c = existingOLI.Invoice_ServiceEndDate__c.addDays(1);
			newOLI.Invoice_ServiceEndDate__c = newOLI.Invoice_ServiceStartDate__c.addMonths(Integer.ValueOf(newOLI.Qty_ContractMonths__c));
		}
		
		newOLI.ServiceDate = existingOLI.ServiceDate;
		newOLI.ReferenceID_OriginalNewSell__c = existingOLI.id;
		newOLI.NumberOfHours__c = existingOLI.NumberOfHours__c;
		newOLI.NumberOfLocations__c = existingOLI.NumberOfLocations__c;
		existingOLI.Waiting_Status__c = 'Fulfilled Renewed';
		
        if (sellType != 'None') {
			newOLI.Sell_Type__c = sellType;
		}
			
		
		PageReference ref;
		try {
				if(sellType == 'None'){
            	String errMsg = 'Please select a Sell Type';
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsg));
            	ref = null;
        		}
            	else{            
				
				insert newOLI;
				update existingOLI;
				ref = new PageReference('/apex/OpportunityLineItemUSCP?id=' + newOLI.Id);
            	}
			} 
        catch (DmlException ex) 
        	{
			System.debug('Update OLI exception details from OpportunityLineItemUSCPCancelController Controller >> ' + ex);
			if (ex.getDmlStatusCode(0) != null && ex.getDmlFields(0) == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
			}
			ref = null;
		}

		return ref;
	}


	public PageReference cancel() {
		PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id=' + oliRecord.Id);

		return ref;
	}

}