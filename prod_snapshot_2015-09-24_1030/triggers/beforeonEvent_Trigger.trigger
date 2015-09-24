trigger beforeonEvent_Trigger on Event (before delete, before insert, before update) {
	if(Trigger.isInsert || Trigger.isUpdate){
	
		// <PWP> Iterator
		for(integer x = 0; x < Trigger.new.size(); x++)
		{
			if(Trigger.new[x].ActivityDate != Null){
			Trigger.new[x].Date_Scheduled__c = Trigger.new[x].ActivityDate;
			}
			if(Trigger.new[x].Description != Null){
				Integer StrLen = Trigger.new[x].Description.length();
				if (StrLen <= 255){
					StrLen = StrLen;
				}
				else{
					StrLen = 255;
				}
				Trigger.new[x].Blog__c = Trigger.new[x].Description.substring(0, StrLen);
			}
		}
	}
}