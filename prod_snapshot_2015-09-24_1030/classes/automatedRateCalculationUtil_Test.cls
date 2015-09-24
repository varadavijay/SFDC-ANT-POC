@isTest
private class automatedRateCalculationUtil_Test{
   
   @testSetup static void setautoRateCalcData() {
      
      //Create test Price book data
      Pricebook2 testPB= New Pricebook2( Name='USCP Wholesale Price Book',
                                         ISACTIVE=TRUE
                                       );
      INSERT testPB;
      
      //Create test Product data
      Product2 testProd= New Product2(Name='Email Blast - Standard',
                                      DESCRIPTION='Test Product',
                                      ISACTIVE=TRUE);
      INSERT testProd;
      
      Id standardPricebookId = Test.getStandardPricebookId();
      
      PricebookEntry standardPrice = new PricebookEntry(
                                            Pricebook2Id = standardPricebookId, Product2Id = testProd.Id,
                                            UnitPrice = 10000, IsActive = true);
      INSERT standardPrice;
      
      PricebookEntry customPrice = new PricebookEntry(
                                            Pricebook2Id = testPB.Id, Product2Id = testProd.Id,
                                            UnitPrice = 12000, IsActive = true);
      INSERT customPrice;
      
      //Create Auto rate calculation data
      Automated_Rate_Calculation__c[] autoRateCalc=new Automated_Rate_Calculation__c[]{};
      
      //Data with column and and row within range
      autoRateCalc.add(new Automated_Rate_Calculation__c (  Name= 'ARC-1',
                                                            Row_Start_Range__c= 10000,
                                                            Column_Start_Range__c= 1,
                                                            Row_End_Range__c = 14999,
                                                            Column_End_Range__c = 2,
                                                            MatrixResult__c= 0.08,
                                                            Product__c=testProd.Id,
                                                            Price_Book__c=testPB.Id
                                                         ));
      //Data with highest range
      autoRateCalc.add(new Automated_Rate_Calculation__c (  Name= 'ARC-2',
                                                            Row_Start_Range__c= 10000,
                                                            Column_Start_Range__c= 12,
                                                            Row_End_Range__c = 14999,
                                                            MatrixResult__c= 0.07,
                                                            Product__c=testProd.Id,
                                                            Price_Book__c=testPB.Id
                                                         ));
      //Data with highest row range
      autoRateCalc.add(new Automated_Rate_Calculation__c (  Name= 'ARC-3',
                                                            Row_Start_Range__c= 2000000,
                                                            Column_Start_Range__c= 6,
                                                            Column_End_Range__c = 11,
                                                            MatrixResult__c= 0.01,
                                                            Product__c=testProd.Id,
                                                            Price_Book__c=testPB.Id
                                                         ));                                                
       //Data with highest Row and Column range                                                  
       autoRateCalc.add(new Automated_Rate_Calculation__c ( Name= 'ARC-4',
                                                            Row_Start_Range__c= 2000000,
                                                            Column_Start_Range__c= 12,
                                                            MatrixResult__c= 0.02,
                                                            Product__c=testProd.Id,
                                                            Price_Book__c=testPB.Id
                                                         ));
       INSERT autoRateCalc;
       
   }
   
   @isTest static void testGetEmailBlastRate() {
     
    Test.startTest();
          PricebookEntry pbe= [SELECT Id from PriceBookEntry WHERE Product2.Name='Email Blast - Standard' AND Pricebook2.Name='USCP Wholesale Price Book'];
          
          List<Automated_Rate_Calculation__c> arcResult_WR= automatedRateCalculationUtil.getEmailBlastRate(10000,
                                                                                                   2,
                                                                                                   pbe.Id);
          if(arcResult_WR!=null){                                                                                        
            System.assertEquals(arcResult_WR[0].MatrixResult__c,0.08);
          }
          
          List<Automated_Rate_Calculation__c> arcResult_HC= automatedRateCalculationUtil.getEmailBlastRate(10000,
                                                                                                  13,
                                                                                                  pbe.Id);
          if(arcResult_HC!=null) {
            System.assertEquals(arcResult_HC[0].MatrixResult__c,0.07);
          }
          
          List<Automated_Rate_Calculation__c> arcResult_HR= automatedRateCalculationUtil.getEmailBlastRate(2000001,
                                                                                                  8,
                                                                                                  pbe.Id); 
          if(arcResult_HR!=null){                                                                                       
            System.assertEquals(arcResult_HR[0].MatrixResult__c,0.01);
          }                                                                                            
          
          List<Automated_Rate_Calculation__c> arcResult_HRC= automatedRateCalculationUtil.getEmailBlastRate(2000001,
                                                                                                  13,
                                                                                                  pbe.Id);
          if(arcResult_HRC!=null){                                                                                         
            System.assertEquals(arcResult_HRC[0].MatrixResult__c,0.02);
          }
     Test.stopTest();
   }
}