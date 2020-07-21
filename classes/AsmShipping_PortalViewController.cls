public class AsmShipping_PortalViewController {
    private AsmShipping_UpsShipper upsShipper { get; set; }
    private String shippingCarrierItemId { get; set; }
    private String salesOrderId { get; set; }
    private OrderApi__Sales_Order__c salesOrder { get; set; }
    
    // Shipping select lists
    public String selectedShippingRate { get; set; }
    public List<SelectOption> shippingRatesSelectlistOptions { get; set; }
    public Map<String, String> shippingRates { get; set; } // {shipping code, rate/amount}
    
    // Address select lists
    public String selectedAddressName { get; set; }
    private Map<String, OrderApi__Known_Address__c> validAddresses { get; set; }
    public List<SelectOption> validAddressesSelectlistOptions { get; set; }
    
    public boolean shippingRequired { get; set; }
    public boolean hideShipping { get; set; }
    public boolean shippingNotSelectedError { get; set; }
    public boolean validAddressNotFound { get; set; }
    public boolean shippingRateNotFound { get; set; }
    public String hostName { get; set; }

    String stepId;
    joinApi.JoinUtils joinUtil;

    public AsmShipping_PortalViewController() {
        this.upsShipper = new AsmShipping_UpsShipper(true);
        this.shippingCarrierItemId = this.upsShipper.upsShippingParms.get('Shipping Carrier Item Id').value__c;
        this.hostName = ApexPages.currentPage().getHeaders().get('Host');
        
        this.shippingRequired = false;
        this.salesOrderId = getSalesOrderIdFromCookie();
        
        // Shipping select lists
        this.shippingRatesSelectlistOptions = new List<SelectOption>();
        this.shippingRates = new Map<String, String>();
        
        // Address select lists
        this.validAddressesSelectlistOptions = new List<SelectOption>();
        this.validAddresses = new Map<String, OrderApi__Known_Address__c>();
        
        if (!String.isBlank(this.salesOrderId)) {
            this.salesOrder = [SELECT Id, Name, No_of_Shippable_Items__c, OrderApi__Contact__c, OrderApi__Contact__r.Name,
                                      Shipping_Package_Length__c, Shipping_Package_Width__c, Shipping_Package_Height__c, Total_Item_Weight__c
                               FROM OrderApi__Sales_Order__c
                               WHERE Id =: this.salesOrderId];
            if (this.salesOrder != null) {
                // Populate address select box
                List<OrderApi__Known_Address__c> contactAddresses = [SELECT Id, OrderApi__Name__c, OrderApi__Is_Default__c, OrderApi__Street__c, OrderApi__City__c, OrderApi__Province__c, OrderApi__Postal_Code__c, OrderApi__Country__c
                                         FROM OrderApi__Known_Address__c
                                         WHERE OrderApi__Contact__c =: this.salesOrder.OrderApi__Contact__c];
                System.debug('JRB contactAddresses.size():' + contactAddresses.size());
                for (OrderApi__Known_Address__c contactAddress : contactAddresses) {
                    if(this.upsShipper.addressIsValid(contactAddress)) {
                        // Set default selected address
                        if (contactAddress.OrderApi__Is_Default__c) this.selectedAddressName = contactAddress.OrderApi__Name__c;
                        else if (this.selectedAddressName == null) this.selectedAddressName = contactAddress.OrderApi__Name__c;
                        
                        this.validAddresses.put(contactAddress.OrderApi__Name__c, contactAddress);
                        this.validAddressesSelectlistOptions.add(this.upsShipper.GetAddressSelectOption(contactAddress));
                    }
                }
            }
        }
        
        this.stepId = Framework.PageUtils.getParam('id');
        this.joinUtil = new joinApi.JoinUtils(stepId);
    }

    // This method is called anytime the address is changed in select list
    public void getShippingRatesForSelectedAddress() {
        this.validAddressNotFound = false;
        this.shippingRateNotFound = false;
        
        // Get shipping
        if (!String.isBlank(selectedAddressName)) {
            OrderApi__Known_Address__c selectedAddress = this.validAddresses.get(this.selectedAddressName);
            this.upsShipper.CalculateShipping(selectedAddress.OrderApi__City__c, selectedAddress.OrderApi__Province__c, selectedAddress.OrderApi__Postal_Code__c, selectedAddress.OrderApi__Country__c,
                                              this.salesOrder.Shipping_Package_Length__c, this.salesOrder.Shipping_Package_Width__c, this.salesOrder.Shipping_Package_Height__c,
                                              this.salesOrder.Total_Item_Weight__c);
        
            // Populate shipping rate select list for address
            this.shippingRatesSelectlistOptions = this.upsShipper.shippingRatesSelectlistOptions;
            this.shippingRates = this.upsShipper.shippingRates;
            if (this.shippingRatesSelectlistOptions.size() < 1) this.shippingRateNotFound = true;
        }
        else {
            this.validAddressNotFound = true;
            this.validAddressesSelectlistOptions.add(new SelectOption('', 'No Valid Address Found'));         
        }
    }
    
    // Main page
    public PageReference Start() {
        if (this.salesOrder != null && this.salesOrder.No_of_Shippable_Items__c > 0) {
            this.shippingRequired = true;
            getShippingRatesForSelectedAddress();

            // Remove any shipping sales order lines
            List<OrderApi__Sales_Order_Line__c> shippingSalesOrderLines = [SELECT Id FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__c =: shippingCarrierItemId AND OrderApi__Sales_Order__c =: this.salesOrderId LIMIT 1];
            if(shippingSalesOrderLines.size() > 0) delete shippingSalesOrderLines[0];

            return null;
        }
        else { // Shipping is not required
            this.hideShipping = true;
            if (this.salesOrder == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cart is empty.'));
                return null;
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Shipping is not required. Click Next to proceed to checkout'));
                
                this.stepId = Framework.PageUtils.getParam('id');
                this.joinUtil = new joinApi.JoinUtils(stepId);
                String redirectURL = this.joinUtil.navStepsMap.get('Next');
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('stepId', this.stepId);
                gen.writeStringField('redirectURL', redirectURL);
                gen.writeEndObject();
                PageReference pageRef = new PageReference(redirectURL);
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
    }

    public PageReference previousStep() {
        return new PageReference(joinUtil.getPreviousStep('{}'));
    }

    // Handles post request
    public PageReference nextStep() {
        if (this.shippingRequired) {
            if (String.IsBlank(this.selectedShippingRate)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'A valid shipping option must be selected to proceed further.'));
                shippingNotSelectedError = true;
                return null;
            }

            // Get then delete any existing shipping and sales tax (sales order lines)
            // Calculate amount to be taxed for taxable items. Only shippable items are taxable per Diane.
            // Get parent sales order line. Prevents Fonteva's logic from overwriting shipping address on the sol 
            Decimal taxableAmount = 0;
            Id parentSalesOrderLineId = null;
            List<OrderApi__Sales_Order_Line__c> shippingSols = new List<OrderApi__Sales_Order_Line__c>();
            List<OrderApi__Sales_Order_Line__c> salesTaxSols = new List<OrderApi__Sales_Order_Line__c>();
            OrderApi__Item__c asmSalesTaxItem = [SELECT Id FROM OrderApi__Item__c WHERE OrderApi__Item_Class__r.Name = 'ASM Sales Tax' LIMIT 1];            
            List<OrderApi__Sales_Order_Line__c> sols = [SELECT Id, OrderApi__Item__c, OrderApi__Item__r.OrderApi__Item_Class__c, OrderApi__Item__r.Taxable_Item__c, OrderApi__Item__r.Shippable_Item__c, OrderApi__Sales_Order__c, OrderApi__Sale_Price__c, OrderApi__Quantity__c, OrderApi__Price_Override__c, OrderApi__Sales_Order_Line__c
                                                        FROM OrderApi__Sales_Order_Line__c
                                                        WHERE OrderApi__Sales_Order__c =: this.salesOrderId];
            for (OrderApi__Sales_Order_Line__c sol : sols) {
                if (sol.OrderApi__Item__c == shippingCarrierItemId) shippingSols.add(sol);
                else if (sol.OrderApi__Item__c == asmSalesTaxItem.Id) salesTaxSols.add(sol);
                else if (sol.OrderApi__Item__r.Shippable_Item__c == 'True' && sol.OrderApi__Item__r.Taxable_Item__c) {
                    parentSalesOrderLineId = sol.OrderApi__Sales_Order_Line__c; // any parent sol here should be fine
                    taxableAmount += sol.OrderApi__Sale_Price__c * sol.OrderApi__Quantity__c;
                }
            }
            delete shippingSols;
            delete salesTaxSols;
            
            // Create "sales tax" sales order line
            OrderApi__Known_Address__c selectedAddress = this.validAddresses.get(this.selectedAddressName);
            Decimal taxPercentage = this.upsShipper.getSalesTaxPercentage(selectedAddress);
            if (asmSalesTaxItem != null && taxableAmount > 0 && taxPercentage > 0) {
                OrderApi__Sales_Order_Line__c salesTaxSol = new OrderApi__Sales_Order_Line__c();
                salesTaxSol.OrderApi__Item__c = asmSalesTaxItem.Id;
                salesTaxSol.OrderApi__Sales_Order__c = this.salesOrderId;
                salesTaxSol.OrderApi__Sale_Price__c = taxableAmount * (taxPercentage * .01);
                salesTaxSol.OrderApi__Tax_Override__c = true;         // Used in AsmTrigger_SalesOrder when re-calculating sales tax when promo/source codes are used.
                salesTaxSol.OrderApi__Tax_Percent__c = taxPercentage; // Used in AsmTrigger_SalesOrder when re-calculating sales tax when promo/source codes are used.                
                salesTaxSol.OrderApi__Quantity__c = 1;
                salesTaxSol.OrderApi__Price_Override__c = true;
                salesTaxSol.OrderApi__Calculate_Shipping_Details__c = false;
                salesTaxSol.OrderApi__Shipping_Contact__c = this.salesOrder.OrderApi__Contact__c;
                insert salesTaxSol;
            }
            System.Debug('JRB2 this.selectedShippingRate:' + this.selectedShippingRate);
            // Create "shipping" sales order line
            OrderApi__Sales_Order_Line__c shippingSol = new OrderApi__Sales_Order_Line__c();
            shippingSol.OrderApi__Item__c = this.shippingCarrierItemId;
            shippingSol.OrderApi__Sales_Order__c = this.salesOrderId;
            shippingSol.OrderApi__Quantity__c = 1;
            shippingSol.OrderApi__Price_Override__c = true;
            shippingSol.OrderApi__Calculate_Shipping_Details__c = false;
            shippingSol.OrderApi__Shipping_Contact__c = this.salesOrder.OrderApi__Contact__c;
            shippingSol.OrderApi__Shipping_Street__c = selectedAddress.OrderApi__Street__c;
            shippingSol.OrderApi__Shipping_City__c = selectedAddress.OrderApi__City__c;
            shippingSol.OrderApi__Shipping_State__c = selectedAddress.OrderApi__Province__c;
            shippingSol.OrderApi__Shipping_Postal_Code__c = selectedAddress.OrderApi__Postal_Code__c;
            shippingSol.OrderApi__Shipping_Country__c = selectedAddress.OrderApi__Country__c;
            shippingSol.OrderApi__Sales_Order_Line__c = parentSalesOrderLineId;
            shippingSol.OrderApi__Sale_Price__c = Decimal.valueof(this.upsShipper.shippingRates.get(this.selectedShippingRate));
            insert shippingSol;

            // Update sales order
            this.salesOrder.OrderApi__Calculate_Shipping_Details__c = false;
            this.salesOrder.OrderApi__Shipping_Contact__c = this.salesOrder.OrderApi__Contact__r.Name;
            this.salesOrder.Shipping_Method__c = this.upsShipper.serviceCodeToDescriptionMapping.get(this.selectedShippingRate);
            this.salesOrder.OrderApi__Shipping_Street__c = selectedAddress.OrderApi__Street__c;
            this.salesOrder.OrderApi__Shipping_City__c = selectedAddress.OrderApi__City__c;
            this.salesOrder.OrderApi__Shipping_State__c = selectedAddress.OrderApi__Province__c;
            this.salesOrder.OrderApi__Shipping_Postal_Code__c = selectedAddress.OrderApi__Postal_Code__c;
            this.salesOrder.OrderApi__Shipping_Country__c = selectedAddress.OrderApi__Country__c;

            update this.salesOrder;
        }
        else {
            List<OrderApi__Sales_Order_Line__c> shippingSalesOrderLines = [SELECT Id FROM OrderApi__Sales_Order_Line__c where OrderApi__Item__c =: shippingCarrierItemId AND OrderApi__Sales_Order__c =: this.salesOrderId LIMIT 1];
            if(shippingSalesOrderLines.size() > 0) delete shippingSalesOrderLines[0];
        }
        
        String redirectURL = this.joinUtil.navStepsMap.get('Next');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('stepId', stepId);
        gen.writeStringField('redirectURL', redirectURL);
        gen.writeEndObject();
        return new PageReference(redirectURL);
    }

    public PageReference cancel() {
        this.joinUtil.deleteCookies();
        return new PageReference(this.joinUtil.navStepsMap.get('First'));
    }

    public String getSalesOrderIdFromCookie() {
        String cookieName = UserInfo.getOrganizationId() + '-fonteva-shopping-cart';
        
        if (ApexPages.currentPage().getCookies().get(cookieName) != null){
            Map<String, Object> fontevaCartExistingCookie = (Map<String, Object>)JSON.deserializeUntyped(ApexPages.currentPage().getCookies().get(cookieName).getValue());            
            if(fontevaCartExistingCookie.containsKey('salesOrderId')) return fontevaCartExistingCookie.get('salesOrderId') + ''; // need the space appended for some odd reason.
        }
        return null;
    }
}