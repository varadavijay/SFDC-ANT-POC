public class OpportunityProductRouter {
    
   OpportunityLineItem controllerOli {set;get;}

   public OpportunityProductRouter(ApexPages.StandardController stdController) {
        
    controllerOli = (OpportunityLineItem) stdController.getRecord(); 
     }
    
    Public PageReference oppLineItemStandard()
    {
        PageReference ref = null;
       // Id oliId = System.currentPagereference().getParameters().get('id');
       OpportunityLineItem oli = [select id,name,opportunity.recordtypeid from OpportunityLineItem where id =:controllerOli.id];
       Recordtype rec = [select id,name from recordtype where name = 'USCP Opportunity']; 
        if(oli.opportunity.recordtypeid != rec.id)   
           ref = new PageReference('/apex/OppLineItem?id='+controllerOli.id);
        //oppproduct.id/e?retURL=%opp.id
        //'/apex/OpportunityLineItem?id='+controllerOli.id
        else
            ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+controllerOli.id);
        return ref;
    }
  /* Public PageReference oppLineItemEditStandard()
    {
        PageReference ref = null;
       OpportunityLineItem oli = [select id,name,opportunity.recordtypeid from OpportunityLineItem where id =:controllerOli.id];
       Recordtype rec = [select id,name from recordtype where name = 'USCP Opportunity']; 
        if(oli.opportunity.recordtypeid != rec.id)
        {ref = new PageReference('/'+controllerOli.id+'/e');
         ref.setRedirect(true);
        }
          // ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+controllerOli.id);  
           
        else
        {
        ref =  new PageReference('/apex/OpportunityLineItemUSCPEdit?id='+controllerOli.id);
        ref.setRedirect(true);
        }
        
        return ref;
    } */
}