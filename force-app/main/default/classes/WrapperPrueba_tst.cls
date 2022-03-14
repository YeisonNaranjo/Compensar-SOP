@isTest
private class WrapperPrueba_tst {
	
	@isTest static void test_method_one() {
		WrapperPrueba wp = new WrapperPrueba();
		System.debug(wp.Body);


		WrapperPrueba.Attributtes atr = new WrapperPrueba.Attributtes();
		System.debug(atr.name);
		System.debug(atr.id);

		WrapperPrueba.DocumentType_x dtx = new WrapperPrueba.DocumentType_x();
		System.debug(dtx.value);
		System.debug(dtx.attributtes);

		WrapperPrueba.Document_x dx = new WrapperPrueba.Document_x();
		System.debug(dx.value);
		System.debug(dx.attributtes);

		WrapperPrueba.Document d = new WrapperPrueba.Document();
		System.debug(d.DateStored);
		System.debug(d.DocumentType_x); 
		System.debug(d.LatestRevision);
		System.debug(d.Document_x);

		WrapperPrueba.Result r = new WrapperPrueba.Result();
		System.debug(r.Document);

		WrapperPrueba.Response rs = new WrapperPrueba.Response();
		System.debug(rs.Result);
		System.debug(rs.Code);

		WrapperPrueba.Xml x = new WrapperPrueba.Xml();
		System.debug(x.Response);

		WrapperPrueba.ExecuteResult exr = new WrapperPrueba.ExecuteResult();
		System.debug(exr.xml);


		WrapperPrueba.ExecuteResponse ers = new WrapperPrueba.ExecuteResponse();
		System.debug(ers.ExecuteResult);


		WrapperPrueba.OnBaseServExecuteRs obs = new WrapperPrueba.OnBaseServExecuteRs();
		System.debug(obs.ExecuteResponse);

		WrapperPrueba.System_x sx = new WrapperPrueba.System_x();
		System.debug(sx.TransactionID);
		System.debug(sx.SystemInvokedService);
		System.debug(sx.ResponseDate);
		System.debug(sx.RequestDate);

		WrapperPrueba.Header h = new WrapperPrueba.Header();
		System.debug(h.System_x);

		WrapperPrueba.WsDocServExecuteOnBaseRs wdseobes = new WrapperPrueba.WsDocServExecuteOnBaseRs();
		System.debug(wdseobes.OnBaseServ_Execute_Rs);
		System.debug(wdseobes.Header);

		WrapperPrueba.Body bd = new WrapperPrueba.Body();
		System.debug(bd.WsDocServ_ExecuteOnBase_Rs);

		WrapperPrueba.RootObject ro = new WrapperPrueba.RootObject(); 
		System.debug(ro.Body);
	}
	
}