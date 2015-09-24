@isTest(seeAllData=true)
public without sharing class ContractOriginalValueTest {
	
	private static Account[] accounts {get;set;}
    private static Opportunity[] opportunities {get;set;}
    private static product2 product {get;set;}
    private static OpportunityLineItem[] opportunityLineItems {get;set;}
    
	static testMethod void SetSingleOriginalContractValuetest ()
    {
        populateOLIRelatedData(1,1,2); // OLIs inserted with blank Status'; defaulted to unitprice =1 as per TestingUtils.cls.
        
        opportunityLineItems[0].waiting_status__c = ''; // OLI1 qualifying after it's inserted
        opportunityLineItems[0].UnitPrice = 5000;
        opportunityLineItems[0].HTML_Fee__c = 50;
        id qualifyingID;
        
        opportunityLineItems[1].waiting_status__c = 'Pending'; // OLI2 not qualifying even after insert
        opportunityLineItems[1].Waiting_Status_Descr__c = 'Notes';
        opportunityLineItems[1].UnitPrice = 4000;
        opportunityLineItems[1].HTML_Fee__c = 40;
        
        integer qualifiedOLIOriginalValueExpected = 5050;
        integer otherOLIOriginalValueExpected = null;
        string qualifiedOLIUpdatedStatusExpected = 'Closed Won';
        string otherOLIUpdatedStatusExpected = 'Pending';
        integer OPPOriginalValueExpected = 5050;
        string results = '';
        
        //Test no relevant OLI. (none inserted yet)
        for (Opportunity opp: opportunities)
        {
        	results = ContractOriginalValue.setSingleOriginalContractValue(opp.ID);        	
        }
        system.assertNotEquals('Success',results,'The Calculate Original Vlaue class should throw an error when there isn\'t a relevant OLI.');
        
        //Test partial relevant OLI      
        results = '';  
        
        insert opportunityLineItems;
        
        qualifyingID = opportunityLineItems[0].ID;
        system.debug('Qualifying ID = ' + qualifyingID);
        set<ID> oliList = new map<id,OpportunityLineItem>(opportunityLineItems).keyset();
        Test.startTest();
        for (Opportunity opp: opportunities)
        {
        	results = ContractOriginalValue.setSingleOriginalContractValue(opp.ID);        	
        }
        system.assertEquals('Success',results,'The Calculate Original Vlaue class should be successful while passing Opps with any qualifying OLI.');
       
        OpportunityLineItem[] updatedOLIs = [	select 	ID, 
       														waiting_status__c,
       														Product_CurrentValue__c,
       														Product_OriginalValue__c,
       														Quantity,
       														UnitPrice,
       														HTML_Fee__c,
       														TotalPrice
	       											from OpportunityLineItem 
	       											where ID in :oliList];
	       											
        system.assertEquals(opportunityLineItems.size(),updatedOLIs.size(),'Expecting the same number of OLI queried as the number inserted');
	    
	    system.debug('opportunityLineItems[0] with ID ' + opportunityLineItems[0].id 
                            + ' was in status: ' + opportunityLineItems[0].waiting_status__c 
                            + '. With Product_CurrentValue__c = ' + opportunityLineItems[0].Product_CurrentValue__c 
                            + ', Product_OriginalValue__c = ' + opportunityLineItems[0].Product_OriginalValue__c
                            + ', Qantity = ' + opportunityLineItems[0].Quantity
                            + ', UnitPrice = ' + opportunityLineItems[0].UnitPrice
                            + ', HTML_Fee__c = ' +  opportunityLineItems[0].HTML_Fee__c
                            + '.  The new values are' 
                            + ' status: ' + updatedOLIs[0].waiting_status__c 
                            + '. With Product_CurrentValue__c = ' + updatedOLIs[0].Product_CurrentValue__c 
                            + ', Product_OriginalValue__c = ' + updatedOLIs[0].Product_OriginalValue__c
                            + ', Qantity = ' + updatedOLIs[0].Quantity
                            + ', UnitPrice = ' + updatedOLIs[0].UnitPrice
                            + ', HTML_Fee__c = ' +  updatedOLIs[0].HTML_Fee__c
                        );
         system.debug('opportunityLineItems[1] with ID ' + opportunityLineItems[1].id 
                            + ' was in status: ' + opportunityLineItems[1].waiting_status__c 
                            + '. With Product_CurrentValue__c = ' + opportunityLineItems[1].Product_CurrentValue__c 
                            + ', Product_OriginalValue__c = ' + opportunityLineItems[1].Product_OriginalValue__c
                            + ', Qantity = ' + opportunityLineItems[1].Quantity
                            + ', UnitPrice = ' + opportunityLineItems[1].UnitPrice
                            + ', HTML_Fee__c = ' +  opportunityLineItems[1].HTML_Fee__c
                            + '.  The new values are' 
                            + ' status: ' + updatedOLIs[1].waiting_status__c 
                            + '. With Product_CurrentValue__c = ' + updatedOLIs[1].Product_CurrentValue__c 
                            + ', Product_OriginalValue__c = ' + updatedOLIs[1].Product_OriginalValue__c
                            + ', Qantity = ' + updatedOLIs[1].Quantity
                            + ', UnitPrice = ' + updatedOLIs[1].UnitPrice
                            + ', HTML_Fee__c = ' +  updatedOLIs[1].HTML_Fee__c
                        );
                        
        if (updatedOLIs[0].ID == qualifyingID)
        {
        	system.assertEquals(qualifiedOLIUpdatedStatusExpected,updatedOLIs[0].waiting_status__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(qualifiedOLIOriginalValueExpected,updatedOLIs[0].Product_OriginalValue__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(otherOLIUpdatedStatusExpected,updatedOLIs[1].waiting_status__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(otherOLIOriginalValueExpected,updatedOLIs[1].Product_OriginalValue__c,'We don\'t expect the orginal value set for non-qualifying opportunityLineItems'); 
        }
        else if (updatedOLIs[1].ID == qualifyingID)
        {
        	system.assertEquals(qualifiedOLIUpdatedStatusExpected,updatedOLIs[1].waiting_status__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(qualifiedOLIOriginalValueExpected,updatedOLIs[1].Product_OriginalValue__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(otherOLIUpdatedStatusExpected,updatedOLIs[0].waiting_status__c,'We expect the orginal value set for qualifying opportunityLineItems');
        	system.assertEquals(otherOLIOriginalValueExpected,updatedOLIs[0].Product_OriginalValue__c,'We expect the orginal value set for qualifying opportunityLineItems');
        }
        else
        {
        	system.assert(0==1,'qualifyingID not found!');
        }
        
        Opportunity updatedOpp = [SELECT 	ID, 
        							Opportunity_Original_Contract_Value__c
        					FROM opportunity 
        					WHERE ID = :opportunities[0].ID];
        
       system.assertEquals(OPPOriginalValueExpected, updatedOpp.Opportunity_Original_Contract_Value__c , 'The formula field should have values from only the qualifying OLI.');       
              
       //Contract Original Value already set.
       results = '';  	    
	    for (Opportunity opp: opportunities)
	    {
	    	results = ContractOriginalValue.setSingleOriginalContractValue(opp.ID);        	
	    }
	    system.assertNotEquals('Success',results,'The Calculate Original Vlaue class should throw errors when original value has already been set.');
    	Test.stopTest();
    }
	


    private static void populateOLIRelatedData( integer numAccToCreate,integer numOppForEachAcct,integer numOliForEachOpp)
    {
        system.assert(numAccToCreate>0 && numOppForEachAcct>0 && numOliForEachOpp>0,'Create at least 1 Account, Opp and OLI.');
        // -- Accounts -- 
        system.debug('ContractOriginalValueTest.populateOLIRelatedData: Creating ' + numAccToCreate + ' Accounts');       
        accounts = new Account[] {};
        accounts = TestingUtils.createAccounts(numAccToCreate,true);
        
        //  -- Opportunity Data --
        System.debug('ContractOriginalValueTest.populateOLIRelatedData: Creating ' + numOppForEachAcct + ' Opportunities');  
		opportunities = new Opportunity[]{};   
        for (account a: accounts)
        {
             opportunities.addAll(TestingUtils.createOpportunities(numOppForEachAcct,'TestContractOriginalValue ' + a.name , a.Id, false));             
        }
        
        for (integer i=0; i< opportunities.size(); i++)
        {
        	opportunities[i].stageName = 'Contract Approved';
        }
        insert opportunities;
       
        // -- Opportunity Line Item, Proudct, & PriceBookEntry Data ---
        System.debug('ContractOriginalValueTest.populateOLIRelatedData: Creating Product, Pricebook and PricebookEntry');           
        product = TestingUtils.createProduct('TestProductSLAServicesProduct',true);
        
        Pricebook2 pricebook = [select id from Pricebook2 where isStandard=true]; // Need to query this.  isStarndard is not a writable field
                                                                                  // and we need a standard pricebook to insert another.
                                                                                  
        PriceBookEntry pricebookEntry = TestingUtils.createPriceBookEntry(product.Id, pricebook.Id, true);
        
        // Not calling the test util because we want to set the Unit Price here.          
        System.debug('ContractOriginalValueTest.populateOLIRelatedData: Creating ' + numOliForEachOpp + ' opportunity products');           
        opportunityLineItems = new OpportunityLineItem[]{};
        
        for (Opportunity opp: opportunities)
        {
	        for (integer i=0; i < numOliForEachOpp; i++)
	        {
	        	//Not using TestingUtils because we want to sepecify the unit price in the test methods.
	            OpportunityLineItem OLI = new OpportunityLineItem(Quantity = 1, ServiceDate = Date.today(), PricebookEntryId = pricebookEntry.ID, OpportunityId = opp.Id);
	            opportunityLineItems.add(OLI);
	        }
        }
        
    }
       
}