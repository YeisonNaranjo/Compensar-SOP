@isTest
private class COM_TraerDatosPerfilSIAN_cls_tst {
	
	@isTest static void test_method_one() {
		Account cuenta = COM_DataGenerator_cls.crearCuenta(true); 
		COM_TraerDatosPerfilSIAN_cls ppp = new COM_TraerDatosPerfilSIAN_cls();
		COM_TraerDatosPerfilSIAN_cls.obtenerURLSIAN(cuenta.Id);
	}
	
	@isTest static void test_method_two() {
		Account cuenta = COM_DataGenerator_cls.crearCuenta(true); 
		List<RecordType> rtid = [select Id, Name  from RecordType where Name = 'Jurídico'];
		cuenta.RecordTypeId = rtid.get(0).Id;
		update cuenta;
		COM_TraerDatosPerfilSIAN_cls ppp = new COM_TraerDatosPerfilSIAN_cls();
		COM_TraerDatosPerfilSIAN_cls.obtenerURLSIAN(cuenta.Id);
	}
	
}