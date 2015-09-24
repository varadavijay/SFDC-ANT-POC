//12/05/2014
/*Purpose of this Trigger is: -
1) Create Campaign Member
2) Populate Campaign Member Field*/

trigger trgContactCampaignMember on Contact(after insert, after Update) {
    
    List<ID> promotionCampIDs = new List<ID>();
    Map<ID,List<CampaignMember>> contactWithCampMember = new Map<ID,List<CampaignMember>>();
    Map<ID,ID> contactWithTargetCampaign = new Map<ID,ID>();
    Map<ID,ID> contactWithPromotionCampaign = new Map<ID,ID>();
    
    //Get the Qualified Contacts
    for(Contact con : [SELECT id,Promotion_Source__c,Target_Campaign__c,(Select id,Promotion_Source__c,Campaignid from CampaignMembers) FROM Contact WHERE Id IN : Trigger.new]){
        if(con.Target_Campaign__c != null ){
            if(con.Promotion_Source__c != null)
            {
                promotionCampIDs.add(con.Promotion_Source__c);
                contactWithPromotionCampaign.put(con.id,con.Promotion_Source__c);                
            }
            contactWithCampMember.put(con.id,new List<CampaignMember>());
            contactWithTargetCampaign.put(con.id,con.Target_Campaign__c);
            if(con.CampaignMembers.size()>0){
                for(CampaignMember cm : con.CampaignMembers){
                    if(con.Target_Campaign__c == cm.Campaignid){
                        System.debug('_______Filter_Passed_____'+con);
                        contactWithCampMember.get(con.id).add(cm); 
                    }
                }
           }
        } 
    }
    System.debug('_____contactWithCampMember_____'+contactWithCampMember);
    
    Map<ID,Campaign> promotionCampMap = new Map<ID,Campaign>();
    if(!promotionCampIDs.isEmpty()){
        for(Campaign camp : [SELECT id,name FROM Campaign WHERE id IN : promotionCampIDs]){
            promotionCampMap.put(camp.id,camp);
        }
    }
    system.debug('______promotionCampMap_________'+promotionCampMap);
    
    List<CampaignMember> newCampMemberList = new List<CampaignMember>();
    List<CampaignMember> campMemberToBeUpdated = new List<CampaignMember>();
    
    if(!contactWithCampMember.isEmpty()){
        for(ID Contactid : contactWithCampMember.keyset()){
            //If Campaign Member Exists
            if(!contactWithCampMember.get(Contactid).isEmpty()){
                System.debug('_____Campaign_Member_Exists_____');
                CampaignMember campMember = contactWithCampMember.get(Contactid)[0];
                if(campMember.Promotion_Source__c == '' || campMember.Promotion_Source__c == null){
                    Campaign campDetail = promotionCampMap.get(contactWithPromotionCampaign.get(Contactid));
                    system.debug('_____campDetail___'+campDetail );
                    if(campDetail != null){
                        campMember.Promotion_Source__c = campDetail.Name;
                        campMemberToBeUpdated.add(campMember);
                    } 
                }
            }
            //If Campaign Member does not Exist, then Insert new
            else{
                System.debug('_____Campaign_Member_needs_to_be_Created___');
                ID campID = contactWithTargetCampaign.get(Contactid);//Target Campaign Id
                Campaign campDetail = promotionCampMap.get(contactWithPromotionCampaign.get(Contactid));//Promotion Campaign Id
                System.debug('_____campDetail ______'+campDetail );
                if(campDetail != null){
                    newCampMemberList.add(new CampaignMember(Campaignid=campID,Contactid=Contactid,Promotion_Source__c=campDetail.Name));
                }
                else
                {
                    newCampMemberList.add(new CampaignMember(Campaignid=campID,Contactid=Contactid));
                }
            }
        }
    }
    System.debug('_____newCampMemberList_____'+newCampMemberList);
    System.debug('_____campMemberToBeUpdated_____'+campMemberToBeUpdated);
    
    //Insert New Campaign Member
    if(!newCampMemberList.isEmpty()){
        insert newCampMemberList;
    }
    System.debug('____Inserted_Campaign_Member_____'+newCampMemberList);
    //Update Campaign Members
    if(!campMemberToBeUpdated.isEmpty()){
        update campMemberToBeUpdated;
    }
    System.debug('____Updated_campaignMember_____'+campMemberToBeUpdated);
}