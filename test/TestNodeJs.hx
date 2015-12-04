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
        Assert.equals(descriptor.arguments.get("id1"), "123");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789");
  }

  public function testBasePathQueryStringOneKVP() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function(?descriptor : RouteDescriptor) {
        Assert.equals(descriptor.query.get("hello"), "world");
      }
    ]);

    router.listen(false);
    emitter.emit("/?hello=world");
  }

  public function testQueryStringOneKVP() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.equals(descriptor.query.get("hello"), "world");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789?hello=world");
  }

  public function testQueryStringMultipleKVPs() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.equals(descriptor.query.get("hello"), "world");
        Assert.equals(descriptor.query.get("foo"), "bar");
        Assert.equals(descriptor.query.get("x"), "y");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789?hello=world&foo=bar&x=y");
  }

  public function testQueryStringOneFlag() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(descriptor.query.exists("flag"));
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789?flag");
  }

  public function testQueryStringMultipleFlags() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(descriptor.query.exists("flagX"));
        Assert.isTrue(descriptor.query.exists("flagY"));
        Assert.isTrue(descriptor.query.exists("flagZ"));
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789?flagX&flagY&flagZ");
  }

  public function testQueryStringMixingKVPsAndFlags() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/test/:id1/foo/:id2/bar/:id3" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(descriptor.query.exists("flagX"));
        Assert.isTrue(descriptor.query.exists("flagY"));
        Assert.isTrue(descriptor.query.exists("flagZ"));
        Assert.equals(descriptor.query.get("foo"), "bar");
        Assert.equals(descriptor.query.get("hello"), "world");
        Assert.equals(descriptor.query.get("one"), "two");
      }
    ]);

    router.listen(false);
    emitter.emit("/test/123/foo/456/bar/789?foo=bar&flagX&hello=world&flagY&one=two&flagZ");
  }

  public function testEmptyPath() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(true);
      }
    ]);

    router.listen(false);
    emitter.emit("");
  }

  public function testUnknownPath() {
    var emitter = new TestRouteEmitter();
    var router = new Routly(emitter);

    router.routes([
      "/exists" => function(?descriptor : RouteDescriptor) {
        Assert.isTrue(false); // we don't want this to get called
      }
    ]);

    router.unknown(function(?descriptor : RouteDescriptor) {
      trace(descriptor.raw);
      Assert.isTrue(true);
    });

    router.listen(false);
    emitter.emit("/nonexistent");
  }
}
