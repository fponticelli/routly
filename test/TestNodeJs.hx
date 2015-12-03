import utest.Assert;

class TestNodeJs {
	public function new () {}

	public function testBasePath() {
		var emitter = new TestRouteEmitter();
		var router = new Routely(emitter);

		router.map([
		  "/" => function(/* path : RouteDescriptor */) {
		  	Assert.isTrue(true);
		  }	
		]);

		//emitter.emitTo(router);	// emitTo may be better name
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