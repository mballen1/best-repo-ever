public class ASMShippingPortalComponentController {
	public class ASMShippingException extends Exception {}
	public class SelectOption {
		public SelectOption(System.SelectOption optionIn){
			this.value = optionIn.getValue();
			this.label = optionIn.getLabel();
		}
		public SelectOption(string value, string label){
			this.value = value;
			this.label = label;
		}
		@AuraEnabled public string label {get;private set;}
		@AuraEnabled public string value {get;private set;}
	}

	/*
	 * Private Properties
	 */
	private static OrderApi__Item__c asmSalesTaxItem{
		get {
			if (asmSalesTaxItem == null){
				for (OrderApi__Item__c item :[SELECT Id FROM OrderApi__Item__c WHERE OrderApi__Item_Class__r.Name = 'ASM Sales Tax' LIMIT 1]){
					asmSalesTaxItem = item;
				}
			}
			return asmSalesTaxItem;
		} private set;
	}
	private static AsmShipping_UpsShipper shipper {
		get {
			if (shipper == null)
				shipper = new AsmShipping_UpsShipper(true);
			return shipper;
		} private set;
	}
	private static String shippingCarrierItemId {
		get{
			if (shippingCarrierItemId == null && shipper.upsShippingParms.get('Shipping Carrier Item Id') != null)
				shippingCarrierItemId = shipper.upsShippingParms.get('Shipping Carrier Item Id').value__c;
			return shippingCarrierItemId;
		} private set;
	}
	private static User currentUserInfo {
		get {
			if (currentUserInfo == null)
				currentUserInfo = [SELECT Id, AccountId, ContactId FROM user where id=:UserInfo.getUserId() LIMIT 1][0];
			return currentUserInfo;
		} private set;
	}
	private static Id salesOrderId {
		get {
			if (salesOrderId == null){
				throw new AuraHandledException('SalesOrderId must be passed in and Set');
			}
			return salesOrderId;
		} private set;
	}
	private static OrderApi__Sales_Order__c salesOrder {
		get {
			if (salesOrder == null)
				salesOrder = [SELECT Id, Shipping_Last_Calculated__c, Name, No_of_Shippable_Items__c, OrderApi__Contact__c, OrderApi__Contact__r.Name, Shipping_Package_Length__c, Shipping_Package_Width__c, Shipping_Package_Height__c, Total_Item_Weight__c FROM OrderApi__Sales_Order__c WHERE id = :salesOrderId][0];
			return salesOrder;
		} private set;
	}
	private static List<OrderApi__Sales_Order_Line__c> salesorderLines {
		get {
			if (salesorderLines == null)
				salesorderLines = [SELECT Id, OrderApi__Item__c, OrderApi__Sales_Order__c, OrderApi__Item__r.OrderApi__Item_Class__c, OrderApi__Item__r.Taxable_Item__c, OrderApi__Item__r.Shippable_Item__c, OrderApi__Sale_Price__c, OrderApi__Quantity__c, OrderApi__Price_Override__c, OrderApi__Sales_Order_Line__c FROM OrderApi__Sales_Order_Line__c WHERE OrderApi__Sales_Order__c =:salesOrderId];
			return salesorderLines;
		} private set;
	}
	private static Map<id,OrderApi__Known_Address__c> contactAddressMap {
		get {
			if (contactAddressMap == null){
				contactAddressMap = new Map<Id,OrderApi__Known_Address__c>();
				for (OrderApi__Known_Address__c addr :contactAddresses){
					contactAddressMap.put(addr.Id,addr);
				}
			}
			return contactAddressMap;
		} private set;
	}
	private static List<OrderApi__Known_Address__c> contactAddresses {
		get {
			if (contactAddresses == null)
				contactAddresses = [SELECT Id, OrderApi__Name__c, OrderApi__Is_Default__c, OrderApi__Street__c, OrderApi__City__c, OrderApi__Province__c, OrderApi__Postal_Code__c, OrderApi__Country__c FROM OrderApi__Known_Address__c WHERE OrderApi__Contact__c = :currentUserInfo.ContactId];
			return contactAddresses;
		} private set;
	}
	/*
	 * End Private Properties
	 */

	 /*
	 * Private Methods
	 */
	private static void removeShippingAndTaxLines(){
		List<OrderApi__Sales_Order_Line__c> resultingLines = salesorderLines;
		list<OrderApi__Sales_Order_Line__c> toDelete = new list<OrderApi__Sales_Order_Line__c>();
		for (OrderApi__Sales_Order_Line__c sol : salesorderLines){
			if (shippingCarrierItemId <> NULL && (sol.OrderApi__Item__c == shippingCarrierItemId || sol.OrderApi__Item__c == asmSalesTaxItem.id)){
				toDelete.add(sol);
			}
		}
		if (toDelete.size() > 0)
			delete toDelete;
		salesorderLines = null;
	}
	private static void getShippingRates(OrderApi__Known_Address__c addr){
		shipper.CalculateShipping(addr.OrderApi__City__c, addr.OrderApi__Province__c, addr.OrderApi__Postal_Code__c, addr.OrderApi__Country__c,
			salesOrder.Shipping_Package_Length__c, salesOrder.Shipping_Package_Width__c, salesOrder.Shipping_Package_Height__c, salesOrder.Total_Item_Weight__c);
	}
	/*
	 * End Private Methods
	 */

	 /*
	 * Public Methods
	 */
	public static void clearSalesInfo(){
		salesOrder = null;
		salesorderLines = null;
		contactAddresses = null;
		salesOrderId = null;
		shippingCarrierItemId = null;
		shipper = null;
		asmSalesTaxItem = null;
	}
	@AuraEnabled
	public static Boolean needShipping(id salesOrderId_in){
		salesOrderId = salesOrderId_in;
		system.debug(salesOrder);
		if (salesOrder.Shipping_Last_Calculated__c <> NULL && salesOrder.Shipping_Last_Calculated__c > Datetime.now().addSeconds(-10)){
			return false;
		} else if (salesOrder.No_of_Shippable_Items__c > 0){
			removeShippingAndTaxLines();
			return true;
		}
		return false;
	}
	@AuraEnabled
	public static list<OrderApi__Known_Address__c> getAddresses(){
		return contactAddresses;
	}
	@AuraEnabled
	public static list<SelectOption> getShippingRate(id salesOrderId_in, id addrId){
		salesOrderId = salesOrderId_in;
		List<OrderApi__Known_Address__c> addrs = [SELECT Id, OrderApi__Name__c, OrderApi__Is_Default__c, OrderApi__Street__c, OrderApi__City__c, OrderApi__Province__c, OrderApi__Postal_Code__c, OrderApi__Country__c FROM OrderApi__Known_Address__c WHERE id = :addrId];
		if (addrs.size() > 0){
			list<SelectOption> res = new list<SelectOption>();
			getShippingRates(addrs[0]);
			system.debug(shipper.shippingRatesSelectlistOptions);
			for (System.SelectOption opt : shipper.shippingRatesSelectListOptions){
				res.add(new SelectOption(opt));
			}
			system.debug(shipper.shippingRates);
			return res;
		}
		return new List<SelectOption>{new SelectOption('0', 'In Valid Address')};
	}
	@AuraEnabled
	public static Boolean selectedShippingRate(id salesOrderId_in, string selectedRate, id selectedAddressId){
		salesOrderId = salesOrderId_in;
		if (contactAddressMap.containsKey(selectedAddressId)){
			Decimal taxableAmount = 0;
			Id parentSalesOrderLineId = null;
			List<OrderApi__Sales_Order_Line__c> toInsert = new List<OrderApi__Sales_Order_Line__c>();
			getShippingRates(contactAddressMap.get(selectedAddressId));
			system.debug('SelectedRate: ' + shipper.shippingRates.get(selectedRate));
			system.debug('SelectedAddressId: ' + selectedAddressid);
			removeShippingAndTaxLines();
			OrderAPI__Sales_Order_Line__c targetLine;
			OrderApi__Known_Address__c selectedAddress = contactAddressMap.get(selectedAddressId);
			for (OrderApi__Sales_Order_Line__c sol : salesorderLines){
				if (sol.OrderApi__Item__r.Shippable_Item__c == 'True' && sol.OrderApi__Item__r.Taxable_Item__c) {
					targetLine = sol;
					parentSalesOrderLineId = sol.OrderApi__Sales_Order_Line__c; // any parent sol here should be fine
					taxableAmount += sol.OrderApi__Sale_Price__c * sol.OrderApi__Quantity__c;
				}
			}
			// Create "sales tax" sales order line
			Decimal taxPercentage = shipper.getSalesTaxPercentage(selectedAddress);
			if (asmSalesTaxItem != null && taxableAmount > 0 && taxPercentage > 0) {
				OrderApi__Sales_Order_Line__c salesTaxSol = new OrderApi__Sales_Order_Line__c(
					OrderApi__Item__c = asmSalesTaxItem.Id,
					OrderApi__Sales_Order_Line__c = targetLine == null ? parentSalesOrderLineId : targetLine.Id,
					OrderApi__Sales_Order__c = salesOrderId,
					OrderApi__Sale_Price__c = taxableAmount * (taxPercentage * .01),
					OrderApi__Tax_Override__c = true,         // Used in AsmTrigger_SalesOrder when re-calculating sales tax when promo/source codes are used.
					OrderApi__Tax_Percent__c = taxPercentage, // Used in AsmTrigger_SalesOrder when re-calculating sales tax when promo/source codes are used.
					OrderApi__Quantity__c = 1,
					OrderApi__Price_Override__c = true,
					OrderApi__Calculate_Shipping_Details__c = false,
					OrderApi__Shipping_Contact__c = salesOrder.OrderApi__Contact__c
				);
				toInsert.add(salesTaxSol);
			}
			// Create "shipping" sales order line
			OrderApi__Sales_Order_Line__c shippingSol = new OrderApi__Sales_Order_Line__c(
				OrderApi__Item__c = shippingCarrierItemId,
				OrderApi__Sales_Order__c = salesOrderId,
				OrderApi__Quantity__c = 1,
				OrderApi__Price_Override__c = true,
				OrderApi__Calculate_Shipping_Details__c = false,
				OrderApi__Shipping_Contact__c = salesOrder.OrderApi__Contact__c,
				OrderApi__Shipping_Street__c = selectedAddress.OrderApi__Street__c,
				OrderApi__Shipping_City__c = selectedAddress.OrderApi__City__c,
				OrderApi__Shipping_State__c = selectedAddress.OrderApi__Province__c,
				OrderApi__Shipping_Postal_Code__c = selectedAddress.OrderApi__Postal_Code__c,
				OrderApi__Shipping_Country__c = selectedAddress.OrderApi__Country__c,
				OrderApi__Sales_Order_Line__c = targetLine == null ? parentSalesOrderLineId : targetLine.Id,
				OrderApi__Sale_Price__c = Decimal.valueof(shipper.shippingRates.get(selectedRate))
			);
			toInsert.add(shippingSol);

			if (toInsert.size() > 0)
				insert toInsert;

			// Update sales order
			salesOrder.OrderApi__Calculate_Shipping_Details__c = false;
			salesOrder.OrderApi__Shipping_Contact__c = salesOrder.OrderApi__Contact__r.Name;
			salesOrder.Shipping_Method__c = shipper.serviceCodeToDescriptionMapping.get(selectedRate);
			salesOrder.OrderApi__Shipping_Street__c = selectedAddress.OrderApi__Street__c;
			salesOrder.OrderApi__Shipping_City__c = selectedAddress.OrderApi__City__c;
			salesOrder.OrderApi__Shipping_State__c = selectedAddress.OrderApi__Province__c;
			salesOrder.OrderApi__Shipping_Postal_Code__c = selectedAddress.OrderApi__Postal_Code__c;
			salesOrder.OrderApi__Shipping_Country__c = selectedAddress.OrderApi__Country__c;
			salesOrder.Shipping_Last_Calculated__c = Datetime.now();

			update salesOrder;
			return true;
		} else {
			throw new AuraHandledException('Invalid Address Selected');
		}
	}
	/*
	 * End Public MEthods
	 */
}