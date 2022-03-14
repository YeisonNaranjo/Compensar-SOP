/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de definir los atributos de salida del servicio de aldea.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
public class COM_AldeaRequisitoResponse_cls {

    private Body Body;

    private COM_BaseWrapper_cls.Header  Header;

    public Body getBody ()
    {
        return Body;
    }

    public void setBody (Body Body)
    {
        this.Body = Body;
    }

    public COM_BaseWrapper_cls.Header  getHeader ()
    {
        return Header;
    }

    public void setHeader (COM_BaseWrapper_cls.Header  Header)
    {
        this.Header = Header;
    }

    /**
     * @see Object.Tostring()
     */
    public override String toString() {
        return  'ClassPojo [Body = '+Body+', Header = '+Header+']';
    }


    public class Body
    {
        private Requisitos Requisitos;

        public Requisitos getRequisitos ()
        {
            return Requisitos;
        }

        public void setRequisitos (Requisitos Requisitos)
        {
            this.Requisitos = Requisitos;
        }


        public override String toString()
        {
            return 'ClassPojo [Requisitos = '+Requisitos+']';
        }
    }


    public class Requisitos
    {
        private Requisito Requisito;

        public Requisito getRequisito ()
        {
            return Requisito;
        }

        public void setRequisito (Requisito Requisito)
        {
            this.Requisito = Requisito;
        }

        public override String toString()
        {
            return 'ClassPojo [Requisito = '+Requisito+']';
        }
    }

    public class Requisito
    {
        private String FechaInicio;

        private String Estado;

        private String Tipo;

        private String FechaFin;

        public String getFechaInicio ()
        {
            return FechaInicio;
        }

        public void setFechaInicio (String FechaInicio)
        {
            this.FechaInicio = FechaInicio;
        }

        public String getEstado ()
        {
            return Estado;
        }

        public void setEstado (String Estado)
        {
            this.Estado = Estado;
        }

        public String getTipo ()
        {
            return Tipo;
        }

        public void setTipo (String Tipo)
        {
            this.Tipo = Tipo;
        }

        public String getFechaFin ()
        {
            return FechaFin;
        }

        public void setFechaFin (String FechaFin)
        {
            this.FechaFin = FechaFin;
        }

        public override String toString()
        {
            return 'ClassPojo [FechaInicio = '+FechaInicio+', Estado = '+Estado+', Tipo = '+Tipo+', FechaFin = '+FechaFin+']';
        }
    }
}