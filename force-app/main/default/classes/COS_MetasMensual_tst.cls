@isTest
public class COS_MetasMensual_tst {
    private static COM_MetaAnual__c objMetaAnual;
	private static COM_MetasMensual__c objMetasMensual;
    
    @isTest
    public static void insercionMetas(){
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
        objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, objMetaAnual.Id);
    }
    
    @isTest
    public static void actualizacionMetas(){
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
        objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, objMetaAnual.Id);
        
        objMetasMensual.COS_TipoPlan__c = 'EP';
        objMetasMensual.COS_Asesor__c = UserInfo.getUserId();
        
        Update objMetasMensual;
    }
}