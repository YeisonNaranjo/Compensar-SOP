global class COS_prospectosSinAsignar_sch implements schedulable{
    global void execute(schedulableContext sc){
      COS_prospectosSinAsignar_bch b = new COS_prospectosSinAsignar_bch();
      Database.executeBatch (b,1);
    }
}