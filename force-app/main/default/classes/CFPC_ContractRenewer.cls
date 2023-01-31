public class CFPC_ContractRenewer {
    public QuoteModel[] load(String masterContractId, String serializedContext) {
        String quotesJSON = SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractRenewer', masterContractId, serializedContext);
        return (QuoteModel[]) JSON.deserialize(quotesJSON, List<QuoteModel>.class);
    }
    
}