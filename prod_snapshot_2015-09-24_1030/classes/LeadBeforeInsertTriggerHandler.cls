/*
  Created By  : Praneeth
  Modified By : Vijay Varada modified on 04/17/2015 fix for DEV-2127
*/
public class LeadBeforeInsertTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {

		this.LeadsOwnedBySalesRep(tp.newList);
	}


	// Validating  the Counts of SML Leads Owned By SalesRep  
	private void LeadsOwnedBySalesRep(List < Lead > newLeadList) {
		System.debug('@@@@inLEADSOWNED' + newLeadList.size());
		Id SMLLEAdRecTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('SML Lead').getRecordTypeId();
		map < id, list < lead >> userWithLeadMap = new map < id, list < lead >> ();
		map < id, integer > numberofLeadsOwned = new map < id, integer > ();
		map < id, integer > numberofLeadsOwning = new map < id, integer > ();
		set < id > newleadownerids = new set < id > ();
		for (Lead leadRecord: newLeadList) {
			string LeadOwnerid = (string) leadRecord.Ownerid;
			if (LeadOwnerid.contains('005')) {
				newleadownerids.add(LeadOwnerid);
				if (leadRecord.RecordTypeid == SMLLEAdRecTypeId && leadRecord.isconverted == false) {
					if (userWithLeadMap.containsKey(leadRecord.OwnerId)) {
						userWithLeadMap.get(leadRecord.Ownerid).add(leadRecord);
					} else {
						userWithLeadMap.put(leadRecord.Ownerid,new list<lead>{leadRecord});
					}
				}
			}
		} //End of FOR loop

		map < id, user > userMap = new map < id, User > ([SELECT id, name, userRole.name FROM USER WHERE id IN: newleadownerids AND userRoleid != null]);
		
		//DEV-2127 Remove GO Digital Data System profile users from the map
		map<Id, User> mapGoDigitalProfileUsers = new Map<Id, User>([Select Id, Name from User 
																		Where Id IN: userWithLeadMap.keySet()  
													 					AND ProfileId =: ProfileCache.getProfile('GO Digital Data System').Id]);
		for(Id oneUserId : mapGoDigitalProfileUsers.Keyset()){
			userWithLeadMap.remove(oneUserId); //Removing GCI Profile Users So, It doesnot go into Aggregate Query
		}
		System.debug('Leads Count by Users : Aggregate Rusult for the users List >> ' + userWithLeadMap);
		//DEV-2127 Remove GO Digital Data System profile users from the map
		
		AggregateResult[] leadAggList = [SELECT ownerid, count(id) total FROM Lead WHERE isconverted = false
												AND RecordTypeid = : SMLLEAdRecTypeId
												AND ownerid IN: userWithLeadMap.keySet()
												AND owner.name Not In('Open ACq Leads')	Group By Ownerid];
		system.debug('leadAggList =============' + leadAggList);
		for (AggregateResult LeadAgr: leadAggList) {
			id uid = (id) LeadAgr.get('ownerid');
			System.debug('id@#$%' + uid);
			Integer totalCount = (Integer) LeadAgr.get('total'); // getting the count of already owned SML Leads
			System.debug('count@#$%' + totalCount);
			Integer LeadsOwned;

			if (userWithLeadMap.containsKey(uid)) {
				leadsOwned = totalCount + userWithLeadMap.get(uid).size(); // Getting the count of trying to own SML leads Including the existing SML Lead counts
				System.debug('###leadsowned123' + leadsOwned);
			}
			numberofLeadsOwning.put(uid, totalCount);
			numberofLeadsOwned.put(uid, leadsOwned);
			newleadownerids.remove(uid);
		} //End of FOR loop of AggregateResult

		if (!newleadownerids.isempty()) {
			for (id leadownerid: userWithLeadMap.keyset()) {
				if (userMap.containsKey(leadownerid)) {
					Integer totalCount = 0;
					Integer LeadsOwned;
					user u = userMap.get(leadownerid);
					if (userWithLeadMap.containsKey(u.id)) {
						leadsOwned = totalCount + userWithLeadMap.get(leadownerid).size(); // Getting the count of trying to own SML leads Including the existing SML Lead counts
						System.debug('###leadsowned1234' + leadsOwned);
					}
					numberofLeadsOwning.put(u.id, totalCount);
					numberofLeadsOwned.put(u.id, leadsOwned);
				}
			}
		}
		for (lead leadRec: newLeadList) {
			string leadOwner = (string) leadRec.ownerid;
			if (leadOwner.contains('005') && userMap.containsKey(leadRec.ownerid)) {
				User u1 = userMap.get(leadRec.ownerId);
				System.debug('@@@userrole@@2' + u1.userrole.name);
				if (numberofLeadsOwned.containsKey(leadRec.ownerid)) {

					// Validate the max lead count for Sales Rep  
					if( (u1.userrole.name.startsWith('RAE') ||  u1.userrole.name.startsWith('Acquisition') || u1.userrole.name.startsWith('National') )
		                   &&(!(u1.userrole.name.contains('Mgr') || u1.userrole.name.contains('Manager') || u1.userrole.name.contains('Director')))
		                   &&  numberofLeadsOwned.get(leadRec.ownerid)>300){
               			System.debug('@@numberleadsOwned@2' + numberofLeadsOwned.get(leadRec.ownerid));
						leadrec.addError('The User you have assigned this Lead currently has ' + numberofLeadsOwning.get(leadRec.ownerid) + ' Leads.This will exceed the maximum limit of 300 Leads in their ownership. Please have the User assign Leads to Open Acquisitions or contact your manager for assistance.');
					}

					//// Validate the max lead count for Sales Analyst Role Users
					if (u1.userrole.name == 'Sales Analyst' && numberofLeadsOwned.get(leadRec.ownerid) > 250) {
						leadrec.addError('The User you have assigned this Lead currently has ' + numberofLeadsOwning.get(leadRec.ownerid) + ' Leads.This will exceed the maximum limit of 250 Leads in their ownership. Please have the User assign Leads to Open Acquisitions or contact your manager for assistance.');

					}
				}

			}
		} //End of Lead FOR loop

	} //End of Method LeadsOwnedBySalesRep   
}