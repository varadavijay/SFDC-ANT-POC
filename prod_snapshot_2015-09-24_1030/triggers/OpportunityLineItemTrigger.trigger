trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, before delete,after delete, after insert, after update, after undelete) {
    // This is the only line of code that is required for the Trigger Framework
    TriggerFactory.createTriggerDispatcher(OpportunityLineItem.sObjectType);
}