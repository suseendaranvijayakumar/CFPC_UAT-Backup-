public with sharing class redirectionLinkwrpperOutput {
    
    public boolean responseStatus;
	public String message;	//Success
	public static redirectionLinkwrpperOutput parse(String json){
		return (redirectionLinkwrpperOutput) System.JSON.deserialize(json, redirectionLinkwrpperOutput.class);
	}

	/*static testMethod void testParse() {
		String json=		'{"responseStatus":true,"message":"Success"}'+
		'';
		redirectionLinkwrpperOutput obj = parse(json);
		System.assert(obj != null);
	}*/
}