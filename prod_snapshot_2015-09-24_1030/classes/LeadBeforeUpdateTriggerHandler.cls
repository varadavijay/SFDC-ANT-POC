public without sharing class LeadBeforeUpdateTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {
		this.ValidateLeadsOwnedBySalesRep(tp.newList, (Map < Id, lead > ) tp.oldMap);
	}

	// Validating  the Counts of SML Leads Owned By SalesRep  
	private void ValidateLeadsOwnedBySalesRep(List < Lead > newLeadList, map < id, lead > oldleadmap) {
		String openACQLeadsQueueId = Constants.OPEN_ACQ_LEADS_QUEUE.Id;
		Id SMLLEAdRecTypeId = Schema.SObjectType.lead.getRecordTypeInfosByName().get('SML Lead').getRecordTypeId();
		map < id, list < lead >> userWithLeadMap = new map < id, list < lead >> ();
		set < id > newleadownerids = new set < id > ();
		map < id, integer > numberofLeadsOwned = new map < id, integer > ();
		map < id, integer > numberofLeadsOwning = new map < id, integer > ();
		for (Lead leadRecord: newLeadlist) {
			if (leadRecord.ownerid != null && (leadRecord.ownerid != oldleadmap.get(leadRecord.id).Ownerid || leadRecord.RecordTypeid != oldleadmap.get(leadRecord.id).RecordTypeid)) {

				string LeadOwnerid = (string) leadRecord.Ownerid;
				if (LeadOwnerid.contains('005')) {
					newleadownerids.add(leadRecord.Ownerid);
					if (leadRecord.RecordTypeid == SMLLEAdRecTypeId && leadRecord.isconverted == false) {
						if (userWithLeadMap.containsKey(leadRecord.Ownerid)) {
							userWithLeadMap.get(leadRecord.Ownerid).add(leadRecord);
						} //End of IF block
						else {
                            userWithLeadMap.put(leadRecord.Ownerid,new list<lead>{leadRecord});
						} //End of ELSE block
					}

				} //End of IF block
			} //End of IF block
		} //End of FOR loop 
		system.debug('userWithLeadMap======================' + userWithLeadMap);

		//Added the filter to check the user role in SOQL
		map < id, user > userMap = new map < id, User > ([SELECT id, name, userRole.name FROM USER WHERE(id IN: newleadownerids or id = : userinfo.getuserid())]);
		System.debug('@@@userMap====' + usermap);
		//DEV-2127 Remove GO Digital Data System profile users from the map
		map<Id, User> mapGoDigitalProfileUsers = new Map<Id, User>([Select Id, Name from User 
																		Where Id IN: userWithLeadMap.keySet()  
													 					AND ProfileId =: ProfileCache.getProfile('GO Digital Data System').Id]);
		for(Id oneUserId : mapGoDigitalProfileUsers.Keyset()){
			userWithLeadMap.remove(oneUserId); //Removing GCI Profile Users So, It doesnot go into Aggregate Query
		}
		System.debug('Leads Count by Users : Aggregate Rusult for the users List >> ' + userWithLeadMap);
		//DEV-2127 Remove GO Digital Data System profile users from the map
		AggregateResult[] leadAggList = [SELECT ownerid, count(id) total FROM Lead WHERE isconverted = false AND RecordTypeid = : SMLLEAdRecTypeId AND ownerid IN: userWithLeadMap.keySet() and owner.name Not In('Open ACq Leads') Group By Ownerid];
		system.debug('leadAggList =============' + leadAggList);
		for (AggregateResult LeadAgr: leadAggList) {
			id uid = (id) LeadAgr.get('ownerid');
			System.debug('id@#$%' + uid);
			Integer totalCount = (Integer) LeadAgr.get('total'); // getting the count of already owned SML Leads
			System.debug('count@#$%' + totalCount);
			Integer LeadsOwned;

			if (userWithLeadMap.containsKey(uid)) {
				leadsOwned = totalCount + userWithLeadMap.get(uid).size(); // Getting the count of trying to own SML leads Including the existing SML Lead counts
				System.debug('###leadsowned##' + leadsOwned);
			}
			numberofLeadsOwning.put(uid, totalCount);
			numberofLeadsOwned.put(uid, leadsOwned);
			newleadownerids.remove(uid);
		} //End of FOR loop of AggregateResult
		//This if for new user lead owner who don't have any existing lead



		if (!newleadownerids.isempty()) {
			for (id leadownerid: userWithLeadMap.keyset()) {
				if (userWithLeadMap.containsKey(leadownerid)) {
					Integer totalCount = 0;
					Integer LeadsOwned;
					user u = userMap.get(leadownerid);
					if (userWithLeadMap.containsKey(u.id)) {
						leadsOwned = totalCount + userWithLeadMap.get(leadownerid).size(); // Getting the count of trying to own SML leads Including the existing SML Lead counts
						System.debug('###leadsowned1234=======' + leadsOwned);
					}
					numberofLeadsOwning.put(u.id, totalCount);
					numberofLeadsOwned.put(u.id, leadsOwned);
				}
			}
		}
		system.debug('numberofLeadsOwning===========' + numberofLeadsOwning);
		system.debug('numberofLeadsOwned===========' + numberofLeadsOwned);
		for (lead leadRec: newLeadlist) {
			if (userMap.containsKey(leadRec.ownerid) && (leadRec.ownerid != oldleadmap.get(leadRec.id).Ownerid || leadRec.RecordTypeid != oldleadmap.get(leadRec.id).RecordTypeid)) {
				User u1 = userMap.get(leadRec.ownerId);


				if (numberofLeadsOwned.containsKey(leadRec.ownerid) && u1.userrole.name != NULL) {
					System.debug('###numberofleadsowned###' + numberofLeadsOwned.get(leadRec.ownerid));
					// Validate the max lead count for Sales Rep 
					if ((u1.userrole.name.startsWith('RAE') || u1.userrole.name.startsWith('Acquisition') || u1.userrole.name.startsWith('National'))
	                   &&(!(u1.userrole.name.contains('Mgr') || u1.userrole.name.contains('Manager') || u1.userrole.name.contains('Director')))
	                   &&  numberofLeadsOwned.get(leadRec.ownerid)>300){
						System.debug('@@Error::' + numberofLeadsOwned.get(leadRec.ownerid));
						leadrec.addError('The User you have assigned this Lead currently has ' + numberofLeadsOwning.get(leadRec.ownerid) + ' Leads.This will exceed the maximum limit of 300 Leads in their ownership. Please have the User assign Leads to Open Acquisitions or contact your manager for assistance.');
					}

					//Validate the max lead count for Sales Analyst Role Users
					if (u1.userrole.name == 'Sales Analyst' && numberofLeadsOwned.get(leadRec.ownerid) > 250) {
						leadrec.addError('The User you have assigned this Lead currently has ' + numberofLeadsOwning.get(leadRec.ownerid) + ' Leads.This will exceed the maximum limit of 250 Leads in their ownership. Please have the User assign Leads to Open Acquisitions or contact your manager for assistance.');

					}
				}

			}
			if (userMap.containsKey(userinfo.getuserid()) && leadRec.ownerid != oldleadmap.get(leadRec.id).Ownerid) {
				User u2 = userMap.get(userinfo.getuserid());
				if (u2.userrole.name != NULL) {
					String LeadOwnerid = (string) leadRec.Ownerid;

					//This validation rule prevents Sales Rep  from Changing the Record owner unless the record is owned by "Open Acqs".
                   if(oldleadmap.get(leadRec.id).Ownerid != openACQLeadsQueueId  && oldleadmap.get(leadRec.id).Ownerid != Userinfo.getuserid()
                      && (u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
                      || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst')
                      &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
						System.debug('@@@ErrorDebug@@' + oldleadmap.get(leadRec.id).Ownerid);

						leadrec.OwnerId.addError('You may only assign a Lead owned by you to Open Acq Leads queue or another Sales Representative. Request that the other User assign the Lead to you or Open Acq Leads or contact your manager for assistance.');
					}


					//This validates the current user of ROE stated roles from assigning leads to any other queues except Open Acq Leads Queue.
					if (LeadOwnerid.contains('00G')) {
	                    if(leadRec.Ownerid != openACQLeadsQueueId  && (oldleadmap.get(leadRec.id).Ownerid == Userinfo.getuserid() || oldleadmap.get(leadRec.id).Ownerid == openACQLeadsQueueId )
		                     && (u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
		                     || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst')
		                     &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
							leadrec.OwnerId.addError('You may only assign a Lead to the Open Acq Leads queue. Assign the Lead to Open Acq Leads queue or another Sales Representative or contact your manager for assistance.');
						}

					}
					//This validates the current user of ROE stated roles from assigning leads to any other Users except ROE stated Role users.
					if (userMap.containsKey(leadRec.Ownerid)) {
						User u3 = userMap.get(leadRec.Ownerid);
						if (LeadOwnerid.contains('005') && u3.userrole.name != NULL) {
                   			if((oldleadmap.get(leadRec.id).Ownerid == Userinfo.getuserid() || oldleadmap.get(leadRec.id).Ownerid == openACQLeadsQueueId ) 
		                        && (!(u3.userrole.name.startsWith('RAE') ||  u3.userrole.name.startsWith('Acquisition') || u3.userrole.name.startsWith('National')
			                    || u3.userrole.name.startsWith('TSE') || u3.userrole.name == 'Sales Analyst') || u3.userrole.name.contains('Mgr') 
			                    || u3.userrole.name.contains('Manager') || u3.userrole.name.contains('Director')) 
			                    && (u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
			                    || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst') 
			                    &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
								leadrec.OwnerId.addError('You may only assign a Lead to the Open Acq Leads queue. Assign the Lead to Open Acq Leads queue or another Sales Representative or contact your manager for assistance.');
							}
						}
						////This validates the current user of ROE stated roles from assigning leads to any other Userswho doesn't 
						if (LeadOwnerid.contains('005') && u3.userrole.name == NULL) {
		                    if((u2.userrole.name.startsWith('RAE') ||  u2.userrole.name.startsWith('Acquisition') || u2.userrole.name.startsWith('National')
			                     || u2.userrole.name.startsWith('TSE') || u2.userrole.name == 'Sales Analyst') 
			                     &&(!(u2.userrole.name.contains('Mgr') || u2.userrole.name.contains('Manager') || u2.userrole.name.contains('Director')))){
								leadrec.OwnerId.addError('You may only assign a Lead to the Open Acq Leads queue. Assign the Lead to Open Acq Leads queue or another Sales Representative or contact your manager for assistance.');
							}
						} //End of If Block
					} //  End of If Block  
				} //End of If Block
			} //End of If Block

		} //End of For Loop

	} //End of Method LeadOwnedBySalesRep

}