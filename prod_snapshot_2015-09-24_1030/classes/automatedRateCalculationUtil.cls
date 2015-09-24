//DEV-2107:Encapsulates the functionality of a USCP Product rate calculation
public class automatedRateCalculationUtil{

    // Main method to retrieve Email blast rates
    public static List<Automated_Rate_Calculation__c> getEmailBlastRate(Long numberOfRecipients, Long numberOfBlasts, Id pbeId) {
        
        List<Automated_Rate_Calculation__c> emailBlastRateList;
        String dynamicWhere;
        Id prodId;
        Id pricebookId;
        Integer HIGHEST_RECEPIENT_RANGE;
        Integer HIGHEST_EMAILBLAST_RANGE;
        
        if(pbeId!=null) {
             List<PricebookEntry> pbeList = Database.query('SELECT Id,Product2Id,Pricebook2Id FROM PricebookEntry WHERE Id = :pbeId AND isActive=TRUE LIMIT 1');
             if(pbeList.size()>0){
                 prodId = pbeList[0].Product2Id; 
                 pricebookId=pbeList[0].Pricebook2Id;
             }
        }else{
          System.debug(Logginglevel.ERROR,'----& Blank Pricebook Name &------');
        }   
         
        
        List<Automated_Rate_Calculation__c> autoratecalc = New List<Automated_Rate_Calculation__c>([ SELECT Row_Start_Range__c,Column_Start_Range__c
                                                       FROM   Automated_Rate_Calculation__c
                                                       WHERE
                                                       Row_End_Range__c=null
                                                       AND
                                                       Column_End_Range__c=null
                                                       AND
                                                       Product__c= :prodId
                                                       AND 
                                                       Price_Book__c= :pricebookId 
                                                       LIMIT 1]);
        
        if(autoratecalc.size()>0){
              HIGHEST_RECEPIENT_RANGE = Integer.ValueOf(autoratecalc[0].Row_Start_Range__c);
              HIGHEST_EMAILBLAST_RANGE = Integer.ValueOf(autoratecalc[0].Column_Start_Range__c);
        }else{
              System.debug(Logginglevel.ERROR,'----& Blank Highest Ranges &------');
        }
        
        //Create dynamic SOQL query to fetch price
        String dynamicSOQL= 'SELECT MatrixResult__c FROM Automated_Rate_Calculation__c';
        
        //Create WHERE clause based on the variable supplied
        if(numberOfRecipients!=null && numberOfBlasts!=null && pricebookId!=null && prodId!=null){
           
               if(numberOfRecipients >= HIGHEST_RECEPIENT_RANGE && numberOfBlasts < HIGHEST_EMAILBLAST_RANGE){
               
                     dynamicWhere =' WHERE Row_Start_Range__c <= :numberOfRecipients AND Row_End_Range__c=null';
                     dynamicWhere +=' AND Column_Start_Range__c <= :numberOfBlasts AND Column_End_Range__c >= :numberOfBlasts';
                     System.Debug('My 1st If ' + numberOfRecipients +' && ' + HIGHEST_RECEPIENT_RANGE + ' && ' + numberOfBlasts + ' && ' + HIGHEST_EMAILBLAST_RANGE);
                     
               }else if(numberOfBlasts >= HIGHEST_EMAILBLAST_RANGE && numberOfRecipients < HIGHEST_RECEPIENT_RANGE){
               
                     dynamicWhere =' WHERE Row_Start_Range__c <= :numberOfRecipients AND Row_End_Range__c >= :numberOfRecipients';
                     dynamicWhere +=' AND Column_Start_Range__c <= :numberOfBlasts AND Column_End_Range__c = null';
                     System.Debug('My 2nd If ' + numberOfRecipients +' && ' + HIGHEST_RECEPIENT_RANGE + ' && ' + numberOfBlasts + ' && ' + HIGHEST_EMAILBLAST_RANGE);
                    
               }else if(numberOfRecipients >= HIGHEST_RECEPIENT_RANGE && numberOfBlasts >= HIGHEST_EMAILBLAST_RANGE){
               
                     dynamicWhere =' WHERE Row_Start_Range__c <= :numberOfRecipients AND Row_End_Range__c = null';
                     dynamicWhere +=' AND Column_Start_Range__c <= :numberOfBlasts AND Column_End_Range__c = null';
                     System.Debug('My 3rd If ' + numberOfRecipients +' && ' + HIGHEST_RECEPIENT_RANGE + ' && ' + numberOfBlasts + ' && ' + HIGHEST_EMAILBLAST_RANGE);
                     
               }else{  
               
                     dynamicWhere =' WHERE Row_Start_Range__c <= :numberOfRecipients AND Row_End_Range__c >= :numberOfRecipients';
                     dynamicWhere +=' AND Column_Start_Range__c <= :numberOfBlasts AND Column_End_Range__c >= :numberOfBlasts';
                     System.Debug('My 4th If ' + numberOfRecipients +' && ' + HIGHEST_RECEPIENT_RANGE + ' && ' + numberOfBlasts + ' && ' + HIGHEST_EMAILBLAST_RANGE);
                     
               }
               
               dynamicWhere +=' AND Product__c= :prodId';
               dynamicWhere +=' AND Price_Book__c= :pricebookId';
             
        }else{
               System.debug(Logginglevel.ERROR,'----& Blank recepient and/or blast numbers &------');
        }
        
        //Merge dynamic WHERE clause & dynamic Query
        if(dynamicSOQL!=null && dynamicWhere!=null && !String.isempty(dynamicSOQL) && !String.isempty(dynamicWhere) ){
             dynamicSOQL += dynamicWhere;
             emailBlastRateList= Database.query(dynamicSOQL);
        }
                                                                                   
        return emailBlastRateList;
    }

}