/* 
Notes/Todos: Start of OnBoardForm Trigger Code 

TODO: 
1. Clear all product details depending on the selection/unselection of the products
2. Business rules to create case and attachment
3. Create Test Class to improve code coverage
*/
trigger OnBoardFormModelTrigger on OnBoardFormModel__c (	after insert, 
													after update, 
													after delete,
													after undelete,
													before insert, 
													before update, 
													before delete){
	// This is the only line of code that is required for the Trigger Framework
	TriggerFactory.createTriggerDispatcher(OnBoardFormModel__c.sObjectType);
}