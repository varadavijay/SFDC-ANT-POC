public with sharing class OpportunityPriceBookController {

    public List<PricebookEntry> priceBookList{get;set;} // List to store Pricebook Entry records
    //Public String searchValue{get;set;} //User input value on search box
    public Boolean HideTable{get;set;}  // Display/Hide table when records zero
    Public String dynamicSOQL{get;set;}
    public List<wrapProduct> wrapPriceBkList {get; set;}
    public List<PricebookEntry> selectedProducts{get;set;}
    public Map<Id,PricebookEntry> tempProductMap{get;set;}
    
    public String productName{get;set;}
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 10;
    public String OptyId{get;set;}
    public opportunity oppPricebookId{get;set;}
    public Boolean SelectAll{get;set;}
    public String ProductId{get;set;}
    public Opportunity oppty{get;set;}
    public Boolean ShowProducts{get;set;}
    public String sortDirection = 'ASC';
    public String sortExp = 'name';
    Public Boolean prodName{get;set;}
    
    //Constructor
    public OpportunityPriceBookController(ApexPages.StandardController controller)
    {
        OptyId=apexpages.currentpage().getparameters().get('oppId');
        oppPricebookId=[select Pricebook2Id from Opportunity where Opportunity.Id=:OptyId];
        if(OptyId !=null && OptyId !='')
            oppty=[select id,name from opportunity where id =:OptyId];
        HideTable=true;
        SelectAll=false;
        prodName=true;
        selectedProducts = new List<PricebookEntry>();
        tempProductMap= new Map<Id,PricebookEntry>();
        totalRecs = [select count() from PricebookEntry where Product2.IsActive=true AND IsActive =true AND Pricebook2.Id =:oppPricebookId.Pricebook2Id ];
        
        priceBookList=[select id,ProductCode,Pricebook2.name,
                                Product2.Description,
                                Product2Id,Product2.name,
                                Product2.RecordType.name,
                                Product2.IsActive,
                                UnitPrice,
                                Product2.Components__c,
                                Product2.family,
                                Product2.HasMediaSpend__c,
                                PriceRangeMin__c,
                                PriceRangeMax__c,
                                Product2.Product_Group__c,
                                Product2.SLA_Bus_Days__c,
                                Product2.SLA_Product_Type__c,
                                Product2.Invoice_Frequency__c 
                                from PricebookEntry 
                                where Product2.IsActive=true AND IsActive =true AND Pricebook2.Id =:oppPricebookId.Pricebook2Id ORDER BY Product2.name ASC LIMIT :LimitSize OFFSET :OffsetSize];    
        
        system.debug('priceBookList-----'+priceBookList);                        
        if(wrapPriceBkList == null) {
            wrapPriceBkList = new List<wrapProduct>();
            
            for(PricebookEntry objPriceBk: priceBookList) {            
                wrapPriceBkList.add(new wrapProduct(objPriceBk,False));
            }
        }
    }
    
    // sorting-----------------
    
         public String sortExpression
       {
         get
         {
            return sortExp;
         }
         set
         {
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
           sortExp = value;
         }
       }
    
     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
    
    //sorting end---------------------------------------
    
    public PageReference cancel()
    {
        //OptyId=apexpages.currentpage().getparameters().get('oppId');
        PageReference optyPage= new PageReference('/'+OptyId);
        optyPage.setRedirect(true);
        Return optyPage;
    }
    
    public PageReference redirectOpty() {
        
        if(selectedProducts.size()<=0)
        {
            ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.INFO, 'Select atleast one product');
            ApexPages.addMessage(apexMessage);
            return null;
        }
        Integer peInc=0;
        //OptyId=apexpages.currentpage().getparameters().get('oppId');
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('OppId',OptyId);
        pageRef.getParameters().put('ProdNum',String.valueOf(selectedProducts.size()));
        
        
        for(PricebookEntry pe: selectedProducts){
          String peStr= string.valueof(peInc);
          pageRef.getParameters().put('peId-' + peInc,pe.Id);
          System.Debug('My PE List ' + 'peId-' + peInc);
          peInc=peInc+1;
        }
        
        return pageRef;
    }
    
    // Create search query based on user typed string
       public PageReference createQueryString() {
             //selectedProducts = new List<PricebookEntry>();
             string sortFullExp = sortExpression  + ' ' + sortDirection;
             String Query;
             String searchName;
             
             if(prodName)
             searchName= Apexpages.currentPage().getParameters().get('productName');
             
             system.debug('searchName::'+searchName);
             system.debug('Productname::'+productName);
             if(searchName !=null && searchName !='' && searchName !=productName)
                 OffsetSize=0;
             
             if(searchName !=null)    
                 productName=searchName;
             else if(searchName =='')
                 productName=searchName;
                 
             system.debug('Productname::'+productName);
             system.debug('OffsetSize------'+OffsetSize);
             
             system.debug('PricebookId::'+oppPricebookId.Pricebook2Id);
             dynamicSOQL= 'select id,ProductCode,Product2.Description,Product2Id,Product2.name,Product2.RecordType.name, ' +
             				'Product2.IsActive,UnitPrice,Product2.Components__c,Product2.family,Product2.HasMediaSpend__c, ' +
             				'PriceRangeMin__c,PriceRangeMax__c,Product2.Product_Group__c,Product2.SLA_Bus_Days__c, ' +
             				'Product2.SLA_Product_Type__c,Product2.Invoice_Frequency__c  from PricebookEntry ' + 
             				'where Product2.IsActive=true AND IsActive =true AND Pricebook2.Id = \''+oppPricebookId.Pricebook2Id+'\'';
             
             
             if(productName!=null && !productName.equals('')){
                 dynamicSOQL += ' AND Product2.name LIKE \'%'+String.escapeSingleQuotes(productName)+'%\'' +' Order by '+sortFullExp;
                 
                 Query=dynamicSOQL;
                 priceBookList= Database.query(dynamicSOQL);
                 totalRecs=priceBookList.size();    
                 //OffsetSize=0;
                     
                 dynamicSOQL +=' LIMIT :LimitSize OFFSET :OffsetSize';
             }else{
             	 dynamicSOQL= 'select id,ProductCode,Product2.Description,Product2Id,Product2.name,Product2.RecordType.name, ' +
             				'Product2.IsActive,UnitPrice,Product2.Components__c,Product2.family,Product2.HasMediaSpend__c, ' +
             				'PriceRangeMin__c,PriceRangeMax__c,Product2.Product_Group__c,Product2.SLA_Bus_Days__c, ' +
             				'Product2.SLA_Product_Type__c,Product2.Invoice_Frequency__c  from PricebookEntry ' +
             				'where Product2.IsActive=true AND IsActive =true AND Pricebook2.Id = \''+oppPricebookId.Pricebook2Id+'\' ORDER BY '+sortFullExp;
                 Query=dynamicSOQL;
                 priceBookList= Database.query(dynamicSOQL);
                 totalRecs=priceBookList.size();    
                 dynamicSOQL +=' LIMIT :LimitSize OFFSET :OffsetSize';
             }
             
             system.debug('dynamicSOQL-----------'+dynamicSOQL);
             // execute database query
             executeDynamicQuery();
             prodName=true;
             return null;
       }
      
       // runs the actual query
       public void executeDynamicQuery() {
              try {
                HideTable=true;
                wrapPriceBkList.clear();
                priceBookList.clear();
                priceBookList= Database.query(dynamicSOQL);
                
               system.debug('wrapPriceBkList---1------'+wrapPriceBkList.size());
               system.debug('priceBookList-----------'+priceBookList);
               system.debug('selectedProducts.size()-----------'+selectedProducts.size());
                    wrapPriceBkList = new List<wrapProduct>();
                    
                    for(PricebookEntry objPriceBk: priceBookList) {
                    
                    system.debug('objPriceBk---------'+objPriceBk);   
                                   
                        if(selectedProducts.size()>0)   
                        { 
                            Boolean Selected=false;
                            for(PricebookEntry objSelected: selectedProducts) 
                            {
                                if(objPriceBk.Id==objSelected.Id)
                                {
                                    system.debug('objPriceBk----true-----'+objPriceBk);
                                    Selected=true;
                                    wrapPriceBkList.add(new wrapProduct(objPriceBk,True));
                                    tempProductMap.put(objPriceBk.Id,objPriceBk);
                                }                                 
                            }
                            system.debug('objPriceBk----Selected-----'+objPriceBk);
                            if(Selected==false)
                                wrapPriceBkList.add(new wrapProduct(objPriceBk,False));
                        } 
                        else
                        {
                            wrapPriceBkList.add(new wrapProduct(objPriceBk,False)); 
                            system.debug('objPriceBk----else-----'+objPriceBk);
                        }       
                        
                    }
                system.debug('objSelected---------'+wrapPriceBkList.size());
                if(priceBookList.size()<=0)
                {
                   HideTable=false;
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Records to display.');
                   ApexPages.addMessage(myMsg);
                }  
                
              }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error returning the search result'));
              }
       }
       
       
    public void productSelected() {
        
        selectedProducts.clear();
        for(wrapProduct  wrapProdObj : wrapPriceBkList) 
        {
            if(wrapProdObj.selected ==true)
            {
                tempProductMap.put(wrapProdObj.priceBook.Id,wrapProdObj.priceBook);
            }
            
            if(wrapProdObj.selected ==false && wrapProdObj.priceBook.Id ==ProductId)
                tempProductMap.remove(ProductId);    
        }
        
        
        selectedProducts=tempProductMap.values();
    }
     public OpportunityPriceBookController(){}
    
    //Pagination 
    
    public void FirstPage()
    {
        prodName=false;
        ProductId=null;
        OffsetSize = 0;
        createQueryString();
        
    }
    public void previous()
    {
        prodName=false;
        ProductId=null;
        OffsetSize = OffsetSize-LimitSize;
        createQueryString();
        
    }
    public void next()
    {
        prodName=false;
        ProductId=null;
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
        prodName=false;
        ProductId=null;
        OffsetSize = totalRecs - LimitSize;
        createQueryString();
    }
    public boolean getprev()
    {
        if(OffsetSize == 0 || totalRecs==10)
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
    
    
    public class wrapProduct {
        public PricebookEntry priceBook{get; set;}
        public Boolean selected {get; set;}
 
        public wrapProduct(PricebookEntry priceBkEnty,Boolean value) {
            priceBook= priceBkEnty;
            selected = value;
        }
    }
    
}