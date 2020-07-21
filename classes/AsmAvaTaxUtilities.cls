// (c) COPYRIGHT OAC SERVICES, INC. dba Foundry52 2020
// (AND ALL PREVIOUS VERSIONS)
/* ====================================================================
   = AUTHOR      : Michael B. Allen
   = DATE CREATED: July 10, 2020
   = VERSION     : 1.0
   = DESCRIPTION : This class will contain various methods used by 
   =               different classes in the integration with AvaTax
   ====================================================================
   = MODIFICATION HISTORY
   ====================================================================

   DATE        NAME           DESCRIPTION
   --------------------------------------------------------------------
   DD MON YY   F.LAST         DESCRIPTION OF MODIFICATION
   ====================================================================
   ====================================================================
*/

public class AsmAvaTaxUtilities {

    // ====================================================================================
    // = getOrganizationDetails
    // =
    // = Returns the address information for the current org and whether the current org is
    // = a sandbox org or not 
    // ====================================================================================

    public static Organization getOrganizationDetails(){
        return [SELECT Street, City, State, PostalCode, Country, IsSandbox FROM Organization LIMIT 1];
    }

    // ====================================================================================
    // = getAvaTax Settings
    // =
    // = Returns the AvaTax Settings from the Avalara AvaTax Setting custom metadata type 
    // ====================================================================================

    public static AsmAvalaraAvaTaxSetting__mdt getAvaTaxSettings() {

        string settingsQuery;
 
        map<STRING, Schema.SObjectField> SourceFields = schema.getGlobalDescribe().get(AsmAvalaraAvaTaxSetting__mdt.getsobjecttype().getDescribe().getname().tolowercase()).getDescribe().fields.getMap();
        STRING fields         = NULL;
        STRING objectClause   = 'AsmAvalaraAvaTaxSetting__mdt';
//        STRING developerName  = ' DeveloperName = ''AsmAvaTaxSettings''';
        STRING developerName  = 'AsmAvaTaxSettings';

        for( STRING field : SourceFields.keySet() ) {
            if(fields == NULL) {
                fields = field;
            } else {
                fields = fields +' ,'+field;
            }
        }

        settingsQuery = 'SELECT '+fields+' FROM AsmAvalaraAvaTaxSetting__mdt WHERE DeveloperName = :developerName LIMIT 1';
        

        return Database.query(settingsQuery);
    }

    // ====================================================================================
    // = getNamedCredentials
    // =
    // = Returns the name of the named credential to use based on whether the org is a 
    // = sandbox org or production org. 
    // ====================================================================================

    public static String getNamedCredentials(Boolean isSandbox, AsmAvalaraAvaTaxSetting__mdt avaTaxSettingsRec) {
        
        return isSandbox ? avaTaxSettingsRec.AsmSandboxNamedCredential__c : avaTaxSettingsRec.AsmProductionNamedCredential__c;
    }

    // ====================================================================================
    // = getCreateTransactionEndPoint
    // =
    // = Returns the end point for the CreateTransaction API to be used in the httpRequest. 
    // ====================================================================================

    public static String getCreateTransactionEndPoint(String namedCredential, AsmAvalaraAvaTaxSetting__mdt asmAvalaraAvaTaxSettingsRec) {

        String endPoint = 'callout:'+namedCredential+asmAvalaraAvaTaxSettingsRec.AsmCreateTransactionEndPoint__c;
        endpoint = asmAvalaraAvaTaxSettingsRec.AsmCreateTransactionIncludeClause__c != null ? endPoint+asmAvalaraAvaTaxSettingsRec.AsmCreateTransactionIncludeClause__c : endPoint;

        return endPoint;
    }

    // ====================================================================================
    // = setupHttpRequest
    // =
    // = Returns an HttpRequest using the values passed into the method 
    // ====================================================================================

    public static httpRequest setupHttpRequest(String httpEndpoint, String httpMethod, MAP <String, String> httpRequestHeaderMap, String httpBody, Integer httpTimeOut){

        system.debug ('Start OAC_HttpRequestApi.setup');
        system.debug ('httpEndpoint: ' + httpEndpoint);
        system.debug ('httpMethod  : ' + httpMethod);

        httpRequest req = new httpRequest();

        if (String.isNotBlank(httpEndpoint)) {
            req.setEndpoint(httpEndpoint);
        }

        if (String.isNotBlank(httpMethod)) {
            req.setMethod(httpMethod);
        }

        if (String.isNotBlank(httpBody)) {
            req.setBody(httpBody);
        }

        if (httpTimeOut != null) {
            req.setTimeout(httpTimeOut);
	    }

        if (!httpRequestHeaderMap.isEmpty()) {
            system.debug('Setting the request Headers');
            Set <String> httpRequestHeaderKeySet = new Set<String>();
            httpRequestHeaderKeySet = httpRequestHeaderMap.keySet();
            for (String httpRequestHeaderKey : httpRequestHeaderKeySet) {
	            system.debug ('httpRequestHeaderKey: ' + httpRequestHeaderKey);
	            system.debug ('httpRequestHeaderVal: ' + httpRequestHeaderMap.get(httpRequestHeaderKey));
                req.setHeader(httpRequestHeaderKey,httpRequestHeaderMap.get(httpRequestHeaderKey));
            }
        }

        return req;

    }

    // ====================================================================================
    // = sendHttpRequest( httpRequest req )
    // =
    // = Send the request you just built and return the response. If this is running in a
    // = test class then return a dummy response. 
    // ====================================================================================

    public static HttpResponse sendHttpRequest( httpRequest request )
    {
        string ResponseBody;
		Http httpPost = new Http();
		HttpResponse response = NULL;
		
		system.debug('request '+request);

		if(Test.isRunningTest() == false) {
			response = httpPost.send(request);
		} else {
			response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			response.setStatus('OK');
			response.setBody('"1234asdasdad2323"');
			response.setStatusCode(200);
			system.debug('response'+response);
			system.debug('response'+response.getBody());
		}

		try {
            ResponseBody = response.getBody();
        } catch (exception e) {
            System.debug('exception' + e);
        }

        return response;
    }

}