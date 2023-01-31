public with sharing class CFPC_WSP_CycleParser {
	public String ID;
    public String CycleType;
    
    public static CFPC_WSP_CycleParser parse(String json){
        return (CFPC_WSP_CycleParser) System.JSON.deserialize(json, CFPC_WSP_CycleParser.class);
    }
}