trigger COM_Quote_tgr on Quote (before insert) {
    If(Trigger.isBefore){
        If(Trigger.isInsert){
            COM_QuoteHandler_cls.beforeInsert(Trigger.new);
        }
    }
}