trigger afteronUser_trigger on User (after delete, after insert, after undelete, after update) {
/**	if(Trigger.isInsert){
		List<KPIRep__c> KPIList = [SELECT Id, Name, User__c FROM KPIRep__c WHERE Id != Null];
		for (User uIterator : Trigger.new) {
			Boolean AddToKPI = True;
			for(KPIRep__c tempKPI : KPIList){
				if(uIterator.Name == tempKPI.Name){
					AddToKPI = False;
				}
			}
			if(AddtoKPI == True){
				KPIRep__c newkpirep = new KPIRep__c(Name = uIterator.Name,User__c = uIterator.Id);
				insert newkpirep;
			}
		}
	}
**/
}