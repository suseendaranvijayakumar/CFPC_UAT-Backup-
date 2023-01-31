public class CFPC_WSP_MemberClassCodeMapping {
    
    public static String doCodeMapping(String cfpcCode) {
        cfpcCode = cfpcCode.replace(' ', '_');
        CFPC_Class_CFPCToMainProCode__mdt mcs = CFPC_Class_CFPCToMainProCode__mdt.getInstance(cfpcCode);
        if(mcs == null){
            return cfpcCode;//'Class Not Found with code:'+cfpcCode;
        }else return mcs.Class_MAINPRO_Code__c;
    }
    
    public static String doDiscontinuedCodeMapping(String discReasonPicklistValue){
        Map<String, CFPC_Discontinued_Reason_Mapping__mdt> allDiscReasonCodes = CFPC_Discontinued_Reason_Mapping__mdt.getAll();
        Map<String, String> discReasonValueCodeMap = new Map<String, String>();
        String discReasonCode;
        for(CFPC_Discontinued_Reason_Mapping__mdt discCode : alldiscReasonCodes.values()){
        	discReasonValueCodeMap.put(discCode.CFPC_Discontinued_Reason__c, discCode.CFPC_Discontinued_MainproCode__c);
        }
        discReasonCode = discReasonValueCodeMap.get(discReasonPicklistValue);
        if(discReasonCode == null){
            return discReasonPicklistValue;
        }else return discReasonCode;
    }
}