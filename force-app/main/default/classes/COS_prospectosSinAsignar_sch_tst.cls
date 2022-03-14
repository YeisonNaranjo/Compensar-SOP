@istest
public class COS_prospectosSinAsignar_sch_tst {
    @istest
    public static void unit_Test1(){
        
        Test.startTest();
        string cronExpr = '0 0 0 15 3 ? 2022';
		COS_prospectosSinAsignar_sch abs= new COS_prospectosSinAsignar_sch();
		String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
		abs.execute(null);
		Test.stopTest();

    }

}