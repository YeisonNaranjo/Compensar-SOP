/************************************************************************************************
Desarrollado por:  Globant
Autor:             Yeison Naranjo (YSN)
Proyecto:          Compensar
Descripción:       Handler Trigger del objeto Metas Mensuales

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.			Fecha			Autor					Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0			06/09/21		Yeison Naranjo (YSN)	Creación Clase.
************************************************************************************************/

public class COS_MetasMensualHandler_cls {
    public static void updateHeadquarters(List<COM_MetasMensual__c> lstNew)
    {
        System.debug('Begin method updateHeadquarters');
        Set<Id> setAdviser = New Set<Id>();
        Set<String> setHeadquarters = New Set<String>();
        Map<String, Id> mapHeadquartersByOwner = New Map<String, Id>();
        Map<String, Id> mapHeadquartersIdByOwner = New Map<String, Id>();
        
        For(COM_MetasMensual__c objMetaMes : lstNew){
            setAdviser.add(objMetaMes.COS_Asesor__c);
            System.debug('setAdviser: ' + setAdviser);
        }
        
        For(User objAdviser : [Select Id, Codigo_Sede__c from User where Id IN: setAdviser]){
            setHeadquarters.add(objAdviser.Codigo_Sede__c);
            mapHeadquartersByOwner.Put(objAdviser.Codigo_Sede__c, objAdviser.Id);
            System.debug('setHeadquarters: ' + setHeadquarters);
            System.debug('mapHeadquartersByOwner: ' + mapHeadquartersByOwner);
        }
        
        For(COS_SedesSalud__c objSedeSalud : [Select Id, COS_Codigo__c from COS_SedesSalud__c where COS_Codigo__c IN: setHeadquarters]){
            System.debug('mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c): ' + mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c));
            If(mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c)){
                mapHeadquartersIdByOwner.put(mapHeadquartersByOwner.get(objSedeSalud.COS_Codigo__c), objSedeSalud.Id);
            }            
        }
        
        For(COM_MetasMensual__c objMetaMes : lstNew){
            System.debug('mapHeadquartersIdByOwner.containsKey(objMetaMes.COS_Asesor__c): ' + mapHeadquartersIdByOwner.containsKey(objMetaMes.COS_Asesor__c));
            If(mapHeadquartersIdByOwner.containsKey(objMetaMes.COS_Asesor__c)){
                System.debug('mapHeadquartersIdByOwner.get(objMetaMes.COS_Asesor__c): ' + mapHeadquartersIdByOwner.get(objMetaMes.COS_Asesor__c));
                objMetaMes.COS_Sede__c = mapHeadquartersIdByOwner.get(objMetaMes.COS_Asesor__c);
            }            
        }
    }
}