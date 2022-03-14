public with sharing class COM_WrapperConsultaRequisitosRequest_cls {
	public ConsultaRequisitos_Request ConsultaRequisitos_Request { get; set; }

	public class ConsultaRequisitos_Request extends COM_BaseWrapper_cls{
		public  Header      Header                  {get;set;}
        public  Body        Body                    {get;set;}
	}

	public class Body{
        public string TipoIdAfiliado {get;set;}
		public string NumeroIdAfiliado {get;set;} 
		public Requisitos Requisitos {get;set;}

    }

    public class Requisitos{
    	public List <Requisito> Requisito {get;set;}
    }

    public class Requisito{
    	public String Tipo {get;set;}
    }

}