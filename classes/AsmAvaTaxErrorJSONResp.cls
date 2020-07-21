// (c) COPYRIGHT OAC SERVICES, INC. dba Foundry52 2020
// (AND ALL PREVIOUS VERSIONS)
/* ====================================================================
   = AUTHOR      : Michael B. Allen
   = DATE CREATED: July 16, 2020
   = VERSION     : 1.0
   = DESCRIPTION : This class will creates the structures needed for
   =               the parsing and error response from the Avalara
   =               APIs
   ====================================================================
   = MODIFICATION HISTORY
   ====================================================================

   DATE        NAME           DESCRIPTION
   --------------------------------------------------------------------
   DD MON YY   F.LAST         DESCRIPTION OF MODIFICATION
   ====================================================================
   ====================================================================
*/

public class AsmAvaTaxErrorJSONResp {

	public class Details {
		public String code {get;set;} 
		public Integer number_Z {get;set;} // in json: number
		public String message {get;set;} 
		public String description {get;set;} 
		public String faultCode {get;set;} 
		public String helpLink {get;set;} 
		public String severity {get;set;} 

		public Details(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'faultCode') {
							faultCode = parser.getText();
						} else if (text == 'helpLink') {
							helpLink = parser.getText();
						} else if (text == 'severity') {
							severity = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Details consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Error error {get;set;} 

	public AsmAvaTaxErrorJSONResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'error') {
						error = new Error(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'AsmAvaTaxErrorJSONResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Error {
		public String code {get;set;} 
		public String message {get;set;} 
		public String target {get;set;} 
		public List<Details> details {get;set;} 

		public Error(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'message') {
							message = parser.getText();
						} else if (text == 'target') {
							target = parser.getText();
						} else if (text == 'details') {
							details = arrayOfDetails(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Error consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static AsmAvaTaxErrorJSONResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new AsmAvaTaxErrorJSONResp(parser);
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
	





    private static List<Details> arrayOfDetails(System.JSONParser p) {
        List<Details> res = new List<Details>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Details(p));
        }
        return res;
    }


}