/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase Handler para Trigger CEL1_Lead_tgr
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19        Manuel Mendez  (MM)     Creación Clase.
	1.1		18/06/21		Jorge Pozo (JPA)		beforeInsert() - Se agregó los metodos RL2_LeadHelper_cls.validarCandidatoDuplicado()
													y RL2_LeadHelper_cls.asignarPropietarioDeCuenta()
													afterUpdate() - Se agregó el método RL2_LeadHelper_cls.actualizarCuentaConvertida()
**************************************************************************************************/  
public with sharing class CEL1_LeadHandler_cls 
{
    public static void beforeInsert(List<Lead> lstNewLead)
    {
        System.debug('beforeInsert ::::: ');
        CEL1_LeadHelper_cls.validarCuentas(lstNewLead);
        CEL1_AsignacionAsesores_cls.asignacionAsesores(lstNewLead);
        COS_AsignacionProspectos_cls.asignacionProspectos(lstNewLead);
        COS_LeadHelper_cls.validarProspectoSalud(lstNewLead);
        RL2_LeadHelper_cls.validarCandidatoDuplicado(lstNewLead);
        RL2_LeadHelper_cls.asignarPropietarioDeCuenta(lstNewLead);
    }
    
    public static void beforeUpdate(List<Lead> lstNewLead,List<Lead> lstOldLead)
    {
        System.debug('beforeUpdate ::::: ');
        System.debug('lstNewLead ::::: '+lstNewLead);
        System.debug('lstOldLead ::::: '+lstOldLead);
        CEL1_LeadHelper_cls.validarPerfil(lstNewLead,lstOldLead);
        CEL1_LeadHelper_cls.convertirCandidatoBefore(lstNewLead,lstOldLead,'Before');
        RL2_LeadHelper_cls.validarCuentaExistente(lstNewLead);
    }
    
    public static void afterInsert(Map<Id,Lead> mapNewLead)
    {
        System.debug('afterInsert ::::: ');
        CEL1_LeadHelper_cls.enviarCorreosCuentaAcreedora(mapNewLead);
    }
    
    public static void afterUpdate(List<Lead> lstNewLead,Map<Id,Lead> mapOldLead)
    //public static void afterUpdate(List<Lead> lstNewLead,List<Lead> lstOldLead)
    {
        System.debug('afterUpdate ::::: ');
        System.debug('lstNewLead ::::: '+lstNewLead);
        System.debug('mapOldLead ::::: '+mapOldLead);
        CEL1_LeadHelper_cls.actualizarTipoCuenta(lstNewLead, mapOldLead);
        CEL1_LeadHelper_cls.convertirCandidatoBefore(lstNewLead,null,'After');
        // CEL1_LeadHelper_cls.agregarNautcliClienteFuture(lstNewLead);
        RL2_LeadHelper_cls.actualizarCuentaConvertida(lstNewLead, mapOldLead);
    }

}