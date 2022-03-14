@isTest
public class COS_creaProspecto_tst {
	@TestSetup
    static void makeData(){
        
    }
    
    @isTest
    static void testMethod_1(){
        COS_creaProspectoRequest_dto dtoLead = new COS_creaProspectoRequest_dto();
        dtoLead.TipoID = '1';
		dtoLead.NumID = '79777999';
    	dtoLead.Nombre = 'Nombre1 Nombre2 Apellido1 Apellido2';
    	dtoLead.TelefonoContactoFijo = '2917720';
		dtoLead.TelefonoContactoCelular = '3107553362';
    	dtoLead.Email = 'Nombre1@gmail.com';
    	dtoLead.NumeroEmpresa = '9006547893';
    	dtoLead.Genero = 'Masculino';
    	dtoLead.Fecha = '2020-10-10 10:10:10';
    	dtoLead.Asesor = 'Asesor SFDC';
    	dtoLead.IDAsesor = '79888111';
    	dtoLead.EmailAsesor = 'Asesor@compensar.com';
    	dtoLead.CategoriaCaja = 'Categoria Caja';
    	dtoLead.Fuentes = 'BD Call Center';
        
        string response = COS_creaProspecto_ws.doPost(dtoLead);
    }
    
    @isTest
    static void testMethod_2(){
        COS_creaProspectoRequest_dto dtoLead = new COS_creaProspectoRequest_dto();
        dtoLead.TipoID = '1';
		dtoLead.NumID = '79777999';
    	dtoLead.Nombre = 'Nombre1 Apellido1 Apellido2';
    	dtoLead.TelefonoContactoFijo = '2917720';
		dtoLead.TelefonoContactoCelular = '3107553362';
    	dtoLead.Email = 'Nombre1@gmail.com';
    	dtoLead.NumeroEmpresa = '9006547893';
    	dtoLead.Genero = 'Masculino';
    	dtoLead.Fecha = '2020-10-10 10:10:10';
    	dtoLead.Asesor = 'Asesor SFDC';
    	dtoLead.IDAsesor = '79888111';
    	dtoLead.EmailAsesor = 'Asesor@compensar.com';
    	dtoLead.CategoriaCaja = 'Categoria Caja';
    	dtoLead.Fuentes = 'BD Call Center';
        
        string response = COS_creaProspecto_ws.doPost(dtoLead);
    }
    
    @isTest
    static void testMethod_3(){
        COS_creaProspectoRequest_dto dtoLead = new COS_creaProspectoRequest_dto();
        dtoLead.TipoID = '1';
		dtoLead.NumID = '79777999';
    	dtoLead.Nombre = 'Nombre1 Apellido1';
    	dtoLead.TelefonoContactoFijo = '2917720';
		dtoLead.TelefonoContactoCelular = '3107553362';
    	dtoLead.Email = 'Nombre1@gmail.com';
    	dtoLead.NumeroEmpresa = '9006547893';
    	dtoLead.Genero = 'Masculino';
    	dtoLead.Fecha = '2020-10-10 10:10:10';
    	dtoLead.Asesor = 'Asesor SFDC';
    	dtoLead.IDAsesor = '79888111';
    	dtoLead.EmailAsesor = 'Asesor@compensar.com';
    	dtoLead.CategoriaCaja = 'Categoria Caja';
    	dtoLead.Fuentes = 'BD Call Center';
        
        string response = COS_creaProspecto_ws.doPost(dtoLead);
    }
    
    @isTest
    static void testMethod_4(){
        COS_creaProspectoRequest_dto dtoLead = new COS_creaProspectoRequest_dto();
        dtoLead.TipoID = '1';
		dtoLead.NumID = '79777999';
    	dtoLead.Nombre = 'Nombre1';
    	dtoLead.TelefonoContactoFijo = '2917720';
		dtoLead.TelefonoContactoCelular = '3107553362';
    	dtoLead.Email = 'Nombre1@gmail.com';
    	dtoLead.NumeroEmpresa = '9006547893';
    	dtoLead.Genero = 'Masculino';
    	dtoLead.Fecha = '2020-10-10 10:10:10';
    	dtoLead.Asesor = 'Asesor SFDC';
    	dtoLead.IDAsesor = '79888111';
    	dtoLead.EmailAsesor = 'Asesor@compensar.com';
    	dtoLead.CategoriaCaja = 'Categoria Caja';
    	dtoLead.Fuentes = 'BD Call Center';
        
        string response = COS_creaProspecto_ws.doPost(dtoLead);
    }
    
    @isTest
    static void testMethod_5(){
        COS_creaProspectoRequest_dto dtoLead = new COS_creaProspectoRequest_dto();
        dtoLead.TipoID = '1';
		dtoLead.NumID = '79777999';
    	dtoLead.Nombre = 'Nombre1 Apellido1 Apellido2';
    	dtoLead.TelefonoContactoFijo = '';
		dtoLead.TelefonoContactoCelular = '';
    	dtoLead.Email = '';
    	dtoLead.NumeroEmpresa = '9006547893';
    	dtoLead.Genero = 'Masculino';
    	dtoLead.Fecha = '2020-10-10 10:10:10';
    	dtoLead.Asesor = 'Asesor SFDC';
    	dtoLead.IDAsesor = '79888111';
    	dtoLead.EmailAsesor = 'Asesor@compensar.com';
    	dtoLead.CategoriaCaja = 'Categoria Caja';
    	dtoLead.Fuentes = 'BD Call Center';
        
        string response = COS_creaProspecto_ws.doPost(dtoLead);
    }
}