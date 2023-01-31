public class ContractAmender {
   public QuoteModel load(String contractId, String context) {

         String quoteJSON = SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractAmender', contractId, null);
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
}