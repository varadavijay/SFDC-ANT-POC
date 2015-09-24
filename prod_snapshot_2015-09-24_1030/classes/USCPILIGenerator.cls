public class USCPILIGenerator extends AbstractInvoiceLineItemsClass{  
	
	//Regen ILIs per the new logic DEV-3111 
	//Donot delete ILIs that are marked as Locked OR Passed Invoice Schedule Date.
    public void regenerateInvoiceLineItems(map < Id, Id > oliIdWithProjectMap) {
    	List < OpportunityLineItem > oliList = new List < OpportunityLineItem > ();
    	oliList = [SELECT Id, PricebookEntry.Product2.Invoice_Frequency__c,
						OpportunityId, Qty_ContractMonths__c,
						Invoice_ServiceStartDate__c, TotalMonthlyCharge__c, 
						Waiting_status__c, Project__c
					FROM OpportunityLineItem
					WHERE Id IN: oliIdWithProjectMap.keyset()];
		
    	system.debug('********oliIdWithProjectMap1111**********' + oliIdWithProjectMap);
    	system.debug('********oliList**********' + oliList);
    	
    	//Filtering newOLIList by removing Cancel and Hard Cancel OLIs
    	List < OpportunityLineItem > newOliList = new List < OpportunityLineItem > ();
    	for(OpportunityLineItem oneOLI : oliList){
    		Boolean exclude = false;
    		//DONOT Support ILI Regen on Two times product
    		if(oneOLI.PricebookEntry.Product2.Invoice_Frequency__c == 'Two Times'){
    			exclude = true;
    			oliIdWithProjectMap.remove(oneOLI.Id);	 
    			System.debug('Ignoring OLI for ILI Regen because its Cancelled and the status is >> ' + oneOLI);
    		} 
    		
    		//DONOT Support ILI Regen on Cancelled OLIs
    		if(oneOLI.Waiting_status__c != null 
    			&& (oneOLI.Waiting_status__c == 'Cancelled' || oneOLI.Waiting_status__c == 'Hard Cancel')){
    			exclude = true;
    			oliIdWithProjectMap.remove(oneOLI.Id);	 
    			System.debug('Ignoring OLI for ILI Regen because its Cancelled and the status is >> ' + oneOLI);
    		} 
    		
    		if(!exclude){
    			newOliList.add(oneOLI);
    		}
    	}
    	
    	if(newOliList.size()==0){
    		System.debug('OLIs didnot meet the criteria for ILI Regen hence moving back');
    		return;
    	}
    	
    	//Retrieve existing  ILIs which are isLocked and IsSystemGenerated for Delete
    	List<Invoice_LineItem__c> deleteUnlockedILIs = [Select Id, Name from Invoice_LineItem__c 
    													Where ProjectRef__c In: oliIdWithProjectMap.Values()
    													and IsSystemGenerated__c=true
    													and isLocked__c=false];
    	
    	//Retrieve existing  ILIs which are isLocked and IsSystemGenerated
    	Map<Id, Project__c> mapExistingILIs = new Map<Id, Project__c>();
    	mapExistingILIs.putAll([Select Id, (Select Id, Name, Invoice_ScheduleDate__c, 
    										 	Invoice_PeriodEnd__c, Invoice_PeriodStart__c, 
    										 	IsSystemGenerated__c, isLocked__c  
    										 from Invoice_Line_Items__r
    										 Where isLocked__c=true and IsSystemGenerated__c=true)
	    							 from Project__c
	    						Where Id In: oliIdWithProjectMap.Values()]);
    	System.debug ('Existing ILIs >> ' + mapExistingILIs); 
    							 
    	//Map of Project Ids with ILI List
		Map<Id, List<Invoice_LineItem__c>> mapILIList = new Map<Id, List<Invoice_LineItem__c>>();
		for (OpportunityLineItem oli: newOliList) {
			Integer qtyContractMonths = Integer.valueOf(oli.Qty_ContractMonths__c);
			Decimal oliMonthlyTotal = oli.TotalMonthlyCharge__c;
			Date startDate = oli.Invoice_ServiceStartDate__c;
			Id opportunityId = oli.opportunityId;
			Id projectId = oliIdWithProjectMap.get(oli.Id);
			
			List<Invoice_LineItem__c> newILIList = new List<Invoice_LineItem__c>(); 
			
			//Calling abstract class create method to get the List of returned Invoice LineItems created for OLI's  
			system.debug('********oli.PricebookEntry.Product2.Invoice_Frequency__c**********' + oli.PricebookEntry.Product2.Invoice_Frequency__c);
			if (oli.PricebookEntry.Product2.Invoice_Frequency__c != 'Two Times') {
				newILIList.addall(createInvoiceLineItems(qtyContractMonths, startDate, oliMonthlyTotal, opportunityId, projectId));
				
				newILIList = regenCreateInvoiceLineItems(mapExistingILIs.get(projectId).Invoice_Line_Items__r, newILIList);
			}			
			mapILIList.put(projectId, newILIList);
		}
    	
    	//Calling Insert method of abstract class to create Invoice LIneItems for the OLI's
    	if (mapILIList != null && mapILIList.size() > 0) {
    		List<Invoice_LineItem__c> invoiceLineItemList = new List<Invoice_LineItem__c>();
    		for(Id projectId : mapILIList.KeySet()){
    			invoiceLineItemList.addall(mapILIList.get(projectId));
    		}
    		system.debug('********invoiceLineItemList**********' + invoiceLineItemList);
    		super.insertInvoiceLineItems(invoiceLineItemList);
    	}
    	
    	//delete UnLocked System Generated ILIs as part of ILI Regeneration 
    	if(deleteUnlockedILIs!=null && deleteUnlockedILIs.size()>0){
    		delete deleteUnlockedILIs;
    	}
    }
   
   //Getting the Opportunity LineItems and to be generated Invoice LiteItems for the associated Oppoortunity LineItems
    public void insertInvoiceLineItems(map<Id, Id> oliIdWithProjectMap)
    {
        List<Invoice_LineItem__c> invoiceLineItemList = new List<Invoice_LineItem__c>();
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList = [SELECT Id,  PricebookEntry.Product2.Invoice_Frequency__c, OpportunityId, Qty_ContractMonths__c, Invoice_ServiceStartDate__c,TotalMonthlyCharge__c 
                                       FROM OpportunityLineItem 
                                       WHERE Id IN : oliIdWithProjectMap.keyset()];
        
        system.debug('********oliIdWithProjectMap1111**********'+oliIdWithProjectMap);
        system.debug('********oliList**********'+oliList);
        if(oliList.size()>0){                             
        for(OpportunityLineItem oli : oliList){                      
            Integer qtyContractMonths= Integer.valueOf(oli.Qty_ContractMonths__c);
            Decimal oliMonthlyTotal = oli.TotalMonthlyCharge__c; 
            Date startDate = oli.Invoice_ServiceStartDate__c;
            Id opportunityId = oli.opportunityId;
            Id projectId = oliIdWithProjectMap.get(oli.Id);
          
            //Calling abstract class create method to get the List of returned Invoice LineItems created for OLI's  
            system.debug('********oli.PricebookEntry.Product2.Product_Type_Dummy__c**********'+oli.PricebookEntry.Product2.Invoice_Frequency__c);
            if(oli.PricebookEntry.Product2.Invoice_Frequency__c!= 'Two Times'){
                invoiceLineItemList.addall(createInvoiceLineItems(qtyContractMonths,  startDate, oliMonthlyTotal, opportunityId, projectId));
            }
            else if(oli.PricebookEntry.Product2.Invoice_Frequency__c== 'Two Times'){
                invoiceLineItemList.addall(createInvoiceLineItemsForONEProduct(qtyContractMonths,  startDate, oliMonthlyTotal, opportunityId, projectId));
            }
        
        }        
        
       } 
       
       //Calling Insert method of abstract class to create Invoice LIneItems for the OLI's
        if(invoiceLineItemList!= null && invoiceLineItemList.size()>0){
            
            system.debug('********invoiceLineItemList**********'+invoiceLineItemList);            
            super.insertInvoiceLineItems(invoiceLineItemList);
        }
    }
    
    
    // Getting the ILI's for all the project Id's and performing soft delete if cancel on OLI occurs.
    // DEV-2588 FIP - Bulkify Cancel and Hard Cancellation Rules Methods
    public void cancelInvoiceLineItems(set < Id > projIds) {
    	//Retrive all OLIs with Project Id
    	Map < Id, OpportunityLineItem > mapOLIs = new Map < Id, OpportunityLineItem > ();
    	mapOLIs.putAll([SELECT Id, Invoice_ServiceStartDate__c, Invoice_ServiceEndDate__c, project__c,
    	Invoice_CancelDate__c, PricebookEntry.Product2.Invoice_Frequency__c
    	FROM OpportunityLineItem WHERE project__c IN: projIds]);


    	//Retrieve All ILIs for the corresponding ProjectIds
    	List < Invoice_LineItem__c > getinvLineItemList = new List < Invoice_LineItem__c > ();
    	getinvLineItemList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, Invoice_ScheduleDate__c,
							    	ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
							    	isDeleted__c, Invoice_PeriodEnd__c, Mgmt_Fee__c, Product_Price__c,
							    	ProjectRef__r.Product_Id__c, ProjectRef__r.Invoice_CancelDate__c,
                                    ProjectRef__r.Related_Product__r.HasMediaSpend__c
						    	FROM Invoice_LineItem__c
						    	WHERE ProjectRef__c In: projIds
							    	AND isDeleted__c = false
							    	AND isLocked__c = false
							    	And IsSystemGenerated__c = true
						    	ORDER BY ProjectRef__c, Invoice_PeriodStart__c ASC];

    	//Store map of OLIs with corresponding ILIs                                         					
    	Map < Id, List < Invoice_LineItem__c >> mapOLIsILIs = new Map < Id, List < Invoice_LineItem__c >> ();
        if(getinvLineItemList != null && getinvLineItemList.size() > 0){
            for (Invoice_LineItem__c oneILI: getinvLineItemList) {
                List < Invoice_LineItem__c > listOLIILIs = mapOLIsILIs.get(oneILI.ProjectRef__r.Product_Id__c);
                if (listOLIILIs == null) {
                    listOLIILIs = new List < Invoice_LineItem__c > ();
                    mapOLIsILIs.put(oneILI.ProjectRef__r.Product_Id__c, listOLIILIs);
                }
    
                //SOQL Criteria moved here (Invoice_ScheduleDate__c >: cancelDate OR Invoice_ScheduleDate__c = null)
                if (oneILI.Invoice_ScheduleDate__c > oneILI.ProjectRef__r.Invoice_CancelDate__c || oneILI.Invoice_ScheduleDate__c == null) {
                    listOLIILIs.add(oneILI);
                }
            }
         }
    
    	//Cancellation Logic starts here
    	List < Invoice_LineItem__c > megeredILIs = new List < Invoice_LineItem__c > ();
    	List < Invoice_LineItem__c > deleteILIs = new List < Invoice_LineItem__c > ();
    	for (OpportunityLineItem oneOppLineItem: mapOLIs.values()) {
    		date cancelDate = oneOppLineItem.Invoice_CancelDate__c;
    		date serviceStartDate = oneOppLineItem.Invoice_ServiceStartDate__c;
    		String invoiceFrequency = oneOppLineItem.PricebookEntry.Product2.Invoice_Frequency__c;
    		date serviceEndDate;
    		date minimumMonths;

    		if (cancelDate > serviceStartDate.addmonths(3)) {
    			//minimum 2 month rule
    			minimumMonths = cancelDate.addmonths(2);
    		} else {
    			//minimum 4 month rule
    			minimumMonths = serviceStartDate.addmonths(4);
    		}
             if(mapOLIsILIs.get(oneOppLineItem.Id) != null){
                if (invoiceFrequency != null && invoiceFrequency != 'Two Times') {
                   
                    System.debug('getinvLineItemList >> ' + mapOLIsILIs.get(oneOppLineItem.Id));
                    Invoice_LineItem__c newILI;
                    
                    for (Invoice_LineItem__c oneILI: mapOLIsILIs.get(oneOppLineItem.Id)) {
                        if (oneILI.Invoice_PeriodEnd__c <= minimumMonths) {
                            newILI = (newILI == null ? new Invoice_LineItem__c() : newILI);
                            if (newILI.Invoice_PeriodStart__c == null) {
                                newILI.Invoice_PeriodStart__c = oneILI.Invoice_PeriodStart__c;
                                newILI.OpportunityRef__c = oneILI.OpportunityRef__c;
                                newILI.ProjectRef__c = oneILI.ProjectRef__c;
                                newILI.TotalMonthlyCharge__c = oneILI.TotalMonthlyCharge__c;
                                newILI.Invoice_LineItemType__c = 'Cancel';
                                newILI.Invoice_PeriodEnd__c = oneILI.Invoice_PeriodStart__c.addMonths(1).addDays(-1);
                            } else {
                                newILI.TotalMonthlyCharge__c = newILI.TotalMonthlyCharge__c + oneILI.TotalMonthlyCharge__c;
                            }
                            serviceEndDate = oneILI.Invoice_PeriodEnd__c;
                        }
                    }
                    System.debug('new ILI >> ' + newILI);
                    if (newILI != null) {
                        megeredILIs.add(newILI);
                        oneOppLineItem.Invoice_ServiceEndDate__c = serviceEndDate;
                    }
                } else {
                    oneOppLineItem.Invoice_ServiceEndDate__c = cancelDate;
                }
                deleteILIs.addAll(mapOLIsILIs.get(oneOppLineItem.Id));
              }
            }

    	//insert new ILI 
    	if (megeredILIs.size() > 0) {
    		super.insertInvoiceLineItems(megeredILIs);
    	}

    	//delete Cancelled ILIs
    	if (deleteILIs.size() > 0) {
    		super.deleteInvoiceLineItems(deleteILIs);
    	}

    	//update OLI
    	if (mapOLIs.values().size() > 0) {
    		update mapOLIs.values();
    	}
    }
    
    // Update the Start and End Dates of ILI whose Product2.Invoice_Frequency__c == 'Two Times'
    public void updateInvoiceLineItems(map<Id, Id> oliIdWithProjectMap)
    {
        List<Invoice_LineItem__c> iliList = new List<Invoice_LineItem__c>();
        
        
        set<Id> projIds = new set<Id>();
        for(OpportunityLineItem  oli : [SELECT Id, PricebookEntry.Product2.Invoice_Frequency__c, Invoice_ServiceEndDate__c,Invoice_ServiceStartDate__c  FROM OpportunityLineItem 
                                       WHERE project__c IN : oliIdWithProjectMap.values()]){
            
            if(oli.PricebookEntry.Product2.Invoice_Frequency__c == 'Two Times' && oli.Invoice_ServiceStartDate__c != null && oli.Invoice_ServiceEndDate__c!= null){
                projIds.add(oliIdWithProjectMap.get(oli.Id));
            }                               
        }
        
        
        for(Invoice_LineItem__c ili : [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, Invoice_ScheduleDate__c,
                                                        ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
                                                        isDeleted__c, Invoice_PeriodEnd__c
                                                 FROM Invoice_LineItem__c
                                                 WHERE ProjectRef__c In : projIds
                                                     AND isDeleted__c = false
                                                     AND isLocked__c = false
                                                     And IsSystemGenerated__c = true
                                                     And Invoice_PeriodEnd__c = null
                                                     AND Invoice_PeriodStart__c = null
                                                 ORDER BY ProjectRef__c, Invoice_PeriodStart__c ASC]){
        
            ili.Invoice_PeriodStart__c = date.today();
            ili.Invoice_PeriodEnd__c = date.today().addmonths(1).adddays(-1);
            iliList.add(ili);
        }
        super.updateInvoiceLineItems(iliList);
    }
    
    public void hardCancelInvoiceLineItems(set<Id> projIds)
    {   
    	//Retrive all OLIs with Project Id
    	Map < Id, OpportunityLineItem > mapOLIs = new Map < Id, OpportunityLineItem > ();
    	mapOLIs.putAll([SELECT Id, Invoice_ServiceStartDate__c, Invoice_ServiceEndDate__c, project__c,
    	Invoice_CancelDate__c, PricebookEntry.Product2.Invoice_Frequency__c
    	FROM OpportunityLineItem WHERE project__c IN: projIds]);


    	//Retrieve All ILIs for the corresponding ProjectIds
    	List < Invoice_LineItem__c > getinvLineItemList = new List < Invoice_LineItem__c > ();
    	getinvLineItemList = [SELECT Id, Invoice_PeriodStart__c, OpportunityRef__c, Invoice_ScheduleDate__c,
							    	ProjectRef__c, TotalMonthlyCharge__c, isLocked__c,
							    	isDeleted__c, Invoice_PeriodEnd__c, Mgmt_Fee__c, Product_Price__c,
							    	ProjectRef__r.Product_Id__c, ProjectRef__r.Invoice_CancelDate__c,
                                    ProjectRef__r.Related_Product__r.HasMediaSpend__c
						    	FROM Invoice_LineItem__c
						    	WHERE ProjectRef__c In: projIds
							    	AND isDeleted__c = false
							    	AND isLocked__c = false
							    	And IsSystemGenerated__c = true
						    	ORDER BY ProjectRef__c, Invoice_PeriodStart__c ASC];

    	//Store map of OLIs with corresponding ILIs                                         					
    	Map < Id, List < Invoice_LineItem__c >> mapOLIsILIs = new Map < Id, List < Invoice_LineItem__c >> ();
        if(getinvLineItemList != null && getinvLineItemList.size() > 0){
            for (Invoice_LineItem__c oneILI: getinvLineItemList) {
                List < Invoice_LineItem__c > listOLIILIs = mapOLIsILIs.get(oneILI.ProjectRef__r.Product_Id__c);
                if (listOLIILIs == null) {
                    listOLIILIs = new List < Invoice_LineItem__c > ();
                    mapOLIsILIs.put(oneILI.ProjectRef__r.Product_Id__c, listOLIILIs);
                }
    
                //SOQL Criteria moved here (Invoice_ScheduleDate__c >: cancelDate OR Invoice_ScheduleDate__c = null)
                if (oneILI.Invoice_ScheduleDate__c > oneILI.ProjectRef__r.Invoice_CancelDate__c || oneILI.Invoice_ScheduleDate__c == null) {
                    listOLIILIs.add(oneILI);
                }
            }
        }
    	//Cancellation Logic starts here
    	List < Invoice_LineItem__c > megeredILIs = new List < Invoice_LineItem__c > ();
    	List < Invoice_LineItem__c > deleteILIs = new List < Invoice_LineItem__c > ();
    	for (OpportunityLineItem oneOppLineItem: mapOLIs.values()) {
    		date cancelDate = oneOppLineItem.Invoice_CancelDate__c;
    		date serviceStartDate = oneOppLineItem.Invoice_ServiceStartDate__c;
    		String invoiceFrequency = oneOppLineItem.PricebookEntry.Product2.Invoice_Frequency__c;
    		date serviceEndDate;
    		date minimumMonths;

    		if (cancelDate > serviceStartDate.addmonths(3)) {
    			//minimum 2 month rule
    			minimumMonths = cancelDate.addmonths(2);
    		} else {
    			//minimum 4 month rule
    			minimumMonths = serviceStartDate.addmonths(4);
    		}
            if(mapOLIsILIs.get(oneOppLineItem.Id) != null){
                if (invoiceFrequency != null && invoiceFrequency != 'Two Times') {
                    System.debug('getinvLineItemList >> ' + mapOLIsILIs.get(oneOppLineItem.Id));
                    Invoice_LineItem__c newILI;
                    for (Invoice_LineItem__c oneILI: mapOLIsILIs.get(oneOppLineItem.Id)) {
                        if (oneILI.Invoice_PeriodEnd__c <= minimumMonths) {
                            newILI = (newILI == null ? new Invoice_LineItem__c() : newILI);
                            if (newILI.Invoice_PeriodStart__c == null) {
                                newILI.Invoice_PeriodStart__c = oneILI.Invoice_PeriodStart__c;
                                newILI.OpportunityRef__c = oneILI.OpportunityRef__c;
                                newILI.ProjectRef__c = oneILI.ProjectRef__c;
                                if(oneILI.Invoice_PeriodStart__c !=null && cancelDate < oneILI.Invoice_PeriodStart__c && oneILI.ProjectRef__r.Related_Product__r.HasMediaSpend__c==true && oneILI.Product_Price__c != null && 
                                   oneILI.Mgmt_Fee__c != null){
                                     newILI.TotalMonthlyCharge__c=  oneILI.Product_Price__c* oneILI.Mgmt_Fee__c/100; 
                                   }else{
                                     newILI.TotalMonthlyCharge__c = oneILI.TotalMonthlyCharge__c;
                                   }
                                newILI.Invoice_LineItemType__c= 'Kill';
                                newILI.Invoice_PeriodEnd__c = oneILI.Invoice_PeriodStart__c.addMonths(1).addDays(-1);
                            }else if (oneILI.ProjectRef__r.Related_Product__r.HasMediaSpend__c==true && oneILI.Product_Price__c != null && 
                                     oneILI.Mgmt_Fee__c != null){
                                newILI.TotalMonthlyCharge__c= newILI.TotalMonthlyCharge__c+ (oneILI.Product_Price__c* oneILI.Mgmt_Fee__c/100);                  
                            }
                            else{
                                newILI.TotalMonthlyCharge__c= newILI.TotalMonthlyCharge__c+ oneILI.TotalMonthlyCharge__c;
                            }
                        }
                    }
                    System.debug('new ILI >> ' + newILI);
                    if (newILI != null) {
                        megeredILIs.add(newILI);
                        oneOppLineItem.Invoice_ServiceEndDate__c = cancelDate;
                    }
                } else {
                    oneOppLineItem.Invoice_ServiceEndDate__c = cancelDate;
                }
                deleteILIs.addAll(mapOLIsILIs.get(oneOppLineItem.Id));
            }
    	}

    	//insert new ILI 
    	if (megeredILIs.size() > 0) {
    		super.insertInvoiceLineItems(megeredILIs);
    	}

    	//delete Cancelled ILIs
    	if (deleteILIs.size() > 0) {
    		super.deleteInvoiceLineItems(deleteILIs);
    	}

    	//update OLI
    	if (mapOLIs.values().size() > 0) {
    		update mapOLIs.values();
    	}  	
    	    
    }
}