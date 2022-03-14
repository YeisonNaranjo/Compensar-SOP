@isTest
private class COM_ConsultarTablaDominio_tst {
	
	@isTest static void test_method_one() {
		COM_ConsultarTablaDominio_cls.consultarValorTabla('COM_NAME_ESTADO_VINCULACION', '1');
	}
	
	@isTest static void test_method_two() {
		COM_ConsultarTablaDominio_cls.consultarCodigoTabla('COM_NAME_ESTADO_VINCULACION', 'Inactivo');
	}

	@isTest static void test_method_three() {
		COM_ConsultarTablaDominio_cls ppp = new COM_ConsultarTablaDominio_cls();
	}

	@isTest static void test_method_four() {
		COM_ConsultarTablaDominio_cls.consultarValorTabla('COM_NAME_ESTADO_VINCULACION', '');
	}
	
	@isTest static void test_method_five() {
		COM_ConsultarTablaDominio_cls.consultarCodigoTabla('COM_NAME_ESTADO_VINCULACION', '');
	}
	
	
}