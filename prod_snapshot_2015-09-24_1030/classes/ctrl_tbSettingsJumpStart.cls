public with sharing class ctrl_tbSettingsJumpStart {
	
	// <refactor> bring this logic into service class
	// <CC> used to grab a custom setting value, can be a property in a service class 
	
	public string endPoint {get;set;}
	public ctrl_tbSettingsJumpStart() {
		// Get endpoint
		for (tinderbox__tinderbox_Accounts__c tba : tinderbox__tinderbox_Accounts__c.getAll().values()) {
			if (tba.tinderbox__Name__c == 'JumpStart') {
				endpoint = tba.tinderbox__TB_Host_Endpoint__c;
				break;
			}	
		}
		
	}

}