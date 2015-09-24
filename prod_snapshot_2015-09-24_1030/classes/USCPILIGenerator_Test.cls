@isTest(SeeAllData=True)
private class USCPILIGenerator_Test {

    static testMethod void insertInvoiceLineItems_Test() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PriceBook2 pb2USCP = [select Id from Pricebook2 where Name = 'USCP Wholesale Price Book'];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true, Invoice_StatusToCreateILI__c = 'Live');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbe;
        
        PricebookEntry pbeUSCP = new PricebookEntry(Pricebook2Id=pb2USCP .Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbeUSCP;
        
        list<OpportunityLineItem> olilist = new  list<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity=2;
        oli.TotalPrice = 2000;
        oli.ServiceDate = date.today();
        oli.OpportunityId = opp.Id;
        oli.PriceBookEntryId=pbeUSCP.Id;
        oli.Waiting_Status__c = 'Live1';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Qty_ContractMonths__c = 2;
        
        
        olilist.add(oli);
        
        insert olilist;
        
        Project__c proj = [SELECT Id,Product_Id__c,Has_ILI__c, CanCreateILI__c,Qty_ContractMonths__c , Invoice_ServiceStartDate__c, Project_Status__c  FROM Project__c WHERE Product_Id__c =: oliList[0].Id];
        //proj.Qty_ContractMonths__c = 5;
        proj.Project_Status__c = 'Live';
        proj.Invoice_ServiceStartDate__c = date.today().adddays(2);
        update proj;
        system.debug('*****mydebug*********'+proj+'*****'+proj.Invoice_ServiceStartDate__c);
        //update proj;
        
        /*USCPILIGenerator classObj = new USCPILIGenerator();
        map<Id, Id> oliWithProjId = new map<Id, Id>();
        oliWithProjId.put(proj.Product_Id__c, proj.Id);
        classObj.insertInvoiceLineItems(oliWithProjId);
        *///classObj.updateInvoiceLineItems(2, date.today(), 2000, opp.Id, proj.Id);    
        //proj.Cancelled__c = true;
        //update proj;
        //classObj.cancelInvoiceLineItems(new set<Id>{proj.Id});
        
        list<Invoice_LineItem__c> iliList = new list<Invoice_LineItem__c>();
        iliList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, 
                        ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
                        isDeleted__c, Invoice_PeriodEnd__c
                 FROM Invoice_LineItem__c
                 WHERE OpportunityRef__c=: opp.Id
                     ];
                     
        system.assertEquals(iliList.size(), 2);
        
        /*test.startTest();
        proj.Invoice_CancelDate__c = date.today().adddays(2);
        proj.Project_Status__c  = 'Cancelled';
        update proj;
        Test.stopTest();*/
    }
    
    static testMethod void insertInvoiceLineItems_Test_2() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PriceBook2 pb2USCP = [select Id from Pricebook2 where Name = 'USCP Wholesale Price Book'];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true, Invoice_Frequency__c= 'Two Times', Invoice_StatusToCreateILI__c = 'Live');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbe;
        
        PricebookEntry pbeUSCP = new PricebookEntry(Pricebook2Id=pb2USCP .Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbeUSCP;
        
        list<OpportunityLineItem> olilist = new  list<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity=2;
        oli.TotalPrice = 2000;
        oli.ServiceDate = date.today();
        oli.OpportunityId = opp.Id;
        oli.PriceBookEntryId=pbeUSCP.Id;
        oli.Waiting_Status__c = 'Live1';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Qty_ContractMonths__c = 2;
        
        
        olilist.add(oli);
        
        insert olilist;
        
        Project__c proj = [SELECT Id,Product_Id__c,Has_ILI__c, CanCreateILI__c,Qty_ContractMonths__c , Invoice_ServiceStartDate__c, Project_Status__c  FROM Project__c WHERE Product_Id__c =: oliList[0].Id];
        proj.Project_Status__c = 'Live';
        proj.Invoice_ServiceStartDate__c = date.today().adddays(2);
        update proj;
        system.debug('*****mydebug*********'+proj+'*****'+proj.Invoice_ServiceStartDate__c);
        
        list<Invoice_LineItem__c> iliList = new list<Invoice_LineItem__c>();
        iliList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, 
                        ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
                        isDeleted__c, Invoice_PeriodEnd__c
                 FROM Invoice_LineItem__c
                 WHERE OpportunityRef__c=: opp.Id
                     ];
                     
        system.assertEquals(iliList.size(), 2);
    }
    
    static testMethod void cancelInvoiceLineItems_Test() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PriceBook2 pb2USCP = [select Id from Pricebook2 where Name = 'USCP Wholesale Price Book'];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true, Invoice_StatusToCreateILI__c = 'Live', Invoice_Frequency__c='One Time');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbe;
        
        PricebookEntry pbeUSCP = new PricebookEntry(Pricebook2Id=pb2USCP .Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbeUSCP;
        
        list<OpportunityLineItem> olilist = new  list<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity=2;
        oli.TotalPrice = 2000;
        oli.ServiceDate = date.today();
        oli.OpportunityId = opp.Id;
        oli.PriceBookEntryId=pbeUSCP.Id;
        oli.Waiting_Status__c = 'Live1';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Qty_ContractMonths__c = 2;
        
        
        olilist.add(oli);
        
        insert olilist;
        
        Project__c proj = [SELECT Id,Product_Id__c,Has_ILI__c, CanCreateILI__c,Qty_ContractMonths__c , Invoice_ServiceStartDate__c, Project_Status__c  FROM Project__c WHERE Product_Id__c =: oliList[0].Id];
        //proj.Qty_ContractMonths__c = 5;
        proj.Project_Status__c = 'Live';
        proj.Invoice_ServiceStartDate__c = date.today().adddays(2);
        update proj;
        system.debug('*****mydebug*********'+proj+'*****'+proj.Invoice_ServiceStartDate__c);
        
        list<Invoice_LineItem__c> iliList = new list<Invoice_LineItem__c>();
        iliList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, 
                        ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
                        isDeleted__c, Invoice_PeriodEnd__c
                 FROM Invoice_LineItem__c
                 WHERE OpportunityRef__c=: opp.Id
                     ];
                     
        system.assertEquals(iliList.size(), 2);
        
        oli.Waiting_Status__c = 'Cancelled';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Invoice_CancelDate__c = date.today().adddays(2);
        oli.Cancellation_Category__c = 'G/O Error';
        oli.Cancellation_Reason__c = 'Test Reason';
        oli.Waiting_Status_Descr__c  = 'Testa Cancel';
        
        update oli;
    }
    
    static testMethod void hardcancelInvoiceLineItems_Test() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PriceBook2 pb2USCP = [select Id from Pricebook2 where Name = 'USCP Wholesale Price Book'];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true, Invoice_StatusToCreateILI__c = 'Live', Invoice_Frequency__c='One Time');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbe;
        
        PricebookEntry pbeUSCP = new PricebookEntry(Pricebook2Id=pb2USCP .Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbeUSCP;
        
        list<OpportunityLineItem> olilist = new  list<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity=2;
        oli.TotalPrice = 2000;
        oli.ServiceDate = date.today();
        oli.OpportunityId = opp.Id;
        oli.PriceBookEntryId=pbeUSCP.Id;
        oli.Waiting_Status__c = 'Live1';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Qty_ContractMonths__c = 2;
        
        
        olilist.add(oli);
        
        insert olilist;
        
        Project__c proj = [SELECT Id,Product_Id__c,Has_ILI__c, CanCreateILI__c,Qty_ContractMonths__c , Invoice_ServiceStartDate__c, Project_Status__c  FROM Project__c WHERE Product_Id__c =: oliList[0].Id];
        //proj.Qty_ContractMonths__c = 5;
        proj.Project_Status__c = 'Live';
        proj.Invoice_ServiceStartDate__c = date.today().adddays(2);
        update proj;
        system.debug('*****mydebug*********'+proj+'*****'+proj.Invoice_ServiceStartDate__c);
        
        list<Invoice_LineItem__c> iliList = new list<Invoice_LineItem__c>();
        iliList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, 
                        ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
                        isDeleted__c, Invoice_PeriodEnd__c
                 FROM Invoice_LineItem__c
                 WHERE OpportunityRef__c=: opp.Id
                     ];
                     
        system.assertEquals(iliList.size(), 2);
        
        oli.Waiting_Status__c = 'Hard Cancel';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Invoice_CancelDate__c = date.today().adddays(2);
        oli.Cancellation_Category__c = 'G/O Error';
        oli.Cancellation_Reason__c = 'Test Reason';
        oli.Waiting_Status_Descr__c  = 'Test Cancel';
        
        update oli;
    }
    
    static testMethod void updateInvoiceLineItems_Test() {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PriceBook2 pb2USCP = [select Id from Pricebook2 where Name = 'USCP Wholesale Price Book'];
        
        Product2 p2 = new Product2(Name='Test Product',isActive=true, Invoice_StatusToCreateILI__c = 'Live', Invoice_Frequency__c='Two Times');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbe;
        
        PricebookEntry pbeUSCP = new PricebookEntry(Pricebook2Id=pb2USCP .Id, Product2Id=p2.Id, UnitPrice=2000, isActive=true);
        insert pbeUSCP;
        
        list<OpportunityLineItem> olilist = new  list<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity=2;
        oli.TotalPrice = 2000;
        oli.ServiceDate = date.today();
        oli.OpportunityId = opp.Id;
        oli.PriceBookEntryId=pbeUSCP.Id;
        oli.Waiting_Status__c = 'Fulfilled-Complete';
        oli.Invoice_ServiceStartDate__c = date.today().adddays(2);
        oli.Invoice_CancelDate__c = date.today().adddays(2);
        oli.Cancellation_Category__c = 'G/O Error';
        oli.Cancellation_Reason__c = 'Test Reason';
        oli.Waiting_Status_Descr__c  = 'Test Cancel';
        oli.Qty_ContractMonths__c = 2;
        
        
        olilist.add(oli);
        
        insert olilist;
        
        Project__c proj = [SELECT Id,Product_Id__c,Has_ILI__c, CanCreateILI__c,Qty_ContractMonths__c , Invoice_ServiceStartDate__c, Project_Status__c  FROM Project__c WHERE Product_Id__c =: oliList[0].Id];
        
        Invoice_LineItem__c i = new Invoice_LineItem__c();
        i.OpportunityRef__c = opp.Id;
        i.Invoice_PeriodStart__c = date.today().addmonths(3);
        i.Invoice_PeriodEnd__c = date.today().addmonths(4).adddays(-1);
        i.ProjectRef__c = proj.Id;
        i.TotalMonthlyCharge__c = 200;
        
        insert i;
        
        USCPILIGenerator classObj = new USCPILIGenerator();
        map<id,Id> oliwithproj = new map<id, Id>();
        oliwithproj.put(oli.id,proj.id);
        classObj.updateInvoiceLineItems(oliwithproj);
    }
}