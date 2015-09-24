/*
	This class call AMP rest service to retrieve Industry list and industry focus.
*/ 

public without sharing class AMPRestService {
	private static Map<String,String> industryMap; 
	private static Map<String, String> industryFocus;
	
	/*
	  Gets Industry List from AMP rest endpoint
	*/
	public static Map<String,String> getIndustryList() {
		AMPIndustryList ampIndustryList; 
	    HttpRequest req = new HttpRequest();   
	    string url = 'https://amp.glplatform.com/api/KeywordSearch/VerticalIndustrySearch?verticalName=';
	    req.setEndpoint( url );
	    req.setHeader('Content-Type', 'application/json');
	    req.setMethod('GET');
	    if(System.isBatch()){
	    	req.setTimeout(120000);
	    }    
	    try {
	    	if(industryMap == null){
		        Http http = new Http();
		        HttpResponse response = http.send(req);    
			    
		        if (response.getStatusCode() == 200 ) {
		        	System.debug('AMP Service response for Industry List>> ' + json.serializePretty(response.getBody()));
		        	String jsonString = '{"IndustryList" :' +response.getBody()+ '}';
		            ampIndustryList = new AMPIndustryList();
		            ampIndustryList = ampIndustryList.parse(jsonString);
		            
		            industryMap = new Map<String, String>();
		            for (IndustryList oneItem: ampIndustryList.IndustryList){
		            	industryMap.put(String.ValueOf(oneItem.CategoryId), oneItem.CategoryName);
		            }
		            return industryMap;
		        } else {
	                System.debug('no response data');
		        }
	    	}else{
	    		return industryMap;
	    	} 
	    } catch( System.Exception ex) {
	        System.debug('ERROR: '+ ex);
	        ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
														null, 'AMPRestService', 'getIndustryList', true, ApplicationLogsModel.Loglevel.Error);
	    }
	    return null;
	}
	
	/*
	   Gets Industry Focus List by Industry
	*/
	public static Map<String,String> getFocusByIndustry(String CategoryId){
		AMPIndustryFocus ampIndustryFocus;
		HttpRequest req = new HttpRequest();   
	    string url = 'https://amp.glplatform.com/api/KeywordSearch/VerticalFocusSearch?industryId=' + CategoryId + '&verticalName=';
	    req.setEndpoint( url );
	    req.setHeader('Content-Type', 'application/json');
	    req.setMethod('GET');
	    if(System.isBatch()){
	    	req.setTimeout(120000);
	    } 
	    try {
	    	if(industryFocus == null){
		        Http http = new Http();
		        HttpResponse response = http.send(req);    
			    
		        if (response.getStatusCode() == 200 ) {
		        	System.debug('AMP Service response for Industry Focus>> ' + json.serializePretty(response.getBody()));
		        	String jsonString = '';
		        	if(response.getBody()<>null){
		        		jsonString = response.getBody().trim();
		        	}
		        	
		        	if(jsonString.startsWith('[')){
		        		jsonString = 'STARTS_WITH' + jsonString;
		        		jsonString = jsonString.replace('STARTS_WITH[', '');
		        	}
		        	
		        	if(jsonString.endsWith(']')){
		        		jsonString = jsonString + 'ENDS_WITH';
		        		jsonString = jsonString.replace(']ENDS_WITH', '');
		        	}
		        	System.debug('Modified Json >> '  + jsonString);
		        	
		            industryFocus = new Map<String, String>();
		            ampIndustryFocus = new AMPIndustryFocus();
		            ampIndustryFocus = ampIndustryFocus.parse(jsonString);
		            
		            for(Children oneItem: ampIndustryFocus.Children){
		            	industryFocus.put(String.ValueOf(oneItem.CategoryId), oneItem.CategoryName);
		            }
		            
		            return industryFocus;
		        } else {
	                System.debug('no response data');
		        }
	    	}else{
	    		return industryFocus;
	    	} 
	    } catch( System.Exception ex) {
	        System.debug('ERROR: '+ ex);
	        ApplicationLogsModel.insertApplicationLog(ex.getMessage(), ex.getStackTraceString(), String.valueOf(ex.getLineNumber()), 
														null, 'AMPRestService', 'getFocusByIndustry', true, ApplicationLogsModel.Loglevel.Error);
	    }
	    return null;
	}
	
	/*
	    The following classes are generated using Json2Apex
	    http://json2apex.herokuapp.com/
	    This helps to deserialize json response to Apex Objects
	    
	    Apex Object for Industry List
	*/
	public class AMPIndustryList {
		public List<IndustryList> IndustryList;
		public AMPIndustryList parse(String json) {
		    return (AMPIndustryList) System.JSON.deserialize(json, AMPIndustryList.class);
		}
	}
	
	public class IndustryList {
		public String CategoryName;
		public Integer CategoryId;
		public Boolean Proxyable;
	}
	
	/*
	    The following classes are generated using Json2Apex
	    http://json2apex.herokuapp.com/
	    This helps to deserialize json response to Apex Objects
	    
	    Apex Object for Industry Focus
	*/
	public class AMPIndustryFocus {
		public String CategoryName;
		public List<Children> Children;
		public Integer CategoryId;
		public Boolean Proxyable;
	
		public AMPIndustryFocus parse(String json) {
			return (AMPIndustryFocus) System.JSON.deserialize(json, AMPIndustryFocus.class);
		}
	}
	
	public class Children {
		public String CategoryName;
		public Integer CategoryId;
		public Boolean Proxyable;
	}
}