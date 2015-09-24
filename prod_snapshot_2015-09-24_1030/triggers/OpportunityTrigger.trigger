trigger OpportunityTrigger on Opportunity (	after insert, 
											after update, 
											after delete,
											after undelete,
											before insert, 
											before update, 
											before delete)
{
	
	/* 
	
	Notes/Todos: Start of Opportunity Trigger Code Transplant Phase 1
	
	Phase RoadMap : 
		- Script: Run Test and Save Results
		- Phase 1 : Deploy Trigger Framework with Opportunity Trigger Event Handlers (empyty)
		- Script: Run Test and Compare, Save Results
		- Phase 2 : Deploy Trigger Framework with All SObject Trigger Event Handlers (empyty)
		- Script: Run Test and Compare, Save Results
		- Phase 3 : Code Transplant Existing Opportunity Trigger Code to Appropriate Event Handlers (no refactoring)
				  : Trigger Event Handler Classes will be evoked on the SObject and any static code or 
				  :  function calls will be executed from here on. 
		- Script: Run Test and Compare, Save Results
		- Phase 4 : Code Transplant Existing SObject Trigger Code to Appropriate Event Handlers (no refactoring)
	 	- Script: Run Test and Compare, Save Results
	 	- Phase 5 : Begin Refactoring Proceess
	 	
	*/
	
	
	// This is the only line of code that is required for the Trigger Framework
	TriggerFactory.createTriggerDispatcher(Opportunity.sObjectType);
		
}