public without sharing class COM_RegistrarCliente_ctr {
	
	public String strMensaje {get; set;}
	public Account objCuenta {get; set;}
	
	public COM_RegistrarCliente_ctr(Apexpages.Standardcontroller objStandardController){
		list<Account> lstCuenta;
		
		this.objCuenta = (Account) objStandardController.getRecord();
		
		lstCuenta = [SELECT Id, Name, COM_Otrosnombres__c, COM_Primerapellido__c, COM_Segundoapellido__c, COM_Nombre_completo_del_cliente__c, 
							COM_FechaNacimiento__c, COM_Genero__c, COM_Estado_civil__c, COM_Profesion__c, COM_Categoria__c, COM_Estadoafiliacion__c, 
							COM_Digitoverificacion__c, Type, COM_NombreComercial__c, COM_Fechaconstitucion__c, COM_ActividadEconomicaCIIU__r.COM_Codigo__c, 
							COM_SectorEconomico__c, Parent.Name, COM_Sucursal__c, COM_CentroCosto__c, COM_Negociacionadicional__c, Phone, COM_Extension__c, 
							COM_Barrio__c, COM_Aceptaenviocorreoelectronico__c, COM_Tipodireccion__c, COM_Direccion__c, COM_Localidad__c, 
							COM_Ciudad__r.COM_Codigo__c, COM_Ciudad__r.Name, COM_Ciudad__r.COM_Departamento__c, COM_CorreoElectronico__c, 
							COM_UsuarioFacebook__c, COM_UsuarioTwitter__c, RecordTypeId, RecordType.DeveloperName, COM_TipoIdentificacion__c, 
							COM_Numero_de_identificacion__c, COM_NAUTCLI__c, COM_TipoCliente__c, COM_ActividadeconomicaSENA__c, COM_CodigoARL__c, 
							COM_No_procesado_On_Line__c, COM_Primernombre__c
					FROM Account 
					WHERE Id = :this.objCuenta.Id];
					
		if(lstCuenta.isEmpty()){
			strMensaje = 'No hay cliente a registrar.';
			this.objCuenta = null;
			return;
		}
		
		this.objCuenta = lstCuenta.get(0);
		
		
	}
	
	public void procesarRegistro(){
		COM_ConsultarClienteGC_ws clientesGC;
		COM_WrapperConsultaClienteGCResponse_cls.Body wrpCuenta;
		Decimal decResponse;
		list<COM_LogTransacciones__c> lstLogs;
		//COM_LogTransacciones__c objLog;
		String strRequestAux;
		boolean blnActualizar;
		COM_WrapperCrearClienteGCResponse_cls nautcli;
		
		if(this.objCuenta == null){
			return;
		}
		
		blnActualizar = false;
		
		lstLogs = new list<COM_LogTransacciones__c>();
		strRequestAux = '';
		
		if(this.objCuenta.COM_NAUTCLI__c != null){
			strMensaje = 'El cliente ya se encuentra registrado.';
			return;
		} else{
			clientesGC = new COM_ConsultarClienteGC_ws();
			
			try {
				system.debug('........... Va a consultar cliente en GC');
				strRequestAux = 'COM_TipoIdentificacion__c: ' + objCuenta.COM_TipoIdentificacion__c + '; COM_Numero_de_identificacion__c: ' + objCuenta.COM_Numero_de_identificacion__c;
				wrpCuenta = clientesGC.Consultar(Integer.valueOf(objCuenta.COM_TipoIdentificacion__c), Integer.valueOf(objCuenta.COM_Numero_de_identificacion__c));
				/*objLog = COM_Utilidades_cls.generarLog(null, strRequestAux, wrpCuenta, Label.COM_WS_ConsultarClienteGC, null);
				lstLogs.add(objLog);*/
				//if(wrpCuenta != null && wrpCuenta.cliente.tipoIdentificacion != '-1' && wrpCuenta.cliente.numeroIdentificacion != '-1'){
				if(wrpCuenta != null && (wrpCuenta.cliente.Id != '0' && wrpCuenta.cliente.Id != '-1')){
					system.debug('........... SI se consulto el cliente y se encontro en GC');
					//objCuenta.COM_NAUTCLI__c = Decimal.valueOf(wrpCuenta.cliente.id);
					strMensaje = 'El cliente ya se encuentra registrado en Gestion de Clientes, por favor consultelo por la ficha Consultar Cliente.';
				} else{
					system.debug('........... NO se encontro el cliente y se va crear en GC');			
					//decResponse = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuenta.Id, false);
					try{
						nautcli = COM_CrearActualizarClienteGC_ws.CrearCliente(this.objCuenta.Id, false,0);
					} catch (COM_WSInactivoException e) {
			        	this.objCuenta.COM_No_procesado_On_Line__c = true;
			            blnActualizar = true;
			            system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
			        } catch(Exception e){
			            throw e;
			        }
			        //Si la transaccion estaba marcada indicando que NO fue procesada Online
					//Se desmarca para indicar que ya se proceso Online
		            if(this.objCuenta.COM_No_procesado_On_Line__c){
		            	this.objCuenta.COM_No_procesado_On_Line__c = false;
		            	blnActualizar = true;
		            } 
					/*objLog = COM_Utilidades_cls.generarLog(objCuenta.Id, objCuenta+'', nautcli, Label.COM_WS_CrearActualizarClienteGC, null);
					lstLogs.add(objLog);*/
					if(nautcli != null && nautcli.CustomerMng_CrearClienteResponse != null && nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente != '0'){
					//if(decResponse != null){
						//this.objCuenta.COM_NAUTCLI__c = decResponse;
						this.objCuenta.COM_NAUTCLI__c = nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente;
						strMensaje = 'Se registro el cliente con éxito. ';
						system.debug('........... NAUTCLI: ' + objCuenta.COM_NAUTCLI__c);
						update this.objCuenta;
					} else {
						if(blnActualizar){
							update this.objCuenta;
						}
                        strMensaje = 'No se pudo crear el cliente.\n'+(nautcli!=null?nautcli.CustomerMng_CrearClienteResponse.Header.ResponseDesc:'GC: Error interno del servidor.');
						system.debug('........... NAUTCLI: ' + objCuenta.COM_NAUTCLI__c);
					}
					
				}
				
			} catch(Exception e){
				/*objLog = COM_Utilidades_cls.generarLog(objCuenta.Id, objCuenta+'', null, Label.COM_WS_CrearActualizarClienteGC, null);
				lstLogs.add(objLog);*/
				System.Debug('====================== EXCEPCION [NAUCLI del Cliente] ======================');
				System.debug( e.getMessage() + ' ' + e.getStackTraceString());
				System.Debug('============================================================================');
				strMensaje = 'Error registrando el cliente: ' + e.getMessage();
			}
		}
		
		lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
		if(!lstLogs.isEmpty()){
			try{
	    		insert lstLogs;
	    		lstLogs = new list<COM_LogTransacciones__c>();
				Cache.Org.put('local.partition1.logs', lstLogs);
	    	} catch(Exception e){
	    		system.debug('NO SE PUDO GUARDAR EL LOG.');
	    		System.Debug('====================== EXCEPCION [log COM_RegistrarCliente_ctr] ======================');
				System.debug( e.getMessage() + ' ' + e.getStackTraceString());
				System.Debug('========================================================================================');
	    	}
		}
		
	}
    
}