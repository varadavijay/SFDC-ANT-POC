public class OpportunityProductReportController {
	
	public OpportunityLineItemChartServices oliChartServices {get; set;}
	
	public final String SOQL_EXECUTION_ERROR = 'There was an issue executing the SOQL Query. Please contact the Salesforce administrator. ';
	
	public static final SelectOption ALL_PRODUCT_STATUSES = new SelectOption('*', 'Status - All');
	public static final SelectOption ALL_PRODUCT_TYPES = new SelectOption('*', 'Type - All');
	
	public String selectedProductStatus {get; set;}
	public String selectedProductType {get; set;}
	public Date selectedStartDate {get; set;}
	public Date selectedEndDate {get; set;}
	public List<SelectOption> selectedProducts {get; set;}

	public OpportunityProductReportController(){
		
		this.oliChartServices = new OpportunityLineItemChartServices();
		
		this.selectedProductStatus = ALL_PRODUCT_STATUSES.getValue();
		this.selectedProducts = new List<SelectOption>();
	}
	
	public String chartDataJSON {
		get {
			system.debug('oliChartServices.chartDataJSON: ' + oliChartServices.chartDataJSON);
			return oliChartServices.chartDataJSON;
		}
		set;
	}
	public String dataFieldDepth {
		get {
			system.debug('oliChartServices.dataFieldDepth: '+ oliChartServices.dataFieldDepth);
			return oliChartServices.dataFieldDepth;
		}
		set;
	}
	

	
	public static List<SelectOption> getProductStatuses {
		get {
			List<SelectOption> options = new List<SelectOption>();
			options.add(ALL_PRODUCT_STATUSES);
			if (getProductStatuses == null){
				Schema.DescribeFieldResult F = OpportunityLineItem.Waiting_Status__c.getDescribe();
				List<Schema.PicklistEntry> stageNamesPickList = F.getPicklistValues();
				for (Schema.PicklistEntry stageEntry : stageNamesPickList){
					if (stageEntry.getLabel().contains('Internal Use Only')) break;
					options.add(new SelectOption(stageEntry.getValue(), stageEntry.getLabel()));
				}
				
			}
			return options; 
		}
		set;
		
	}
	
	public static List<SelectOption> getProductTypes {
		get {
			List<SelectOption> options = new List<SelectOption>();
			options.add(ALL_PRODUCT_TYPES);
			if (getProductTypes == null){
				Schema.DescribeFieldResult F = Product2.Product_Type__c.getDescribe();
				List<Schema.PicklistEntry> typeNamesPickList = F.getPicklistValues();
				for (Schema.PicklistEntry typeEntry : typeNamesPickList){
					options.add(new SelectOption(typeEntry.getValue(), typeEntry.getLabel()));
				}
				
			}
			return options; 
		}
		set;
		
	}
	
	
	public List<SelectOption> allProducts {
		get {
			List<SelectOption> options = new List<SelectOption>();
			if (allProducts == null){
				List<OpportunityLineItem> allOppProducts = [Select OpportunityId, Opp_Product_Id__c, Id, Product_Name__c 
															From OpportunityLineItem  ];
				for (OpportunityLineItem oppProduct : allOppProducts){
					options.add(new SelectOption(oppProduct.Opp_Product_Id__c, oppProduct.Product_Name__c));
				}
			}
			return options; 
		}
		set;
	}
	

	public List<Opportunity_Product_History__c> getOppProdHistResults {
		get {
			List<Opportunity_Product_History__c> results; 
			
			Set<String> selectedProductsIds = new Set<String>();
			for (SelectOption op : selectedProducts){
				selectedProductsIds.add(op.getValue());
			}
			
			system.debug('selectedProductsIds: '+ selectedProductsIds);
			system.debug('selectedProductStatus: '+ selectedProductStatus);
			
			String databaseQuery = 'Select Id, Opportunity__c, Opportunity_Product__c, Opportunity_Product_Type__c, ';
			databaseQuery +=	   		'OLI_Stage__c, Notes__c, ';
			databaseQuery +=	   		'Duration__c, Time_In__c, Time_Out__c ';
			databaseQuery +=		'From Opportunity_Product_History__c ';
			databaseQuery +=		'Where Opportunity_Product__c in :selectedProductsIds ';
			
			if (selectedProductStatus != ALL_PRODUCT_STATUSES.getValue()){
				databaseQuery += ' AND OLI_Stage__c = :selectedProductStatus ';
			}
			if (selectedProductType != ALL_PRODUCT_TYPES.getValue()){
				databaseQuery += ' AND Opportunity_Product_Type__c = :selectedProductType ';
			}
			if (selectedStartDate != null){
				databaseQuery += ' AND Time_In__c >= :selectedStartDate ';
			}
			if (selectedEndDate != null){
				databaseQuery += ' AND Time_Out__c <= :selectedEndDate ';
			}
			databaseQuery +=		' Order By Time_In__c ';
		
			try {
				results =  Database.query(databaseQuery);
			}
			catch (Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SOQL_EXECUTION_ERROR + e.getMessage()));
			}
			return results;
		}
		set;
	}	

	
	public void runReport() {
		
		this.oliChartServices = new OpportunityLineItemChartServices();
	
		Map<String, Integer> dataFieldIndex = new Map<String, Integer>(); 
		for (Opportunity_Product_History__c oppProdHist : getOppProdHistResults){
			OpportunityLineItemChartServices.OppProductHistoryRecord hRecord = new OpportunityLineItemChartServices.OppProductHistoryRecord(oppProdHist);
			String stage = oppProdHist.OLI_Stage__c != null ? hRecord.record.OLI_Stage__c : OpportunityLineItemServices.CREATED_STAGE_NAME;
			
			if (!dataFieldIndex.containsKey(stage)){
				dataFieldIndex.put(stage, 1);
			} 
			else {
				dataFieldIndex.put(stage, dataFieldIndex.get(stage)+1);
			}
			
			if (oliChartServices.chartDataMap.containsKey(stage)){
				oliChartServices.chartDataMap.get(stage).setDataPoint(dataFieldIndex.get(stage), hRecord.getDuration);
			}
		}
		
	}

	
}