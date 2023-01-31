public class CFPC_WSL_EM_FM_Parser {
	public String MemberId;
    public DateTime EmFmCompletionDate;
    public String EmFmCompletionFlag;
    public String Type;
    
    public static CFPC_WSL_EM_FM_Parser parse(String json){
        return (CFPC_WSL_EM_FM_Parser) System.JSON.deserialize(json, CFPC_WSL_EM_FM_Parser.class);
    }
}