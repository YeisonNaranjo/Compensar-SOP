public class COM_QuoteHandler_cls {
    public static void beforeInsert(List<Quote> lstNewQuote)
    {
        Set<Id> idOpp = New Set<Id>();
        Set<Id> idOppNoCot = New Set<Id>();
        
        For(Quote objQuote : lstNewQuote){
            idOpp.add(objQuote.OpportunityId);
        }
        
        Map<Id, Opportunity> mapOpp = new  Map<Id, Opportunity>([Select Id, StageName from Opportunity where Id IN : idOpp and StageName != 'Cotizada']);
        
        For(Quote objQuote : lstNewQuote){
            If(mapOpp.containsKey(objQuote.OpportunityId)){
                objQuote.addError(Label.COM_Oportunidad_no_cotizada);
            }
        }
    }
}