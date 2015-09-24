trigger beforeonCase_trigger on Case (before delete, before insert, before update) 
{
	if(Trigger.isInsert)
	{
		for(integer x = 0; x < Trigger.new.size(); x++)
		{
			if(    Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Call_Request').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Rate_Request').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Digital_Audit').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Email_Count').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Website_Audit').Id)
			{
				
				String CarePhone = Trigger.new[x].Contact_Phone__c;
				// <not used> String AuditMedProp = Trigger.new[x].Media_Partner__c;
				String CareCompany = Trigger.new[x].Company_Name__c;
				String CareContact;
				if (Trigger.new[x].Contact_Name__c != Null)
				{
					CareContact = Trigger.new[x].Contact_Name__c;
				}
				
				//Account Variables
				String CAPhone;
				List<Lead> ClientLeadP = new List<Lead>();
				String CAId1;
				
				// The following code all depends on a phone number being passed in, if that field is null,
				// none of the code in the block would have run anyway, and it was making the SOQL queries fail
				if(CarePhone != null && CarePhone != '')
				{
					// Get matching Account info baseed on phone for SML_Company 
					List <Account> ClientAccountP = [SELECT Id, Phone
													 FROM Account
													 WHERE RecordTypeId = :RecordTypeCache.getRecordType('Account', 'SML_Company').Id
													 AND Phone = :CarePhone
													 limit 1];
													 
					if(Trigger.new[x].Digital_Lead__c == Null)
					{
						// Get matching Lead info based on Phone for Digital_Fulfillment leads
						ClientLeadP = [SELECT Id, Phone
									   FROM Lead
									   WHERE RecordTypeId = :RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id
									   AND Phone = :CarePhone
									   AND IsConverted = False
									   limit 1];
					}
					
					// <refactor> Why a for loop when the query limited to 1?
					// Associate the account found by matching the phone number to this case prior to saving
					for(Account tempAcct : ClientAccountP)
					{
						CAPhone = tempAcct.Phone;
						CAId1 = tempAcct.Id;
						if(CAPhone != null && CAPhone != '' && CarePhone == CAPhone)
						{
							Trigger.new[x].AccountId = CAId1;
						}
					}
					// <refactor> Why a for loop when the query limited to 1?
					// Associate the lead found by matching the phone number to this case prior to saving
					for(Lead tempLead : ClientLeadP)
					{
						CAPhone = tempLead.Phone;
						CAId1 = tempLead.Id;
						if(CAPhone != null && CAPhone != '' && CarePhone == CAPhone)
						{
							Trigger.new[x].Digital_Lead__c = CAId1;
						}
					}
					//Contact Variables
					if(Trigger.new[x].AccountId != Null)
					{
						String CCPhone;
						String CCId;
						String CAId2;
						List <Contact> ClientContact = [SELECT Id, AccountId, Phone
														FROM Contact
														WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'SML_Contact').Id
														AND (Phone = :CarePhone OR Name = :CareContact)
														AND AccountId != Null
														limit 1];
														
						for (Contact tempCntct : ClientContact)
						{
							CCPhone = tempCntct.Phone;
							CCId = tempCntct.Id;
							CAId2 = tempCntct.AccountId;
							if(CCPhone != null && CCPhone != '' && CarePhone == CCPhone)
							{
								Trigger.new[x].ContactId = CCId;
								if(Trigger.new[x].AccountId == Null && CAId2 != Null)
								{
									Trigger.new[x].AccountId = CAId2;
								}
							}
						}
					}// If Account != null
					else if(Trigger.new[x].AccountId == Null)
					{
						String CCPhone;
						String CCId;
						String CAId2;
						List <Contact> ClientContact = [SELECT Id, AccountId, Phone
														FROM Contact
														WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'SML_Contact').Id
														AND AccountId != Null
														AND Phone = :CarePhone
														limit 1];
														
						for (Contact tempCntct : ClientContact)
						{
							CCPhone = tempCntct.Phone;
							CCId = tempCntct.Id;
							CAId2 = tempCntct.AccountId;
							if(CCPhone != null && CCPhone != '' && CarePhone == CCPhone)
							{
								Trigger.new[x].ContactId = CCId;
								if(Trigger.new[x].AccountId == Null && CAId2 != Null)
								{
									Trigger.new[x].AccountId = CAId2;
									Trigger.new[x].ContactId = CCId;
								}
							}
						}
					} // If Account == null
				}// if phone not null
				
				 
				if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Call_Request').Id){
					Trigger.new[x].Subject = 'Call Request - ' + Trigger.new[x].Company_Name__c;
				}
				// This will never be the case, since it wasn't part of the filter on line 7
				//else if (Trigger.new[x].RecordTypeId == '012F0000000yDXz'){
				//	Trigger.new[x].Subject = 'Care Request - ' + Trigger.new[x].Company_Name__c;
				//	Trigger.new[x].Description = Trigger.new[x].GLC_Request_Reason__c;
				//}
				else if (Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Rate_Request').Id){
					Trigger.new[x].Subject = 'Rate Request - ' + Trigger.new[x].Company_Name__c;
				}
				else if (Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Email_Count').Id){
					Trigger.new[x].Subject = 'Email Count - ' + Trigger.new[x].Company_Name__c;
				}
				else if (Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Website_Audit').Id){
					Trigger.new[x].Subject = 'Website Audit - ' + Trigger.new[x].Company_Name__c;
				}
				else if (Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Digital_Audit').Id)
				{
						Trigger.new[x].Subject = 'Audit Request - ' + Trigger.new[x].Company_Name__c;
				}
			} // record type filter
			
			//OnBoard Submittals
			if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_OnBoard').Id)
			{
				String CarePhone = Trigger.new[x].Contact_Phone__c;
				String CareCompany = Trigger.new[x].Company_Name__c;
				String CareContactName = Trigger.new[x].Contact_Name__c;
				String CareAfflRep = Trigger.new[x].Affl_Sales_Rep__c;
				//Account Variables
				String CAPhone;
				String CAId1;
				
				
				// The following code all depends on a phone number being passed in, if that field is null,
				// none of the code in the block would have run anyway, and it was making the SOQL queries fail
				if(CarePhone != null && CarePhone != '')
				{
					// Get matching Account info baseed on phone for SML_Company
					List <Account> ClientAccountP = [SELECT Id,
															CF_Reporting_FName__c,
															CF_Reporting_LName__c,
															CF_Reporting_Email__c,
															CF_UserFirst__c,
															CF_UserLast__c,
															CF_UserEmail__c,
															Phone
													FROM Account
													WHERE RecordTypeId = :RecordTypeCache.getRecordType('Account', 'SML_Company').Id
													AND Phone = :CarePhone
													limit 1];
													
					// Get matching Digital_Fulfillment Lead based on phone or combination of contact name and sales rep
					List <Lead> ClientLeadP = [SELECT Id,
													  Phone,
													  Name,
													  SalesRep__c,
													  Notify_Email_1__c,
													  Notify_Email_2__c,
													  Notify_Email_3__c,
													  Notify_1__c,
													  Notify_2__c,
													  Notify_3__c
												FROM Lead
												WHERE RecordTypeId = :RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id
												AND (Phone = :CarePhone OR (Name = :CareContactName AND SalesRep__c = :CareAfflRep))
												AND IsConverted = False
												limit 1];
												
					for(Lead tempLead : ClientLeadP)
					{
						CAPhone = tempLead.Phone;
						CAId1 = tempLead.Id;
						if((CAPhone != null && CAPhone != '' && CarePhone == CAPhone) || (tempLead.Name == CareContactName && tempLead.SalesRep__c == CareAfflRep))
						{
							if(tempLead.Notify_Email_1__c == Null)
							{
								tempLead.Notify_Email_1__c = Trigger.new[x].Notify_Email_1__c;
							}
							if(tempLead.Notify_Email_2__c == Null)
							{
								tempLead.Notify_Email_2__c = Trigger.new[x].Notify_Email_2__c;
							}
							if(tempLead.Notify_Email_3__c == Null)
							{
								tempLead.Notify_Email_3__c = Trigger.new[x].Notify_Email_3__c;
							}
							Trigger.new[x].Digital_Lead__c = CAId1;
						}
						update tempLead;
					}
					if(Trigger.new[x].Digital_Lead__c == Null)
					{
						for(Account tempAcct : ClientAccountP)
						{
							CAPhone = tempAcct.Phone;
							CAId1 = tempAcct.Id;
							if(CAPhone != null && CAPhone != '' && CarePhone == CAPhone)
							{
								Trigger.new[x].AccountId = CAId1;
							}
						}
					}
				} // If Phone == null

				//CREATE ACCOUNT FOR ONBOARD ATTACHMENT IF NEEDED
				String NewAcctId;
				if (Trigger.new[x].Digital_Lead__c == Null && Trigger.new[x].AccountId == Null)
				{
					Account NewTR = new Account();
				    NewTR.RecordTypeId = RecordTypeCache.getRecordType('Account', 'OnBoarding').Id;
				    NewTR.Name = CareCompany;
				    NewTR.Phone = CarePhone;
				    NewTR.Affl_Sales_Rep__c = Trigger.new[x].Affl_Sales_Rep__c;
				    NewTR.Market_Originator__c = Trigger.new[x].Media_Partner__c;
				    NewTR.Industry_General__c = Trigger.new[x].Industry_General__c;
				    NewTR.Affiliated_Sales_Rep__c = Trigger.new[x].Affl_Sales_Rep_Text__c;
				    NewTR.CF_Reporting_FName__c = Trigger.new[x].GLO_RepDash_FName__c;
				    NewTR.CF_UserFirst__c = Trigger.new[x].GLO_RepDash_FName__c;
				    NewTR.CF_Reporting_LName__c = Trigger.new[x].GLO_RepDash_LName__c;
				    NewTR.CF_UserLast__c = Trigger.new[x].GLO_RepDash_LName__c;
				    NewTR.CF_Reporting_Email__c = Trigger.new[x].GLO_RepDash_Email__c;
				    NewTR.CF_UserEmail__c = Trigger.new[x].GLO_RepDash_Email__c;
				    NewTR.CF_Reporting_Requested__c = True;
				    insert NewTR;
				          
				    NewAcctId = NewTR.Id;
				    Trigger.new[x].AccountId = NewAcctId;
				} //If there is no lead or account
				else if (Trigger.new[x].AccountId != Null && Trigger.new[x].GLO_RepDash_FName__c != Null)
				{
					Account AcctToUpsert = [SELECT 	Id,
													Name,
													CF_Reporting_FName__c,
													CF_Reporting_LName__c,
													CF_Reporting_Email__c,
													CF_Reporting_Requested__c,
													CF_UserFirst__c,
													CF_UserLast__c,
													CF_UserEmail__c
											FROM Account
											WHERE Id = :Trigger.new[x].AccountId];
											
					AcctToUpsert.CF_Reporting_FName__c = Trigger.new[x].GLO_RepDash_FName__c;
					AcctToUpsert.CF_Reporting_LName__c = Trigger.new[x].GLO_RepDash_LName__c;
					AcctToUpsert.CF_Reporting_Email__c = Trigger.new[x].GLO_RepDash_Email__c;
					AcctToUpsert.CF_Reporting_Requested__c = True;
					AcctToUpsert.CF_UserFirst__c = Trigger.new[x].GLO_RepDash_FName__c;
					AcctToUpsert.CF_UserLast__c = Trigger.new[x].GLO_RepDash_LName__c;
					AcctToUpsert.CF_UserEmail__c = Trigger.new[x].GLO_RepDash_Email__c;
					
					update AccttoUpsert;
				} // If account and RepDash exists on current case
				Trigger.new[x].Subject = 'OnBoard - ' + Trigger.new[x].Company_Name__c;
			} // On Board submission
			if (Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Product_Enhancement').Id)
			{
				Trigger.new[x].Subject = 'Product Enhancement';
			}
		} // Trigger loop
	} // isInsert 

	if(Trigger.isUpdate)
	{
		for(integer x = 0; x < Trigger.new.size(); x++)
		{
			if(    Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Call_Request').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Rate_Request').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Care_Request').Id
				|| Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_OnBoard').Id)
			{
				// updated Owned stamp, if applicable
				// PWP 01-21-2015: only update the first time (ie when owned_Stamp == null)
				if(   Trigger.new[x].OwnerId != Trigger.old[x].OwnerId
				   && Trigger.new[x].IsClosed == False
				   && Trigger.new[x].Owned_Stamp__c == null)
				{
					Trigger.new[x].Owned_Stamp__c = datetime.now();
				}
				
				// <PWP 02-04-2015> The better way to do this would be to base the Closed_Stamp__c on the Date/Time Closed standard Field. 
				// When we refactor this trigger, we should look into that, but for now, the ease of this fix outweighs the benefit of researching all of the places that 
				// Closed_Stamp__c is used and modifying it, not to mention Code_End_Date.
				
				// Update Closed stamp if we go into one of the following statuses and we weren't already closed
				if(	Trigger.old[x].IsClosed != True
					&& (Trigger.new[x].Status == 'Resolved'
					    || Trigger.new[x].Status == 'Approved'
						|| Trigger.new[x].Status == 'Not Approved'
						|| Trigger.new[x].Status == 'Closed'
						|| Trigger.new[x].Status == 'Assigned'
						|| Trigger.new[x].Status == 'Archived'
						|| Trigger.new[x].Status == 'Not A Care Case'
						|| Trigger.new[x].Status == 'Invalid'))
				{
					Trigger.new[x].Closed_Stamp__c = datetime.now();
				}
				
				
				if(Trigger.new[x].Open_Calender_Date__c == Null)
				{
					Date OpenDate = Trigger.new[x].CreatedDate.date();
					List <KPICalender__c> OpenCalDate = [SELECT Id FROM KPICalender__c WHERE Date__c = :OpenDate limit 1];
					for(KPICalender__c tempKPICal : OpenCalDate)
					{
						Trigger.new[x].Open_Calender_Date__c = tempKPICal.Id;
					}
				}
				
				
				if	(Trigger.new[x].Close_Calender_Date__c == Null
				     && Trigger.new[x].IsClosed == True
				     ||	Trigger.old[x].IsClosed != True
					 &&	(   Trigger.new[x].Status == 'Resolved'
						 || Trigger.new[x].Status == 'Approver'
						 || Trigger.new[x].Status == 'Not Approved'
						 || Trigger.new[x].Status == 'Closed'
						 || Trigger.new[x].Status == 'Assigned'))
				{
					Date CloseDate = date.today();
					List <KPICalender__c> CloseCalDate = [SELECT Id FROM KPICalender__c WHERE Date__c = :CloseDate limit 1];
					for(KPICalender__c tempKPICal : CloseCalDate)
					{
						Trigger.new[x].Close_Calender_Date__c = tempKPICal.Id;
					}
				}
			} // RecordType filter
		} //Trigger loop
	} //if isUpdate
} //Trigger