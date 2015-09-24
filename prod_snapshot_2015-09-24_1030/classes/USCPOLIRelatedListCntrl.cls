public class USCPOLIRelatedListCntrl {
    Public List<OpportunityLineItem>  oliList {set;get;}
    Public Opportunity Opp {set;get;}
    Public string pricebkName {set;get;}
    private integer totalRecs {set;get;}
    private integer OffsetSize = 0;
    private integer LimitSize= 5;
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                //String strSql = 'select id,Product2.name,Periods2__c,UnitPrice,ServiceDate,Product_Description__c,ListPrice,Opportunity.Pricebook2.Name from OpportunityLineItem where opportunityid =\'' +opp.id+'\'';
        
                con = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select id,name,(select id,Product2.name,Notes__c,Sell_Type__c,Qty_ContractMonths__c,Invoice_Units__c,Mgmt_Fee_Percent__c,Quantity,UnitPrice,Invoice_ServiceStartDate__c,Invoice_ServiceEndDate__c,Waiting_Status__c,Live_Date__c,ListPrice,Opportunity.Pricebook2.Name,Order_Form__c,Opportunity.CloseDate,PricebookEntry.Product2.ProductCode,Opportunity.StageName from OpportunityLineItems) from opportunity where id = :opp.id]));
            }
            return con;
        }
        set;
    }
    
    public USCPOLIRelatedListCntrl(ApexPages.StandardController stdController) {
        
         Opp = (Opportunity)stdController.getRecord(); 
       Opportunity opb1 = [select id,Pricebook2.Name from Opportunity where id =:opp.id ]; 
        totalRecs = [select count() from OpportunityLineItem where opportunityid = :opp.id];
       oliList =  [select id,Product2.name,Notes__c,Sell_Type__c,Qty_ContractMonths__c,Invoice_Units__c,Mgmt_Fee_Percent__c,Quantity,UnitPrice,Invoice_ServiceStartDate__c,Invoice_ServiceEndDate__c,Live_Date__c,ListPrice,Opportunity.Pricebook2.Name,Order_Form__c,Opportunity.CloseDate,PricebookEntry.Product2.ProductCode,Opportunity.StageName,Waiting_Status__c from OpportunityLineItem where opportunityid = :opp.id LIMIT :LimitSize OFFSET :OffsetSize];
       //totalRecs = oliList.size();
       pricebkname = opb1.Pricebook2.Name; 
    }
    public void createQueryString()
    {
        oliList =  [select id,Product2.name,Notes__c,Sell_Type__c,Qty_ContractMonths__c,Invoice_Units__c,Mgmt_Fee_Percent__c,Quantity,UnitPrice,Invoice_ServiceStartDate__c,Invoice_ServiceEndDate__c,Live_Date__c,ListPrice,Opportunity.Pricebook2.Name,Order_Form__c,Opportunity.CloseDate,PricebookEntry.Product2.ProductCode,Opportunity.StageName,Waiting_Status__c from OpportunityLineItem where opportunityid = :opp.id LIMIT :LimitSize OFFSET :OffsetSize];
        
        
    }
    //Pagination
    public void FirstPage()
    {
        OffsetSize = 0;
        createQueryString();
        
    }
    public void previous()
    {
       OffsetSize = OffsetSize-LimitSize;
        createQueryString();
        
    }
    public void next()
    {
        
        OffsetSize = OffsetSize + LimitSize;
        createQueryString();
        
    }
     public integer pageNumber {
        get {
            integer pageNo=1;
             pageNo = pageNo + (OffsetSize/LimitSize);
           
            return pageNo;
        }
        set;
    }
    public integer totalPages {
        get {
            integer totlPages=0;
            if(math.mod(totalRecs,LimitSize) > 0)
                {totlPages = totlPages + (totalRecs/LimitSize)+1;
                system.debug('total pages-------'+totlPages);
                system.debug('total Records-------'+totalRecs);}
            else
                totlPages = totlPages + (totalRecs/LimitSize);
            
             
        
           // return con.getPageNumber();
            return totlPages;
        }
        set;
    }
    public void LastPage()
    {
        
        OffsetSize = totalrecs-math.mod(totalRecs,LimitSize)-1;
        createQueryString();
    }
    public boolean getprev()
    {
        if(OffsetSize == 0 || totalRecs==5)
            return false;
        else
            return true;
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > (totalRecs-1))
            return false;
        else
            return true;
    }
    
    Public PageReference addProduct()
    {
        PageReference ref = new PageReference('/apex/OpportunityPriceBook?oppId='+opp.id);
        //ref.getParemeters().put('inline','0');
        //ref.setRedirect(true);
        system.debug('Add products Page::'+ ref);
        return ref;
    }
    public PageReference oliDelete()
    {
        String oliId = ApexPages.currentPage().getParameters().get('oliid');
        PageReference ref = new PageReference('/'+opp.id);
        ref.setRedirect(true);
        OpportunityLineItem oli = new OpportunityLineItem(id=oliId);
        delete oli;
        
        return ref;
    }
}