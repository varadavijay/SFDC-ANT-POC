//12/05/2014
/*Purpose of this Trigger is: -
1) Create Campaign Member
2) Populate Campaign Member Field*/

trigger trgLeadCampaignMember on Lead (after insert, after Update) {
    
    List<ID> promotionCampIDs = new List<ID>();
    Map<ID,List<CampaignMember>> leadWithCampMember = new Map<ID,List<CampaignMember>>();
    Map<ID,ID> leadWithTargetCampaign = new Map<ID,ID>();
    Map<ID,ID> leadWithPromotionCampaign = new Map<ID,ID>();
    
    //Get the Qualified Leads
    for(Lead led : [SELECT id,Promotion_Source__c,Target_Campaign__c,(Select id,Promotion_Source__c,Campaignid from CampaignMembers) FROM Lead WHERE Id IN : Trigger.new]){
        if(led.Target_Campaign__c != null ){
            if(led.Promotion_Source__c  != null)
            {
                leadWithPromotionCampaign.put(led.id,led.Promotion_Source__c);            
                promotionCampIDs.add(led.Promotion_Source__c);
            }            
            leadWithCampMember.put(led.id,new List<CampaignMember>());
            leadWithTargetCampaign.put(led.id,led.Target_Campaign__c);

            if(led.CampaignMembers.size()>0){
                for(CampaignMember cm : led.CampaignMembers){
                    if(led.Target_Campaign__c == cm.Campaignid){
                        System.debug('_______Filter_Passed_____'+led);
                        leadWithCampMember.get(led.id).add(cm); 
                    }
                }
           }
        } 
    }
    System.debug('_____leadWithCampMember_____'+leadWithCampMember);
    
    Map<ID,Campaign> promotionCampMap = new Map<ID,Campaign>();
    if(!promotionCampIDs.isEmpty()){
        for(Campaign camp : [SELECT id,name FROM Campaign WHERE id IN : promotionCampIDs]){
            promotionCampMap.put(camp.id,camp);
        }
    }
    system.debug('______promotionCampMap_________'+promotionCampMap);
    
    List<CampaignMember> newCampMemberList = new List<CampaignMember>();
    List<CampaignMember> campMemberToBeUpdated = new List<CampaignMember>();
    
    if(!leadWithCampMember.isEmpty()){
        for(ID leadid : leadWithCampMember.keyset()){
            //If Campaign Member Exists
            if(!leadWithCampMember.get(leadid).isEmpty()){
                System.debug('_____Campaign_Member_Exists_____');
                CampaignMember campMember = leadWithCampMember.get(leadid)[0];
                if(campMember.Promotion_Source__c == '' || campMember.Promotion_Source__c == null){
                    Campaign campDetail = promotionCampMap.get(leadWithPromotionCampaign.get(leadid));
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
                ID campID = leadWithTargetCampaign.get(leadid);//Target Campaign ID
                Campaign campDetail = promotionCampMap.get(leadWithPromotionCampaign.get(leadid));//Promotion Campaign
                System.debug('_____campDetail ______'+campDetail );
                if(campDetail != null){
                    newCampMemberList.add(new CampaignMember(Campaignid=campID,Leadid=leadid,Promotion_Source__c=campDetail.Name));
                }
                else
                {
                     newCampMemberList.add(new CampaignMember(Campaignid=campID,Leadid=leadid));
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