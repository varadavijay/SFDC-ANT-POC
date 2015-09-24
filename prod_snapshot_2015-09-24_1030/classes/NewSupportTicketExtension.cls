public class NewSupportTicketExtension {

public String problemCat {get; set;}
public String problemSubCat {get;set;}
public Boolean addRecipient {get;set;}
public String partnerMarket {get;set;}
public Boolean isUser {get;set;}
public Boolean stopEmail {get;set;}
public String EmailAlertID {get; set;}
public String EmailTemplateID {get; set;}
public Blob screenShotFile {get;set;}
public String screenShotFilename {get;set;}
public String contentType {get; set;}
public Blob emailNotifictionFile {get;set;}
public String emailNotifictionFilename {get;set;}
public String emailBodyDescription {get;set;}
public Case supportCase {get;set;}
public User userToChange {get;set;}
public Attachment attach {get;set;}
public Blob attachmentbody{get;set;}
public String attachmentname {get;set;}
public Integer Notes_CharCount {get;set;}
        
        
        
    public NewSupportTicketExtension(ApexPages.StandardController controller) {
    
        supportCase = (Case)controller.getRecord();
        supportCase.Dev_Submitted_By__c = UserInfo.getUserID();
        supportCase.RecordTypeId = RecordTypeCache.getRecordType('Case','Support_Ticket').ID;
        Notes_CharCount = 0;
       
    }
    
    
    
    public List<SelectOption> getRoles()
    {
        List<SelectOption> roles = new List<SelectOption>();
        
        return roles;
    }
    public List<SelectOption> getMarkets()
    {
        List<SelectOption> markets = new List<SelectOption>();
        
        return markets ;
    }
    public void clearSubCat () {
        problemSubCat = null;
    }   
    
    
    
    
    // Custom Save
    public PageReference customSave()
    {   
    
    
    
    // -------------- Beginning the Save Section
    
    // --- Make sure that the Notes_CharCount is null before starting the count
        System.Debug ('Notes_CharCount should be Zero. Currently it is ' + Notes_CharCount);

        
        if (supportCase.Dev_Notes__c != null) 
        {
            Notes_CharCount = supportCase.Dev_Notes__c.length() ;
        }
    // --- Check that the Notes_CharCount now has a valid number if the field was not Null at time of submission
        System.Debug ('Notes_CharCount is now ' + Notes_CharCount);
        
        if (supportCase.Dev_Submitted_By__c == null)
        {   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please identify who is submitting this issue.'));
            return null;
        }
        else if (supportCase.Dev_Business_Unit__c == null)
        {   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please identify which business unit this issue is affecting.'));
            return null;
        }       
        else if  (problemCat == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the category of the issue you are having.'));
            return null;
        }
        else if  (problemSubCat == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the subcategory of the issue you are having.'));
            return null;
        }
        else if ( (problemCat == 'User') && (problemSubCat =='NewUser') && (supportCase.Dev_New_User_Name__c == null) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter the name of the User being added.'));
            return null;    
        }
        else if ( (problemCat == 'User') && (problemSubCat =='NewUser') && (supportCase.Dev_New_User_Manager__c == null) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter the name of the Users manager.(Role Report To.)'));
            return null;    
        }
        else if ( (problemCat == 'User') && (problemSubCat =='NewUser') && (supportCase.Dev_User_to_Mirror__c == null) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter the name of a peer of the User being added so their permissions can be mirrored.'));
            return null;    
        }
        else if ( (problemCat == 'User') && (supportCase.Dev_User_to_Change__c == null) &&  ((problemSubCat =='EditUser') || (problemSubCat =='ResetPassword') || (problemSubCat =='Deactivate') || (problemSubCat =='TinderBox') || (problemSubCat =='InsideSales') ) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter the name of the User.'));
            return null;
        }
        else if ( (problemCat == 'User') && (problemSubCat == null) )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please identify which User Access and Permissions problem you are having.'));
            return null;
        }
        else if ( Notes_CharCount > 10000 )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Notes field cannot be longer than 10,000 characters.'));
            return null;
        }
    
                
        supportCase.RecordTypeId = RecordTypeCache.getRecordType('Case','Support_Ticket').ID;       

        //If User Change Request, Get User Name
        //Validate What kind of Problem user is have
        If (supportcase.Dev_User_to_Change__c <> null)
        {
            userToChange = [Select Name from User where id = :supportcase.Dev_User_to_Change__c];
        }
        system.debug('problemCat = ' + problemCat + ' | ProbllemSubCat = ' + problemSubCat);
        //Clear Unused Fields
        //Set Hidden Values 
        if(problemCat == 'User')
        {
            supportCase.Dev_Request_Category__c = 'Support';
            supportCase.Description = null ;
            supportCase.Dev_Report_URL__c = null ;
            supportCase.Dev_DashBoard_Name__c = null ;
            supportCase.Dev_DashBoard_URL__c = null ;
            supportCase.Dev_SalesForce_URL__c = null ;
        }
        else if(problemCat == 'Reports')
        {
            supportCase.Dev_Request_Category__c = 'Support';
        }
        else if(problemCat == 'Function')
        {
            supportCase.Dev_Request_Category__c = 'Development';
        }
        else if(problemCat == 'Error')
        {
            supportCase.Dev_Request_Category__c = 'Development';
        }
        if(problemSubCat == 'NewUser')
        {
            supportCase.Subject = 'Add User - ' + supportCase.Dev_New_User_Name__c;
            
        }
        if(problemSubCat == 'EditUser')
        {

            supportCase.Subject = 'Edit User - ' + userToChange.name;
            
        }
        if(problemSubCat == 'ResetPassword')
        {

            supportCase.Subject = 'Reset Password for ' + userToChange.name;
            
        }

        else if(problemSubCat == 'TinderBox')
        {

            supportCase.Subject = 'Add ' + userToChange.name + ' to TinderBox';
            
        }
        else if(problemSubCat == 'InsideSales')
        {

            supportCase.Subject = 'Add ' + userToChange.name + ' to PowerDialer';
            
        }
        else if(problemSubCat == 'Radius')
        {

            supportCase.Subject = 'Add ' + userToChange.name  + ' to Radius';
        }
        else if(problemSubCat == 'Deactivate')
        {
            supportCase.Subject = 'Deactivate ' + userToChange.name;
            
        }
        else if(problemSubCat == 'Report')
        {
            supportCase.Subject = 'Incorrect Data in a Report';
            
           
        }
        else if(problemSubCat == 'Dashboard')
        {
            supportCase.Subject = 'Incorrect Data on a Dashboard';
            
            
        }
        else if(problemSubCat == 'Courier')
        {
            supportCase.Subject = 'Courier';
            
        }
        else if(problemSubCat == 'OtherReport')
        {
            supportCase.Subject = 'Other Report, Dashboard or Notification Issue';
            
        }
        else if(problemSubCat == 'Email')
        {
            supportCase.Subject = 'Email';
            
        }
        else if(problemSubCat == 'ChangeEmail')
        {
            supportCase.Subject = 'Update an Email Notification';
            
        }
        else if(problemSubCat == 'ChangeRequest')
        {
            
        }
        else if(problemSubCat == 'Recording')
        {
            
        }
        else if(problemSubCat == 'Reassign')
        {
            supportCase.Subject = 'Reassign';
            supportCase.Description = 'Reassign';
        }
        else if(problemSubCat == 'BulkData')
        {
            supportCase.Subject = 'BulkData';
            supportCase.Description = 'BulkData';
        }
        else if(problemSubCat == 'Permissions')
        {
            supportCase.Subject = 'Permissions';
            supportCase.Description = 'Permissions';
        }
        else if(problemSubCat == 'RecordError')
        {
            supportCase.Subject = 'RecordError';
            supportCase.Description = 'RecordError';
        }
        else if(problemSubCat == 'OtherError')
        {
        
        }
        else if(problemSubCat == 'Other')
        {
            
        }
        
        
        //Add Attachments
                
        system.debug('attachmentname = ' + attachmentname + ' AND THEN attachmentbody = ' + attachmentbody);
        
        if(attachmentname != null && attachmentname != '')
        {
            attach = new Attachment();
            attach.ContentType = contentType;
            attach.parentID = supportCase.ID;
            attach.Body = attachmentbody;
            attach.Name = attachmentname;
            insert (attach);
        }  
                
        if(screenShotFilename != null && screenShotFilename != '')
        {
            Attachment SSattach = new Attachment();
            SSattach.Body = screenShotFile;
            SSattach.Name = screenShotFilename;
            SSattach.ContentType = contentType;
            SSattach.parentID = supportCase.ID;
            insert(SSattach);
        }
         if(emailNotifictionFilename != null && emailNotifictionFilename != '')
        {
            Attachment EMattach = new Attachment();
            EMattach.Body = emailNotifictionFile;
            EMattach.Name = emailNotifictionFilename ;
            EMattach.ContentType = contentType;
            EMattach.parentID = supportCase.ID;
            insert(EMattach);
        }
       // This section specifically triggers the Assignment Rules on the Case
       // This allows for proper Case Ownership based on the Business Units specified Leads. 
                //Fetching the assignment rules on case
                AssignmentRule AR = new AssignmentRule();
                        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

                        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

                        
                        //Setting the DMLOption on Case instance
                        supportCase.setOptions(dmlOpts);
        
       //Save Record
        
        insert(supportCase);
              
        //Add Attachments
        system.debug('attachmentname = ' + attachmentname + ' AND THEN attachmentbody = ' + attachmentbody);
        if(attachmentname != null && attachmentname != '')
        {
            attach = new Attachment();
            attach.ContentType = contentType;
            attach.parentID = supportCase.ID;
            attach.Body = attachmentbody;
            attach.Name = attachmentname;
            insert (attach);
        }  
        
       //redirect to Cases Page
        return new PageReference('/'+supportCase.ID);

    }


    

}