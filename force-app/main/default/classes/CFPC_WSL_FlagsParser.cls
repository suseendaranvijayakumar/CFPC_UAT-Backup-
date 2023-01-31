public class CFPC_WSL_FlagsParser {
	
    public cls_FlagData[] Flags;
    
    public class cls_FlagData{
        public String Key;
    	public String Value;
    }
    
    public static CFPC_WSL_FlagsParser parse(String json){
        return (CFPC_WSL_FlagsParser) System.JSON.deserialize(json, CFPC_WSL_FlagsParser.class);
    }
}