public class AsmShipping_StaffViewController {
    private AsmShipping_UpsShipper upsShipper { get; set; }
    private String shippingCarrierItemId { get; set; }
    private String salesOrderId { get; set; }
    private String parentSalesOrderLineId { get; set; }
    public OrderApi__Sales_Order__c salesOrder { get; set; }

    // Shipping select lists
    public String selectedShippingRate { get; set; }
    public List<SelectOption> shippingRatesSelectlistOptions { get; set; }
    public Map<String, String> shippingRates { get; set; } // {shipping code, rate/amount}

    // Address select lists
    public String selectedAddressName { get; set; }
    public List<SelectOption> validAddressSelectlistOptions { get; set; }
    private Map<String, OrderApi__Known_Address__c> validAddresses { get; set; }

    public boolean shippingRequired { get; set; }
    public boolean shippingNotSelectedError { get; set; }
    public boolean validAddressNotFound { get; set; }
    public boolean shippingRateNotFound { get; set; }
    public boolean upsAccountNumberEntered { get; set; }
    public string upsAccountNumber {get; set; }

    public AsmShipping_StaffViewController() {
        this.upsShipper = new AsmShipping_UpsShipper(true);
        this.shippingCarrierItemId = this.upsShipper.upsShippingParms.get('Shipping Carrier Item Id').value__c;
        this.shippingRequired = false;
        this.salesOrderId = ApexPages.currentPage().getParameters().get('id');

        // Shipping select lists
        this.shippingRatesSelectlistOptions = new List<SelectOption>();
        this.shippingRates = new Map<String, String>();

        // Address select lists
        this.validAddressSelectlistOptions = new List<SelectOption>();
        this.validAddresses = new Map<String, OrderApi__Known_Address__c>();

        if (!String.isBlank(this.salesOrderId)) {
            this.salesOrder = [SELECT Id, Name, OrderApi__Account__c, OrderApi__Contact__c, OrderApi__Contact__r.Name, OrderApi__Entity__c, No_of_Shippable_Items__c, Total_Item_Weight__c,
                                      Shipping_Package_Length__c, Shipping_Package_Width__c, Shipping_Package_Height__c
                               FROM OrderApi__Sales_Order__c
                               WHERE Id =: this.salesOrderId];
            if (this.salesOrder != null) {
                // Account addresses for account level orders
                if (this.salesOrder.OrderApi__Entity__c == 'Account') {
                    List<Account> accounts = [SELECT Id, BillingAddress, ShippingAddress, UPS_Account_Number__c
                                              FROM Account
                                              WHERE Id =: this.salesOrder.OrderApi__Account__c];
                    if (accounts.size() > 0) {
                        if(!String.isBlank(accounts[0].UPS_Account_Number__c)) this.upsAccountNumber = accounts[0].UPS_Account_Number__c;

                        if(accounts[0].BillingAddress != null && this.upsShipper.addressIsValid(accounts[0].BillingAddress)) {
                            OrderApi__Known_Address__c ka = ConvertToKnownAddress('billing', accounts[0].BillingAddress);
                            validAddresses.put('billing', ka);
                            this.validAddressSelectlistOptions.add(this.upsShipper.getAddressSelectOption(ka));
                        }
                        if(accounts[0].ShippingAddress != null && this.upsShipper.AddressIsValid(accounts[0].ShippingAddress)) {
                            OrderApi__Known_Address__c ka = ConvertToKnownAddress('shipping', accounts[0].ShippingAddress);
                            validAddresses.put('shipping', ka);
                            this.validAddressSelectlistOptions.add(this.upsShipper.getAddressSelectOption(ka));
                        }
                    }
                }
                // Contact addresses for contact level orders
                else {
                    List<OrderApi__Known_Address__c> contactAddresses = [SELECT Id, OrderApi__Name__c, OrderApi__Is_Default__c, OrderApi__Street__c, OrderApi__City__c, OrderApi__Province__c, OrderApi__Postal_Code__c, OrderApi__Country__c
                                                                  FROM OrderApi__Known_Address__c
                                                                  WHERE OrderApi__Contact__c =: this.salesOrder.OrderApi__Contact__c];
                    System.debug('AsmShipping_StaffViewController contactAddresses.size():' + contactAddresses.size());
                    for (OrderApi__Known_Address__c contactAddress : contactAddresses) {
                        if(this.upsShipper.addressIsValid(contactAddress)) {                        	
                            // Set default selected address
                            if (contactAddress.OrderApi__Is_Default__c) this.selectedAddressName = contactAddress.OrderApi__Name__c;
                            else if (this.selectedAddressName == null) this.selectedAddressName = contactAddress.OrderApi__Name__c;
                            System.debug('AsmShipping_StaffViewController this.selectedAddressName:' + this.selectedAddressName);

                            this.validAddresses.put(contactAddress.OrderApi__Name__c, contactAddress);
                            this.validAddressSelectlistOptions.add(this.upsShipper.getAddressSelectOption(contactAddress));
                        }
                    }
                }
                
                 // Set selected address if unset (works at both the account and contact levels)
                if (String.isBlank(this.selectedAddressName)) {
                    for (String key : validAddresses.keySet()) {
                        OrderApi__Known_Address__c ka = validAddresses.get(key);
                        if (ka.OrderApi__Is_Default__c) {
                            this.selectedAddressName = ka.OrderApi__Name__c;
                            break;
                        }
                        else this.selectedAddressName = ka.OrderApi__Name__c;
                    }
                }                
            }
        }
    }

    public void refreshRates() {
        ApexPages.getMessages().clear();
    }

    // This method is called anytime the address is changed in select list
    public void getShippingRatesForSelectedAddress() {
        this.validAddressNotFound = false;
        this.shippingRateNotFound = false;

        if (!String.isBlank(selectedAddressName)) {
            OrderApi__Known_Address__c selectedAddress = this.validAddresses.get(this.selectedAddressName);
            this.upsShipper.CalculateShipping(selectedAddress.OrderApi__City__c, selectedAddress.OrderApi__Province__c, selectedAddress.OrderApi__Postal_Code__c, selectedAddress.OrderApi__Country__c,
                                              this.salesOrder.Shipping_Package_Length__c, this.salesOrder.Shipping_Package_Width__c, this.salesOrder.Shipping_Package_Height__c,
                                              this.salesOrder.Total_Item_Weight__c);


            // Populate shipping rate select list for address
            this.shippingRatesSelectlistOptions = this.upsShipper.shippingRatesSelectlistOptions;
            this.shippingRates = this.upsShipper.shippingRates;
            if (this.shippingRatesSelectlistOptions.size() == 0) this.shippingRateNotFound = true;
        }
        else {
            this.validAddressNotFound = true;
            this.validAddressSelectlistOptions.add(new SelectOption('', 'No Valid Address Found'));
        }
    }

    // Main page
    public void Start() {
        if (String.isBlank(this.selectedAddressName)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'No valid address found'));
        }
        else if (this.salesOrder != null && this.salesOrder.No_of_Shippable_Items__c > 0) {
            this.shippingRequired = true;
            getShippingRatesForSelectedAddress();
        }
        else { // Shipping is not required
            this.shippingRequired = false;
            if (String.isBlank(this.salesOrderId)) ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cart is empty.'));
            else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Shipping is not required. Click Next to proceed to checkout'));
        }
    }

    public PageReference submit() {
        if (shippingRequired) {
            System.debug('JRB this.upsAccountNumberEntered:' + this.upsAccountNumberEntered);
            System.debug('JRB this.upsAccountNumber:' + this.upsAccountNumber);
            System.debug('JRB this.selectedShippingRate:' + this.selectedShippingRate);
            if (this.upsAccountNumberEntered && String.isBlank(this.upsAccountNumber)) {
                shippingNotSelectedError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'UPS Account Number is required.'));
                return null;
            }
            else if (!this.upsAccountNumberEntered && String.isBlank(selectedShippingRate)){
                shippingNotSelectedError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'A valid shipping option must be selected to proceed further.'));
                return null;
            }

            if (this.upsAccountNumberEntered) {
                Account account = new Account(Id = this.salesOrder.OrderApi__Account__c, UPS_Account_Number__c = this.upsAccountNumber);
                update account;
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

            // Create/Update "sales tax" sales order line
            OrderApi__Known_Address__c selectedAddress = this.validAddresses.get(this.selectedAddressName);
            Decimal taxPercentage = this.upsShipper.getSalesTaxPercentage(selectedAddress);
            System.debug('asmSalesTaxItem.Id: ' + asmSalesTaxItem.Id + ', taxableAmount: ' + taxableAmount + ', taxPercentage: ' + taxPercentage);
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

            // Create/Update shipping sales order line
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
            if (this.upsAccountNumberEntered) shippingSol.OrderApi__Sale_Price__c = 0;
            else shippingSol.OrderApi__Sale_Price__c = Decimal.valueof(this.upsShipper.shippingRates.get(this.selectedShippingRate));
            insert shippingSol;

            // Update sales order
            this.salesOrder.OrderApi__Calculate_Shipping_Details__c = false;
            this.salesOrder.OrderApi__Shipping_Contact__c = this.salesOrder.OrderApi__Contact__r.Name;
            if (this.upsAccountNumberEntered) this.salesOrder.Shipping_Method__c = 'CustomerAcct';
            else this.salesOrder.Shipping_Method__c = this.upsShipper.serviceCodeToDescriptionMapping.get(this.selectedShippingRate);
            this.salesOrder.OrderApi__Shipping_Street__c = selectedAddress.OrderApi__Street__c;
            this.salesOrder.OrderApi__Shipping_City__c = selectedAddress.OrderApi__City__c;
            this.salesOrder.OrderApi__Shipping_State__c = selectedAddress.OrderApi__Province__c;
            this.salesOrder.OrderApi__Shipping_Postal_Code__c = selectedAddress.OrderApi__Postal_Code__c;
            this.SalesOrder.OrderApi__Shipping_Country__c = selectedAddress.OrderApi__Country__c;

            update this.salesOrder;
        }
        else {
            List<OrderApi__Sales_Order_Line__c> shippingSalesOrderLines = [SELECT Id FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Item__c =: this.shippingCarrierItemId AND OrderApi__Sales_Order__c =: this.salesOrderId LIMIT 1];
            if(shippingSalesOrderLines.size() > 0) delete shippingSalesOrderLines[0];
        }

        return new PageReference('/apex/ROEApi__rapidOrderEntry?salesOrder='+ this.salesOrderId);
    }

    public PageReference cancel() {
        return new PageReference('/apex/ROEApi__rapidOrderEntry?salesOrder='+ this.salesOrderId);
    }

    // Simplifies logic to convert all address types to known address types
    private OrderApi__Known_Address__c ConvertToKnownAddress(String name, Address address) {
        OrderApi__Known_Address__c ka = new OrderApi__Known_Address__c();
        ka.OrderApi__Name__c = name;
        ka.OrderApi__Is_Default__c = false;
        ka.OrderApi__Street__c = address.getStreet();
        ka.OrderApi__City__c = address.getCity();
        ka.OrderApi__Province__c = address.getState();
        ka.OrderApi__Postal_Code__c = address.getPostalCode();
        ka.OrderApi__Country__c = address.getCountry();
        return ka;
    }
}