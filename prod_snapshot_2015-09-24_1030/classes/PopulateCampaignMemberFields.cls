@isTest(SeeAllData=true)
Private Class PopulateCampaignMemberFields{
    static testmethod void populateCampaignMemberTestMethod(){ 
    
        //Insert Account
        Account acc = new Account(name='testAccountG');
        insert acc;
        
        //Insert Campaign
        Campaign c1 = new Campaign(name='testCampaign');
        insert c1;
        Campaign c2 = new Campaign(name='testCampaignG');
        insert c2;
        
        //Insert Contact
        Contact con = new Contact(accountid=acc.id,lastname='testlastname',Target_Campaign__c=c1.id);
        insert con;
        
        //Insert Lead
        Lead led = new Lead(firstname='testGLead',lastname='testlastname',Company='testGCompany',Industry_AffiliatedMarkets__c='Education',Target_Campaign__c=c1.id);
        insert led;
        
        //Update Lead with Target and Promotion Id
        led.Promotion_Source__c = c2.id;
        update led;
        
        //Update Contact with Target and Promotion Id
        con.Promotion_Source__c = c2.id;
        update con;
        
        //Insert Lead with all the data
        Lead ledd = new Lead(firstname='testingLead',lastname='testingname',Company='testingCompany',Industry_AffiliatedMarkets__c='Education',Target_Campaign__c=c1.id,Promotion_Source__c=c2.id);
        insert ledd;
        //Insert Contact with all the data
        Contact cont = new Contact(accountid=acc.id,lastname='testlastname',Target_Campaign__c=c1.id,Promotion_Source__c=c2.id);
        insert cont;
    }
    
}