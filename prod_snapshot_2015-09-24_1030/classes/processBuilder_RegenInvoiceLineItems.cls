/* This class will be invoked from process builder
    This class handles the regeneration of Invoive Line items
*/

public class processBuilder_RegenInvoiceLineItems{  
	
	@InvocableMethod
    public static void regenerateInvoiceLineItems(List<Project__c> proj){
        if(proj != null && proj.size()>0){
            
            map<Id, Id> oliIdWithProjectMap = new  map<Id, Id>();
            for(Project__c proObj : proj){
                
                oliIdWithProjectMap .put(proObj.Product_Id__c, proObj.Id);
                
            }
            
            USCPILIGenerator iliGenerator = new USCPILIGenerator ();
            iliGenerator.regenerateInvoiceLineItems(oliIdWithProjectMap);
        }
    }
}