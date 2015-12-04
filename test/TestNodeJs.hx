import utest.Assert;

class TestNodeJs {
  public function new () {}

  public function testBasePathWithInitialFire() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function() {
        Assert.isTrue(true);
      }  
    ]);

    router.listen();
  }

  public function testBasePathWithoutInitialFire() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function() {
        Assert.isTrue(true);
      }
    ]);

    router.listen(false);
    emitter.emit("/");
  }


  public function testPathWithoutArguments() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test" => function() {
        Assert.isTrue(true);
      }
    ]);

    router.listen(false);
    emitter.emit("/test");
  }

  public function testPathWith1ArgumentNullableInt() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/:id" => function(?id : Int) {
        Assert.equals(id, 2873);
      }
    ]);

    router.listen(false);
    emitter.emit("/2873");
  }

  public function test1ArgumentNullableString() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/:key" => function(?key : String) {
        Assert.equals(key, "abcd1234");
      }
    ]);

    router.listen(false);
    emitter.emit("/abcd1234");
  }

  public function testMultipleArgsDifferingTypes1() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/:key/test/:id" => function(?key : String, ?id : Int) {
        Assert.equals(id, 2);
        Assert.equals(key, "helloWorld");
      }
    ]);

    router.listen(false);
    emitter.emit("/helloWorld/test/2");
  }

  public function testMultipleArgsDifferingTypes2() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/:id/test/:key" => function(?id : Int, ?key : String) {
        Assert.equals(id, 2);
        Assert.equals(key, "helloWorld");
      }
    ]);

    router.listen(false);
    emitter.emit("/2/test/helloWorld");
  }

  public function testIncorrectType() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/:id" => function(?id : Int) {
        //trace("Why is this an Int?! > " + id);
        Assert.isTrue(true);
      }
    ]);

    router.listen(false);
    emitter.emit("/helloWorld");
  }


  public function testDecimal() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/lat/:lat/long/:long" => function(?lat : Float, ?long : Float) {
        //trace("Why is this an Int?! > " + id);
        Assert.equals(lat + long, 27.83236462346 - 7.473643234);
      }
    ]);

    router.listen(false);
    emitter.emit("/lat/27.83236462346/long/-7.473643234");
  }
/*

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
        Assert.equals(descriptor.arguments.get("id1"), "123");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789");
  }

  public function testPathMatchesWithMultipleArguments() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.equals(descriptor.arguments.get("id1"), "123");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789");
  }
  */
}