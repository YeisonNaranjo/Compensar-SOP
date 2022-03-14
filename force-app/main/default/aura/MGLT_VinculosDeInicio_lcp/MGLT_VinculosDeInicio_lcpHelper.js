({
	goToURL : function(URL) {
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			"url": URL,
			"isredirect": "true"
		});
		urlEvent.fire();		
	}
})