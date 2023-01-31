public class CFPC_WSL_Designation_Parser {
	public String MemberId;
    public String DesignationCode;
    public String EffectiveDate;//public Datetime EffectiveDate;
    public String RouteCode;
    public String ResidencyCompletionDate;//public Datetime ResidencyCompletionDate;
    //public Date CompletionDate; //From imis code
    
    public static CFPC_WSL_Designation_Parser parse(String json){
        return (CFPC_WSL_Designation_Parser) System.JSON.deserialize(json, CFPC_WSL_Designation_Parser.class);
    }
}