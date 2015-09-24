/* This class will be invoked from process builder
    This class handles the modification of Invoive Line items
*/


public class processBuider_CancelInvoiceLineItems{

   @InvocableMethod
   public static void cancelInvoiceLineItems (List<Project__c> proj){
      if(proj != null && proj.size()>0){
            set<Id> projIdsCancel = new set<Id>();
            set<Id> projIdsHardCancel = new set<Id>();
            for(Project__c projObj : proj){
                if(projObj.Project_Status__c =='Cancelled'){
                    projIdsCancel.add(projObj .Id);
                }
                else if(projObj.Project_Status__c =='Hard Cancel'){
                    projIdsHardCancel.add(projObj .Id);
                }
            }
            
            USCPILIGenerator iliGenrator= new USCPILIGenerator ();
            if(projIdsCancel.size()>0){
                iliGenrator.cancelInvoiceLineItems(projIdsCancel);
            }
            if(projIdsHardCancel.size()>0){
                iliGenrator.hardCancelInvoiceLineItems(projIdsHardCancel);
            }
        }
    }
}