public class TestingUtils {
	
	public static List<Account> createAccounts ( Integer numOfAccounts, Boolean isInsert ){

        List<Account> testAccounts = new List<Account>();
        for ( Integer i = 0; i < numOfAccounts; i++ ){
             Account testAccount = new Account();
             testAccount.Name = 'TestAccount_' + i;
             testAccount.BillingCountry = 'United States';
             testAccount.BillingPostalCode = '11209';
             testAccount.BillingState = 'NY';
             testAccounts.add ( testAccount );
        }
        if ( isInsert )
            insert testAccounts;

        return testAccounts;
    }
    
	public static List<Opportunity> createOpportunities(Integer numToCreate, String name, Id actId, Boolean doInsert)
    {
    	List<Opportunity> testOpps = new List<Opportunity>();
    	for (Integer i=0; i<numToCreate; i++){
	        Opportunity testOpportunity = new Opportunity(AccountId = actId);
	        testOpportunity.Name = (name == null)? 'testOpp_' + i : name+'_'+i;	        
	        testOpportunity.StageName = 'Closed Won';
			testOpportunity.CloseDate = date.today();
	        testOpps.add(testOpportunity);
    	}
        if( doInsert)
            insert testOpps;
        return testOpps;

    }
    public static Product2 createProduct(String name, Boolean doInsert){
    	Product2 prod = new Product2(Name = name, IsActive= true);
    	if (doInsert) {
    		insert prod;
    	}
    	return prod;
    }
    public static Pricebook2 createPriceBook(String pbName, Boolean doInsert){
    	Pricebook2 pricebook = new Pricebook2(Name=pbName);
    	if (doInsert){
    		insert pricebook;
    	}
    	return pricebook;
    }
    
    public static PriceBookEntry createPriceBookEntry(Id prodId, Id pbId, Boolean doInsert){
    	PriceBookEntry priceBookEntry = new PriceBookEntry(Product2Id = prodId, Pricebook2Id = pbId, UnitPrice = 1, IsActive = true);
    	if (doInsert){
    		insert priceBookEntry;
    	}
    	return priceBookEntry;
    }
    
    public static Project__c createProject(String pName, Boolean doInsert){
    	Project__c testProject = new Project__c(Name='testProject_'+pName);
    	if (doInsert){
    		insert testProject;
    	}
    	return testProject;
    }
    
    public static OpportunityLineItem createOLI(Id testPriceBookEntryId, Id testOppId, Boolean doInsert){
    	OpportunityLineItem oppProd = new OpportunityLineItem(Quantity = 1, TotalPrice = 1, ServiceDate = Date.today(), PricebookEntryId = testPriceBookEntryId, OpportunityId = testOppId );
        if (doInsert){
        	insert oppProd;
        }
        return oppProd;
    }
    
    public static OpportunityLineItem createOLIandGetRecordInfo(Id testPriceBookEntryId, Id testOppId, Boolean doInsert){
    	OpportunityLineItem oppProd = createOLI(testPriceBookEntryId, testOppId, doInsert);
    	system.debug('oppProd: '+ oppProd);
    	if (doInsert)
    		oppProd = [Select Id, Project__c, Quantity, TotalPrice, PricebookEntryId, OpportunityId, LastModifiedDate, CreatedDate From OpportunityLineItem Where Id = :oppProd.Id];
        system.debug('oppProd: '+ oppProd);
        return oppProd;
    }
    
    public static List<Opportunity_Product_History__c> createOliHistory(Integer numToCreate, Boolean doInsert){
    	List<Opportunity_Product_History__c> oppProdHistList = new List<Opportunity_Product_History__c>();
    	
    	for (Integer i=0; i<numToCreate; i++){
    		Opportunity_Product_History__c oppProdHist = new Opportunity_Product_History__c();
    		oppProdHistList.add(oppProdHist);
    	}
    	if (doInsert)
    		insert oppProdHistList;
    	return oppProdHistList;		
    }
    
}