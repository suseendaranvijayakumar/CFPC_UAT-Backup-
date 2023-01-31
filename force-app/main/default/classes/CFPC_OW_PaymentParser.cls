public with sharing class CFPC_OW_PaymentParser {

	public String OpenWaterId;
	public String CfpcMemberId;
	public String PaymentTxnRefId;
	public Double PaymentAmount;
	public Integer PaymentTxnResponseCode;
	public String CreditCardType;
	public String SourceSystem;
	public String ProductCode;
    public Integer Sequence;
    public String CacOpenWaterId;
    //public boolean Test;

	
	public static CFPC_OW_PaymentParser parse(String json) {
		return (CFPC_OW_PaymentParser) System.JSON.deserialize(json, CFPC_OW_PaymentParser.class);
	}
}