trigger afteronCase_trigger on Case (after delete, after insert, after undelete, after update){
    if(Trigger.isUpdate)
    {
        for(integer x = 0; x < Trigger.new.size(); x++)
        {
            if(     (Trigger.new[x].Opportunity__c != Null)
                &&  (Trigger.new[x].Opportunity__c != Trigger.old[x].Opportunity__c)
                &&  (   Trigger.new[x].Notify_Email_1__c != Null
                     || Trigger.new[x].Notify_Email_2__c != Null
                     || Trigger.new[x].Notify_Email_3__c != Null))
            {
                List <Opportunity> ClientOpp = [SELECT Id, Notify_Email_1__c, Notify_Email_2__c, Notify_Email_3__c
                                                FROM Opportunity
                                                WHERE Id = :Trigger.new[x].Opportunity__c];
                                                
                for(Opportunity tempOpp : ClientOpp){
                    if(tempOpp.Notify_Email_1__c == Null && Trigger.new[x].Notify_Email_1__c != Null)
                    {
                        tempOpp.Notify_Email_1__c = Trigger.new[x].Notify_Email_1__c;
                    }
                    if(tempOpp.Notify_Email_2__c == Null && Trigger.new[x].Notify_Email_2__c != Null)
                    {
                        tempOpp.Notify_Email_2__c = Trigger.new[x].Notify_Email_2__c;
                    }
                    if(tempOpp.Notify_Email_3__c == Null && Trigger.new[x].Notify_Email_3__c != Null)
                    {
                        tempOpp.Notify_Email_3__c = Trigger.new[x].Notify_Email_3__c;
                    }
                    update tempOpp;
                }
            }
        }
    }// isUpdate
    if(Trigger.isInsert)
    {
        for(integer x = 0; x < Trigger.new.size(); x++){
            String ThisCaseId = Trigger.new[x].Id;
            String AuditMedProp = Trigger.new[x].Media_Partner__c;
            String AfflRepName;
            
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Digital_Audit').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT  Id, Email, FirstName, LastName 
                                FROM Contact
                                WHERE (RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                        AND AccountId = :AuditMedProp
                                        AND Auto_Email_Digital_Audit_Submit__c = True
                                        AND Email != Null)
                                    OR Id = :Trigger.new[x].Affl_Sales_Rep__c
                                limit 8];
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Audit Request - Manager Notification');
                        mail.setTemplateId('00XF0000001Q4TM');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            }// GL_Digital_Audit
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Care_Request').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT  Id, Email, FirstName, LastName
                                FROM Contact
                                WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                AND AccountId = :AuditMedProp
                                AND Auto_Email_Care_Request_Submit__c = True
                                AND Email != Null
                                limit 8];
                                
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();                
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Care Request - Manager Notification');
                        mail.setTemplateId('00XF0000001QGK2');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            }// GL_Care_Request
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Rate_Request').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT  Id, Email, FirstName, LastName
                                FROM Contact
                                WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                AND AccountId = :AuditMedProp
                                AND Auto_Email_Rate_Request_Submittal__c = True
                                AND Email != Null
                                limit 8];
                                
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();                
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Rate Request - Manager Notification');
                        mail.setTemplateId('00XF0000001QGue');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            }//GL_Rate_Request
            
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Email_Count').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT Id, Email, FirstName, LastName 
                                FROM Contact
                                WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                AND AccountId = :AuditMedProp
                                AND Auto_Email_Email_Count_Req__c = True
                                AND Email != Null
                                limit 8];
                
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Email Count Request - Manager Notification');
                        mail.setTemplateId('00XF0000001QmPH');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            }// GL_Email_Count
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Website_Audit').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT  Id, Email, FirstName, LastName
                                FROM Contact
                                WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                AND AccountId = :AuditMedProp
                                AND Auto_Email_Website_Audit_Req__c = True
                                AND Email != Null
                                limit 8];
                
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();                
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Website Audit Request - Manager Notification');
                        mail.setTemplateId('00XF0000001QmPM');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            } // GL_Website_Audit
            if(Trigger.new[x].RecordTypeId == RecordTypeCache.getRecordType('Case', 'GL_Call_Request').Id)
            {
                List<Contact> cListToEmail = new List<Contact>();
                cListToEmail = [SELECT  Id, Email, FirstName, LastName
                                FROM Contact
                                WHERE RecordTypeId = :RecordTypeCache.getRecordType('Contact', 'Affiliated').Id
                                AND AccountId = :AuditMedProp
                                AND Auto_Email_Call_Request__c = True
                                AND Email != Null
                                limit 8];
                
                List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();
                for(Contact tempEmail : cListToEmail)
                {
                    if(tempEmail.Id != Trigger.new[x].Affl_Sales_Rep__c)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(tempEmail.Id);
                        mail.setReplyTo('answers@godigitalmarketing.com');
                        mail.setSenderDisplayName('GL Sales Call Request - Manager Notification');
                        mail.setTemplateId('00XF0000001QmPR');
                        mail.setSaveAsActivity(False);
                        mail.setWhatId(ThisCaseId);
                        emailNotifications.add(mail);
                    }
                }
                if(emailNotifications.size()>0){
                	Messaging.sendEmail(emailNotifications);
                }
            }// GL_Call_Request
        }// beforeInsert Trigger loop
    } // isInsert

}