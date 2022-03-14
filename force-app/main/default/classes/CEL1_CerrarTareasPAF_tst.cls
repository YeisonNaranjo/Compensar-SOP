/**
* Globant
* @author           Paula Bohórquez href=<pbohorquez@globant.com>
* Project:          Compensar
* Description:      Clase de prueba para batch y scheduleable CEL1_CerrarTareasPAF_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2020-02-19      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
@isTest
public class CEL1_CerrarTareasPAF_tst {

    @TestSetup
    static void crearData(){
        
		List<Task> lstTareas = new List<Task>();  
        for (Integer i = 0 ; i<50 ; i++) {
            lstTareas.add(new Task(Description = Label.CEL1_CandidatoConvertidoDesc,
                                        Priority = 'Normal',
                                        Subject = Label.CEL1_CandidatoConvertido,
                                        IsReminderSet = true,
                                        ReminderDateTime = System.now(),
                                        OwnerId =  UserInfo.getUserId()));
        }        
        insert lstTareas;
                                   
        Datetime dtTemp = Datetime.now().addDays(-9);
        for(Task objTask : lstTareas){
        	Test.setCreatedDate(objTask.Id, dtTemp);                              
        }
    }
    
    @istest
    public static void cerrarTareasPAF_tst(){        
        Test.startTest();
            CEL1_CerrarTareasPAF_sch schCerrar = new CEL1_CerrarTareasPAF_sch();
            String sch = '0 0 23 * * ?';
            System.schedule('Test CEL1_CerrarTareasPAF_sch', sch, schCerrar);           
           
        Test.stopTest();
    }
}