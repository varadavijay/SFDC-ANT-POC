/*
		 Name: SLAPerformanceComparisonController.cls
		 Date Created: 8/01/2014 (CRM Sprint 1.0.18)
         Purpose: Summarizes data in Product_SLA__c for the SLA Summary Report VF page.  Done in a VF Page to achieve a particular look requested.
		 Used by: /apex/SLAPerformanceComparison; /apex/SLASummaryExport; /apex/SLASummaryReport; /apex/SLASummaryReportExport;
		 Uses: VisualForceReportFilters.cls
*/
public with sharing class SLAPerformanceComparisonController {
	
	
	    
    /*****************************************************
    
    				Class Variables
    				----------------    
    
    ******************************************************/
    
    public date liveStartDate {get;set;}
    public date liveEndDate {get;set;}
    public datetime liveStartDateTime {get;set;} //not used by the vf page.  This is to provide info in the view state for debugging purposes
    public datetime liveEndDateTime {get;set;} //not used by the vf page.  This is to provide info in the view state for debugging purposes
    public integer liveDatePeriod {get;set;}
    public string DisplayliveDateFilter {get;set;}
    
    public string productTypeFilterOperator {get;set;}
    public boolean productTypeFilterUsed {get;set;}
    public list<string> productTypeFilters {get;set;}
    public string productTypeFilter {get;set;}
    public string productFilterString {get;set;}

    public string error {get;set;}
    public string summarizeBy {get;set;}
    public boolean summarizePerProduct {get;set;}
    
    public dateTime OppProdStartDate {get;set;}
    public string OppProdStartFilterString {get;set;}
    
    private string summaryQuery{get;set;}
    
    //Using these just to display in 
    public Product_SLA__c[] SummaryDisplay {get;set;}
    public Product_SLA__c[] WeightedAvg {get;set;}
    //Want the look and feel of a VF Component in the search filter so using this for setting dates
    //This was done after the business rejected the look and feel of the caldendar control in HTML5 dispaly.
    public Product_SLA__c StartDate {get;set;}
    public Product_SLA__c EndDate   {get;set;}
    public OpportunityLineItem oppProduct {set;get;}
    
    public decimal TotalInFulfillment {get;set;}
    public decimal TotalSLADays {get;set;}
    public decimal TotalNumberOfProducts {get;set;}
    public boolean onloadFlag {set;get;}
    public List<selectOption> seltypeOptionLst {set;get;}
    public List<String> selSeltypeLst {set;get;}
    public List<SelectOption> getNumberOperators(){
        List<SelectOption> NumOperators = new List<SelectOption>();
        NumOperators.add(new SelectOption('=','equals'));
        NumOperators.add(new SelectOption('!=','does not equal'));
        NumOperators.add(new SelectOption('<','less than'));
        NumOperators.add(new SelectOption('>','greater than'));
        NumOperators.add(new SelectOption('<=','less or equal'));
        NumOperators.add(new SelectOption('>=','greater or equal'));
        return NumOperators;
    }
    
    
    public List<SelectOption> getStringOperators(){
        List<SelectOption> StringOperators = new List<SelectOption>();
        StringOperators.add(new SelectOption(' = ','equals'));
        StringOperators.add(new SelectOption(' != ','does not equal'));
        StringOperators.add(new SelectOption(' like ','contains'));
        //To maintain the 'Starts with in the drop down, add an extra space before and after the like for starts with.
        StringOperators.add(new SelectOption('  like  ','starts with'));
        return StringOperators;
    }
     //For export labels defining criteria
    private map<string,string>  comparisonOperators = new map<string,string>{   ' = ' => ' or ', 
                                                                                ' != ' => ' and ', 
                                                                                ' like ' => ' or ',
                                                                                '  like  ' => ' or ' // with an extra spaces to keep Starts 
                                                                             };
                                                                             
    private map<string,string>  ProductFilterOperationString = new map<string,string>{   ' = ' => ' equals ', 
		                                                                                ' != ' => 'does not equal', 
		                                                                                ' like ' => 'contains',
		                                                                                '  like  ' => 'starts with'// with an extra spaces to keep Starts 
		                                                                             };
    
    public List<SelectOption> getLiveDateFilters(){
        List<SelectOption> LiveDateFilters = new List<SelectOption>();
        LiveDateFilters.add(new SelectOption('0','This Fiscal Period'));
        LiveDateFilters.add(new SelectOption('-1','Last Fiscal Period'));
        LiveDateFilters.add(new SelectOption('-2','2 Fiscal Periods before'));
        LiveDateFilters.add(new SelectOption('1','Custom'));
        return LiveDateFilters;
    }
    
    public List<SelectOption> getsummarizeByField(){
        List<SelectOption> summarizeByField = new List<SelectOption>();
        summarizeByField.add(new SelectOption(' Product_Type__c','Product'));
        summarizeByField.add(new SelectOption(' Market__c','Market'));
        summarizeByField.add(new SelectOption(' Media_Partner__c','Media Partner'));
        return summarizeByField;
    }
    
    
    /*****************************************************
    
    				Constructor
    				-----------
    
    ******************************************************/
    
    // Since the same controller is used by both the Visual Force page and the export functionality,
    // we use to the constructor to initialize variables, and parse variables when sent from the VF page to the Export Functionality through the URL. 
    public SLAPerformanceComparisonController(){
        system.debug('SLAPerformanceComparisonController: Entering Constructor');
        
        //Instantiate variables when it isn't defined in the URL on the constructor load.
        if (ApexPages.currentPage().getParameters().get('summarizePerProduct') != null){
            summarizePerProduct = boolean.valueof(ApexPages.currentPage().getParameters().get('summarizePerProduct'));
        }else{
            summarizePerProduct = true;
        }
        
         if (ApexPages.currentPage().getParameters().get('productTypeFilterUsed') != null) {
            productTypeFilterUsed = boolean.valueof(ApexPages.currentPage().getParameters().get('productTypeFilterUsed'));
        }else{
            productTypeFilterUsed = true;
        }
        
         if (ApexPages.currentPage().getParameters().get('summarizePerProduct') != null){
            summarizePerProduct = boolean.valueof(ApexPages.currentPage().getParameters().get('summarizePerProduct'));
        }else {
            summarizePerProduct = true;
        }
        
         if (ApexPages.currentPage().getParameters().get('productTypeFilterOperator') != null){
            productTypeFilterOperator = ApexPages.currentPage().getParameters().get('productTypeFilterOperator');
        }else{
            productTypeFilterOperator = ' != ';
        }
        
        if (ApexPages.currentPage().getParameters().get('productTypeFilter') != null){
            productTypeFilter = ApexPages.currentPage().getParameters().get('productTypeFilter');
        }else{
            productTypeFilter = 'Misc,Print,Website';
        }
        
        if (ApexPages.currentPage().getParameters().get('liveDatePeriod') != null) {
            liveDatePeriod = integer.valueof(ApexPages.currentPage().getParameters().get('liveDatePeriod'));
        }else{
            liveDatePeriod = -1;
        }
        
        if (ApexPages.currentPage().getParameters().get('liveStartDate') != null){
            liveStartDate = date.valueof(ApexPages.currentPage().getParameters().get('liveStartDate'));
        } else{
            liveStartDate = date.newInstance(2014,01,01);
        }
        
         if (ApexPages.currentPage().getParameters().get('liveEndDate') != null){
            liveEndDate = date.valueof(ApexPages.currentPage().getParameters().get('liveEndDate'));
        }else{
            liveEndDate = date.newInstance(2014,12,31);
        }
        
         if (ApexPages.currentPage().getParameters().get('OppProdStartDate') != null){
            OppProdStartDate = date.valueof(ApexPages.currentPage().getParameters().get('OppProdStartDate'));
        }else{
            OppProdStartDate = datetime.newInstance(2013, 12, 8, 00, 00, 00);
        }
        
        if (ApexPages.currentPage().getParameters().get('OppProdStartFilterString') != null){
            OppProdStartDate = date.valueof(ApexPages.currentPage().getParameters().get('OppProdStartFilterString'));
        }
        
        
         if (ApexPages.currentPage().getParameters().get('ProductFilterString') != null){
            ProductFilterString = ApexPages.currentPage().getParameters().get('ProductFilterString');
        }
        
        if (ApexPages.currentPage().getParameters().get('DisplayliveDateFilter') != null){
            DisplayliveDateFilter = ApexPages.currentPage().getParameters().get('DisplayliveDateFilter');
        }
        
        if (ApexPages.currentPage().getParameters().get('summarizeBy') != null){
            summarizeBy = ApexPages.currentPage().getParameters().get('summarizeBy');
        }else{
            summarizeBy = ' Product_Type__c';
        }
       
		if (ApexPages.currentPage().getParameters().get('TotalInFulfillment') != null){
            TotalInFulfillment = decimal.valueof(ApexPages.currentPage().getParameters().get('TotalInFulfillment'));
        }else{
            TotalInFulfillment = 0;
        }
        if (ApexPages.currentPage().getParameters().get('TotalSLADays') != null){
            TotalSLADays = decimal.valueof(ApexPages.currentPage().getParameters().get('TotalSLADays'));
        } else{
            TotalSLADays = 0;
        }
        if (ApexPages.currentPage().getParameters().get('TotalNumberOfProducts') != null){
            TotalNumberOfProducts = decimal.valueof(ApexPages.currentPage().getParameters().get('TotalNumberOfProducts'));
        } else{
            TotalNumberOfProducts = 0;
        }
        
        SummaryDisplay = new Product_SLA__c[]{};
        WeightedAvg = new Product_SLA__c[]{};
        StartDate = new Product_SLA__C();
        EndDate = new Product_SLA__C();
        onloadFlag = false;
        oppProduct = new OpportunityLineItem();
        seltypeOptionLst = new List<selectoption>();
        selSeltypeLst = new List<string>();
       Schema.DescribeFieldResult sellType = OpportunityLineItem.Sell_Type__c.getDescribe();
       List<Schema.PicklistEntry> sellTypeLst = sellType.getPicklistValues();
       for(Schema.PicklistEntry val : sellTypeLst)
       {
          seltypeOptionLst.add(new SelectOption(val.getvalue(),val.getLabel()));
          selSeltypeLst.add(val.getvalue());
       }
        system.debug('SLAPerformanceComparisonController.Constructor: Calling calcLiveDate');
        calcLiveDate();
         system.debug('SLAPerformanceComparisonController.Constructor: StarDateFilter: ' + startDate.Filter_Date__c );
        //CompileSearchString();
        
    }
    
        
    /*****************************************************
    
    				Action Methods
    				--------------
    
    ******************************************************/
    //Used by SLAPerformanceComparison's export funtionality. Builds the URL with variables of the current instance.
    public pageReference Export() {
        system.debug('Entering SLAPerformanceComparisonController.Export(): with summaryQuery' + summaryQuery);         
        PageReference ref;//default null
        ref = new PageReference('/apex/SLASummaryExport');
        ref.getParameters().put('summarizePerProduct',string.valueof(summarizePerProduct)); 
        ref.getParameters().put('productTypeFilterUsed',string.valueof(productTypeFilterUsed));
        ref.getParameters().put('productTypeFilterOperator',productTypeFilterOperator);
        ref.getParameters().put('productTypeFilter',productTypeFilter);
        ref.getParameters().put('liveDatePeriod',string.valueof(liveDatePeriod));
        ref.getParameters().put('liveStartDate',string.valueof(liveStartDate));
        ref.getParameters().put('liveEndDate',string.valueof(liveEndDate));
        ref.getParameters().put('ProductFilterString',ProductFilterString);     
        ref.getParameters().put('DisplayliveDateFilter',DisplayliveDateFilter);   
        ref.getParameters().put('OppProdStartDate',string.valueof(OppProdStartDate));
        ref.getParameters().put('OppProdStartFilterString',OppProdStartFilterString);
        ref.getParameters().put('TotalInFulfillment',string.valueof(TotalInFulfillment));
        ref.getParameters().put('TotalSLADays',string.valueof(TotalSLADays));
        ref.getParameters().put('TotalNumberOfProducts',string.valueof(TotalNumberOfProducts));
        system.debug('TotalInFulfillment Export:'+TotalInFulfillment);
        system.debug('TotalSLADays Export::'+TotalSLADays);
        system.debug(ref);
        //return null;
      return ref;
    }
    
    //Used by SLASummaryReport's export funtionality. Builds the URL with variables of the current instance.    
    public pageReference ExportSLA()  {
        system.debug('Entering SLAPerformanceComparisonController.Export(): with summaryQuery' + summaryQuery);         
        PageReference ref;//default null
        ref = new PageReference('/apex/SLASummaryReportExport');
        ref.getParameters().put('summarizePerProduct',string.valueof(summarizePerProduct)); 
        ref.getParameters().put('productTypeFilterUsed',string.valueof(productTypeFilterUsed));
        ref.getParameters().put('productTypeFilterOperator',productTypeFilterOperator);
        ref.getParameters().put('productTypeFilter',productTypeFilter);
        ref.getParameters().put('liveDatePeriod',string.valueof(liveDatePeriod));
        ref.getParameters().put('liveStartDate',string.valueof(liveStartDate));
        ref.getParameters().put('liveEndDate',string.valueof(liveEndDate));
        ref.getParameters().put('ProductFilterString',ProductFilterString);     
        ref.getParameters().put('DisplayliveDateFilter',DisplayliveDateFilter);   
        ref.getParameters().put('OppProdStartDate',string.valueof(OppProdStartDate));
        ref.getParameters().put('OppProdStartFilterString',OppProdStartFilterString);
        ref.getParameters().put('TotalInFulfillment',string.valueof(TotalInFulfillment));
        ref.getParameters().put('TotalSLADays',string.valueof(TotalSLADays));
        ref.getParameters().put('TotalNumberOfProducts',string.valueof(TotalNumberOfProducts));
        system.debug(ref);
        //return null;
      return ref;
    }
    
    
    public pagereference CalcLiveDate(){
        system.debug('SLAPerformanceComparisonController Entering CalcLiveDate()');
        datetime thisDay = date.today();
        integer ThisPeriodNum;
        period[] Past2Quarter = new Period[]{};
        try{
            Past2Quarter = [Select StartDate, EndDate, type, Number From Period Where (StartDate = LAST_N_FISCAL_QUARTERS:2 or StartDate = THIS_FISCAL_QUARTER) and Type = 'Month'];
            system.debug('Past2Quarter size: ' + Past2Quarter.size());
            for (period p: Past2Quarter){
                if (date.today() <= p.EndDate && date.today() >= p.StartDate){
                    ThisPeriodNum = p.Number;
                }
            }        
            system.debug('Live date Period: ' + liveDatePeriod);
            system.debug('Current Period Number: ' + ThisPeriodNum);
            
            if (liveDatePeriod <= 0){
	        	integer periodNeeded = ThisPeriodNum+liveDatePeriod;
	            if (periodNeeded <= 0 ){
	                periodNeeded = periodNeeded +12;
	            }
	            for (period p: Past2Quarter){
	              if (p.Number == periodNeeded){
	                     liveStartDate = p.StartDate;
	                     liveEndDate = p.EndDate;
	                }
	            }        
            }
            system.debug('Today: ' + date.today() + ' Live Start Date: ' + liveStartDate + '  Live End EndDate:' +  liveEndDate);
            DisplayliveDateFilter = 'Live date between \'' + string.valueof(liveStartDate) + '\' and \'' + string.valueof(liveEndDate)+ '\'';
            startDate.Filter_Date__c = liveStartDate ;
            endDate.Filter_Date__c = liveEndDate;
        } catch (Exception ex) {
            system.debug('SLAPerformanceComparisonController SearchRecords(): Exception: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception occured while calculating live date ranges: ' + ex.getMessage()));
        }
        //SearchRecords();
        return null;
    }
    
    //Called when user hits search. It builds the search string based on the user selections and passes to the search() method.
    //Uses VisualForceReportFilters to compile search string for Product_Type__c filter; and Live Date when not custom.
    public pageReference CompileSearchString(){
       
        boolean errorflag = true;
        summaryQuery = '';//default empty
        // We get the sum of Status' duration instead of the AVG, because we want to account for total timespent/ total number of products.
        // The AVG function will not account for all products (especially if a particular product hasn't hit that status)   
        onloadFlag = true;
        liveStartDate = startDate.Filter_Date__c;  
        liveEndDate = endDate.Filter_Date__c;
        if(liveStartDate != null)
        liveStartDateTime = Datetime.newInstance(liveStartDate.year(), liveStartDate.month(), liveStartDate.day(), 0,0,0);
        if(liveEndDate != null)
        liveEndDateTime = Datetime.newInstance(liveEndDate.year(), liveEndDate.month(), liveEndDate.day(), 23,59,59);        
        
        string FilterString = productTypeFilter;
        FilterString = FilterString.replace(', ', ',');
        FilterString = FilterString.replace(' ,', ',');
        productTypeFilters = FilterString.split(',',100000);
        system.debug(productTypeFilters);
        SummaryDisplay.clear();   
        if (liveEndDate < liveStartDate){
            system.debug('SLAPerformanceComparisonController.SearchRecords(): Ensure Live Start Date is before End Date');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Ensure Live Start Date is Before End Date.'));
        }
        
        try{
            summaryQuery =   'SELECT   SUM(Awaiting_Client_Approval_Hours__c) AwaitingClientApproval, ';
            summaryQuery +=            'SUM(Awaiting_Client_Asset_Hours__c) AwaitingClientAsset, ';
            summaryQuery +=            'SUM(Awaiting_On_Board_Hours__c) AwaitingOnBoard, ';
            summaryQuery +=            'SUM(Closed_Won_Hours__c) ClosedWon, ';
            summaryQuery +=            'AVG(Hours_To_Go_Live__c) DaysToGoLive, ';
            summaryQuery +=            'SUM(In_Fulfillment_Hours__c) InFulfillment, ';
            summaryQuery +=            'SUM(Pending_Hours__c) Pending,';
        	summaryQuery +=            'SUM(Total_SLA_Status_Hours__c) TotalSLAHours,';      
            summaryQuery +=            'SUM(Total_Non_SLA_Status_Hours__c) TotalNonSLAHours,';                    
            summaryQuery +=            'AVG(Business_Hours_per_Day__c) BusinessHoursInDay,';
            summaryQuery +=            'COUNT(Opportunity_Product__c) ProductsLive, ';
            summaryQuery +=            'SUM(SLA_Met__c) SLAMet, ';
            summaryQuery +=            'AVG(SLA__c) ProductSLA, ';
            summaryQuery +=            summarizeBy;
            summaryQuery +=         ' FROM     Product_SLA__c    WHERE ';
            
            if (OppProdStartDate != null) {
            	OppProdStartFilterString = ' Opportunity Products created after ' + string.valueof(OppProdStartDate);
                summaryQuery += '  Opportunity_Product_Create_Date__c >= :OppProdStartDate ' ;
            }
            if(liveStartDate == null || liveEndDate == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select Live Start Date & Live End Date'));
               errorflag = false;
            }
            if (liveStartDate != null){
                summaryQuery += ' AND  Live_Date__c >= :liveStartDateTime ' ;
            }
            
            if (liveEndDate != null){
                summaryQuery += ' AND Live_Date__c <= :liveEndDateTime ';
            }
            if(selSeltypeLst != null && selSeltypeLst.size() > 0 )
            {
                summaryQuery += ' AND ProjectRef__r.Sell_Type__c = :selSeltypeLst';
            }   
            if (productTypeFilterUsed == true && productTypeFilters.size()>0){
                ProductFilterString = 'Product ' + ProductFilterOperationString.get(productTypeFilterOperator)+ ' \'' + productTypeFilter + '\'';
                string CompareStart = '\'';
                string CompareEnd = '\'';
                if ( productTypeFilterOperator == ' like '){
                    CompareStart = '\'%';
                    CompareEnd = '%\'';
                }
                
                if ( productTypeFilterOperator == '  like  '){
                    CompareEnd = '%\'';
                }
                system.debug( 'The size of Product Type Filters: ' + productTypeFilters.size());
                for (integer i=0;i<productTypeFilters.size();i++) {
                    system.debug( 'The value of i: ' + i + ' Filter ' + productTypeFilters[i]);
                    if (i==0){
                        //The start of a filter
                        
                        if (productTypeFilters.size() > 1) {
                            summaryQuery += ' AND ( Product_Type__c ' + productTypeFilterOperator + CompareStart + productTypeFilters[i] + CompareEnd;
                        }else {
                            summaryQuery += ' AND Product_Type__c ' + productTypeFilterOperator + CompareStart + productTypeFilters[i] + CompareEnd;
                        }
                    }else if (i == productTypeFilters.size()-1){
                        //Then end of the filter
                         summaryQuery += comparisonOperators.get(productTypeFilterOperator) + ' Product_Type__c ' +  productTypeFilterOperator + CompareStart + productTypeFilters[i] + CompareEnd + ')';
                    } else{
                        //Any continuations
                        summaryQuery += comparisonOperators.get(productTypeFilterOperator) + ' Product_Type__c ' +  productTypeFilterOperator + CompareStart + productTypeFilters[i] + CompareEnd;
                    }
                }
            }
            
            
            summaryQuery += ' GROUP BY ' + summarizeBy;
             system.debug('LiveStartDate: '+ liveStartDate + ' LiveEndDate: ' + liveEndDate);
             system.debug(summaryQuery);
        } catch(Exception ex) {
            system.debug('SLAPerformanceComparisonController CompileSearchString(): Exception: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception occured while compiling the search query: ' + ex.getMessage()));
        }
       if (summaryQuery!='' && errorflag) {
            SearchRecords();
       }
       return null;
    }
    
    //After the search string has been built, this method queries the results and processes it for display
    private void SearchRecords()
    {
        system.debug('SLAPerformanceComparisonController Entering SearchRecords()');
        summaryDisplay.clear();
        try {        
            /* Set<String> oppProdIdLst = new Set<String>();
             List<opportunityLineItem> oppProdLst = [select id,name from opportunityLineItem where Sell_Type__c =:selSeltypeLst];
             for(opportunityLineItem oli :oppProdLst)
              oppProdIdLst.add(oli.id);*/
        	// Query the search string 
            AggregateResult[] groupedResults = database.query(summaryQuery);    
            TotalInFulfillment = 0;
    		TotalSLADays = 0;
    		TotalNumberOfProducts = 0;
    
            // Make null values 0; otherwise populate the values in variables representing. 
             for (AggregateResult ar: groupedResults){
                 system.debug(ar);
                decimal ProductSLA  = integer.valueOf(ar.get('ProductSLA'));
                if (ProductSLA == null) {
                    ProductSLA = 0;
                }
                
                decimal ProductsLive = integer.valueOf(ar.get('ProductsLive'));
                if (ProductsLive == null){
                    ProductsLive = 0; 
                }
                 TotalNumberOfProducts += ProductsLive;
                 
                decimal BusinessHoursInDay = (Decimal)ar.get('BusinessHoursInDay');
                if (BusinessHoursInDay == null){
                    BusinessHoursInDay = 1;
                }
                                
               // Calculate the averages of the products in the VF page:  Total Time Spent/ Total number of products
               // Convert the averages to days by diving it by the average Business Hours in a Day.  This is done here to minimize rounding errors on the VF Report.  
                decimal DivideByProducts = 1;
                if (ProductsLive != 0 ){
                	DivideByProducts = ProductsLive;
                }
                
                decimal AwaitingClientApproval= (Decimal)ar.get('AwaitingClientApproval');
                if (AwaitingClientApproval == null){
                    AwaitingClientApproval = 0;
                }else {
                    AwaitingClientApproval = (AwaitingClientApproval/DivideByProducts)/BusinessHoursInDay;
                   
                }
                
                decimal AwaitingClientAsset= (Decimal)ar.get('AwaitingClientAsset');
                if (AwaitingClientAsset == null){
                    AwaitingClientAsset = 0;
                }else {
                    AwaitingClientAsset = (AwaitingClientAsset/DivideByProducts)/BusinessHoursInDay;                    
                }
                
                decimal AwaitingOnBoard= (Decimal)ar.get('AwaitingOnBoard');
                if (AwaitingOnBoard == null) {
                    AwaitingOnBoard = 0;
                } else {
                     AwaitingOnBoard= (AwaitingOnBoard/DivideByProducts)/BusinessHoursInDay;
                }
                
                decimal ClosedWon = (Decimal)ar.get('ClosedWon');
                if (ClosedWon == null){
                    ClosedWon = 0;
                }else{
                    ClosedWon = (ClosedWon/DivideByProducts)/BusinessHoursInDay;
                }
                
                decimal  TotalSLAHours= (Decimal)ar.get('TotalSLAHours');
                if (TotalSLAHours == null){
                    TotalSLAHours = 0;
                }else{
                    TotalSLAHours = (TotalSLAHours/DivideByProducts)/BusinessHoursInDay;
                }
                
                decimal  TotalNonSLAHours= (Decimal)ar.get('TotalNonSLAHours');
                if (TotalNonSLAHours== null) {
                    TotalNonSLAHours= 0;
                }else{
                    TotalNonSLAHours = (TotalNonSLAHours/DivideByProducts)/BusinessHoursInDay;
                }
                
                decimal  DaysToGoLive= (Decimal)ar.get('DaysToGoLive');
                if (DaysToGoLive == null){
                    DaysToGoLive = 0;
                } else {
                    DaysToGoLive= DaysToGoLive/BusinessHoursInDay;
                }
                
                
                decimal InFulfillment = (Decimal)ar.get('InFulfillment');
                if (InFulfillment == null){
                    InFulfillment = 0;
                } else {
                    InFulfillment = (InFulfillment/DivideByProducts)/BusinessHoursInDay;
                }
                
                decimal Pending = (Decimal)ar.get('Pending');
                if (Pending == null){
                    Pending = 0;
                } else {
                    Pending = (Pending/DivideByProducts)/BusinessHoursInDay;
                }
                                
                
                decimal  SLAMet = integer.valueOf(ar.get('SLAMet'));
                if (SLAMet == null){
                    SLAMet = 0;
                }
                
                // Create an instance of the Product_SLA__c; NEVER to be committed to the database.
                // This is used to be able to display the specific VF controls requested. 
                Product_SLA__c DisplayRow = new Product_SLA__c();
                DisplayRow.Awaiting_Client_Approval__c = AwaitingClientApproval.setscale(0);
                DisplayRow.Awaiting_Client_Asset__c = AwaitingClientAsset.setscale(0);
                DisplayRow.Awaiting_On_Board__c = AwaitingOnBoard.setscale(0);
                DisplayRow.Closed_Won__c = ClosedWon.setscale(0);
                DisplayRow.In_Fulfillment__c = InFulfillment.setscale(0);
                DisplayRow.Pending__c = Pending.setscale(0);
                DisplayRow.Total_SLA_Status__c= DisplayRow.Awaiting_Client_Approval__c +
                								DisplayRow.Awaiting_Client_Asset__c +
                								DisplayRow.Awaiting_On_Board__c +
                								DisplayRow.Closed_Won__c +
                								DisplayRow.In_Fulfillment__c +
                								DisplayRow.Pending__c;  // DE684 -  D2GL in the report should be the sum the rounded SLA durations     							
                DisplayRow.Total_Non_SLA_Status__c = TotalNonSLAHours.setscale(0);
                DisplayRow.Days_To_Go_Live__c = DaysToGoLive.setscale(0);
                //Using Total_Non_SLA_Status__c to display the % met.
                DisplayRow.Total_Non_SLA_Status__c = (SLAMet/ProductsLive * 100).setscale(0);
                DisplayRow.Count__c = ProductsLive;
                DisplayRow.SLA__c = ProductSLA; //Display the product SLA                
                DisplayRow.SLA_Met__c = SLAMet;//Number of records that have met the SLA.                
                DisplayRow.Product_Type__c = string.valueOf(ar.get('Product_Type__c'));
                system.debug ('AwaitingClientApproval = ' + AwaitingClientApproval.setscale(0)
                                +   ' AwaitingClientAsset = ' + AwaitingClientAsset.setscale(0)
                                +   ' AwaitingOnBoard = ' + AwaitingOnBoard.setscale(0)
                                +   ' ClosedWon = ' + ClosedWon.setscale(0)
                                +   ' DaysToGoLive = ' + DaysToGoLive.setscale(0)
                                +   ' InFulfillment = ' +  InFulfillment.setscale(0)
                                +   ' Pending = ' + Pending.setscale(0)
                                +   ' ProductsLive = ' + ProductsLive
                                +   ' ProductSLA = ' + ProductSLA
                                +   ' SLAMet = ' + SLAMet
                                +   ' Product_Type__c = ' + DisplayRow.Product_Type__c
                                );
                //Add relevant fields to the weighted averages.  Caclulated after rounding is done to avoid visual descrepancies.
                 TotalSLADays += DisplayRow.Total_SLA_Status__c * ProductsLive;
                 TotalInFulfillment += DisplayRow.In_Fulfillment__c * ProductsLive;
                SummaryDisplay.add(DisplayRow);
             }// For each SLA Summary
             //Weighted averages             
             system.debug( ' Total SLA Days: ' + TotalSLADays + '; Total In Fulfillment time: ' + TotalInFulfillment + '; Total Number Of Products: ' + TotalNumberOfProducts);
             if (TotalSLADays != 0)
             { 
               TotalSLADays = (TotalSLADays/TotalNumberOfProducts).setscale(0);
             }
            if(TotalInFulfillment!=0)
                TotalInFulfillment = (TotalInFulfillment/TotalNumberOfProducts).setscale(0);
                system.debug('TotalSLADays::'+TotalSLADays);
                system.debug('TotalInFulfillment::'+TotalInFulfillment);
                Product_SLA__c WAvg = new Product_SLA__c();
                WAvg.Product_Type__c = 'Weighted Average';
                WAvg.In_Fulfillment__c = TotalInFulfillment;
                WAvg.Total_SLA_Status__c = TotalSLADays;
                WeightedAvg.clear();
                WeightedAvg.add(WAvg);
             
        } catch (Exception ex)  {
            system.debug('SLAPerformanceComparisonController SearchRecords(): Exception: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Exception occured while searching records: ' + ex.getMessage()));
        }//Catch
    }
    

}