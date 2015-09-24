// How is this a handler?
// What is Whoosh?

// CC Ph2 - refactoring thoughts:
// 1)	3 static functions do nothing other than init lists. Why aren't the Lists just static Mem Vars?
// 2)	The for loops that make use of the parallel lists

//
global class whooshHandler {

	public static List<String> FieldSetResultList(){
		List<String> fieldSetResultList = new List<String>();
		fieldSetResultList.add('W_Keyword_01_Result__c');
		fieldSetResultList.add('W_Keyword_02_Result__c');
		fieldSetResultList.add('W_Keyword_03_Result__c');
		fieldSetResultList.add('W_Keyword_04_Result__c');
		fieldSetResultList.add('W_Keyword_05_Result__c');
		fieldSetResultList.add('W_Keyword_06_Result__c');
		fieldSetResultList.add('W_Keyword_07_Result__c');
		fieldSetResultList.add('W_Keyword_08_Result__c');
		fieldSetResultList.add('W_Keyword_09_Result__c');
		fieldSetResultList.add('W_Keyword_10_Result__c');
		return fieldSetResultList;
	}
	
	public static List<String> FieldSetKeywordList(){
		List<String> fieldSetKeywordList = new List<String>();
		fieldSetKeywordList.add('W_Keyword_01__c');
		fieldSetKeywordList.add('W_Keyword_02__c');
		fieldSetKeywordList.add('W_Keyword_03__c');
		fieldSetKeywordList.add('W_Keyword_04__c');
		fieldSetKeywordList.add('W_Keyword_05__c');
		fieldSetKeywordList.add('W_Keyword_06__c');
		fieldSetKeywordList.add('W_Keyword_07__c');
		fieldSetKeywordList.add('W_Keyword_08__c');
		fieldSetKeywordList.add('W_Keyword_09__c');
		fieldSetKeywordList.add('W_Keyword_10__c');
		return fieldSetKeywordList;
	}
	
	public static List<String> FieldSetIDList(){
		List<String> fieldSetIDList = new list<string>();
		fieldSetIDList.add('W_Keyword_01_ID__c');
		fieldSetIDList.add('W_Keyword_02_ID__c');
		fieldSetIDList.add('W_Keyword_03_ID__c');
		fieldSetIDList.add('W_Keyword_04_ID__c');
		fieldSetIDList.add('W_Keyword_05_ID__c');
		fieldSetIDList.add('W_Keyword_06_ID__c');
		fieldSetIDList.add('W_Keyword_07_ID__c');
		fieldSetIDList.add('W_Keyword_08_ID__c');
		fieldSetIDList.add('W_Keyword_09_ID__c');
		fieldSetIDList.add('W_Keyword_10_ID__c');
		return fieldSetIDList;
	}
		
	public static HTTPResponse runKeywordSearch(String keyword, String url){
		//String logon = 'P1wsP3iTHu7/DbT';
		//String apiKey = 'triIx7zAVK7ekY4yuNJLguF7nvJcE24u5jJEn4YtFsP8jJXi3Q/iO';
		
		String logon = 	'eTwEAMTBPjp1Fzs';
		string apiKey = 'guo616S08o7M4NWWAcz2vOMaIXWyDoGdvEKDAcIINfWgjjQ.TO8fG';
		//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Testing'));
		String xml = '<?xml version="1.0" encoding="UTF-8"?>' +
		
		'<pair>' +
  		'<url>http://'+ url + '</url>' + 
  		'<keyword>'+keyword+'</keyword>' +
		'</pair>';

		HttpRequest req = new HttpRequest();
	    req.setMethod('POST');
	    req.setEndpoint('https://secure.whooshtraffic.com/ranktracker/pairs');
	    Blob headerValue = Blob.valueOf(logon  + ':' + apiKey);
	    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
	    req.setHeader('Authorization', authorizationHeader);
	    req.setHeader('Accept', 'application/vnd.whoosh.api+xml');
	    req.setHeader('Content-Length', string.valueOf(xml.length()));
	    req.setBody(xml);
	    Http http = new Http();
	    HttpResponse resp = http.send(req);
	    return resp;
	}
	
	public static string findKeywordSearchID(String response){
		string keyID = '';
		
		if(response.contains('success')){
			response = response.removeEnd('</pairid></success>');
			system.debug(response);
			response = response.trim();
			system.debug(response);
			integer lastIndex = response.lastIndexOf('>');
			keyId = response.substring((lastIndex+1), response.length());
		}
		return keyID;
	}
	
	webservice static void findWhooshResults(ID caseID){
		Case thisCase = [SELECT ID, 
								DA_Website__c,
								W_Keyword_02_ID__c,
								W_Keyword_02__c,
								W_Keyword_03_ID__c,
								W_Keyword_03__c, 
								W_Keyword_04_ID__c,
								W_Keyword_04__c,
								W_Keyword_05_ID__c,
								W_Keyword_05__c,
								W_Keyword_06_ID__c,
								W_Keyword_06__c,
								W_Keyword_07_ID__c,
								W_Keyword_07__c,
								W_Keyword_08_ID__c,
								W_Keyword_08__c, 
								W_Keyword_09_ID__c,
								W_Keyword_09__c, 
								W_Keyword_10_ID__c,
								W_Keyword_10__c,
								W_Keyword_01_ID__c,
								W_Keyword_01__c
							FROM Case where ID = :caseID];
		
		List<string> fieldSetKeywordList = whooshHandler.FieldSetKeywordList();
		List<string> fieldSetIDList = whooshHandler.FieldSetIDList(); 
		
		for (integer i = 0; i<FieldSetKeywordList.size(); i++){
			if(thisCase.get(fieldSetKeywordList[i]) != null){
				HTTPResponse resp = whooshHandler.runKeywordSearch(string.valueOf(thisCase.get(fieldSetKeywordList[i])), thisCase.DA_Website__c);
				String response = resp.getBody();
				string temp = whooshHandler.findKeywordSearchID(response);
				thisCase.put(fieldSetIDList[i], temp);
			}
		}
		//thisCase.Whoosh_Results_Requested__c = true;
		update thisCase;
	}
	
	webservice static String findRankedKeywords(){
		//Case thisCase = [SELECT ID, DA_Website__c,  W_Keyword_02_ID__c, W_Keyword_02__c,  W_Keyword_03_ID__c, W_Keyword_03__c,  W_Keyword_04_ID__c, W_Keyword_04__c,  W_Keyword_05_ID__c, W_Keyword_05__c,  W_Keyword_06_ID__c, W_Keyword_06__c,  W_Keyword_07_ID__c, W_Keyword_07__c,  W_Keyword_08_ID__c, W_Keyword_08__c,  W_Keyword_09_ID__c, W_Keyword_09__c,  W_Keyword_10_ID__c, W_Keyword_10__c, W_Keyword_01_ID__c, W_Keyword_01__c FROM Case where ID = :caseID];
		String logon = 	'eTwEAMTBPjp1Fzs';
		String apiKey = 'guo616S08o7M4NWWAcz2vOMaIXWyDoGdvEKDAcIINfWgjjQ.TO8fG';
		HttpRequest req = new HttpRequest();
		
		req.setMethod('GET');
	    req.setEndpoint('https://secure.whooshtraffic.com/ranktracker/pairs/ranked');
	    
	    Blob headerValue = Blob.valueOf(logon  + ':' + apiKey);
	    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
	    
	    req.setHeader('Authorization', authorizationHeader);
	    req.setHeader('Accept', 'application/vnd.whoosh.api+json');
	    
	    //req.setHeader('Range', 'engine=google;');	
	    string response = '';
	    
	    if(Test.isRunningTest()){
	    	response = '';
	    }else{
		    Http http = new Http();
		    HttpResponse resp = http.send(req);
		    
		    response = resp.getBody();
	    }
	    
	   // Dom.Document doc = resp.getBodyDocument();
	    
	    return response;
	}
	
	public static Dom.Document findRankedKeywordsDoc(ID caseID){
		Case thisCase = [SELECT ID,
								DA_Website__c,
								W_Keyword_02_ID__c,
								W_Keyword_02__c, 
								W_Keyword_03_ID__c,
								W_Keyword_03__c,
								W_Keyword_04_ID__c,
								W_Keyword_04__c,
								W_Keyword_05_ID__c,
								W_Keyword_05__c, 
								W_Keyword_06_ID__c,
								W_Keyword_06__c,
								W_Keyword_07_ID__c,
								W_Keyword_07__c,
								W_Keyword_08_ID__c,
								W_Keyword_08__c,
								W_Keyword_09_ID__c,
								W_Keyword_09__c,
								W_Keyword_10_ID__c,
								W_Keyword_10__c,
								W_Keyword_01_ID__c,
								W_Keyword_01__c
							FROM Case where ID = :caseID];
							
		String logon = 	'eTwEAMTBPjp1Fzs';
		String apiKey = 'guo616S08o7M4NWWAcz2vOMaIXWyDoGdvEKDAcIINfWgjjQ.TO8fG';
		HttpRequest req = new HttpRequest();
		
		req.setMethod('GET');
	    req.setEndpoint('https://secure.whooshtraffic.com/ranktracker/pairs/ranked');
	    Blob headerValue = Blob.valueOf(logon  + ':' + apiKey);
	    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
	    
	    req.setHeader('Authorization', authorizationHeader);
	    req.setHeader('Accept', 'application/vnd.whoosh.api+xml');
	    
	    //req.setHeader('Range', 'engine=google;');	
	    Http http = new Http();
	    HttpResponse resp = http.send(req);
	    
	    string response = resp.getBody();
	    Dom.Document doc = resp.getBodyDocument();
	    
	    return doc;
	    //thisCase.Whoosh_Response_Ranked__c = response.subString(0,32760);
	    //update thisCase;
	}

	webservice static void searchKeyWords(ID caseID){
		Case thisCase = [SELECT ID,
								DA_Website__c,
								W_Keyword_02_ID__c,
								W_Keyword_02__c,
								W_Keyword_03_ID__c,
								W_Keyword_03__c,
								W_Keyword_04_ID__c,
								W_Keyword_04__c,
								W_Keyword_05_ID__c,
								W_Keyword_05__c,
								W_Keyword_06_ID__c,
								W_Keyword_06__c,
								W_Keyword_07_ID__c,
								W_Keyword_07__c,
								W_Keyword_08_ID__c,
								W_Keyword_08__c,
								W_Keyword_09_ID__c,
								W_Keyword_09__c,
								W_Keyword_10_ID__c,
								W_Keyword_10__c,
								W_Keyword_01_ID__c,
								W_Keyword_01__c
							FROM Case where ID = :caseID];
							
		List<string> fieldsetkeywordList = whooshHandler.FieldSetKeywordList();
		List<string> fieldSetResultList = whooshHandler.FieldSetResultList();
		List<string> fieldSetIDList = whooshHandler.FieldSetIDList();
		
		for (integer i = 0; i<FieldSetKeywordList.size(); i++){
			if(thisCase.get(fieldSetIDList[i]) != null){
				string temp = whooshHandler.findPairRankings(string.valueOf(thisCase.get(fieldSetIDList[i])));
				thisCase.put(fieldSetResultList[i], temp);
			}
		}
		try{
			update thisCase;
		}catch(exception e){
			
		}
	}
	
	public static string findPairRankings(string keyID){
		String logon = 	'eTwEAMTBPjp1Fzs';
		String apiKey = 'guo616S08o7M4NWWAcz2vOMaIXWyDoGdvEKDAcIINfWgjjQ.TO8fG';
		HttpRequest req = new HttpRequest();
	    
	    req.setMethod('GET');
	    req.setEndpoint('https://secure.whooshtraffic.com/ranktracker/pairs/'+keyID+'/timeline');
	    
	    Blob headerValue = Blob.valueOf(logon  + ':' + apiKey);
	    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
	    
	    req.setHeader('Authorization', authorizationHeader);
	    req.setHeader('Accept', 'application/vnd.whoosh.api+json');
	    req.setHeader('Range', 'months=2; engine=google');	
	    
	    Http http = new Http();
	    HttpResponse resp = http.send(req);
	    
	    string response = resp.getBody();
	    
	    if(response.contains('404')){
	    	response = 'No Ranking Available';
	    	system.debug('Response ' + response);
	    }
	    
		return response;
	}
	
	webservice static void updateWhooshResults(ID caseID){
		Case thisCase = [SELECT ID,
								DA_Website__c,
								W_Keyword_02_ID__c,
								W_Keyword_02__c, 
								W_Keyword_03_ID__c,
								W_Keyword_03__c,
								W_Keyword_04_ID__c,
								W_Keyword_04__c,
								W_Keyword_05_ID__c,
								W_Keyword_05__c,
								W_Keyword_06_ID__c,
								W_Keyword_06__c,
								W_Keyword_07_ID__c,
								W_Keyword_07__c,
								W_Keyword_08_ID__c,
								W_Keyword_08__c,
								W_Keyword_09_ID__c,
								W_Keyword_09__c,
								W_Keyword_10_ID__c,
								W_Keyword_10__c,
								W_Keyword_01_ID__c,
								W_Keyword_01__c
							FROM Case where ID = :caseID];
							
		map<string, integer> rankMap = new map<string,integer>();
		String response = whooshHandler.findRankedKeywords();
		List<string> fieldsetkeywordList = whooshHandler.FieldSetKeywordList();
		List<string> fieldSetResultList = whooshHandler.FieldSetResultList();
		
		rankMap = JSONWhoosh.parse(response);
		
			for (integer i = 0; i<FieldSetKeywordList.size(); i++){
				if(rankMap.containsKey(string.valueOf(thisCase.get(FieldsetKeywordList[i])))){
					thisCase.put(fieldSetResultList[i],
								 string.valueOf(rankMap.get(string.valueOf(thisCase.get(fieldSetKeywordList[i])))));
				}else{
					thisCase.put(fieldSetResultList[i], 'No Ranking');
				}
			}
		
		update thisCase;
	}
	
	
	

}