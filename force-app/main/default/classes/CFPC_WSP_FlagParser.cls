public class CFPC_WSP_FlagParser {
	public String Key;
    public String Value;
    
    public static CFPC_WSP_FlagParser parse(String json){
        return (CFPC_WSP_FlagParser) System.JSON.deserialize(json, CFPC_WSP_FlagParser.class);
    }
}