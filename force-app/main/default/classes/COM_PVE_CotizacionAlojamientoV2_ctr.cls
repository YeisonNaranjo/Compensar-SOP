public with sharing class COM_PVE_CotizacionAlojamientoV2_ctr {

	public String templateHtml{get;set;}
	public list<Opportunity> prostrTipoCotizacionductos{get;set;}
	public String htmlproductos;
	public String htmlproductosAdicionales;
	public String htmlserviciosTransporte;
	public String nombreAsesor {get;set;}
	public String celAsesor {get;set;}
	public String emailAsesor{get;set;}
	public string color;
	public String strTipo;

	public COM_PVE_CotizacionAlojamientoV2_ctr(ApexPages.Standardcontroller controller) {

		String strId = Apexpages.currentPage().getParameters().get( 'id' );
		strTipo = Apexpages.currentPage().getParameters().get( 'tipoDoc' );
		String strTipoCotizacion = '{!$Resource.logo'+strTipo+'}';

		EmailTemplate template= new EmailTemplate ();
		template = [select id, name, Body,HTMLValue from EmailTemplate where developername =: strTipo];
		templateHtml = template.HTMLValue;
		list<Quote> cotizaciones = new list<Quote>();

		if (strId!= null){
		cotizaciones = [SELECT CreatedDate,Id,
						OpportunityId,Opportunity.COM_Fechahorainicio__c, 
						Opportunity.Account.COM_Numero_de_identificacion__c,
						Opportunity.Account.Name, 
						Opportunity.Account.Id, 
						Opportunity.COM_Fechahorafinalizacion__c,
						Opportunity.COM_TotalAlojamiento__c,
						Opportunity.COM_Totaladicionales__c,
						Opportunity.COM_ValorTotalAlojamiento__c,
						Opportunity.COM_ValorTransporte__c,
						QuoteNumber 
						FROM Quote 
						WHERE id =: strId LIMIT 1];
		}
	
		String url= getDocumentLogoUrl('logo'+strTipo);
		AccountContactRelation contactoPrincipal = new AccountContactRelation();
		contactoPrincipal= getContactoPrincipal(cotizaciones.get(0).Opportunity.Account.Id);
		User asesor = new User ();
		asesor = getUser();
		nombreAsesor = asesor.Name;
		celAsesor = asesor.Phone;
		emailAsesor = asesor.Email;
		color =  strTipo.contains('LagoSol') ? '#1CFF14' :'#FFF4CF' ;

		htmlproductos = getHhtmlproductos( cotizaciones.get(0).Opportunity.id, 'Alojamiento', cotizaciones.get(0).Opportunity.COM_ValorTotalAlojamiento__c, cotizaciones.get(0).Opportunity.COM_TotalAlojamiento__c, cotizaciones.get(0).Opportunity.COM_Totaladicionales__c );
		htmlproductosAdicionales = getHhtmlproductos( cotizaciones.get(0).Opportunity.id, 'Adicionales', cotizaciones.get(0).Opportunity.COM_ValorTotalAlojamiento__c, cotizaciones.get(0).Opportunity.COM_TotalAlojamiento__c, cotizaciones.get(0).Opportunity.COM_Totaladicionales__c);
		htmlserviciosTransporte= getHtmlTableTransporte( cotizaciones.get(0).Opportunity.COM_ValorTotalAlojamiento__c, cotizaciones.get(0).Opportunity.COM_ValorTransporte__c);
		templateHtml = templateHtml.replace('{logoCotizacion}',  '<img  src="'+url+'" width="100%" />');
		templateHtml = templateHtml.replace('{!Account.Name}', cotizaciones.get(0).Opportunity.Account.Name );
		templateHtml = templateHtml.replace('{NombrecontactoPrincipal}',  contactoPrincipal.Contact.firstname + ' '+ contactoPrincipal.Contact.Lastname);
		templateHtml = templateHtml.replace('{CargocontactoPrincipal}',  contactoPrincipal.COM_CargoEmpresa__c);
		templateHtml = templateHtml.replace('{ProductosOportunidad}', htmlproductos );
		templateHtml = templateHtml.replace('{ProductosOportunidad Adicionales}', htmlproductosAdicionales );
		templateHtml = templateHtml.replace('{transporte}', htmlserviciosTransporte );
		templateHtml = templateHtml.replace('{cotizacionNumero}', cotizaciones.get(0).QuoteNumber );
		templateHtml = templateHtml.replace('{cotizacionFecha}', String.valueOf(cotizaciones.get(0).CreatedDate) );
		templateHtml = templateHtml.replace('{Account.Nit}',String.valueOf(cotizaciones.get(0).Opportunity.Account.COM_Numero_de_identificacion__c	
 ));
		templateHtml = templateHtml.replace('{opp.COM_Fechahorainicio}', String.valueOf(cotizaciones.get(0).Opportunity.COM_Fechahorainicio__c) );
		templateHtml = templateHtml.replace('{opp_Fechahorafinalización}', String.valueOf(cotizaciones.get(0).Opportunity.COM_Fechahorafinalizacion__c ));
		templateHtml = templateHtml.replace('{fecha}', System.today().day() + ' de '+ COM_CambiarALetrasUtil_cls.getMesLetras(System.today().month()) +' '+ System.today().year()); 
		
	}


	public String getHhtmlproductos(String idopp, String tipo, Decimal valorTotal, Decimal valorAlojamiento, Decimal valorAdicionales){

		list<OpportunityLineItem> productos = new list<OpportunityLineItem>();
		String recordtypename = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(tipo).getRecordTypeId();

		productos = [SELECT Id,Name,OpportunityId, 
							COM_NoPax__c, ListPrice,UnitPrice, 
							TotalPrice, Quantity, Product2.RecordtypeId 
						FROM OpportunityLineItem  
						WHERE OpportunityId =: idopp AND Product2.RecordtypeId =: recordtypename];


		String 	htmlproductos = '<div id="productos">';
				htmlproductos += '<table width="100%" border="1" Style="border:1px Solid #000;font-family: sans-serif; font-size:10px;font-weight: lighter; margin:0px; padding:0px;">';
				
			if (tipo == 'Adicionales')
				htmlproductos += '<tr Style="background-color:  '+color+';"><th colspan="5" Style="text-align: center;">SERVICIOS ADICIONALES</th></tr>';

				htmlproductos += '<tr Style="background-color:  '+color+';"><th>CONCEPTO</th><th scope="col">No.PAX</th><th scope="col">VALOR PERSONA</th>';
				
			if (strTipo=='CotizacionConvencionLagoMar' ||  strTipo=='CotizacionConvencionLagoSol')
				htmlproductos += '<th scope="col">No.DE NOCHES</th>';
				
				htmlproductos += '<th scope="col">VALOR TOTAL</th></tr>';
				
			for (OpportunityLineItem pr: productos ){				

				String valor =  tipo == 'Alojamiento' ? String.valueOf(pr.UnitPrice) : 'Incluido' ;
				htmlproductos += '<tr><td>'+pr.Name+'</td>'+
								 '<td>'+pr.COM_NoPax__c+'</td>';
				if (strTipo=='CotizacionConvencionLagoMar' ||  strTipo=='CotizacionConvencionLagoSol')
				htmlproductos += '<td>'+valor+'</td>';
				htmlproductos += '<td>'+pr.Quantity+'</td>'+
								 '<td>'+pr.TotalPrice+'</td></tr>';
			}

			if (tipo == 'Alojamiento'){
				htmlproductos += '<tr Style="background-color:  '+color+';"><td Style="text-align: center;" colspan=4>SUB -TOTAL ALOJAMIENTO</td><td>'+valorAlojamiento+'</td></tr>';
		
			} else {
				htmlproductos += '<tr Style="background-color:  '+color+';"><td Style="text-align: center;" colspan=4>Subtotal  Servicios Adicionales</td><td>'+valorAdicionales+'</td></tr>';
				htmlproductos += '<tr><tdcolspan=5></td></tr>';
				htmlproductos += '<tr Style="background-color:  '+color+';"><td Style="text-align: center;" colspan=4>SUB -TOTAL ALOJAMIENTO</td><td>'+valorTotal+'</td></tr>';	
			}
			
			htmlproductos += '</table></div></br>';
 			return htmlproductos;

	}

	public static string getDocumentLogoUrl(String name)
	{
		List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document where Name =: name limit 1];
		string strOrgId = UserInfo.getOrganizationId();
		string orgInst = URL.getSalesforceBaseUrl().getHost();
		string strDocUrl = 'https://'+orgInst + '/servlet/servlet.ImageServer?id=' + lstDocument[0].Id + '&oid=' + strOrgId;
		return strDocUrl;
	}


	public static AccountContactRelation getContactoPrincipal (String idAccount){

		list<AccountContactRelation> lstcontactoPrincipal = new list<AccountContactRelation> ();
		lstcontactoPrincipal = [SELECT id, Contact.firstname,Contact.Lastname, COM_CargoEmpresa__c 
								FROM AccountContactRelation 
								WHERE Accountid =: idAccount AND Roles INCLUDES ('Representante Legal') AND isActive = true Limit 1];
		return lstcontactoPrincipal.get(0);
	}

	public String getHtmlTableTransporte (Decimal valorTransporte , Decimal valorTotal){

		Decimal valorTransporteAlojamiento= valorTransporte + valorTotal;

		String 	htmlproductos = '<div id="transporte">';
				htmlproductos += '<table  width="100%" border="1" Style="border:1px Solid #000;font-family: sans-serif; font-size:10px;font-weight: lighter; margin:0px; padding:0px;">';
				htmlproductos += '<tr><td Style="text-align: center;">Servicio de transporte (Opcional)  Bogota - Girardot - Bogota para el grupo,  modelo reciente, con baño, aire acondicionado y revisión técnico mecánica al día. </td>';
				htmlproductos += '<td>'+valorTransporte+'</td></tr>';				
				htmlproductos += '<tr Style="background-color:  '+color+';"><td Style="text-align: center;"  colspan=4>TOTAL PRELIQUIDACION + TRANSPORTE</td><td>'+valorTransporteAlojamiento+'</td></tr>';	
				htmlproductos += '<tr Style="background-color:  '+color+';"><td colspan=5></td></tr>';	
				htmlproductos += '</table></div></br>';

		return htmlproductos;

	}

	public static User getUser (){

    	Id runningUserId = UserInfo.getUserId();
        User user = new user ();
        user = [Select id, name, Email, Phone from User where id =: runningUserId ]; 
        return user;

    }



}