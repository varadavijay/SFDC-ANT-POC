public abstract class AbstractInvoiceLineItemsClass
{   
    // creating the  Invoice_Line_Items__c records as per the arguments
    
    public virtual list<Invoice_LineItem__c> createInvoiceLineItems(Integer qtyContractMonths, Date startDate, Decimal oliMonthlyTotal, Id opportunityId, Id projectId){
            
        List<Invoice_LineItem__c> invoiceLineItemList = new List<Invoice_LineItem__c>();
        
        
        for(integer i = 0; i < qtyContractMonths; i++){
            Invoice_LineItem__c invLineItem = new Invoice_LineItem__c();
                invLineItem.Invoice_PeriodStart__c = startDate.addmonths(i);
                invLineItem.Invoice_PeriodEnd__c = startDate.addmonths(i+1).adddays(-1);
                invLineItem.OpportunityRef__c = OpportunityId;
                invLineItem.ProjectRef__c = projectId;
                invLineItem.TotalMonthlyCharge__c = oliMonthlyTotal;
                invLineItem.Invoice_LineItemType__c = 'Standard';
            invoiceLineItemList.add(invLineItem);
        }
            
        return invoiceLineItemList;
    }
    public virtual list<Invoice_LineItem__c> createInvoiceLineItemsForONEProduct(Integer qtyContractMonths, Date startDate, Decimal oliMonthlyTotal, Id opportunityId, Id projectId){
            
        List<Invoice_LineItem__c> invoiceLineItemList = new List<Invoice_LineItem__c>();
       
        
        if(qtyContractMonths!=null && qtyContractMonths>0){
            Invoice_LineItem__c invLineItem = new Invoice_LineItem__c();
                invLineItem.Invoice_PeriodStart__c = startDate;
                invLineItem.Invoice_PeriodEnd__c = startDate.addmonths(1).adddays(-1);
                invLineItem.OpportunityRef__c = OpportunityId;
                invLineItem.ProjectRef__c = projectId;
                invLineItem.TotalMonthlyCharge__c = oliMonthlyTotal;
                invLineItem.Invoice_LineItemType__c = 'Standard';
            invoiceLineItemList.add(invLineItem);
            
            Invoice_LineItem__c invLineItem1 = new Invoice_LineItem__c();
                invLineItem1.Invoice_PeriodStart__c = null;
                invLineItem1.Invoice_PeriodEnd__c = null;
                invLineItem1.OpportunityRef__c = OpportunityId;
                invLineItem1.ProjectRef__c = projectId;
                invLineItem1.TotalMonthlyCharge__c = oliMonthlyTotal;
                invLineItem1.Invoice_LineItemType__c = 'Standard';
            invoiceLineItemList.add(invLineItem1);
        }
            
        return invoiceLineItemList;
    }
    public virtual void insertInvoiceLineItems(List<Invoice_LineItem__c> invoiceLineItemList){
          if(invoiceLineItemList != null && invoiceLineItemList.size()>0){
              system.debug('********invoiceLineItemList**********'+invoiceLineItemList);
            insert invoiceLineItemList;
          }  
    }
    
     // Soft Deleting  Invoice_Line_Items__c records based on like cancel checkbox which in turn calls update on ili's
    public  virtual void deleteInvoiceLineItems(list<Invoice_LineItem__c> invLineItemList){
      for(Invoice_LineItem__c invLineItem : invLineItemList){
            invLineItem.isDeleted__c = true;
            //invLineItem.Invoice_LineItemType__c = 'Cancel'; DEV 3106
        }
        if(invLineItemList!= null && invLineItemList.size() > 0){
             update invLineItemList;
         }
    }
    
    // Updating Invoice LineItems.
    public virtual void updateInvoiceLineItems(list<Invoice_LineItem__c> invLineItemList){
      
        if(invLineItemList!= null && invLineItemList.size() > 0){
             update invLineItemList;
         }
    } 
    
    //Compare Existing ILI List Vs New ILI List and return final ILI List for Regen ILIs
    public  virtual list<Invoice_LineItem__c> regenCreateInvoiceLineItems(list<Invoice_LineItem__c> oldInvLineItemList, 
    													list<Invoice_LineItem__c> newInvLineItemList){
      List<Invoice_LineItem__c> processILIs = new List<Invoice_LineItem__c>();
      //returning back if there are new ILIs 
      if(!(newInvLineItemList!=null && newInvLineItemList.size()>0)){
      	 return processILIs;
      }
      
      Map<Date, Invoice_LineItem__c> newMapILIs = new Map<Date, Invoice_LineItem__c>();
      for(Invoice_LineItem__c  oneILI : newInvLineItemList){
      	 newMapILIs.put((Date)oneILI.Invoice_PeriodStart__c.addMonths(1).toStartofMonth(), oneILI);
      }
      
      System.debug('Map of New ILIs with Date param >> ' + newMapILIs);      
      if(oldInvLineItemList!=null){
	      for(Invoice_LineItem__c  oneILI : oldInvLineItemList){
	      	 System.debug('There are old values here >> ' + (Date)oneILI.Invoice_ScheduleDate__c);
	      	 newMapILIs.remove((Date)oneILI.Invoice_ScheduleDate__c);
	      } 
      }
      processILIs = newMapILIs.values();
      return processILIs;
    } 
}