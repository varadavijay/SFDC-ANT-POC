/**
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*        on the Account object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*        This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*        to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*        as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
*/

public class LeadTriggerDispatcher extends TriggerDispatcherBase {
  private static Boolean isBeforeInsertProcessing = false;
  private static Boolean isBeforeUpdateProcessing = false;
  private static Boolean isBeforeDeleteProcessing = false;
  private static Boolean isAfterInsertProcessing = false;
  private static Boolean isAfterUpdateProcessing = false; 
  private static Boolean isAfterDeleteProcessing = false; 
  private static Boolean isAfterUndeleteProcessing = false; 
  
  /** 
  * @description   Called by the trigger framework to carry out the actions before the records are inserted. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void beforeInsert(TriggerParameters tp) {
    if(!isBeforeInsertProcessing) {
      isBeforeInsertProcessing = true;
      execute(new LeadBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
      isBeforeInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
  }
  
  /** 
  * @description   Called by the trigger framework to carry out the actions before the records are updated. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void beforeUpdate(TriggerParameters tp) {
    if(!isBeforeUpdateProcessing) {
      isBeforeUpdateProcessing = true;
      execute(new LeadBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
      isBeforeUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
  }
  
  /** 
  * @description   Called by the trigger framework to carry out the actions before the records are deleted. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void beforeDelete(TriggerParameters tp) {
    if(!isBeforeDeleteProcessing) {
      isBeforeDeleteProcessing = true;
      execute(new LeadBeforeDeleteTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeDelete);
      isBeforeDeleteProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeDelete);
  }

  /** 
  * @description   Called by the trigger framework to carry out the actions after the records are inserted. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void afterInsert(TriggerParameters tp) {
    if(!isAfterInsertProcessing) {
      isAfterInsertProcessing = true;
      execute(new LeadAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isAfterInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }

  /** 
  * @description   Called by the trigger framework to carry out the actions after the records are updated. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void afterUpdate(TriggerParameters tp) {
    if(!isAfterUpdateProcessing) {
      isAfterUpdateProcessing = true;
      execute(new LeadAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
      isAfterUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
  }
  
  /** 
  * @description   Called by the trigger framework to carry out the actions after the records are deleted. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void afterDelete(TriggerParameters tp) {
    if(!isAfterDeleteProcessing) {
      isAfterDeleteProcessing = true;
      execute(new LeadAfterDeleteTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
      isAfterDeleteProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
  }
  
  /** 
  * @description   Called by the trigger framework to carry out the actions after the records are undeleted. 
  *         If there is an existing call running on the same context, the rentrant call will utilize
  *         the handler that was created in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void afterUndelete(TriggerParameters tp) {
    if(!isAfterUndeleteProcessing) {
      isAfterUndeleteProcessing = true;
      execute(new LeadAfterUndeleteTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUndelete);
      isAfterUndeleteProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterUndelete);
  }
}