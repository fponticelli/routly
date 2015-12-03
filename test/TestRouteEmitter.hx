import js.html.HashChangeEvent;

class TestRouteEmitter implements IRouteEmitter {
  public var subscribers : Array<Routly>;

  public function new() {}

  public function emit(?path : String) {

    if (path == null) {
      path = "/";
    }

    for(subscriber in subscribers) {
      subscriber.fire(path);
    }
  }

  public function subscribe(router : Routly) {
    if (subscribers == null) subscribers = new Array<Routly>();

    subscribers.push(router);
  }
}
