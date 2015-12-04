import utest.Assert;

class TestNodeJs {
  public function new () {}

  public function testBasePathWithInitialFire() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }  
    ]);

    router.listen();
  }

  public function testBasePathWithoutInitialFire() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }  
    ]);

    // pass false because the router assumes we want it to initiate 
    // a hashchangeevent when it starts listening (this is desired in the browser).
    // otherwise, the assert will be called twice
    router.listen(false);

    // force our emitter to emit
    emitter.emit("/");
  }

  public function testPathWithNoArguments() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }  
    ]);

    router.listen(false);
    emitter.emit("/test");
  }

  public function testPathMatchesWithOneArgument() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }  
    ]);

    router.listen(false);
    emitter.emit("/test/1");
  }

  public function testPathMatchesWithMultipleArguments() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }  
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789");
  }

}