trigger beforeonAccount_trigger on Account (before delete, before insert, before update) {
	if(trigger.isUpdate){
		for( Account Acct : Trigger.new){
			
			String AcctBillStrt;
			Acct.Owner__c = Acct.OwnerId;
			if(Acct.BillingStreet != Null){
				AcctBillStrt = Acct.BillingStreet;
			}
			else{
				AcctBillStrt = '';
			}
			
			if(Acct.RecordTypeId == '012F0000000y9WcIAI'){
				Acct.Market_Originator__c = Null;
			}
			if(AcctBillStrt.contains('\n')){
				Acct.CF_Line_Break__c = 'Street Address';
				Acct.BillingStreet = Acct.BillingStreet.replaceall('\n',' ');
			}
			else{
				Acct.CF_Line_Break__c = 'No Line Break';
			}
		}
	}
	if(trigger.isInsert){
		for( Account Acct : Trigger.new){
			
			String AcctBillStrt;
			Acct.Owner__c = Acct.OwnerId;
			if(Acct.BillingStreet != Null){
				AcctBillStrt = Acct.BillingStreet;
			}
			else{
				AcctBillStrt = '';
			}
			if(Acct.RecordTypeId == '012F0000000y9WcIAI'){
				Acct.Market_Originator__c = Null;
			}
			if(AcctBillStrt.contains('\n')){
				Acct.CF_Line_Break__c = 'Street Address';
				Acct.BillingStreet = Acct.BillingStreet.replaceall('\n',' ');
			}
			else if(Acct.CF_Line_Break__c == Null){
				Acct.CF_Line_Break__c = 'No Line Break';
			}
			else{}
		}
	}
}