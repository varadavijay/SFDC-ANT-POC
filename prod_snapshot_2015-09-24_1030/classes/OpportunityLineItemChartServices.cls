public without sharing class OpportunityLineItemChartServices {
  
  public static String FIELD_NAME_PREFIX = 'data';
  public static String BACKGROUND_ROW_STYLE = 'backgroundRowStyle';
  public static String BACKGROUND_ROW_STYLE_DEFAULT = 'backgroundRowStyleDefault';
  
  
  public List<Data> chartDataOrder {get;set;}
  public Map<String, Data> chartDataMap {get;set;}
  
  
  public OpportunityLineItemChartServices(){
    
    chartDataMap = new Map<String, Data>();
    chartDataOrder = new List<Data>();
    chartDataMap.put(OpportunityLineItemServices.CREATED_STAGE_NAME, new Data(OpportunityLineItemServices.CREATED_STAGE_NAME));
    chartDataOrder.add(chartDataMap.get(OpportunityLineItemServices.CREATED_STAGE_NAME));
    
    
    Schema.DescribeFieldResult F = OpportunityLineItem.Waiting_Status__c.getDescribe();
    List<Schema.PicklistEntry> stageNamesPickList = F.getPicklistValues();
    
    for (Schema.PicklistEntry stageEntry : stageNamesPickList){
      if (stageEntry.getLabel().contains('Internal Use Only')) break;
      chartDataMap.put(stageEntry.getLabel(), new Data(stageEntry.getLabel()));
      chartDataOrder.add(chartDataMap.get(stageEntry.getLabel()));
    }
  }
  
  
  // Wrapper class
    public class Data {
        public String name { get; set; }
        @testVisible private Map<Integer, Double> dataPoints { get; set;}
        
        public Data(String name)
        {
          this.name = name;
          this.dataPoints = new Map<Integer, Double>();
        }
      
        public void setDataPoint(Integer dataPointDepth, Double value)
        {
          this.dataPoints.put(dataPointDepth, value);
        }
        
        public Double getDataPoint(Integer dataPointDepth)
        {
          if (this.dataPoints.get(dataPointDepth) != null){
            return this.dataPoints.get(dataPointDepth);
          }
          return 0;
        }
    }
  
  
  public String dataFieldDepth { 
    get {
      return printDataFieldDepth(findMaxDataPointDepth(chartDataOrder));
    }
  }
  
  public String chartDataJSON {
    get {
      return toJSON(chartDataOrder, findMaxDataPointDepth(chartDataOrder));
    }
    set;
  }
  
  public class OppProductHistoryRecord {
    public Opportunity_Product_History__c record {get; set;}
    public Boolean backtrack { get; set; }
    public Integer orderOfOccurence { get; set; }
    public string TimeInFormatted {get;set;}
    public String styleClass { 
      get {
        if (backtrack){
          return BACKGROUND_ROW_STYLE;
        } return BACKGROUND_ROW_STYLE_DEFAULT;
      }
      set; 
    }
    public Boolean isCurrent { 
      get {
        return record.Duration__c == null && record.Time_Out__c == null;
      }
      set; 
    }
    public Double runningTime { 
      get {
        return OpportunityLineItemServices.getBusinessHoursDifference(record.Time_In__c, Datetime.now());
      }
      set; 
    }
    public Double getDuration { 
      get {
        if (isCurrent){
          return runningTime;
        }
        return record.Duration__c;
      }
      set; 
    }

    public OppProductHistoryRecord(Opportunity_Product_History__c record){
      this.backtrack = false;
      this.record = record;
      this.styleClass = BACKGROUND_ROW_STYLE_DEFAULT;
      this.TimeInFormatted = record.Time_In__c.format();
    }
  }

  /*
        Return the representation of the specified data in a JSON array, capturing as many data points per data as specified.
        
        Preconditions
          1) The name field in each Data is not null
          2) MaxDataPointDepth must be greater than 0
        Postconditions:
          For each element E in the generated JSON array:
              1) There will be as many data points for E as maxDataPointDepth.
              2) Any data point without data present will be set to 0
    */
    public static String toJSON(List<Data> dataList, Integer maxDataPointDepth)
    {
      JSONGenerator responseJSON = JSON.createGenerator(false);
      
      responseJSON.writeStartArray();
      
      for (Data dataRecord : dataList ){
        responseJSON.writeStartObject();
        
        responseJSON.writeStringField('name', dataRecord.name);
        for (Integer fieldIndex = 1; fieldIndex <= maxDataPointDepth; fieldIndex++){
          if (dataRecord.dataPoints.containsKey(fieldIndex)){
            responseJSON.writeNumberField(getFieldName(fieldIndex), Double.valueOf(dataRecord.getDataPoint(fieldIndex)));
          }
          else {
            responseJSON.writeNumberField(getFieldName(fieldIndex), Double.valueOf(0));
          }
        }
        responseJSON.writeEndObject();
      }
      
      responseJSON.writeEndArray();
      responseJSON.close();
         return responseJSON.getAsString();
    }
    
    /*
    Return the maximum data point depth of all of the data elements specified
    
    Postcondition
      1) If no data is specified for all the data elements specified, return 1
    */
    @TestVisible private static Integer findMaxDataPointDepth(List<Data> dataList)
    {
      Integer maxDataPoint = 1;
      for (Data dataRecord : dataList){
        Integer currentMaxDataPoint = 1;
        for ( Integer dataPointIndex : dataRecord.dataPoints.keySet()){
          if ( dataPointIndex > currentMaxDataPoint && dataRecord.dataPoints.get(dataPointIndex) != null){
            currentMaxDataPoint = dataPointIndex;
          }
        }
        if (currentMaxDataPoint > maxDataPoint)
          maxDataPoint = currentMaxDataPoint;  
      }
      return maxDataPoint;
    }
    
    /*
    Generate a field name to represent the specified depth. 
    
    Precondition:
      1) Depth must be a nonnull value greater than 0
    Postconditions:
      1) Every call of getFieldName for the same depth will result in the same field name
      2) For each unique depth value, getFieldName will result in a unique string
      3) The field name must begin with the string specified in FIELD_NAME_PREFIX
    */
    @TestVisible private static String getFieldName(Integer depth)
    {
      return FIELD_NAME_PREFIX+depth;
    }
    
    /*
    Generates a string specifing the field names for each datapoint, up to the specified maxDataPointDepth, seperated by a comma
    
    Precondition:
    1) maxDataPointDepth must be greater than 0
    */
    public static String printDataFieldDepth(Integer maxDataPointDepth)
    {
      List<String> dataFields = new List<String>();
      for (Integer i = 1; i <= maxDataPointDepth; i++){
        dataFields.add(getFieldName(i));
      }
      return String.join(dataFields,',');
    }
  
  

}