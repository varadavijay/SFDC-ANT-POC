/**
After the Update of the Project object, if the Status of the Project has been updated or the Delayed nofitication has been checked.
Generates an Email to notify Users that have opted in of the change to to the project
--4/25/14-- SR
trigger updated to include G/O Assist Rep on CC Line of Email.
Code Cleaned up to be easier to read and removed unused commented out sections
--5/15/2014 PP: Bug fixed DE310: Error trying to modify project field: Send Delayed Notice
**/
trigger afterUpdateOnProject_tr on Project__c (after update) 
{
    if(!Validator_afteronProject_cls.hasAlreadyDone())
    {
    Validator_afteronProject_cls.setAlreadyDone();
    
    Set<Id> opportunityIds = new Set<Id>();
    Set<Id> oliIds = new Set<Id>();
    Set<Id> groupId = new Set<Id>();
    for (Project__c proj :Trigger.new){
         opportunityIds.add(proj.Opportunity__c);
         oliIds.add(proj.Product_Id__c);
    }

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    List<Opportunity> allOpportunities = [Select Id, Media_Partner__r.Partner_Type__c,RecordTypeId from Opportunity Where  Id IN :opportunityIds and RecordType.name IN ('SML Opportunity','Digital Fulfillment') ];
    System.debug(':::all::' + allOpportunities);
    Map<Id, Opportunity> mapOpportunities =   new Map<Id, Opportunity>(allOpportunities);
    Map<Id, String> mapProjOLIs = new Map<Id, String>();
    Map<Id, Boolean> mapProjOpps = new Map<Id, Boolean>();

    for (Opportunity oneOpp:[Select id,Opportunity_IsReplicated__c
    	                                    from Opportunity
    	                             where Id IN :opportunityIds]){
    	mapProjOpps.put(oneOpp.Id,oneOpp.Opportunity_IsReplicated__c);
    }
    /* Commenting as part of DEV-2914
    for (OpportunityLineItem oneOLI:[Select id,ReplicationOLI_TargetID__c,Project__c 
    	                                    from OpportunityLineItem
    	                             where Id IN :oliIds]){
    	mapProjOLIs.put(oneOLI.Project__c,oneOLI.ReplicationOLI_TargetID__c);
    }*/

   
    
    List<Group> g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Clipper Email Notification Group'];  
    if(g != null && g.size()>0){
       for (GroupMember gm : g[0].groupMembers) {
         groupId.add(gm.userOrGroupId);
       }  
    }   
    User[] users;
    if(groupId != null){
       users = [SELECT email FROM user WHERE id IN :groupId];     
    }     
    for(Integer x = 0; x<Trigger.new.size(); x++){
        //Non-Waiting - Status Notifications To Channel
        if((Trigger.new[x].Project_Status__c != Trigger.old[x].Project_Status__c)
            && Trigger.new[x].Project_Status__c != Null
            && Trigger.new[x].Project_Status__c != 'Waiting On Client Resource'
            && Trigger.new[x].Project_Status__c != 'Waiting On Client Approval'
            && Trigger.new[x].Project_Status__c != 'Awaiting Onboard'
            && Trigger.new[x].Project_Status__c != 'Closed Won'
            && (Trigger.new[x].Project_Status__c != 'Pending' || (Trigger.new[x].Project_Status__c == 'Pending' && Trigger.new[x].Product_Name__c == 'Email Blast')
               )
            && mapProjOpps.get(Trigger.new[x].Opportunity__c) == false 
            //&& (mapProjOLIs.get(Trigger.new[x].Id) == null || mapProjOLIs.get(Trigger.new[x].Id) == '')
           

           )
        {
            system.debug(':::::::::: Entered here');
            String oppId= Trigger.new[x].Opportunity__c;
            String EmailOne;
            String EmailTwo;
            String[] toAddresses = new String[]{};
            String[] ccAddresses = new String[] {};
            if(Trigger.new[x].Affl_Sales_Rep__c != Null){
                EmailOne = Trigger.new[x].Affl_Sales_Rep_Email__c;
            }
            else{
                EmailOne = Trigger.new[x].Opp_Owner_Email__c;
            }
            toAddresses.add(EmailOne);
            
            if(Trigger.new[x].DigAM_Email__c != Null){
                EmailTwo = Trigger.new[x].DigAM_Email__c;
                toAddresses.add(EmailTwo);
            }
                    //If G/O Assiting Rep #1 or #2 have a value, Add the email for that rep to the CC line of the email
                    if(Trigger.new[x].GO_Assisting_Rep_Email__c != Null)
                    {
                        ccAddresses.add(Trigger.new[x].GO_Assisting_Rep_Email__c);
                    }
                    if(Trigger.new[x].GO_Asst_Rep_2_Email__c != Null)
                    {
                        ccAddresses.add(Trigger.new[x].GO_Asst_Rep_2_Email__c);
                    }
                    
                 
                     if(Trigger.new[x].Project_Status__c == 'Live' || Trigger.new[x].Project_Status__c == 'Cancelled'){
                        Opportunity allOpps = mapOpportunities.get(oppId);
                        if(allopps!=null && allopps.Media_Partner__r.Partner_Type__c == 'CLP'){
                          for(User u : users) {
                              if(u.email != null)
                                 ccAddresses.add(u.email);
                           }
                         }    
                     }
            system.debug(':::::::::: After update user email address:'+ccAddresses);
            
            String MedPropToEmail = Trigger.new[x].Media_Partner__c;
            String ProjectStatus = Trigger.new[x].Project_Status__c;
            String ThisProjectId = Trigger.new[x].Id;
            String ThisDigAMEmail;
            String ThisProduct = Trigger.new[x].Product_Name__c;
            
            if(Trigger.new[x].Digital_Account_Manager__c != Null){
                ThisDigAMEmail = Trigger.new[x].DigAM_Email__c;
            }
            else{
                ThisDigAMEmail = 'GODigitalCRMTeam-SnR@gannett.com';
            }
            String DateToPrint = Trigger.new[x].Waiting_Since_Date__c.format();
            String CommentToAdd;
            if(Trigger.new[x].Waiting_Status_Descr_Last_Set__c != Null){
                CommentToAdd = Trigger.new[x].Waiting_Status_Descr_Last_Set__c;
            }
            else{
                CommentToAdd = 'No Notes';
            }
            List<Contact> cListToEmail = new List<Contact>();
            cListToEmail = [SELECT  Id, 
                                    Email,
                                    FirstName,
                                    LastName,
                                    Status_Alert_Options__c
                            FROM Contact
                            WHERE RecordTypeId = '012F0000000y9gD'
                            AND AccountId = :MedPropToEmail
                            AND Email != Null
                            AND Status_Alert_Options__c != Null];

			for(Contact tempEmail : cListToEmail){
				if(tempEmail.Status_Alert_Options__c.contains(ProjectStatus)){
					ccAddresses.add(tempEmail.Email);
				}
			}
			
			String CancelCat = '<br/>';
			String CancelReason = '<br/>';
			if(Trigger.new[x].Cancellation_Category__c != Null){
				CancelCat = 'Cancel Type - ' + Trigger.new[x].Cancellation_Category__c + '<br/>';
				CancelReason = 'Cancel Reason - ' + Trigger.new[x].Cancellation_Reason__c + '<br/>';
			}
			else{
				CancelCat = '';
				CancelReason = '';
			}
			String StatusDisplay = Trigger.new[x].Status_For_Display__c;
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setHtmlBody('<br/>'
			+ Trigger.new[x].Affl_Sales_Rep_First__c
			+ ', <br/><br/> This email is to alert you that the G/O Digital product<br/><br/><strong>'
			+ Trigger.new[x].Product_Name__c + '</strong><br/><br/> is <br/><br/><strong>'
			+ StatusDisplay	+ '<br/>' + CancelCat  + CancelReason
			+ 'Notes: ' + CommentToAdd
			+ '<br/></strong><br/><br/> as of <br/><br/><strong>' + DateToPrint
			+ '</strong><br/><br/>If you have any questions regarding this project please contact your G/O Digital Account Manager, noted below.<br/>'
			+ '<br/>Opportunity : <strong>' + Trigger.new[x].Opp_Name__c
			+ '</strong><br/>Project : <strong>' + Trigger.new[x].Product_Name__c
			+ '</strong><br/>Sold Date : <strong>' + Trigger.new[x].Sold_Date__c
			+ '</strong><br/>Sales Rep : <strong>' + Trigger.new[x].Affl_Sales_Rep_Full__c
			+ '</strong><br/>Customer : <strong>' + Trigger.new[x].Project_Account__c
			+ '</strong><br/>Digital AM : <strong>' + Trigger.new[x].DigAM_Full__c
			+ '</strong><br/>Media Partner : <strong>' + Trigger.new[x].Media_Partner_Name__c
			+ '</strong><br/><br/>Thank You,<br/><br/>Your G/O Digital Team<br/><br/><br/>Project Id - <strong>'
			+ Trigger.new[x].Project_Id__c + '</strong><br/>');
			
			mail.setToAddresses(toAddresses);
			mail.setCcAddresses(ccAddresses);
			mail.setReplyTo(ThisDigAMEmail);
			mail.setOrgWideEmailAddressId('0D2F00000004DSL');
			mail.setSaveAsActivity(True);
			mail.setWhatId(ThisProjectId);
			mail.setSubject('Project Status Update - ' + Trigger.new[x].Product_Name__c + ' - ' + ProjectStatus);
			
                       emails.add(mail);
			
		}
		//Waiting Status Notifications
		if((Trigger.new[x].Send_Delayed_Notice__c == 'Notice 0'
			|| Trigger.new[x].Send_Delayed_Notice__c == 'Notice 1'
		 	|| Trigger.new[x].Send_Delayed_Notice__c == 'Notice 2'
		 	|| Trigger.new[x].Send_Delayed_Notice__c == 'Notice 3'
		 	|| Trigger.new[x].Send_Delayed_Notice__c == 'Notice 4'
		 	|| Trigger.new[x].Send_Delayed_Notice__c == 'Notice 5'
		   	)
		   	&& Trigger.new[x].Affl_Sales_Rep_Email__c != Null
		   	&& Trigger.new[x].Send_Delayed_Notice__c != Trigger.old[x].Send_Delayed_Notice__c
		        && mapProjOpps.get(Trigger.new[x].Opportunity__c) == false 
		       //&& (mapProjOLIs.get(Trigger.new[x].Id) == null || mapProjOLIs.get(Trigger.new[x].Id) == '')
		   	)
		{
			String EmailOne = Trigger.new[x].Affl_Sales_Rep_Email__c;
			String EmailTwo = Trigger.new[x].DigAM_Email__c;
			String[] toAddresses = new String[] {EmailOne};
			toAddresses.add(EmailTwo);
			String[] ccAddresses = new String[] {};
			String MedPropToEmail = Trigger.new[x].Media_Partner__c;
			String ProjectStatus = Trigger.new[x].Project_Status__c;
			String ThisProjectId = Trigger.new[x].Id;
			String ThisDigAMEmail = Trigger.new[x].DigAM_Email__c;
			String StatusNotes = '<br/>Notes:' + Trigger.new[x].Waiting_Status_Descr_Last_Set__c;
			if(Trigger.new[x].Waiting_Status_Descr_Last_Set__c == Null){
				StatusNotes = 'Notes:';
			}
			String DateToPrint = Trigger.new[x].Waiting_Since_Date__c.format();
			List<Contact> cListToEmail = new List<Contact>();
			cListToEmail = [SELECT Id, Email, FirstName, LastName, Status_Alert_Options__c
							FROM Contact
							WHERE RecordTypeId = '012F0000000y9gD'
							AND AccountId = :MedPropToEmail
							AND Email != Null
							AND Status_Alert_Options__c != Null];

			for(Contact tempEmail : cListToEmail){
				if(tempEmail.Status_Alert_Options__c.contains(ProjectStatus)){
					ccAddresses.add(tempEmail.Email);
				}
			}
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setHtmlBody('<br/>' + Trigger.new[x].Affl_Sales_Rep_First__c
			+ ', <br/><br/> This email is to alert you that the G/O Digital product<br/><br/><strong>' + Trigger.new[x].Product_Name__c
			+ '</strong><br/><br/> is <br/><br/><strong>' + Trigger.new[x].Project_Status__c + StatusNotes
			+ '</strong><br/><br/> as of <br/><br/><strong>' + DateToPrint
			+ '</strong><br/><br/>Please note that the campaign launch date will be further delayed if there is not a response from the client.'
			+ 'Please reach out to help expedite this process.  If you have any questions regarding this project please contact your G/O Digital Account Manager, noted below.<br/>'
			+ '<br/>Opportunity : <strong>' + Trigger.new[x].Opp_Name__c
			+ '</strong><br/>Project : <strong>' + Trigger.new[x].Product_Name__c
			+ '</strong><br/>Sold Date : <strong>' + Trigger.new[x].Sold_Date__c
			+ '</strong><br/>Sales Rep : <strong>' + Trigger.new[x].Affl_Sales_Rep_Full__c
			+ '</strong><br/>Customer : <strong>' + Trigger.new[x].Project_Account__c
			+ '</strong><br/>Digital AM : <strong>' + Trigger.new[x].DigAM_Full__c
			+ '</strong><br/>Media Partner : <strong>' + Trigger.new[x].Media_Partner_Name__c
			+ '</strong><br/><br/>Thank You,<br/><br/>Your G/O Digital Team<br/><br/><br/>Project Id - <strong>' + Trigger.new[x].Project_Id__c
			+ '</strong><br/>' + Trigger.new[x].Send_Delayed_Notice__c);
			
			mail.setToAddresses(toAddresses);
			mail.setCcAddresses(ccAddresses);
			mail.setReplyTo(ThisDigAMEmail);
			mail.setOrgWideEmailAddressId('0D2F00000004DSL');
			mail.setSaveAsActivity(True);
			mail.setWhatId(ThisProjectId);
			mail.setSubject('Waiting Status - ' + Trigger.new[x].Product_Name__c);
			
                        emails.add(mail);
				
		}
	}
	
        if(emails.size() > 0 && emails != null){
	  Messaging.sendEmail(emails);
        }
}
}