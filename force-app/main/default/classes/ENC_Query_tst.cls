@isTest (SeeAllData=true)
private class ENC_Query_tst
{
	static testMethod void addMessage_tst()
	{
		Test.startTest();
			ENC_Query_int cls = new ENC_Query_imp();
			cls.getSObject( 'Account', 'Id', ' Id = null ' );
			cls.getListaSObject( 'Account', 'Id', ' Id = null ', 1, ' CreatedDate asc ' );
			cls.getListaSObject( 'Account', 'Id', ' Id = null ', null, ' CreatedDate asc ' );
			cls.getControladorEstandar( 'AVX_ENC_PreguntaEncuesta__c', 'Abiertas', '', 1, ' CreatedDate asc ', ' Id = null ' );
			cls.getControladorEstandar( 'AVX_ENC_PreguntaEncuesta__c', 'Cerradas', '', null, ' CreatedDate asc ', ' Id = null ' );
			cls.getControladorEstandar( 'Account', new set<String>{'Name'} , '', 1, ' CreatedDate asc ', ' Id = null ' );
			cls.getControladorEstandar( 'Account', new set<String>{'Name'}, 'Buscar Filtro*', 1, ' CreatedDate asc ', ' Id = null ' );//Busqueda con filtro
			cls.getControladorEstandar( 'Account', new set<String>{'Name'}, '*Buscar Filtro', 1, ' CreatedDate asc ', ' Id = null ' );//Busqueda con filtro
			cls.getControladorEstandar( 'Account', new set<String>{'Name'}, 'Buscar Filtro', 1, ' CreatedDate asc ', ' Id = null ' );//Busqueda con filtro
			cls.getFuncionAggregate( 'Account', 'Name', 'Id != null', 5, 'Name', 'Name' );
			cls.getSOSLResult( 'Account', 'Daniel' );
		Test.stopTest();
	}
}