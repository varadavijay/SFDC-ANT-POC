global class JSONWhoosh {

	public class whooshRanking{
		public object keyword;
		public object created;
		public object locale;
		public object settings;
		public object modified;
		public object rank;
		public object url;
		public object id;
		public object change;
	}
	
	// <refactor> no reference here  
	public class whooshRankingList{
		List<whooshRanking> rankList;
	}
	
	public static map<string,integer> parse(String jsonString){
		// <CC> consistent syntax and formatting, String, Integer ?
		map<string, integer> whooshMap = new map<string, integer>();
		JSONWhoosh.whooshRanking wRanking = new JSONWhoosh.whooshRanking();
		
		JSONParser parser = JSON.createParser(jsonString);
		while (parser.nextToken() != null) {
			system.debug(parser.getCurrentToken() + 'Find Me');
			if (parser.getCurrentToken() == JSONToken.START_Object){
				//system.debug(parser.getCurrentToken() + 'FIND ME');
				while (parser.nextToken() != null && parser.nextToken() != JSONToken.END_Array) {
					if (parser.getCurrentName()=='id' && parser.getCurrentToken()==JSONToken.VALUE_NUMBER_INT)	wRanking.id = parser.getIntegerValue();
					if (parser.getCurrentName()=='keyword' && parser.getCurrentToken()==JSONToken.VALUE_STRING) 	wRanking.keyword	= parser.getText();
					//system.debug(string.valueOf(wRanking.keyword) + ' Find Me2');
					if (parser.getCurrentName()=='rank' && parser.getCurrentToken()==JSONToken.VALUE_NUMBER_INT) wRanking.rank = parser.getIntegerValue();
					if (parser.getCurrentName()=='settings'){
						parser.skipChildren();
					}
					if (parser.getCurrentName()=='keyword' && parser.getCurrentToken()==JSONToken.VALUE_STRING) 	wRanking.keyword	= parser.getText();
					if (parser.getCurrentName()=='rank' && parser.getCurrentToken()==JSONToken.VALUE_NUMBER_INT) wRanking.rank = parser.getIntegerValue();
					//if (parser.getCurrentName()=='created' && parser.getCurrentToken()==JSONToken.VALUE_NUMBER_INT) wRanking.rank = parser.getIntegerValue();
					//system.debug(string.valueOf(wRanking.Keyword) + ' Find Me');
					
					if (parser.getCurrentToken() == JSONToken.End_Object){
						if(whooshMap.containsKey(string.valueOf(wRanking.keyword))){
							if(whooshMap.get(string.valueOf(wRanking.keyword)) > integer.valueOf(wRanking.rank)){
								whooshMap.put(string.valueOf(wRanking.keyword), integer.valueOf(wRanking.rank));
							}
						}
						else{
							if(integer.valueOf(wRanking.rank) != null){
								whooshMap.put(string.valueOf(wRanking.keyword), integer.valueOf(wRanking.rank));
							}
						}
					}
				}
			}
		}
		
		return whooshMap;
	}
}