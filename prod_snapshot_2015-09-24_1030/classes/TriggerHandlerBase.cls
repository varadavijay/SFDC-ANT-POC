/**
* @description This class implements the ITriggerHandler to provide abstract/virtual methods for the interface methods
*				and so that the trigger handlers need to implement only the method that they have to. The only exception
*				is the mainEntry, which is mandatory for the trigger handlers to implement.
*/
public abstract class TriggerHandlerBase implements ITriggerHandler {
	private Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();
	protected List<SObject> sObjectsToInsert = new List<SObject>();
	
	/** 
	* @description Called for the first time in the execution context. The trigger handlers need to implement
	*				this method.
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public abstract void mainEntry(TriggerParameters tp);
	
	/** 
	* @description Called for the subsequent times in the same execution context. The trigger handlers can chose
	*				to ignore if they don't need the reentrant feature.
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public virtual void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/** 
	* @description Updates the objects, if any.
	*/
	public virtual void updateObjects() {
		if(sObjectsToUpdate.size() > 0){
			update sObjectsToUpdate.values();
			sObjectsToUpdate.clear();
		}
	}
	
	/** 
	* Added By: Vijay Varada
	* @description Insert the objects, if any.
	*/
	public virtual void insertObjects() {
		if(sObjectsToInsert.size() > 0){
			insert sObjectsToInsert;
			sObjectsToInsert.clear();
		}
	}
	
	
	
	/** 
	* Added By: Vijay Varada
	* @description return a reference to existing or new sObject from sObjectsToUpdate and caller is responsible for casting
	*/
	protected sObject getReferenceToSobjectsToUpdateRecord(Id oneId){
		sObject newSObject = this.sObjectsToUpdate.get(oneId);
	    if(newSObject == null){
	        newSObject = oneId.getSObjectType().newsObject();
	    } 
	    newSObject.Id = oneId;
	    //Eventhough we are placing newOppLineItem in map here since its a reference it will get further updates too!.
	    this.sObjectsToUpdate.put(newSObject.Id, newSObject); 
	    return newSObject;
	}
	
	
	/** 
	* Added By: Vijay Varada
	* @description adds the sObject to the map that gets updated at the end. Use this method only in cases where your sobjects are getting updated 
	* only in single method because this method overrides the entire sObject in the map with the new sObject
	*/
	protected void addSObjectForUpdate(Id oneId, sObject oneObject){
		if(oneId == null){
			throw new TriggerException('Salesforce Id passed to this method(TriggerHandlerBase.addSObjectForUpdate) cannot be null.');
		}
	    this.sObjectsToUpdate.put(oneId, oneObject);
	}
}