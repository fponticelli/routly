import utest.Assert;

class TestNodeJs {
	public function new () {}

	public function testBasePath() {
		var emitter = new TestRouteEmitter();
		var router = new Routly(emitter);

		router.routes([
		  "/" => function(/* path : RouteDescriptor */) {
		  	Assert.isTrue(true);
		  }	
		]);

		router.listen();

		emitter.emit("/");
	}

	// public function testTestPath() {
	// 	var router = new Routely();

	// 	router.map([
	// 	  "/test" => function(/* path : RouteDescriptor */) {
	// 	    trace("test path!");
	// 	  }	
	// 	]);

	// 	var testEmitter = new TestEmitter();

	// 	testEmitter.subscribe(router);	// emitTo may be better name
	// 	testEmitter.emit("/test");
	// }
}