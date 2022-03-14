trigger RF2_EncuestasCasos_tgr on RF2_EncuestasCasos__c (after insert, after update) {
    if(RF2_EncuestasCasos_cls.canIRun()){
        if (Trigger.isAfter) {
            if(Trigger.isInsert){
                RF2_EncuestasCasos_cls clsEncuestasCasos = new RF2_EncuestasCasos_cls();
                clsEncuestasCasos.AsignarPropetario(Trigger.new);
            }
            if(Trigger.isUpdate){
                RF2_EncuestasCasos_cls clsEncuestasCasos = new RF2_EncuestasCasos_cls();
                clsEncuestasCasos.AsignarPropetario(Trigger.new);
            }
        }
    }
}