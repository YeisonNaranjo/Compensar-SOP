/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			ProjectName
* Description:		Clase encargada de ejecutar  las operaciones de los trigger sobre el objeto 
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		18/09/2017		Cristian Mosquera (CM)		Implementacion inicial del trigger.
**/
public class Example {

    private Response response;

    public Response getResponse() {
        return response;
    }

    public void setResponse(Response response) {
        this.response = response;
    }



    public class Response {

        private Result result;
        private String code;

        public Result getResult() {
            return result;
        }

        public void setResult(Result result) {
            this.result = result;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }


    }

    public class Result {

        private List<Document> document = null;

        public List<Document> getDocument() {
            return document;
        }

        public void setDocument(List<Document> document) {
            this.document = document;
        }


    }


    public class Document {

        private String dateStored;
        private DocumentType documentType;
        private String latestRevision;
        private List<DocumentParentProperties> document_x = null;

        public String getDateStored() {
            return dateStored;
        }

        public void setDateStored(String dateStored) {
            this.dateStored = dateStored;
        }

        public DocumentType getDocumentType() {
            return documentType;
        }

        public void setDocumentType(DocumentType documentType) {
            this.documentType = documentType;
        }

        public String getLatestRevision() {
            return latestRevision;
        }

        public void setLatestRevision(String latestRevision) {
            this.latestRevision = latestRevision;
        }

        public List<DocumentParentProperties> getDocument_x() {
            return document_x;
        }

        public void setDocument(List<DocumentParentProperties> document_x) {
            this.document_x = document_x;
        }


    }



    public class DocumentParentProperties {

        private String value;
        private Attributtes attributtes;

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public Attributtes getAttributtes() {
            return attributtes;
        }

        public void setAttributtes(Attributtes attributtes) {
            this.attributtes = attributtes;
        }
    }

    public class Attributtes {

        private String name;
        private String id;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

    }

    public class DocumentType {

        private String value;
        private Attributtes attributtes;

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public Attributtes getAttributtes() {
            return attributtes;
        }

        public void setAttributtes(Attributtes attributtes) {
            this.attributtes = attributtes;
        }


    }


}