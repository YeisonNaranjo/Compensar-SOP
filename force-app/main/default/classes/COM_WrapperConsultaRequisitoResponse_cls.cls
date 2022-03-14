public with sharing class COM_WrapperConsultaRequisitoResponse_cls {
    public ConsultaRequisitos_Response ConsultaRequisitos_Response {get;set;}

	public class ConsultaRequisitos_Response extends COM_BaseWrapperResponse_cls{
		public  Header      Header                  {get;set;}
        public  Body        Body                    {get;set;}
	}

	public class Body{
		public Requisitos Requisitos {get;set;}
    }

    public class Requisitos{
    	public List <Requisito> Requisito {get;set;}
    }

    public class Requisito{
    	public String Tipo {get;set;}
        public String FechaInicio {get;set;}
        public String FechaFin {get;set;}
        public String ValorAlfanumerico {get;set;}
        public String ValorNumerico {get;set;}
        public String ValorBooleano {get;set;}
    }
}