public class OppLineItemCntrl {
    
   public ApexPages.StandardController theController;
    
    public OpportunityLineItem oli {get;set;}
   // public OpportunityLineItemChartServices oliChartServices {get; set;}
    
    //public List<Opportunity_Product_History__c> HistoryTrack {get; set;}
   // public List<OpportunityLineItemChartServices.OppProductHistoryRecord> HistoryTrackRecords {get; set;}
    
    public OppLineItemCntrl(ApexPages.StandardController stdController) {
        
         OpportunityLineItem controllerOli = (OpportunityLineItem)stdController.getRecord(); 
        /*this.oli = [Select Id From OpportunityLineItem Where Id = :controllerOli.ID];
        
        this.oliChartServices = new OpportunityLineItemChartServices();
        
        this.HistoryTrackRecords = new List<OpportunityLineItemChartServices.OppProductHistoryRecord>();
        this.HistoryTrack = [Select     Id, 
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
                            Where Opportunity_Product__c = :controllerOli.Id 
                            Order By Time_In__c];
        
        Map<String, Integer> dataFieldIndex = new Map<String, Integer>(); 
        
        Integer i = 0;
        for (Opportunity_Product_History__c oppProdHist : HistoryTrack){
            OpportunityLineItemChartServices.OppProductHistoryRecord hRecord = new OpportunityLineItemChartServices.OppProductHistoryRecord(oppProdHist);
            
            String stage = hRecord.record.OLI_Stage__c != null ? hRecord.record.OLI_Stage__c : OpportunityLineItemServices.CREATED_STAGE_NAME;

            hRecord.backtrack = false;
            
            hRecord.orderOfOccurence = ++i;

            if (!dataFieldIndex.containsKey(stage)){
                dataFieldIndex.put(stage, 1);
            } 
            else {
                dataFieldIndex.put(stage, dataFieldIndex.get(stage)+1);
                hRecord.backtrack = true;
            }
            
           if (oliChartServices.chartDataMap.containsKey(stage)){
                oliChartServices.chartDataMap.get(stage).setDataPoint(dataFieldIndex.get(stage), hRecord.getDuration);
            }
            
            HistoryTrackRecords.add(hRecord);
        } */
    }
    
   
}