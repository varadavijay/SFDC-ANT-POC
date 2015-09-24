/* This class will be invoked from process builder
    This class handles the insertion of Invoive Line items
*/

public class processBuilder_UpdateInvoiceLineItems{
  
    @InvocableMethod
    public static void updateInvoiceLineItems(List<Project__c> proj){
      System.debug('**********UpdateILI_EndDate************'+proj);
        if(proj != null && proj.size()>0){
            
            map<Id, Id> oliIdWithProjectMap = new  map<Id, Id>();
            for(Project__c proObj : proj){
                
                oliIdWithProjectMap .put(proObj.Product_Id__c, proObj.Id);
                
            }
            system.debug('********proj**********'+proj);
            system.debug('********oliIdWithProjectMap*********'+oliIdWithProjectMap );
            
            USCPILIGenerator iliGenerator = new USCPILIGenerator ();
            iliGenerator.updateInvoiceLineItems(oliIdWithProjectMap);
            
            
        }
        
    }
}