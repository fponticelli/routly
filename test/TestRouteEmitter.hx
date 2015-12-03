import js.html.HashChangeEvent;

class TestRouteEmitter implements IRouteEmitter {
  public var subscribers : Array<Routely>;

  public function new() {}

  public function emit(?path : String) {

    if (path == null) {
      path = "/";
    }

    for(subscriber in subscribers) {
      subscriber.fire(path);
    }
  }

  public function subscribe(router : Routely) {
    if (subscribers == null) subscribers = new Array<Routely>();

    subscribers.push(router);
  }
}
