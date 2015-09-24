/*This class is used on OpportunityLineItemUSCP.page and OpportunityLineItemUSCPEdit.pages
*/
public class OpportunityLineItemUSCPExt {
    
   public OpportunityLineItem controllerOli {set;get;}
   public OpportunityLineItem oli {set;get;}
   public String subtxt {set;get;}
   public String ProdName {set;get;}
   public String LastMod  {set;get;}
   public string creatdBy {set;get;}
   public OpportunityLineItemUSCPExt(ApexPages.StandardController stdController) {
      controllerOli = (OpportunityLineItem) stdController.getRecord(); 
       oli = [select id,name,opportunity.name,Project__r.Max_ILIScheduledDate__c,opportunity.stagename,OpportunityId,Product2.Name,LastModifiedBy.Name,CreatedBy.Name,Mgmt_Fee_Percent__c,Invoice_CancelDate__c,Waiting_Status_Options__c,Waiting_Status_Options_Before__c,Active_Product__c,Fulfillment_Specialist__c  from opportunityLineItem where id =:controllerOli.id];
      
       subtxt = oli.name;
       ProdName = oli.Product2.Name;
       LastMod = oli.LastModifiedBy.Name;
       creatdBy = oli.CreatedBy.Name; 
    }
	
	Public PageReference redirectSysAdmin(){
	   //Re-directing Sys Admins to OpportunityLineItemUSCPEditSysAdmin.page incase if they land on OpportunityLineItemUSCPEdit.page
	   List<User> loggedInUser = [Select Id, Profile.Name from User Where Id =: Userinfo.getUserId()];
	   PageReference ref;
	   if(loggedInUser!=null && loggedInUser.size()>0 && loggedInUser[0].Profile.Name == 'System Administrator'){
			ref = new PageReference('/apex/OpportunityLineItemUSCPEditSysAdmin?id='+controllerOli.id);
			ref.setRedirect(true);
	   }
	   return ref;
	}
    public PageReference editOpportunityProduct()
    {
		List<User> loggedInUser = [Select Id, Profile.Name from User Where Id =: Userinfo.getUserId()];
		PageReference ref;
		if(loggedInUser!=null && loggedInUser.size()>0 && loggedInUser[0].Profile.Name == 'System Administrator'){
			ref = new PageReference('/apex/OpportunityLineItemUSCPEditSysAdmin?id='+controllerOli.id);
		}else{
			ref = new PageReference('/apex/OpportunityLineItemUSCPEdit?id='+controllerOli.id);
		}
        ref.setRedirect(true);
        
        return ref;
    }
    
    public PageReference cancelInvoiceLineItems()
    {
        PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP_Cancelled?id='+controllerOli.id);
        ref.setRedirect(true);
        
        return ref;
    }
    
    public PageReference updateAgreement()
    {
        PageReference ref = new PageReference('/apex/UpdateAgreement?id='+controllerOli.id);
        ref.setRedirect(true);
        
        return ref;
    }
    
    public PageReference oliDelete()
    {
        
        PageReference ref = new PageReference('/'+controllerOli.opportunityid);
         ref.setRedirect(true);
         try{
            OpportunityLineItem oli = new OpportunityLineItem(id=controllerOli.id);
            delete oli;
            }catch(DmlException ex){
                 System.debug('Update OLI exception details from OpportunityLineItemUSCPCancelController Controller >> ' + ex);
                 if(ex.getDmlStatusCode(0) !=null && ex.getDmlFields(0) == null){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
                 }
                 ref = null;
             }    
        return ref;
    }
    
    public PageReference createPaymentEntries()
    {
        PageReference ref = null;
       try
       {
         String res = OpportunityPaymentEntries.createPaymentEntries(controllerOli.id);
          if(res == 'Success')
          {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Payment Entry created Succesfully');
           ApexPages.addMessage(msg); 
          }
           else
           {
               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,res);
           ApexPages.addMessage(msg);  
           }  
           
       }catch(Exception e)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
           ApexPages.addMessage(msg); 
       }
        return ref;
        
    }

  	public PageReference save()
  	{
        PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+controllerOli.id);
        ref.setRedirect(true);
    	try
        {
	if((controllerOli.Waiting_Status__c == null || controllerOli.Waiting_Status__c == '') && controllerOli.Waiting_Status_Options_Before__c!= null)
				{
        controllerOli.Waiting_Status__c = controllerOli.Waiting_Status_Options_Before__c;
                }
            else if(controllerOli.Waiting_Status_Options__c!= null)
				{
        controllerOli.Waiting_Status__c = controllerOli.Waiting_Status_Options__c;
                }
        update controllerOli;
        }catch(DmlException ex){
           System.debug('Update OLI exception details from Edit Controller >> ' + ex);
           if(ex.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY'))
           {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
           }
           else if(ex.getDmlStatusCode(0) !=null && ex.getDmlFields(0) == null){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
           }
           ref = null;
        }
        catch(Exception e)
        {
           System.debug('Update OLI exception details from Edit Controller >> ' + e);
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()); 
           ApexPages.addMessage(myMsg);
           ref = null;
        }
    	  
    	return ref;  
  	}
  	Public PageReference cancel()
  	{
      	//PageReference ref = new PageReference('/apex/OpportunityLineItemUSCPEdit?id='+controllerOli.id);
      	String oppType = ApexPages.currentPage().getParameters().get('type');
        system.debug('val::'+oppType);
        PageReference ref =  null;
        if(oppType != null && oppType == 'opp')
            ref = new PageReference('/'+controllerOli.opportunityid);
        else
           ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+controllerOli.id);
        
        ref.setRedirect(true);
        
    	return ref;
  	}
    
    Public PageReference invoiceAdjustment()
    {
      PageReference ref = new PageReference('/apex/InvoiceAdjustment?oliid='+controllerOli.id);
        
       return ref; 
        
    }
    
    public Boolean canCancelOLI {
		get
		{ 
			Map<String, Set<String>> permissionSet2Profiles = new Map<String,Set<String>>();
			//Finance, Client Services and Admin Profiles
		    permissionSet2Profiles.put('canCancelOLI', new set<String>{
												  'SML Customer Care /Encrypted Field Access',
												  'SML Customer Care',
												  'System Administrator',
												  'Digital Account Manager',
												  'Digital AM Team Manager',
												  'Digital Project Manager'}); 
												  
			List<User> loggedInUser = [Select Id, Profile.Name from User Where Id =: Userinfo.getUserId()];
		    if(loggedInUser!=null && loggedInUser.size()>0 && String.IsNotBlank(loggedInUser[0].Profile.Name) &&
				permissionSet2Profiles.get('canCancelOLI').contains(loggedInUser[0].Profile.Name)){	
				return true;
			}			
			return false;
		}
	}
	
	public Boolean canUpdateAgreement{
	   get{
	      return this.canAdjustInvoice;
	   }
	}
	
	public Boolean canAdjustInvoice {
		get
		{ 
			Map<String, Set<String>> permissionSet2Profiles = new Map<String,Set<String>>();
			//Finance and Admin Profiles
		    permissionSet2Profiles.put('canAdjustInvoice', new set<String>{
												  'SML Customer Care /Encrypted Field Access',
												  'SML Customer Care',
												  'System Administrator'}); 
												  
			List<User> loggedInUser = [Select Id, Profile.Name from User Where Id =: Userinfo.getUserId()];
		    if(loggedInUser!=null && loggedInUser.size()>0 && String.IsNotBlank(loggedInUser[0].Profile.Name) &&
				permissionSet2Profiles.get('canAdjustInvoice').contains(loggedInUser[0].Profile.Name)){	
				return true;
			}			
			return false;
		}
	}

  public boolean disableCancelOLI{
   get{
      if(oli.opportunity.stagename != 'Closed Won' 
        || (oli.opportunity.stagename == 'Closed Won' && oli.Invoice_CancelDate__c != null && oli.Invoice_CancelDate__c <= date.today())
        || (oli.Project__r.Max_ILIScheduledDate__c != null && oli.Project__r.Max_ILIScheduledDate__c <= date.today())){
            return true;
        }
    
        return false;
    }
  }
}