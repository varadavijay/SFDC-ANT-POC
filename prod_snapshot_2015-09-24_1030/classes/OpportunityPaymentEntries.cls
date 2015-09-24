/**
 *  @Class Name : OpportunityPaymentEntries
    Created By  : Vijaya Varada
    Descritpion : Creates Opportunity Products Payment Entries based Opportunity Products Schedule
    Modifed By  : N/A
 */
 
global with sharing class OpportunityPaymentEntries {
	
	webservice static string createPaymentEntries(Id oppLineItemId){
		try{
			updateOppPaymentProcessAndcreatePaymentEntries(oppLineItemId);
			return 'Success';
		}catch(exception ex)
        {
            return ex.getMessage();
        }
	}
	
	//Create Payment Entries Based on Criteria 
	private static void updateOppPaymentProcessAndcreatePaymentEntries(Id oppLineItemId){
		//If Logged in User is not same as Gannet Local User
		if (UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id){
			List<OpportunityLineItem> oppLineItems = [Select Id, Payment_Processing__c, OpportunityId 
														from OpportunityLineItem Where Id =: oppLineItemId];
			
			OpportunityLineItem oneOppLineItem;		
			Payment_Processing__c onePaymentProcessing;				
								
			if(oppLineItems != null && oppLineItems.size()>0){
				oneOppLineItem = oppLineItems[0];
				List<Payment_Processing__c> oppPaymentProcessings = [SELECT Id, Name FROM Payment_Processing__c 
			 								 						  WHERE Opportunity__c =: oppLineItems[0].OpportunityId];
				if(oppPaymentProcessings != null && oppPaymentProcessings.size()>0){
					onePaymentProcessing = oppPaymentProcessings[0];
				}			 								 						  
			}
			
			if(oneOppLineItem != null && onePaymentProcessing != null){
				oneOppLineItem.Payment_Processing__c = onePaymentProcessing.Id;
				update oneOppLineItem;
				createPaymentEntriesforOpportunityLineItemSchedules(oneOppLineItem, onePaymentProcessing);
			}			
		}
	}
	
	//Create Payment Entries for Opportunity Line Item Schedules
    private static void createPaymentEntriesforOpportunityLineItemSchedules(OpportunityLineItem oneOppLineItem, Payment_Processing__c onePaymentProcessing){
		//Opportunity Payment Entries that needs to be inserted
        Map<Date, Payment_Entries__c> mapOppPaymentEntries = new Map<Date, Payment_Entries__c>();    																   	
    	Date minDate;
    	//If Logged in User is not same as Gannet Local User
		if (UserInfo.GetUserId() != Constants.GANNETT_LOCAL_USER.Id 
			&& oneOppLineItem != null && onePaymentProcessing != null){
				
			 List<OpportunityLineItemSchedule> listOppLineItemSchedules
			 						 = [SELECT Id, ScheduleDate, Revenue, OpportunityLineItemId 
 										 FROM OpportunityLineItemSchedule
 									   	 WHERE OpportunityLineItemId in (Select Id from OpportunityLineItem 
 										 		Where OpportunityId =: oneOppLineItem.OpportunityId)
 										 ORDER BY ScheduleDate];
 										 								
			 for(OpportunityLineItemSchedule oneOppLineItemSchedule : listOppLineItemSchedules){
		 		Payment_Entries__c newPaymentEntry = mapOppPaymentEntries.get(oneOppLineItemSchedule.ScheduleDate);
				if(newPaymentEntry == null){
					newPaymentEntry = new Payment_Entries__c();
			 		newPaymentEntry.CC__c = onePaymentProcessing.Id;
			 		newPaymentEntry.Name = onePaymentProcessing.Name + '-' + mapOppPaymentEntries.size();
			 		newPaymentEntry.Date__c = oneOppLineItemSchedule.ScheduleDate; 
			 		newPaymentEntry.Amount__c = oneOppLineItemSchedule.Revenue;
			 		newPaymentEntry.Custom_Set__c = true;
			 		newPaymentEntry.Processor__c = Constants.SALESFORCE_ADMINISTRATION.Id;
			 		newPaymentEntry.System_Set__c = false;
			 		newPaymentEntry.KPI_Calender__c = Constants.KPI_CAL_20111226.Id;
			 		if(minDate!=null && minDate > oneOppLineItemSchedule.ScheduleDate){
			 			minDate = oneOppLineItemSchedule.ScheduleDate;
			 		}else if(minDate==null){
			 			minDate = oneOppLineItemSchedule.ScheduleDate;
			 		}
			 		mapOppPaymentEntries.put(oneOppLineItemSchedule.ScheduleDate, newPaymentEntry);	
				}else{
					newPaymentEntry.Amount__c = newPaymentEntry.Amount__c + oneOppLineItemSchedule.Revenue;
				}
			 }
		
		
		 	System.debug('mapOppPaymentEntries >> ' + mapOppPaymentEntries) ;
			List<Payment_Entries__c> deletePaymentEntries = [Select Id from Payment_Entries__c
																where CC__c in (Select Id from Payment_Processing__c 
																	where Opportunity__c =: oneOppLineItem.OpportunityId)
																and Completed__c = false and Declined__c = false];
            if(deletePaymentEntries.size()>0){
            	delete deletePaymentEntries;
            }
	            
	        if(mapOppPaymentEntries.size() >0){
			    //The very first item in the map will have book amont because the map is sorted by ScheduleDate in SOQL
	            Payment_Entries__c firstPaymentEntry = mapOppPaymentEntries.get(minDate);
	            firstPaymentEntry.Book_Amount__c = firstPaymentEntry.Amount__c;
	            insert mapOppPaymentEntries.Values();
			}
		}
    }
}