// (c) COPYRIGHT OAC SERVICES, INC. dba Foundry52 2020
// (AND ALL PREVIOUS VERSIONS)
/* ====================================================================
   = AUTHOR      : Michael B. Allen
   = DATE CREATED: July 10, 2020
   = VERSION     : 1.0
   = DESCRIPTION : This class will perform queries to get the source
   =               data and map it to the Avalara AvaTax API data
   =               Model, make the callout to Avalara and then
   =               process the returned message.
   ====================================================================
   = MODIFICATION HISTORY
   ====================================================================

   DATE        NAME           DESCRIPTION
   --------------------------------------------------------------------
   DD MON YY   F.LAST         DESCRIPTION OF MODIFICATION
   ====================================================================
   ====================================================================
*/

public class AsmAvaTaxDocuments {

    public Static Organization organizationRec = AsmAvaTaxUtilities.getOrganizationDetails();
    public Static AsmAvalaraAvaTaxSetting__mdt asmAvalaraAvaTaxSettingsRec = AsmAvaTaxUtilities.getAvaTaxSettings();
    public Static String namedCredential = AsmAvaTaxUtilities.getNamedCredentials(organizationRec.isSandbox,asmAvalaraAvaTaxSettingsRec);
    public Static Map <String,String> httpRequestHeaderMap = new Map <String, String>{'Content-Type' => 'application/json', 'Accept' => 'application/json'};
/*
    public AsmAvaTaxDocuments (Organization organizationRec, AsmAvalaraAvaTaxSetting__mdt asmAvalaraAvaTaxSettingsRec, String namedCredential, Map <String,String> httpRequestHeaderMap) {
        this.organizationRec = organizationRec; //AsmAvaTaxUtilities.getOrganizationDetails();
        this.asmAvalaraAvaTaxSettingsRec = asmAvalaraAvaTaxSettingsRec; //AsmAvaTaxUtilities.getAvaTaxSettings();
        this.namedCredential = namedCredential; //AsmAvaTaxUtilities.getNamedCredentials(organizationRec.isSandbox,asmAvalaraAvaTaxSettingsRec);
        this.httpRequestHeaderMap = httpRequestHeaderMap; //new Map <String, String>{'Content-Type' => 'application/json', 'Accept' => 'application/json'};
    }
*/
    // ====================================================================================
    // = getSalesOrderTax
    // =
    // = This method will take the sales order passed into it and create the JSON message
    // = for the CreateTransaction API
    // ====================================================================================

    public static void getSalesOrderTax(OrderApi__Sales_Order__c salesOrderRec, Boolean commitTax, Boolean isBatch){

        System.debug('organizationRec: '+organizationRec);
        System.debug('asmAvalaraAvaTaxSettingsRec: '+asmAvalaraAvaTaxSettingsRec);
        System.debug('namedCredential: '+namedCredential);
        System.debug('httpRequestHeaderMap: '+httpRequestHeaderMap);
        system.debug('salesOrderRec.Id: '+salesOrderRec.Id);
        system.debug('salesOrderRec.Name: '+salesOrderRec.Name);
        system.debug('salesOrderRec.OrderApi__Shipping_Street__c: '+salesOrderRec.OrderApi__Shipping_Street__c);
        system.debug('salesOrderRec.OrderApi__Shipping_City__c: '+salesOrderRec.OrderApi__Shipping_City__c);
        system.debug('salesOrderRec.OrderApi__Shipping_State__c: '+salesOrderRec.OrderApi__Shipping_State__c);
        system.debug('salesOrderRec.OrderApi__Shipping_Postal_Code__c: '+salesOrderRec.OrderApi__Shipping_Postal_Code__c);
        system.debug('salesOrderRec.OrderApi__Shipping_Country__c: '+salesOrderRec.OrderApi__Shipping_Country__c);
        
        // ====================================================================================
        // = Create some variables to be used later in this method
        // ====================================================================================

        AsmCreateTransactionJSONReq.CreateTransaction createTransaction = new AsmCreateTransactionJSONReq.CreateTransaction();
        LIST <AsmCreateTransactionJSONReq.Lines> linesList = new LIST <AsmCreateTransactionJSONReq.Lines>();
        AsmCreateTransactionJSONReq.Addresses headerAddressesRec = new AsmCreateTransactionJSONReq.Addresses();
        AsmCreateTransactionJSONReq.ShipTo shipToRec = new AsmCreateTransactionJSONReq.ShipTo();
        AsmCreateTransactionJSONReq.Lines linesRec = new AsmCreateTransactionJSONReq.Lines();
        AsmCreateTransactionJSONReq.Addresses lineAddressesRec = new AsmCreateTransactionJSONReq.Addresses();
        AsmCreateTransactionJSONReq.ShipFrom shipFromRec = new AsmCreateTransactionJSONReq.ShipFrom();

        // ====================================================================================
        // = When committing a sales order transaction we pass the Posted Date otherwise we
        // = pass the Closed Date.
        // ====================================================================================

        DateTime documentDate = commitTax ? salesOrderRec.OrderApi__Posted_Date__c : salesOrderRec.OrderApi__Closed_Date__c;

        // ====================================================================================
        // = Using the sales order passed in set the values in the JSON request
        // = First the document header information
        // ====================================================================================

        createTransaction.code              = salesOrderRec.Name;
        createTransaction.documentType      = asmAvalaraAvaTaxSettingsRec.AsmCreateTransactionGetTaxDocumentType__c;
        createTransaction.documentDate      = documentDate;
        createTransaction.companyCode       = asmAvalaraAvaTaxSettingsRec.AsmDefaultAvalaraCompanyCode__c;
        createTransaction.customerCode      = salesOrderRec.OrderApi__Account__r.Account_Number__c != null ? salesOrderRec.OrderApi__Account__r.Account_Number__c : null;
        createTransaction.entityUseCode     = salesOrderRec.OrderApi__Contact__r.Account.Asm_Entity_Use_Code__c;
        createTransaction.purchaseOrderNo   = salesOrderRec.OrderApi__Customer_Reference_Number__c;
        createTransaction.referenceCode     = salesOrderRec.Name;

        // ====================================================================================
        // = So here we are deciding to commit or not commit the transaction in Avalara based
        // = on the boolen passed in as an argument. 
        // ====================================================================================

        createTransaction.commitBoolean = commitTax;

        // ====================================================================================
        // = The ship to address is always pulled from the sales order object. After assigning
        // = the values to the various fields in the shipToRec we then assign that variable
        // = to the shipTo construct on the headerAddressesRec which in turn gets assigned to 
        // = the addresses construct on the createTransaction model.
        // ====================================================================================

        shipToRec.line1      = salesOrderRec.OrderApi__Shipping_Street__c != null ? salesOrderRec.OrderApi__Shipping_Street__c : null;
        shipToRec.city       = salesOrderRec.OrderApi__Shipping_City__c;
        shipToRec.region     = salesOrderRec.OrderApi__Shipping_State__c;
        shipToRec.country    = salesOrderRec.OrderApi__Shipping_Country__c;
        shipToRec.postalCode = salesOrderRec.OrderApi__Shipping_Postal_Code__c;

        system.debug('shipToRec: '+shipToRec);

        headerAddressesRec.shipTo = shipToRec;
        system.debug('headerAddressesRec.shipTo: '+headerAddressesRec.shipTo);
        createTransaction.addresses = headerAddressesRec;

        // ====================================================================================
        // = Now we load up the lines for the transaction.
        // ====================================================================================

        List <OrderApi__Sales_Order_Line__c> salesOrderLineList = new List<OrderApi__Sales_Order_Line__c>(salesOrderRec.OrderApi__Sales_Order_Lines__r);
        for (OrderApi__Sales_Order_Line__c salesOrderLineRec : salesOrderLineList) {

            linesRec.lineNumber     = salesOrderLineRec.Name;
            linesRec.quantity       = salesOrderLineRec.OrderApi__Quantity__c;
            linesRec.amount         = salesOrderLineRec.OrderApi__Subtotal__c;
            linesRec.taxCode        = salesOrderLineRec.OrderApi__Item__r.Asm_External_Tax_Code__c != null ? salesOrderLineRec.OrderApi__Item__r.Asm_External_Tax_Code__c : 'P';
            linesRec.itemCode       = salesOrderLineRec.OrderApi__Item__r.OrderApi__SKU__c;
            linesRec.discounted     = false;
            linesRec.taxIncluded    = false;
            linesRec.ref1           = salesOrderLineRec.Id;
            linesRec.description    = salesOrderLineRec.OrderApi__Item__r.Name;

            // ====================================================================================
            // = The ship from is handled at the line level because the "fulfiller" of different
            // = items on the transaction can be different.
            // = If there is no item on the line or the item does not have a fulfiller on it then
            // = pull the ship from address from the organization otherwise get it from the
            // = fulfiller object.
            // ====================================================================================

            shipFromRec.Line1       = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.Address1__c : organizationRec.Street;
            shipFromRec.Line2       = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.Address2__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.Address2__c : null;
            shipFromRec.City        = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.City__c : organizationRec.City;
            shipFromRec.Region      = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.State_Province__c : organizationRec.State;
            shipFromRec.postalCode  = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.Zip_Postal_Code__c : organizationRec.PostalCode;
            shipFromRec.country     = String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__c)) && String.isNotBlank(String.valueOf(salesOrderLineRec.OrderApi__Item__r.Fulfiller__c)) ?
                                      salesOrderLineRec.OrderApi__Item__r.Fulfiller__r.Country__c : organizationRec.Country;

            // ====================================================================================
            // = Now that we have set our shipFromRec we add it to the shipFrom construct on the
            // = lineAddressesRec and then add that to the addresses construct on the line
            // ====================================================================================

            lineAddressesRec.shipFrom = shipFromRec;
            linesRec.addresses = lineAddressesRec;
            linesList.add(linesRec);
        }

            // ====================================================================================
            // = We have our lines set so we now need to assign them to the lines construct on the 
            // = createTransactions model. After that we can create our JSON message.
            // ====================================================================================

            createTransaction.lines = linesList;
            String jsonString = AsmCreateTransactionJSONReq.generateCreateTransactionJSON(createTransaction);
            system.debug (jsonString);

            String endPoint = AsmAvaTaxUtilities.getCreateTransactionEndPoint(namedCredential,asmAvalaraAvaTaxSettingsRec);
            Integer httpTimeout = asmAvalaraAvaTaxSettingsRec.AsmhttpTimeout__c != null ? asmAvalaraAvaTaxSettingsRec.AsmhttpTimeout__c.intValue() : null;
            httpRequest createTransactionHttpRequest = AsmAvaTaxUtilities.setupHttpRequest (endPoint,asmAvalaraAvaTaxSettingsRec.AsmCreateTransactionMethod__c,httpRequestHeaderMap,JSONString,httpTimeout);

            // ====================================================================================
            // = Time to send the Http request to the API
            // ====================================================================================

            HTTP httpRequest = new HTTP();
            HTTPResponse resposneMessage = httpRequest.send(createTransactionHttpRequest);
            System.debug(resposneMessage);
            System.debug(resposneMessage.getBody());

            if (resposneMessage.getStatusCode() >= 200 && resposneMessage.getStatusCode() < 300) {
                AsmCreateTransactionJSONResp jsonResponse = AsmCreateTransactionJSONResp.parse (resposneMessage.getBody());
                processSalesOrderResponse(jsonResponse,salesOrderRec,isBatch);
            } else {
                AsmAvaTaxErrorJSONResp jsonResponse = AsmAvaTaxErrorJSONResp.parse (resposneMessage.getBody());
                processSalesOrderErrorResponse(jsonResponse,salesOrderRec,isBatch);
            }            
    
    }

    // ====================================================================================
    // = processSalesOrderResponse
    // =
    // = Updates the sales order with the tax information sent back from Avalara AvaTax 
    // ====================================================================================

    public static void processSalesOrderResponse(AsmCreateTransactionJSONResp jsonResponse, OrderApi__Sales_Order__c salesOrderRec, Boolean isBatch) {

        String jsonRespString = JSON.serializePretty(jsonResponse);
        Double totalTaxRate = 0.0;

        // ====================================================================================
        // = Create a Map of the sales order line Ids to the sales order line record so that we
        // = can use the line id passed to and returned from Avalara to get to the correct
        // = sales order line for updating.
        // ====================================================================================

        Map <Id,OrderApi__Sales_Order_Line__c> salesOrderLineIdTosalesOrderLineRecMap = new Map <id,OrderApi__Sales_Order_Line__c>();
        List <OrderApi__Sales_Order_Line__c> salesOrderLineList = new List<OrderApi__Sales_Order_Line__c>(salesOrderRec.OrderApi__Sales_Order_Lines__r);
        for (OrderApi__Sales_Order_Line__c salesOrderLineRec : salesOrderLineList) {
            salesOrderLineIdTosalesOrderLineRecMap.put(salesOrderLineRec.id,salesOrderLineRec);
        }

        // ====================================================================================
        // = Let's set the sales order header field values
        // ====================================================================================

        salesOrderRec.Asm_AvaTax_JSON_return_message__c = jsonRespString != null ? jsonRespString : null;
        salesOrderRec.Asm_AvaTax_Error_Message__c = null;
        salesOrderRec.Asm_AvaTax_Status__c = 'Taxed';
        salesOrderRec.Asm_AvaTax_Tax_Date__c = Datetime.now();

        // ====================================================================================
        // = Loop through the lines in the Avalara response message setting the line level
        // = tax status and tax amount.
        // ====================================================================================

        for (Integer i = 0; i < jsonResponse.lines.size(); i++ ) {

            OrderApi__Sales_Order_Line__c salesOrderLineRec = new OrderApi__Sales_Order_Line__c();
            Double taxRate = 0.0;
            salesOrderLineRec = salesOrderLineIdTosalesOrderLineRecMap.get(jsonResponse.lines[i].ref1);
            salesOrderLineRec.Asm_AvaTax_Tax_Status__c = jsonResponse.status == 'Committed' ? 'Committed' : 'Taxed';
            salesOrderLineRec.OrderApi__Tax_Amount__c = jsonResponse.lines[i].tax;

            // ====================================================================================
            // = Loop through the line details in the Avalara response message and sum up the 
            // = tax rate for each jurisdiction.
            // ====================================================================================

            for (Integer d = 0; d < jsonResponse.lines[i].details.size(); d++) {
                taxRate = taxRate + jsonResponse.lines[i].details[d].rate;
            }

            // ====================================================================================
            // = Add the accumulated taxRate for the line to the total order tax rate and set the
            // = value in the summary tax rate on the line.
            // ====================================================================================

            totalTaxRate = totalTaxRate + taxRate;
            salesOrderLineRec.Asm_AvaTax_Summary_Tax_Rate__c = taxRate;

        }

        if (salesOrderRec != null) {
            update salesOrderRec;
        }
        
        if (!salesOrderLineIdTosalesOrderLineRecMap.values().isEmpty()) {
            upsert salesOrderLineIdTosalesOrderLineRecMap.values();
        }

    }

    // ====================================================================================
    // = processSalesOrderErrorResponse
    // =
    // = Updates the sales order with the error information sent back from Avalara AvaTax 
    // ====================================================================================

    public static void processSalesOrderErrorResponse(AsmAvaTaxErrorJSONResp jsonResponse, OrderApi__Sales_Order__c salesOrderRec, Boolean isBatch) {

        system.debug ('Start AsmAvaTaxDocuments.processSalesOrderErrorResponse ');

        String jsonRespString = JSON.serializePretty(jsonResponse);
        String errorMessage = null;

        for (AsmAvaTaxErrorJSONResp.Details jsonResponseDetailRec : jsonResponse.error.details) {
            errorMessage = errorMessage == null ? jsonResponseDetailRec.message + '-' + jsonResponseDetailRec.description : errorMessage + ', ' + jsonResponseDetailRec.message + '-' + jsonResponseDetailRec.description;
        }

        if (!isBatch) {
            ApexPages.Message apexPageErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
            ApexPages.addMessage(apexPageErrorMessage);      
        }

        salesOrderRec.Asm_AvaTax_JSON_return_message__c = jsonRespString != null ? jsonRespString : null;
        salesOrderRec.Asm_AvaTax_Error_Message__c = errorMessage;
        salesOrderRec.Asm_AvaTax_Status__c = 'Error';
        salesOrderRec.Asm_AvaTax_Tax_Date__c = Datetime.now();

        List <OrderApi__Sales_Order_Line__c> salesOrderLineList = new List<OrderApi__Sales_Order_Line__c>(salesOrderRec.OrderApi__Sales_Order_Lines__r);
        for (OrderApi__Sales_Order_Line__c salesOrderLineRec : salesOrderLineList) {
            salesOrderLineRec.Asm_AvaTax_Tax_Status__c = 'Error';
        }

        system.debug ('AsmAvaTaxDocuments.processSalesOrderErrorResponse - update salesOrderRec');
        update salesOrderRec;

        if (!salesOrderLineList.isEmpty()) {
            system.debug ('AsmAvaTaxDocuments.processSalesOrderErrorResponse - update salesOrderLineList');
            update salesOrderLineList;
        }

        system.debug ('End AsmAvaTaxDocuments.processSalesOrderErrorResponse ');

    }

}