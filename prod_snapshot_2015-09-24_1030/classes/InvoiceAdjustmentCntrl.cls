public class InvoiceAdjustmentCntrl {
 Public Id oliId {set;get;}
 public Invoice_LineItem__c ili {set;get;}    
 public InvoiceAdjustmentCntrl() {
   oliId = ApexPages.currentPage().getParameters().get('oliid'); 
   ili = new Invoice_LineItem__c();  
    
 }
    
 public pageReference adjustInvoiceDetails()
 {
  PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+oliId); 
     
     OpportunityLineItem oli1 = [select id,name,Project__c,OpportunityId from OpportunityLineItem where id=:oliId];
 // List<Invoice_LineItem__c> invLineItemLst  = [select id,name,TotalMonthlyCharge__c,InvoiceType__c,Invoice_PeriodStart__c,Invoice_PeriodEnd__c,Invoice_ScheduleDate__c,OpportunityRef__c,ProjectRef__c from Invoice_LineItem__c where OpportunityRef__c =:oli1.OpportunityId  and ProjectRef__c =:oli1.Project__c];
     boolean errFlag = false;
     String errMsg = 'Please select';
     if(ili.Invoice_CreditOrDebit__c == null)
     {    errFlag = true;
          errMsg = errMsg +' Credit or Debit';
     }
      
     if(ili.Invoice_CreditOrDebit_Reason__c == null)
     {
      if(errFlag)
          errMsg = errMsg +' , Adjustment Reason';
         else
           errMsg = errMsg +' Adjustment Reason';
           
         errFlag = true;
        
     }
     if(ili.TotalMonthlyCharge__c == null)
     {
       if(errFlag)
       errMsg = errMsg +' and enter an Amount';
       else
        errMsg = 'Please enter an Amount';
        
         errFlag = true;
        
     }  
       
     
     if(errFlag)
     {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsg));
         ref = null;
     }
     else if(oli1.Project__c != null)
     {
       Invoice_LineItem__c ili1 = new Invoice_LineItem__c();
        ili1.Invoice_LineItemType__c = 'Adjustment';
      if(ili.Invoice_CreditOrDebit__c == 'Credit')
     {
          ili1.TotalMonthlyCharge__c = (-ili.TotalMonthlyCharge__c);
         
     }
     else if(ili.Invoice_CreditOrDebit__c == 'Debit')
     {
         ili1.TotalMonthlyCharge__c = (ili.TotalMonthlyCharge__c);   
     }
         ili1.Invoice_CreditOrDebit_Reason__c =  ili.Invoice_CreditOrDebit_Reason__c;
         ili1.Invoice_PeriodStart__c  = date.today();
         ili1.Invoice_PeriodEnd__c  = date.today();
         ili1.Invoice_CreditOrDebit__c = ili.Invoice_CreditOrDebit__c;
         ili1.Invoice_AdjustmentDetails__c = ili.Invoice_AdjustmentDetails__c;
         ili1.OpportunityRef__c = oli1.OpportunityId;
         ili1.ProjectRef__c = oli1.Project__c;
         
         insert ili1;
     }  
   
   return ref;  
 }

    public PageReference cancel()
    {
        PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+oliId);
        
        return ref;
    }
}