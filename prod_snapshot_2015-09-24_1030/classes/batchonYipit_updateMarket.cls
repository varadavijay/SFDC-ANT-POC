global class batchonYipit_updateMarket implements Database.Batchable<Yipit__c>{
	Date YipitLimit = date.today()-14;
	List<Yipit__c> YipsToUpdate = [SELECT Id, Division__c, Market__c FROM Yipit__c WHERE Date_Ended__c >= :YipitLimit limit 50000];
	List<Yipit_Market__c> YipMarks = [SELECT Id, Name, Market__c FROM Yipit_Market__c];
	global Iterable<Yipit__c> start(database.batchablecontext Yips){
		return (YipsToUpdate);
	}
	global void execute(Database.BatchableContext Yips, List<Yipit__c> scope){
		List<Yipit__c> YipsToLoad = new List<Yipit__c>();
		for(Yipit__c tempYip : scope){
			for(Yipit_Market__c tempYipMark : YipMarks){
				if(tempYipMark.Name == tempYip.Division__c){// && (tempYip.Market__c == Null || tempYip.Market__c != tempYipMark.Market__c)){}
					tempYip.Market__c = tempYipMark.Market__c;
					YipsToLoad.add(tempYip);
					//YipsToLoad.add((Yipit__c) tempYip);
				}
			}
		}
		upsert YipsToLoad;//upsert scope;
	}
global void finish(Database.BatchableContext info){}
}