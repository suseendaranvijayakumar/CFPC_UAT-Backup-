public with sharing class CFPC_OW_CACApplicantParser {
    
	public String CacOpenWaterId;
	public Integer CfpcMemberId;
	public String CacApplicationType;
	public String CacApplicationArea;
	public String PreferredLanguage;
	public String NameOnCertificate;

	
	public static CFPC_OW_CACApplicantParser parse(String json) {
		return (CFPC_OW_CACApplicantParser) System.JSON.deserialize(json, CFPC_OW_CACApplicantParser.class);
	}
}