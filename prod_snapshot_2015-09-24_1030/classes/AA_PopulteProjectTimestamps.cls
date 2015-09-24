// one-time use class to fix nulls in the Waiting Client Approval Status on a project

public with sharing class AA_PopulteProjectTimestamps {
	
	public class ProjectStatus implements Comparable {
		String statusName;
		Datetime statusIn;
		Datetime statusOut;

		public ProjectStatus(String name, Datetime timeIn, Datetime timeOut){
			this.statusName = name;
			this.statusIn = timeIn;
			this.statusOut = timeOut;
		}
		public Integer compareTo(Object objectToCompareTo){
			ProjectStatus projToCompare = (ProjectStatus)objectToCompareTo;
			if (this.statusIn == projToCompare.statusIn) return 0;
			if (this.statusIn > projToCompare.statusIn) return 1;
			return -1;
		}
		
	}
	
	public void populate(){
		Integer GAP_MINUTES = 5;
		
		// Select all in/out timestamps from Project
		List<Project__c> projects = [Select 	Id, PopulateTimestampNotes__c,
												In_Awaiting_Onboard_Stamp__c, In_Awaiting_Onboard_Out_Stamp__c, 
												In_Pending_Stamp__c, In_Pending_Out_Stamp__c,
												In_Waiting_Resource_Stamp__c, In_Waiting_Resource_Out_Stamp__c,
												In_Waiting_Approval_Stamp__c, In_Waiting_Approval_Out_Stamp__c, 
												In_Fulfillment_Stamp__c, In_Fulfillment_Out_Stamp__c, 
												Live_Date__c  
										FROM Project__c
										Where Live_Date__c > 2013-12-30T00:00:00Z
										and Live_Date__c < 2014-02-03T00:00:00Z
										and In_Waiting_Approval_Stamp__c = null
										and In_Waiting_Approval_Out_Stamp__c = null];
											
		for(Project__c project : projects){
			//Set notes to empty string to clear it out, and to not have it null the first time
			project.PopulateTimestampNotes__c = '';
			
			// put each status in a list
			List<ProjectStatus> statuses = new List<ProjectStatus>();
			addNonNullTimestamp(project, statuses, 'Awaiting Onboard', project.In_Awaiting_Onboard_Stamp__c, project.In_Awaiting_Onboard_Out_Stamp__c);
			addNonNullTimestamp(project, statuses, 'Pending', project.In_Pending_Stamp__c, project.In_Pending_Out_Stamp__c);
			addNonNullTimestamp(project, statuses, 'Waiting Resource', project.In_Waiting_Resource_Stamp__c, project.In_Waiting_Resource_Out_Stamp__c);
			addNonNullTimestamp(project, statuses, 'In Fulfillment', project.In_Fulfillment_Stamp__c, project.In_Fulfillment_Out_Stamp__c);

			//Time in and Time out are same for Live date for the purposes of this algorithm
			statuses.add(new ProjectStatus('Live', project.Live_Date__c, project.Live_Date__c));
			
			// sort the list
			statuses.sort();
			
			// Only Process if last status is 'Live', otherwise, just make a note of it and move on, don't consider gaps.
			if(statuses[statuses.size()-1].statusName == 'Live'){
				
				// inspect for a gap and assign the gap to Awaiting Cust Approv
				for(Integer i=0; i<statuses.size()-1; ++i){
					if(statuses[i].statusOut.addMinutes(GAP_MINUTES) < statuses[i+1].statusIn){
						//Gap Identified
						project.PopulateTimestampNotes__c += 'Gap between ' + statuses[i].statusName + ' and ' + statuses[i+1].statusName;
						project.PopulateTimestampNotes__c += ' - assign to Awaiting Approval';
						project.In_Waiting_Approval_Stamp__c = statuses[i].statusOut;
						project.In_Waiting_Approval_Out_Stamp__c = statuses[i+1].statusIn;
						
						//Only identify the first gap
						break;
						
					}
				}
			}
			else {
				project.PopulateTimestampNotes__c += ' | Live is NOT the last date - Skipping | ';
			}
			
		} // For each project
		
		//Update the projects
		update projects;
	}
	
	private void addNonNullTimestamp(Project__c project, List<ProjectStatus> timestamps, String statusName, DateTime timeIn, DateTime timeOut){
			if(timeIn == null){
				if(timeOut == null){
					project.PopulateTimestampNotes__c += statusName + ' skipped | ';
				}
				else{
					project.PopulateTimestampNotes__c += 'ERR: ' + statusName + ': OUT with no IN | ';
				}
			}
			else{
				if(timeOut == null){
					project.PopulateTimestampNotes__c += 'ERR: ' + statusName + ': IN with no OUT | ';
				}
				else{
					ProjectStatus status = new ProjectStatus(statusName, timeIn, timeOut);
					timestamps.add(status);
				}
				
			}
		
	}	
}