var initESW = function(gslbBaseURL) {

    embedded_svc.settings.displayHelpButton = true; //O falso
    embedded_svc.settings.language = ''; //Por ejemplo, introduzca 'en' o 'en-US'

    embedded_svc.settings.defaultMinimizedText = 'Iniciar'; //(Toma como valor predeterminado Sesión de chat con un experto)
    embedded_svc.settings.disabledMinimizedText = 'No disponible'; //(Toma como valor predeterminado Agente sin conexión)
    embedded_svc.settings.autoOpenPostChat = true;
    embedded_svc.settings.loadingText = 'Cargando'; //(Toma como valor predeterminado Cargando)
    //embedded_svc.settings.storageDomain = 'yourdomain.com'; //(Establece el dominio para su desarrollo de modo que los visitantes puedan navegar por subdominios durante una sesión de chat)

    // Configuración para Chat
    //embedded_svc.settings.directToButtonRouting = function(prechatFormData) {
        // Dynamically changes the button ID based on what the visitor enters in the pre-chat form.
        // Returns a valid button ID.
    //};
    //embedded_svc.settings.widgetWidth = "400px";
    //Establece la cumplimentación automática de los campos del formulario previo al chat
    //embedded_svc.settings.fallbackRouting = []; //Una matriz de identificadores de botones, de usuario o userId_buttonId
    //embedded_svc.settings.offlineSupportMinimizedText = '...'; //(Toma como valor predeterminado la opción Contacto)
   
    embedded_svc.settings.extraPrechatFormDetails = [
        {"label":"Nombre", "transcriptFields": ["RF2_Nombres__c"]},
        {"label":"Apellidos", "transcriptFields": ["RF2_Apellidos__c"]},
        {"label":"Tipo Identificación", "transcriptFields": ["MGLT_Tipo_Identificacion__c"]},                    
        {"label":"Número de identificación", "transcriptFields": ["RF2_NumeroIdentificacion__c"]},                    
        {"label":"Correo electrónico", "transcriptFields": ["RF2_CorreoElectronico__c"]},
        {"label":"Teléfono", "transcriptFields": ["RF2_Telefono__c"]},
        {"label":"Autorizo envío de campañas publicitarias", "transcriptFields": ["RF2_AutorizacionCampanias__c"]},
        {"label":"Consulta", "transcriptFields": ["RF2_Consulta__c"]},
        {"label": "Solucionado en primer contacto","value": "true","displayToAgent": true},
        {"label": "Origen del caso","value": "Chat","displayToAgent": true},
        {"label": "Estado","value": "Abierto","displayToAgent": true}
    ]; 

        
    embedded_svc.settings.extraPrechatInfo = [
        {
           
            "entityName":"Contact","showOnCreate":true,"entityFieldMaps":
            [
                 {
                    "doCreate":false,
                    "doFind":false,
                    "fieldName":"LastName",
                    "isExactMatch":true,
                    "label":"Apellidos"
                },
                                            {
                    "doCreate":false,
                    "doFind":false,
                    "fieldName":"FirstName",
                    "isExactMatch":true,
                    "label":"Nombre"
                },
                {
                    "doCreate":false,
                    "doFind":false,
                    "fieldName":"Name",
                    "isExactMatch":true,
                    "label":"Nombre completo"
                },
                {
                    "doCreate":false,
                    "doFind":false,
                    "fieldName":"Email",
                    "isExactMatch":true,
                    "label":"Correo electrónico"
                },
                   {
                    "doCreate":false,
                    "doFind":true,
                    "fieldName":"COM_TipoIdentificacion__c",
                    "isExactMatch":true,
                    "label":"Tipo Identificación"
                },
                                            {
                    "doCreate":false,
                    "doFind":true,
                    "fieldName":"COM_Numeroidentificacion__c",
                    "isExactMatch":true,
                    "label":"Número de identificación"
                }
            ]
        },
        
        {
            
            "entityName":"Case","showOnCreate":false,"entityFieldMaps":
            [
                {"isExactMatch":false,
                 "fieldName":"MGLT_Consulta__c",
                 "doCreate":true,
                 "doFind":false,
                 "label":"Consulta"
                },
                {"isExactMatch":false,
                 "fieldName":"RF2_SolucionadoPrimerContacto__c",
                 "doCreate":true,
                 "doFind":false,
                 "label":"Solucionado en primer contacto"
                },                            ,
                {"isExactMatch":false,
                 "fieldName":"Origin",
                 "doCreate":true,
                 "doFind":false,
                 "label":"Origen del caso"
                },                            ,
                {"isExactMatch":false,
                 "fieldName":"Status",
                 "doCreate":true,
                 "doFind":false,
                 "label":"Estado"
                }
            ]
        }
    ];         
    
    
     // Configuración para Chat
    embedded_svc.settings.directToButtonRouting = function(prechatFormData) {
            var valSeleccionado = prechatFormData[0].value; 
            switch (valSeleccionado) {
                case 'Vivienda': 
                    return "573190000008PonAAE";
                    
                case 'Vacunación Empresarial':      
                    return "573190000008PoiAAE";
                
                case 'Transacciones en línea':      
                    return "573190000008PodAAE";
                
                case 'Subsidio Monetario':      
                    return "573190000008PoYAAU";
                
                case 'Solicita tu Crédito Nuevo':       
                    return "573190000008PoTAAU";
                
                case 'Recreación y cultura':        
                    return "573190000008PoOAAU";
                
                case 'Odontología Especializada':       
                    return "573190000008PoJAAU";
                
                case 'Eventos':     
                    return "573190000008PoEAAU";
                
                case 'Educación':       
                    return "573190000008Po9AAE";
                
                case 'Deportes':        
                    return "573190000008Po4AAE";
                
                case 'Crédito vigente y pignoración de subsidio':       
                    return "573190000008PnzAAE";
                
                case 'Cirugía Estética':        
                    return "573190000008PnuAAE";
                
                case 'Afiliación Caja Compensación':        
                    return "573190000008PnkAAE";
                    
                default:          
                    return "573190000008PosAAE";
                
            }
        
        
    };
    
    embedded_svc.settings.enabledFeatures = ['LiveAgent'];
    embedded_svc.settings.entryFeature = 'LiveAgent';

    embedded_svc.init(
        'https://compensar.my.salesforce.com',
        'https://compensar-prod.secure.force.com/pruebachatmg',
        gslbBaseURL,
        '00D6A000001UfII',
        'Integracion_Chat',
        {
            baseLiveAgentContentURL: 'https://c.la1-c1cs-ph2.salesforceliveagent.com/content',
            deploymentId: '5726A000000HI4w',
            buttonId: '5732G000000fxT9',
            baseLiveAgentURL: 'https://d.la1-c1cs-ph2.salesforceliveagent.com/chat',
            eswLiveAgentDevName: 'EmbeddedServiceLiveAgent_Parent04I190000008OM7EAM_16d9258492b',
            isOfflineSupportEnabled: false
        }
    );
};

if (!window.embedded_svc) {
    var s = document.createElement('script');
    s.setAttribute('src', 'https://compensar.my.salesforce.com/embeddedservice/5.0/esw.min.js');
    s.onload = function() {
        initESW(null);
    };
    document.body.appendChild(s);
} else {
    initESW('https://service.force.com');
}