import utest.Assert;

class TestHtml {
	public function new () {}

	public function testBasePath() {

		var router = new Routely(/* new HtmlRouteEmitter() is implicit */);

		router.map([
		  "/" => function(/* path : RouteDescriptor */) {
		  	Assert.isTrue(true);
		  }	
		]);
	}
}
