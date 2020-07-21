// (c) COPYRIGHT OAC SERVICES, INC. dba Foundry52 2020
// (AND ALL PREVIOUS VERSIONS)
/* ====================================================================
   = AUTHOR      : Michael B. Allen
   = DATE CREATED: July 16, 2020
   = VERSION     : 1.0
   = DESCRIPTION : This class will creates the structures needed for
   =               the Avalara CreateTransaction JSON REST API response
   ====================================================================
   = MODIFICATION HISTORY
   ====================================================================

   DATE        NAME           DESCRIPTION
   --------------------------------------------------------------------
   DD MON YY   F.LAST         DESCRIPTION OF MODIFICATION
   ====================================================================
   ====================================================================
*/

public class AsmCreateTransactionJSONResp {

	public class Addresses {
		public Integer id {get;set;} 
		public Integer transactionId {get;set;} 
		public String boundaryLevel {get;set;} 
		public String line1 {get;set;} 
		public String line2 {get;set;} 
		public String line3 {get;set;} 
		public String city {get;set;} 
		public String region {get;set;} 
		public String postalCode {get;set;} 
		public String country {get;set;} 
		public Integer taxRegionId {get;set;} 
		public String latitude {get;set;} 
		public String longitude {get;set;} 

		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'transactionId') {
							transactionId = parser.getIntegerValue();
						} else if (text == 'boundaryLevel') {
							boundaryLevel = parser.getText();
						} else if (text == 'line1') {
							line1 = parser.getText();
						} else if (text == 'line2') {
							line2 = parser.getText();
						} else if (text == 'line3') {
							line3 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'region') {
							region = parser.getText();
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'taxRegionId') {
							taxRegionId = parser.getIntegerValue();
						} else if (text == 'latitude') {
							latitude = parser.getText();
						} else if (text == 'longitude') {
							longitude = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TaxSubTypeDetails {
		public String taxSubType {get;set;} 
		public Integer totalTaxable {get;set;} 
		public Double totalExempt {get;set;} 
		public Double totalNonTaxable {get;set;} 
		public Double totalTax {get;set;} 

		public TaxSubTypeDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'taxSubType') {
							taxSubType = parser.getText();
						} else if (text == 'totalTaxable') {
							totalTaxable = parser.getIntegerValue();
						} else if (text == 'totalExempt') {
							totalExempt = parser.getDoubleValue();
						} else if (text == 'totalNonTaxable') {
							totalNonTaxable = parser.getDoubleValue();
						} else if (text == 'totalTax') {
							totalTax = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'TaxSubTypeDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Details {
		public Integer id {get;set;} 
		public Integer transactionLineId {get;set;} 
		public Integer transactionId {get;set;} 
		public Integer addressId {get;set;} 
		public String country {get;set;} 
		public String region {get;set;} 
		public String stateFIPS {get;set;} 
		public Double exemptAmount {get;set;} 
		public Integer exemptReasonId {get;set;} 
		public Boolean inState {get;set;} 
		public String jurisCode {get;set;} 
		public String jurisName {get;set;} 
		public Integer jurisdictionId {get;set;} 
		public String signatureCode {get;set;} 
		public String stateAssignedNo {get;set;} 
		public String jurisType {get;set;} 
		public String jurisdictionType {get;set;} 
		public Double nonTaxableAmount {get;set;} 
		public Integer nonTaxableRuleId {get;set;} 
		public String nonTaxableType {get;set;} 
		public Double rate {get;set;} 
		public Integer rateRuleId {get;set;} 
		public Integer rateSourceId {get;set;} 
		public String serCode {get;set;} 
		public String sourcing {get;set;} 
		public Double tax {get;set;} 
		public Integer taxableAmount {get;set;} 
		public String taxType {get;set;} 
		public String taxSubTypeId {get;set;} 
		public String taxTypeGroupId {get;set;} 
		public String taxName {get;set;} 
		public Integer taxAuthorityTypeId {get;set;} 
		public Integer taxRegionId {get;set;} 
		public Double taxCalculated {get;set;} 
		public Double taxOverride {get;set;} 
		public String rateType {get;set;} 
		public String rateTypeCode {get;set;} 
		public Double taxableUnits {get;set;} 
		public Double nonTaxableUnits {get;set;} 
		public Double exemptUnits {get;set;} 
		public String unitOfBasis {get;set;} 
		public Boolean isNonPassThru {get;set;} 
		public Boolean isFee {get;set;} 

		public Details(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'transactionLineId') {
							transactionLineId = parser.getIntegerValue();
						} else if (text == 'transactionId') {
							transactionId = parser.getIntegerValue();
						} else if (text == 'addressId') {
							addressId = parser.getIntegerValue();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'region') {
							region = parser.getText();
						} else if (text == 'stateFIPS') {
							stateFIPS = parser.getText();
						} else if (text == 'exemptAmount') {
							exemptAmount = parser.getDoubleValue();
						} else if (text == 'exemptReasonId') {
							exemptReasonId = parser.getIntegerValue();
						} else if (text == 'inState') {
							inState = parser.getBooleanValue();
						} else if (text == 'jurisCode') {
							jurisCode = parser.getText();
						} else if (text == 'jurisName') {
							jurisName = parser.getText();
						} else if (text == 'jurisdictionId') {
							jurisdictionId = parser.getIntegerValue();
						} else if (text == 'signatureCode') {
							signatureCode = parser.getText();
						} else if (text == 'stateAssignedNo') {
							stateAssignedNo = parser.getText();
						} else if (text == 'jurisType') {
							jurisType = parser.getText();
						} else if (text == 'jurisdictionType') {
							jurisdictionType = parser.getText();
						} else if (text == 'nonTaxableAmount') {
							nonTaxableAmount = parser.getDoubleValue();
						} else if (text == 'nonTaxableRuleId') {
							nonTaxableRuleId = parser.getIntegerValue();
						} else if (text == 'nonTaxableType') {
							nonTaxableType = parser.getText();
						} else if (text == 'rate') {
							rate = parser.getDoubleValue();
						} else if (text == 'rateRuleId') {
							rateRuleId = parser.getIntegerValue();
						} else if (text == 'rateSourceId') {
							rateSourceId = parser.getIntegerValue();
						} else if (text == 'serCode') {
							serCode = parser.getText();
						} else if (text == 'sourcing') {
							sourcing = parser.getText();
						} else if (text == 'tax') {
							tax = parser.getDoubleValue();
						} else if (text == 'taxableAmount') {
							taxableAmount = parser.getIntegerValue();
						} else if (text == 'taxType') {
							taxType = parser.getText();
						} else if (text == 'taxSubTypeId') {
							taxSubTypeId = parser.getText();
						} else if (text == 'taxTypeGroupId') {
							taxTypeGroupId = parser.getText();
						} else if (text == 'taxName') {
							taxName = parser.getText();
						} else if (text == 'taxAuthorityTypeId') {
							taxAuthorityTypeId = parser.getIntegerValue();
						} else if (text == 'taxRegionId') {
							taxRegionId = parser.getIntegerValue();
						} else if (text == 'taxCalculated') {
							taxCalculated = parser.getDoubleValue();
						} else if (text == 'taxOverride') {
							taxOverride = parser.getDoubleValue();
						} else if (text == 'rateType') {
							rateType = parser.getText();
						} else if (text == 'rateTypeCode') {
							rateTypeCode = parser.getText();
						} else if (text == 'taxableUnits') {
							taxableUnits = parser.getDoubleValue();
						} else if (text == 'nonTaxableUnits') {
							nonTaxableUnits = parser.getDoubleValue();
						} else if (text == 'exemptUnits') {
							exemptUnits = parser.getDoubleValue();
						} else if (text == 'unitOfBasis') {
							unitOfBasis = parser.getText();
						} else if (text == 'isNonPassThru') {
							isNonPassThru = parser.getBooleanValue();
						} else if (text == 'isFee') {
							isFee = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Details consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Parameters {
		public String name {get;set;} 
		public String value {get;set;} 
		public String unit {get;set;} 

		public Parameters(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else if (text == 'unit') {
							unit = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Parameters consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Messages {
		public String summary {get;set;} 
		public String details {get;set;} 
		public String refersTo {get;set;} 
		public String severity {get;set;} 
		public String source {get;set;} 

		public Messages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'summary') {
							summary = parser.getText();
						} else if (text == 'details') {
							details = parser.getText();
						} else if (text == 'refersTo') {
							refersTo = parser.getText();
						} else if (text == 'severity') {
							severity = parser.getText();
						} else if (text == 'source') {
							source = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Messages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LocationTypes {
		public Integer documentLocationTypeId {get;set;} 
		public Integer documentId {get;set;} 
		public Integer documentAddressId {get;set;} 
		public String locationTypeCode {get;set;} 

		public LocationTypes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'documentLocationTypeId') {
							documentLocationTypeId = parser.getIntegerValue();
						} else if (text == 'documentId') {
							documentId = parser.getIntegerValue();
						} else if (text == 'documentAddressId') {
							documentAddressId = parser.getIntegerValue();
						} else if (text == 'locationTypeCode') {
							locationTypeCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LocationTypes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class InvoiceMessages {
		public String content {get;set;} 
		public List<String> lineNumbers {get;set;} 

		public InvoiceMessages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'content') {
							content = parser.getText();
						} else if (text == 'lineNumbers') {
							lineNumbers = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'InvoiceMessages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Integer id {get;set;} 
	public String code {get;set;} 
	public Integer companyId {get;set;} 
	public String documentDate {get;set;} // in json: date
	public String status {get;set;} 
	public String documentType {get;set;} // in json: type
	public String batchCode {get;set;} 
	public String currencyCode {get;set;} 
	public String entityUseCode {get;set;} 
	public String customerVendorCode {get;set;} 
	public String customerCode {get;set;} 
	public String exemptNo {get;set;} 
	public Boolean reconciled {get;set;} 
	public String locationCode {get;set;} 
	public String reportingLocationCode {get;set;} 
	public String purchaseOrderNo {get;set;} 
	public String referenceCode {get;set;} 
	public String salespersonCode {get;set;} 
	public String taxOverrideType {get;set;} 
	public Double taxOverrideAmount {get;set;} 
	public String taxOverrideReason {get;set;} 
	public Double totalAmount {get;set;} 
	public Double totalExempt {get;set;} 
	public Double totalDiscount {get;set;} 
	public Double totalTax {get;set;} 
	public Integer totalTaxable {get;set;} 
	public Double totalTaxCalculated {get;set;} 
	public String adjustmentReason {get;set;} 
	public Boolean locked {get;set;} 
	public String region {get;set;} 
	public String country {get;set;} 
	public Integer version {get;set;} 
	public String softwareVersion {get;set;} 
	public Integer originAddressId {get;set;} 
	public Integer destinationAddressId {get;set;} 
	public String exchangeRateEffectiveDate {get;set;} 
	public Double exchangeRate {get;set;} 
	public Boolean isSellerImporterOfRecord {get;set;} 
	public String description {get;set;} 
	public String email {get;set;} 
	public String businessIdentificationNo {get;set;} 
	public String modifiedDate {get;set;} 
	public Integer modifiedUserId {get;set;} 
	public String taxDate {get;set;} 
	public List<Lines> lines {get;set;} 
	public List<Addresses> addresses {get;set;} 
	public List<LocationTypes> locationTypes {get;set;} 
	public List<Summary> summary {get;set;} 
	public List<TaxDetailsByTaxType> taxDetailsByTaxType {get;set;} 
	public List<Parameters> parameters {get;set;} 
	public List<Messages> messages {get;set;} 
	public List<InvoiceMessages> invoiceMessages {get;set;} 

	public AsmCreateTransactionJSONResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						id = parser.getIntegerValue();
					} else if (text == 'code') {
						code = parser.getText();
					} else if (text == 'companyId') {
						companyId = parser.getIntegerValue();
					} else if (text == 'date') {
						documentDate = parser.getText();
					} else if (text == 'status') {
						status = parser.getText();
					} else if (text == 'type') {
						documentType = parser.getText();
					} else if (text == 'batchCode') {
						batchCode = parser.getText();
					} else if (text == 'currencyCode') {
						currencyCode = parser.getText();
					} else if (text == 'entityUseCode') {
						entityUseCode = parser.getText();
					} else if (text == 'customerVendorCode') {
						customerVendorCode = parser.getText();
					} else if (text == 'customerCode') {
						customerCode = parser.getText();
					} else if (text == 'exemptNo') {
						exemptNo = parser.getText();
					} else if (text == 'reconciled') {
						reconciled = parser.getBooleanValue();
					} else if (text == 'locationCode') {
						locationCode = parser.getText();
					} else if (text == 'reportingLocationCode') {
						reportingLocationCode = parser.getText();
					} else if (text == 'purchaseOrderNo') {
						purchaseOrderNo = parser.getText();
					} else if (text == 'referenceCode') {
						referenceCode = parser.getText();
					} else if (text == 'salespersonCode') {
						salespersonCode = parser.getText();
					} else if (text == 'taxOverrideType') {
						taxOverrideType = parser.getText();
					} else if (text == 'taxOverrideAmount') {
						taxOverrideAmount = parser.getDoubleValue();
					} else if (text == 'taxOverrideReason') {
						taxOverrideReason = parser.getText();
					} else if (text == 'totalAmount') {
						totalAmount = parser.getDoubleValue();
					} else if (text == 'totalExempt') {
						totalExempt = parser.getDoubleValue();
					} else if (text == 'totalDiscount') {
						totalDiscount = parser.getDoubleValue();
					} else if (text == 'totalTax') {
						totalTax = parser.getDoubleValue();
					} else if (text == 'totalTaxable') {
						totalTaxable = parser.getIntegerValue();
					} else if (text == 'totalTaxCalculated') {
						totalTaxCalculated = parser.getDoubleValue();
					} else if (text == 'adjustmentReason') {
						adjustmentReason = parser.getText();
					} else if (text == 'locked') {
						locked = parser.getBooleanValue();
					} else if (text == 'region') {
						region = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else if (text == 'version') {
						version = parser.getIntegerValue();
					} else if (text == 'softwareVersion') {
						softwareVersion = parser.getText();
					} else if (text == 'originAddressId') {
						originAddressId = parser.getIntegerValue();
					} else if (text == 'destinationAddressId') {
						destinationAddressId = parser.getIntegerValue();
					} else if (text == 'exchangeRateEffectiveDate') {
						exchangeRateEffectiveDate = parser.getText();
					} else if (text == 'exchangeRate') {
						exchangeRate = parser.getDoubleValue();
					} else if (text == 'isSellerImporterOfRecord') {
						isSellerImporterOfRecord = parser.getBooleanValue();
					} else if (text == 'description') {
						description = parser.getText();
					} else if (text == 'email') {
						email = parser.getText();
					} else if (text == 'businessIdentificationNo') {
						businessIdentificationNo = parser.getText();
					} else if (text == 'modifiedDate') {
						modifiedDate = parser.getText();
					} else if (text == 'modifiedUserId') {
						modifiedUserId = parser.getIntegerValue();
					} else if (text == 'taxDate') {
						taxDate = parser.getText();
					} else if (text == 'lines') {
						lines = arrayOfLines(parser);
					} else if (text == 'addresses') {
						addresses = arrayOfAddresses(parser);
					} else if (text == 'locationTypes') {
						locationTypes = arrayOfLocationTypes(parser);
					} else if (text == 'summary') {
						summary = arrayOfSummary(parser);
					} else if (text == 'taxDetailsByTaxType') {
						taxDetailsByTaxType = arrayOfTaxDetailsByTaxType(parser);
					} else if (text == 'parameters') {
						parameters = arrayOfParameters(parser);
					} else if (text == 'messages') {
						messages = arrayOfMessages(parser);
					} else if (text == 'invoiceMessages') {
						invoiceMessages = arrayOfInvoiceMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'AsmCreateTransactionJSONResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class TaxDetailsByTaxType {
		public String taxType {get;set;} 
		public Integer totalTaxable {get;set;} 
		public Double totalExempt {get;set;} 
		public Double totalNonTaxable {get;set;} 
		public Double totalTax {get;set;} 
		public List<TaxSubTypeDetails> taxSubTypeDetails {get;set;} 

		public TaxDetailsByTaxType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'taxType') {
							taxType = parser.getText();
						} else if (text == 'totalTaxable') {
							totalTaxable = parser.getIntegerValue();
						} else if (text == 'totalExempt') {
							totalExempt = parser.getDoubleValue();
						} else if (text == 'totalNonTaxable') {
							totalNonTaxable = parser.getDoubleValue();
						} else if (text == 'totalTax') {
							totalTax = parser.getDoubleValue();
						} else if (text == 'taxSubTypeDetails') {
							taxSubTypeDetails = arrayOfTaxSubTypeDetails(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TaxDetailsByTaxType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Summary {
		public String country {get;set;} 
		public String region {get;set;} 
		public String jurisType {get;set;} 
		public String jurisCode {get;set;} 
		public String jurisName {get;set;} 
		public Integer taxAuthorityType {get;set;} 
		public String stateAssignedNo {get;set;} 
		public String taxType {get;set;} 
		public String taxSubType {get;set;} 
		public String taxName {get;set;} 
		public String taxGroup {get;set;} 
		public String rateType {get;set;} 
		public String rateTypeCode {get;set;} 
		public Integer taxable {get;set;} 
		public Double rate {get;set;} 
		public Double tax {get;set;} 
		public Double taxCalculated {get;set;} 
		public Double nonTaxable {get;set;} 
		public Double exemption {get;set;} 

		public Summary(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'country') {
							country = parser.getText();
						} else if (text == 'region') {
							region = parser.getText();
						} else if (text == 'jurisType') {
							jurisType = parser.getText();
						} else if (text == 'jurisCode') {
							jurisCode = parser.getText();
						} else if (text == 'jurisName') {
							jurisName = parser.getText();
						} else if (text == 'taxAuthorityType') {
							taxAuthorityType = parser.getIntegerValue();
						} else if (text == 'stateAssignedNo') {
							stateAssignedNo = parser.getText();
						} else if (text == 'taxType') {
							taxType = parser.getText();
						} else if (text == 'taxSubType') {
							taxSubType = parser.getText();
						} else if (text == 'taxName') {
							taxName = parser.getText();
						} else if (text == 'taxGroup') {
							taxGroup = parser.getText();
						} else if (text == 'rateType') {
							rateType = parser.getText();
						} else if (text == 'rateTypeCode') {
							rateTypeCode = parser.getText();
						} else if (text == 'taxable') {
							taxable = parser.getIntegerValue();
						} else if (text == 'rate') {
							rate = parser.getDoubleValue();
						} else if (text == 'tax') {
							tax = parser.getDoubleValue();
						} else if (text == 'taxCalculated') {
							taxCalculated = parser.getDoubleValue();
						} else if (text == 'nonTaxable') {
							nonTaxable = parser.getDoubleValue();
						} else if (text == 'exemption') {
							exemption = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Summary consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LineLocationTypes {
		public Integer documentLineLocationTypeId {get;set;} 
		public Integer documentLineId {get;set;} 
		public Integer documentAddressId {get;set;} 
		public String locationTypeCode {get;set;} 

		public LineLocationTypes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'documentLineLocationTypeId') {
							documentLineLocationTypeId = parser.getIntegerValue();
						} else if (text == 'documentLineId') {
							documentLineId = parser.getIntegerValue();
						} else if (text == 'documentAddressId') {
							documentAddressId = parser.getIntegerValue();
						} else if (text == 'locationTypeCode') {
							locationTypeCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LineLocationTypes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Lines {
		public Integer id {get;set;} 
		public Integer transactionId {get;set;} 
		public String lineNumber {get;set;} 
		public Integer boundaryOverrideId {get;set;} 
		public String entityUseCode {get;set;} 
		public String description {get;set;} 
		public Integer destinationAddressId {get;set;} 
		public Integer originAddressId {get;set;} 
		public Double discountAmount {get;set;} 
		public Integer discountTypeId {get;set;} 
		public Double exemptAmount {get;set;} 
		public Integer exemptCertId {get;set;} 
		public String certificateId {get;set;} 
		public String exemptNo {get;set;} 
		public Boolean isItemTaxable {get;set;} 
		public Boolean isSSTP {get;set;} 
		public String itemCode {get;set;} 
		public Integer lineAmount {get;set;} 
		public Integer quantity {get;set;} 
		public String ref1 {get;set;} 
		public String ref2 {get;set;} 
		public String reportingDate {get;set;} 
		public String revAccount {get;set;} 
		public String sourcing {get;set;} 
		public Double tax {get;set;} 
		public Integer taxableAmount {get;set;} 
		public Double taxCalculated {get;set;} 
		public String taxCode {get;set;} 
		public Integer taxCodeId {get;set;} 
		public String taxDate {get;set;} 
		public String taxEngine {get;set;} 
		public String taxOverrideType {get;set;} 
		public String businessIdentificationNo {get;set;} 
		public Double taxOverrideAmount {get;set;} 
		public String taxOverrideReason {get;set;} 
		public Boolean taxIncluded {get;set;} 
		public List<Details> details {get;set;} 
		public List<Details> nonPassthroughDetails {get;set;} 
		public List<LineLocationTypes> lineLocationTypes {get;set;} 
		public List<Parameters> parameters {get;set;} 
		public String hsCode {get;set;} 
		public Double costInsuranceFreight {get;set;} 
		public String vatCode {get;set;} 
		public Integer vatNumberTypeId {get;set;} 

		public Lines(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'transactionId') {
							transactionId = parser.getIntegerValue();
						} else if (text == 'lineNumber') {
							lineNumber = parser.getText();
						} else if (text == 'boundaryOverrideId') {
							boundaryOverrideId = parser.getIntegerValue();
						} else if (text == 'entityUseCode') {
							entityUseCode = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'destinationAddressId') {
							destinationAddressId = parser.getIntegerValue();
						} else if (text == 'originAddressId') {
							originAddressId = parser.getIntegerValue();
						} else if (text == 'discountAmount') {
							discountAmount = parser.getDoubleValue();
						} else if (text == 'discountTypeId') {
							discountTypeId = parser.getIntegerValue();
						} else if (text == 'exemptAmount') {
							exemptAmount = parser.getDoubleValue();
						} else if (text == 'exemptCertId') {
							exemptCertId = parser.getIntegerValue();
						} else if (text == 'certificateId') {
							certificateId = parser.getText();
						} else if (text == 'exemptNo') {
							exemptNo = parser.getText();
						} else if (text == 'isItemTaxable') {
							isItemTaxable = parser.getBooleanValue();
						} else if (text == 'isSSTP') {
							isSSTP = parser.getBooleanValue();
						} else if (text == 'itemCode') {
							itemCode = parser.getText();
						} else if (text == 'lineAmount') {
							lineAmount = parser.getIntegerValue();
						} else if (text == 'quantity') {
							quantity = parser.getIntegerValue();
						} else if (text == 'ref1') {
							ref1 = parser.getText();
						} else if (text == 'ref2') {
							ref2 = parser.getText();
						} else if (text == 'reportingDate') {
							reportingDate = parser.getText();
						} else if (text == 'revAccount') {
							revAccount = parser.getText();
						} else if (text == 'sourcing') {
							sourcing = parser.getText();
						} else if (text == 'tax') {
							tax = parser.getDoubleValue();
						} else if (text == 'taxableAmount') {
							taxableAmount = parser.getIntegerValue();
						} else if (text == 'taxCalculated') {
							taxCalculated = parser.getDoubleValue();
						} else if (text == 'taxCode') {
							taxCode = parser.getText();
						} else if (text == 'taxCodeId') {
							taxCodeId = parser.getIntegerValue();
						} else if (text == 'taxDate') {
							taxDate = parser.getText();
						} else if (text == 'taxEngine') {
							taxEngine = parser.getText();
						} else if (text == 'taxOverrideType') {
							taxOverrideType = parser.getText();
						} else if (text == 'businessIdentificationNo') {
							businessIdentificationNo = parser.getText();
						} else if (text == 'taxOverrideAmount') {
							taxOverrideAmount = parser.getDoubleValue();
						} else if (text == 'taxOverrideReason') {
							taxOverrideReason = parser.getText();
						} else if (text == 'taxIncluded') {
							taxIncluded = parser.getBooleanValue();
						} else if (text == 'details') {
							details = arrayOfDetails(parser);
						} else if (text == 'nonPassthroughDetails') {
							nonPassthroughDetails = arrayOfDetails(parser);
						} else if (text == 'lineLocationTypes') {
							lineLocationTypes = arrayOfLineLocationTypes(parser);
						} else if (text == 'parameters') {
							parameters = arrayOfParameters(parser);
						} else if (text == 'hsCode') {
							hsCode = parser.getText();
						} else if (text == 'costInsuranceFreight') {
							costInsuranceFreight = parser.getDoubleValue();
						} else if (text == 'vatCode') {
							vatCode = parser.getText();
						} else if (text == 'vatNumberTypeId') {
							vatNumberTypeId = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Lines consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static AsmCreateTransactionJSONResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new AsmCreateTransactionJSONResp(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<TaxSubTypeDetails> arrayOfTaxSubTypeDetails(System.JSONParser p) {
        List<TaxSubTypeDetails> res = new List<TaxSubTypeDetails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new TaxSubTypeDetails(p));
        }
        return res;
    }


    private static List<Summary> arrayOfSummary(System.JSONParser p) {
        List<Summary> res = new List<Summary>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Summary(p));
        }
        return res;
    }


    private static List<Details> arrayOfDetails(System.JSONParser p) {
        List<Details> res = new List<Details>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Details(p));
        }
        return res;
    }




    private static List<LineLocationTypes> arrayOfLineLocationTypes(System.JSONParser p) {
        List<LineLocationTypes> res = new List<LineLocationTypes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LineLocationTypes(p));
        }
        return res;
    }




    private static List<Parameters> arrayOfParameters(System.JSONParser p) {
        List<Parameters> res = new List<Parameters>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Parameters(p));
        }
        return res;
    }


    private static List<InvoiceMessages> arrayOfInvoiceMessages(System.JSONParser p) {
        List<InvoiceMessages> res = new List<InvoiceMessages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InvoiceMessages(p));
        }
        return res;
    }


    private static List<Lines> arrayOfLines(System.JSONParser p) {
        List<Lines> res = new List<Lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Lines(p));
        }
        return res;
    }




    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }




    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
        }
        return res;
    }





    private static List<LocationTypes> arrayOfLocationTypes(System.JSONParser p) {
        List<LocationTypes> res = new List<LocationTypes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LocationTypes(p));
        }
        return res;
    }


    private static List<Messages> arrayOfMessages(System.JSONParser p) {
        List<Messages> res = new List<Messages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Messages(p));
        }
        return res;
    }


    private static List<TaxDetailsByTaxType> arrayOfTaxDetailsByTaxType(System.JSONParser p) {
        List<TaxDetailsByTaxType> res = new List<TaxDetailsByTaxType>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new TaxDetailsByTaxType(p));
        }
        return res;
    }





}