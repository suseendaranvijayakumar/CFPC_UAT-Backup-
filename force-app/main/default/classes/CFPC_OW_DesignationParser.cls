public with sharing class CFPC_OW_DesignationParser {
	
    //AEG
	public String MemberId;
	public String DesignationCode; //SubcategoryCode in Postman Collection, DesignationCode in imiswebservices code
    public Date EffectiveDate;
    public String RouteCode;
    
    //CAC
    public String CfpcMemberId;
    public String CacOpenWaterId;
    public String CacDesignation;
    public Date CacEffectiveDate;
	
	public static CFPC_OW_DesignationParser parse(String json) {
		return (CFPC_OW_DesignationParser) System.JSON.deserialize(json, CFPC_OW_DesignationParser.class);
	}
}