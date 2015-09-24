global class JIRAConnectorWebserviceCalloutCreate {
    @future (callout=true)
    WebService static void createIssue( String jiraURL, String systemId, String objectType, String objectId, String projectKey, String issueType) {
 
        //Set your username and password here
        String username = 'admin';
        String password = 'F5nPRbrvJWSq';
 
        //Construct HTTP request and response
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
 
        //Construct Authorization and Content header
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
 
        //Construct Endpoint
        String endpoint = jiraURL+'/rest/customware/connector/1.0/'+systemId+'/'+objectType+'/'+objectId+'/issue/create.json';
 
        //Set Method and Endpoint and Body
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody('{"project":"'+projectKey+'", "issueType":"'+issueType+'"}');
 
        try {
           //Send endpoint to JIRA
           res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug(res.toString());
        }
    }
 
}