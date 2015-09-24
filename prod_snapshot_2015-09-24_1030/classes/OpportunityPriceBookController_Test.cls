@isTest(SeeAllData=true)
public class OpportunityPriceBookController_Test
{
    static testMethod void optyPriceBook()
    {
        Account objAcc=new Account(name='test Account');
        insert objAcc;
        Account objMedia=new Account(name='Harsha');
        insert objMedia;
        KPICalender__c objCal=new KPICalender__c(name='test',Date__c=system.today());
        insert objCal;
        KPIRep__c objKRep=new KPIRep__c(name='test',User__c=userinfo.getUserId());
        insert objKRep;
        Pricebook2 objPb=new Pricebook2(name='USCP Wholesale Price Book',IsActive=true);
        insert objPb;
        
        String rtypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('USCP Opportunity').getRecordTypeId();
        opportunity objOpty=new opportunity(name='Harsha Opty',Pricebook2Id=objPb.Id,Stagename='Prospecting',closedate=system.today()+10,AccountId=objAcc.Id,Media_Partner__c=objMedia.Id,RecordTypeid=rtypeId);
        insert objOpty;
        
        List<Product2> prodLst=new List<Product2>();
        Product2 objProd1=new Product2(Name='Test product 1',IsActive=true,Description='test description',ProductCode='1234');
        prodLst.add(objProd1);
        Product2 objProd2=new Product2(Name='Test product 2',IsActive=true,Description='test description1',ProductCode='1235');
        prodLst.add(objProd2);
        Product2 objProd3=new Product2(Name='Test product 3',IsActive=true,Description='test description2',ProductCode='1236');
        prodLst.add(objProd3);
        Product2 objProd4=new Product2(Name='Test product 4',IsActive=true,Description='test description3',ProductCode='1237');
        prodLst.add(objProd4);
        Product2 objProd5=new Product2(Name='Test product 5',IsActive=true,Description='test description4',ProductCode='12345');
        prodLst.add(objProd5);
        insert prodLst;
        
        
        Pricebook2 ojbStandrad=[select id,name,isActive from Pricebook2 where name='Standard Price Book' And isActive=true And IsStandard=true];
        
        List<PricebookEntry> PBELst=new List<PricebookEntry>();
        PricebookEntry objPBE1=new PricebookEntry(IsActive=true,Pricebook2Id=ojbStandrad.Id,Product2Id=prodLst[0].Id,UnitPrice=100);
        PBELst.add(objPBE1);
        PricebookEntry objPBE2=new PricebookEntry(IsActive=true,Pricebook2Id=ojbStandrad.Id,Product2Id=prodLst[1].Id,UnitPrice=200);
        PBELst.add(objPBE2);
        PricebookEntry objPBE3=new PricebookEntry(IsActive=true,Pricebook2Id=ojbStandrad.Id,Product2Id=prodLst[2].Id,UnitPrice=120);
        PBELst.add(objPBE3);
        PricebookEntry objPBE4=new PricebookEntry(IsActive=true,Pricebook2Id=ojbStandrad.Id,Product2Id=prodLst[3].Id,UnitPrice=145);
        PBELst.add(objPBE4);
        PricebookEntry objPBE5=new PricebookEntry(IsActive=true,Pricebook2Id=ojbStandrad.Id,Product2Id=prodLst[4].Id,UnitPrice=1000);
        PBELst.add(objPBE5);
        
        PricebookEntry objPBE6=new PricebookEntry(IsActive=true,Pricebook2Id=objPb.Id,Product2Id=prodLst[0].Id,UnitPrice=100);
        PBELst.add(objPBE6);
        PricebookEntry objPBE7=new PricebookEntry(IsActive=true,Pricebook2Id=objPb.Id,Product2Id=prodLst[1].Id,UnitPrice=200);
        PBELst.add(objPBE7);
        PricebookEntry objPBE8=new PricebookEntry(IsActive=true,Pricebook2Id=objPb.Id,Product2Id=prodLst[2].Id,UnitPrice=120);
        PBELst.add(objPBE8);
        PricebookEntry objPBE9=new PricebookEntry(IsActive=true,Pricebook2Id=objPb.Id,Product2Id=prodLst[3].Id,UnitPrice=145);
        PBELst.add(objPBE9);
        PricebookEntry objPBE10=new PricebookEntry(IsActive=true,Pricebook2Id=objPb.Id,Product2Id=prodLst[4].Id,UnitPrice=1000);
        PBELst.add(objPBE10);
        insert PBELst;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpty);
        apexpages.currentpage().getparameters().put('oppId',objOpty.Id);
        OpportunityPriceBookController controller=new OpportunityPriceBookController(sc);
        
        OpportunityPriceBookController.wrapProduct objWrap=new OpportunityPriceBookController.wrapProduct(PBELst[6],false);
        List<OpportunityPriceBookController.wrapProduct> wrpLst=new List<OpportunityPriceBookController.wrapProduct>();
        
        test.startTest();
        controller.sortDirection = 'ASC';
        controller.sortExp = 'name';
        controller.totalPages=2;
        controller.pageNumber=1;
        controller.getSortDirection();
        controller.setSortDirection('DESC');
        controller.redirectOpty();
        controller.selectedProducts.add(PBELst[8]);
        controller.wrapPriceBkList[3].selected=true;
        controller.productSelected();
        controller.cancel();
        controller.redirectOpty();
        controller.FirstPage();
        controller.previous();
        controller.LastPage();
        controller.getnxt();
        controller.getprev();
        
        Apexpages.currentPage().getParameters().put('productName','Test');
        controller.next();
        test.stopTest();
    }
}