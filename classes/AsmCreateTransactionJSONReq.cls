// (c) COPYRIGHT OAC SERVICES, INC. dba Foundry52 2020
// (AND ALL PREVIOUS VERSIONS)
/* ====================================================================
   = AUTHOR      : Michael B. Allen
   = DATE CREATED: July 10, 2020
   = VERSION     : 1.0
   = DESCRIPTION : This class will creates the structures needed for
   =               the Avalara CreateTRansaction JSON REST API
   ====================================================================
   = MODIFICATION HISTORY
   ====================================================================

   DATE        NAME           DESCRIPTION
   --------------------------------------------------------------------
   DD MON YY   F.LAST         DESCRIPTION OF MODIFICATION
   ====================================================================
   ====================================================================
*/

public class AsmCreateTransactionJSONReq {

	public class Addresses {
		public SingleLocation singleLocation;
		public ShipFrom shipFrom;
		public ShipTo shipTo;
		public PointOfOrderOrigin pointOfOrderOrigin;
		public PointOfOrderAcceptance pointOfOrderAcceptance;
	}

	public class TaxOverride {
		public String taxType;
		public Double taxAmount;
		public DateTime taxDate;
		public String reason;
	}

	public class Parameters {
		public String name;
		public String value;
		public String unit;
	}

	public class SingleLocation {
		public String locationCode;
		public String line1;
		public String line2;
		public String line3;
		public String city;
		public String region;
		public String country;
		public String postalCode;
		public Double latitude;
		public Double longitude;
	}

	public class ShipFrom {
		public String locationCode;
		public String line1;
		public String line2;
		public String line3;
		public String city;
		public String region;
		public String country;
		public String postalCode;
		public Double latitude;
		public Double longitude;
	}

	public class ShipTo {
		public String locationCode;
		public String line1;
		public String line2;
		public String line3;
		public String city;
		public String region;
		public String country;
		public String postalCode;
		public Double latitude;
		public Double longitude;
	}

	public class PointOfOrderOrigin {
		public String locationCode;
		public String line1;
		public String line2;
		public String line3;
		public String city;
		public String region;
		public String country;
		public String postalCode;
		public Double latitude;
		public Double longitude;
	}

	public class PointOfOrderAcceptance {
		public String locationCode;
		public String line1;
		public String line2;
		public String line3;
		public String city;
		public String region;
		public String country;
		public String postalCode;
		public Double latitude;
		public Double longitude;
	}

	public class CreateTransaction {
		public List<Lines> lines;
		public String code;
		public String documentType;
		public String companyCode;
		public DateTime documentDate;
		public String salespersonCode;
		public String customerCode;
		public String entityUseCode;
		public Double discount;
		public String purchaseOrderNo;
		public String exemptionNo;
		public Addresses addresses;
		public List<Parameters> parameters;
		public String referenceCode;
		public String reportingLocationCode;
		public Boolean commitBoolean;
		public String batchCode;
		public TaxOverride taxOverride;
		public String currencyCode;
		public String serviceMode;
		public Double exchangeRate;
		public DateTime exchangeRateEffectiveDate;
		public String posLaneCode;
		public String businessIdentificationNo;
		public Boolean isSellerImporterOfRecord;
		public String description;
		public String email;
		public String debugLevel;
	}

	public class Lines {
		public String lineNumber;
		public Double quantity;
		public Double amount;
		public Addresses addresses;
		public String taxCode;
		public String entityUseCode;
		public String itemCode;
		public String exemptionCode;
		public Boolean discounted;
		public Boolean taxIncluded;
		public String revenueAccount;
		public String ref1;
		public String ref2;
		public String description;
		public String businessIdentificationNo;
		public TaxOverride taxOverride;
		public List<Parameters> parameters;
		public String hsCode;
	}

	// ============================================================================
	// = generateCreateTransactionJSON
	// =
	// = Pass in the wrapper class CreateTransaction variable that has all the 
	// = fields you want to pass with the values set.
	// = 
	// = This method will serialize the avaTaxTransaction variable. It will then
	// = replace all occurences of LineNumber with number, documentType with type,
	// = documentDate with date and commitBoolean with commit.  This is required 
	// = because the field names cannot be number, type, date, or commit and in 
	// = order to setup the wrapper class we had to provide a different field name 
	// = which was then part of the serialized JSON string.  Performing the 
	// = replacements sets the field names to what Avalara AvaTax expects.
	// ============================================================================

	public static String generateCreateTransactionJSON (CreateTransaction avaTaxTransaction){

		String jsonString = json.serializePretty(avaTaxTransaction,true);
		jsonString = jsonString.replace('lineNumber','number');
		jsonString = jsonString.replace('documentType','type');
		jsonString = jsonString.replace('documentDate','date');
		jsonString = jsonString.replace('commitBoolean','commit');

		return jsonString;
	}

}