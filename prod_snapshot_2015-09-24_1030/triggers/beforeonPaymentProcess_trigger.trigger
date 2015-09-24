trigger beforeonPaymentProcess_trigger on Payment_Processing__c (before delete, before insert, before update) 
{
	if(Trigger.isUpdate)
	{    	
		
	if(!ValidatorPaymentProc_Class.hasAlreadyDonePP()){
	    ValidatorPaymentProc_class.setAlreadyDone();
		for(integer x = 0; x < Trigger.new.size(); x++)
		{
			if(Trigger.new[x].Cycles__c == null){Trigger.new[x].Cycles__c = '0';}
			String PPName = Trigger.new[x].Name;
			String PPId = Trigger.new[x].Id;
			Date PPFirstDay = Trigger.new[x].First_Charge_Day__c;
			String PPCycleType = Trigger.new[x].Entry_Cycle__c;
			Integer PPCycleNum = integer.valueOf(Trigger.new[x].Cycles__c);
			Boolean PPResetEntries = Trigger.new[x].Reset_Entries__c;
			String PPProcessor = Trigger.new[x].Entry_Processor__c;
			Date PPLastDay = Trigger.new[x].End_Date__c;
			
			if(PPResetEntries == True)
			{
				Integer RecToDelete = [SELECT count() from Payment_Entries__c WHERE CC__c = :PPId];
				if(RecToDelete >0){
					List<Payment_Entries__c>  DeletePPEntries = [SELECT Id FROM Payment_Entries__c where CC__c = :PPId AND Completed__c = False];
					delete DeletePPEntries;
				}
			}
			
			if(PPFirstDay != null && PPCycleType != null && PPCycleNum >= 1 && PPLastDay == null && PPResetEntries == True)
			{
				List<Payment_Entries__c> NewPayEntries = new List<Payment_Entries__c>();
				Date PayDates;
				Date SatDate;
				Date SunDate;
				Integer ModOfDatesSat;
				Integer ModOfDatesSun;
				Integer SatBetween;
				Integer SunBetween;
				
				for (Integer i = 0; i < PPCycleNum; i++)
				{
					
					if(PPCycleType == 'Weekly')
					{
						PayDates = PPFirstDay.addDays(i*7);
					}
					else if (PPCycleType == 'Monthly')
					{
						PayDates = PPFirstDay.addMonths(i);
					}
					else if (PPCycleType == 'Bi-Weekly')
					{
						PayDates = PPFirstDay.addDays(i*14);
					}
					else{}
					
					SatDate = date.valueOf('2000-01-01 12:00:00');
					SunDate = date.valueOf('2000-01-02 12:00:00');
					
					SatBetween = -1 * (PayDates.daysBetween(SatDate));
					SunBetween = -1 * (PayDates.daysBetween(SunDate));
					
					ModOfDatesSat = math.mod(SatBetween,7);
					ModOfDatesSun = math.mod(SunBetween,7);
					
					if (ModOfDatesSat == 0){PayDates = PayDates - 1;}
					if (ModOfDatesSun == 0){PayDates = PayDates - 2;}
					
					Payment_Entries__c PayEntry = new Payment_Entries__c(
					CC__c = PPId,
					Name = PPName + '-' + i,
					Processor__c = PPProcessor,
					Date__c = PayDates,
					System_Set__c = True
					);
					
					NewPayEntries.add(PayEntry);
				}
				
				insert NewPayEntries;
			}
			
			else if(PPFirstDay != null && PPCycleType != null && (PPCycleNum == 0 || PPCycleNum == null) && PPLastDay != null && PPResetEntries == True)
			{
				List<Payment_Entries__c> NewPayEntries = new List<Payment_Entries__c>();
				Date PayDates = PPFirstDay;
				Date SatDate;
				Date SunDate;
				Integer ModOfDatesSat;
				Integer ModOfDatesSun;
				Integer SatBetween;
				Integer SunBetween;
				Integer i = 0;
				
				while (PayDates <= PPLastDay)
				{
					
					if(PPCycleType == 'Weekly')
					{
						PayDates = PPFirstDay.addDays(i*7);
					}
					else if (PPCycleType == 'Monthly')
					{
						PayDates = PPFirstDay.addMonths(i);
					}
					else if (PPCycleType == 'Bi-Weekly')
					{
						PayDates = PPFirstDay.addDays(i*14);
					}
					else{}
					
					SatDate = date.valueOf('2000-01-01 12:00:00');
					SunDate = date.valueOf('2000-01-02 12:00:00');
					
					SatBetween = -1 * (PayDates.daysBetween(SatDate));
					SunBetween = -1 * (PayDates.daysBetween(SunDate));
					
					ModOfDatesSat = math.mod(SatBetween,7);
					ModOfDatesSun = math.mod(SunBetween,7);
					
					if (ModOfDatesSat == 0){PayDates = PayDates - 1;}
					if (ModOfDatesSun == 0){PayDates = PayDates - 2;}
					
					Payment_Entries__c PayEntry = new Payment_Entries__c(
					CC__c = PPId,
					Name = PPName + '-' + i,
					Processor__c = PPProcessor,
					Date__c = PayDates,
					System_Set__c = True
					);
					if(PayDates <= PPLastDay)
					{
						NewPayEntries.add(PayEntry);
					}
					
					i = i + 1;
				}
				
				insert NewPayEntries;
			}			
			else{}

			Trigger.new[x].Cycles__c = null;
			Trigger.new[x].First_Charge_Day__c = null;
			Trigger.new[x].Entry_Cycle__c = null;
			Trigger.new[x].Reset_Entries__c = False;
			Trigger.new[x].Entry_Processor__c = null;
			Trigger.new[x].End_Date__c = null;
		}
	}
	}
}