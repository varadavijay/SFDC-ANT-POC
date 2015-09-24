/*OLI Status History Component Controller*/
public class OLIStatusHistoryCompCntrl {
public id oliId {set;get;}
 public List<OpportunityLineItemChartServices.OppProductHistoryRecord> historyTrackRecords = null;

 public OLIStatusHistoryCompCntrl()
 {
     this.HistoryTrackRecords = new List<OpportunityLineItemChartServices.OppProductHistoryRecord>();
          
    
     
 }
   
   public List<OpportunityLineItemChartServices.OppProductHistoryRecord>  getHistoryTrackRecords()
   {
      List<Opportunity_Product_History__c> HistoryTrack = [Select     Id, 
                                        Opportunity__c, 
                                        Opportunity_Product__c, 
                                        OLI_Stage__c, 
                                        Notes__c,
                                        Duration__c, 
                                        Time_In__c, 
                                        Time_Out__c,
                                        CreatedBy.Name,
                                        LastModifiedBy.Name
                            From Opportunity_Product_History__c 
                            Where Opportunity_Product__c = :oliId 
                            Order By Time_In__c];
       Integer i = 0;
      system.debug('oliId::'+oliId);
     system.debug('prod history::'+HistoryTrack);
       for (Opportunity_Product_History__c oppProdHist : HistoryTrack){
           OpportunityLineItemChartServices.OppProductHistoryRecord hRecord = new OpportunityLineItemChartServices.OppProductHistoryRecord(oppProdHist);
            hRecord.orderOfOccurence = ++i;
           HistoryTrackRecords.add(hRecord);  
           
       } 
       return HistoryTrackRecords;
       
   }
    
}