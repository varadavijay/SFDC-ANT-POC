// How is this a handler?
// What is Whoosh?
// <CC> future method to call a webservice method 
// <deletefile>
// <CC> no *active* calls to this code </CC>
global class whooshCalloutHandler {

	@future(callout=true)
	public static void callWhoosh(ID cID){
		whooshHandler.searchKeywords(cID);
	}

}