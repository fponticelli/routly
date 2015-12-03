import routely.*;
import js.Browser.*;
import js.html.HashChangeEvent;

class HtmlRouteEmitter implements IRouteEmitter {
  public var subscribers : Array<Routely>;

  public function new() {
    // wrap our emit method around the browser's window.onhashchange
    trace("in HtmlRouteEmitter constructor");
    window.onhashchange = function(changeEvent : HashChangeEvent) {
      var path = parsePath(changeEvent);
      emit(path);
    }
  }

  public function emit(path : String) {
    for(subscriber in subscribers) {
      subscriber.fire(path);
    }
  }

  public function subscribe(router : Routely) {
    if (subscribers == null) subscribers = new Array<Routely>();

    subscribers.push(router);
  }

  // take a HashChangeEvent and return the new hash path
  private function parsePath(hashChangeEvent : HashChangeEvent) {
    var split = hashChangeEvent.newURL.split("#");
    if (split == null || split.length < 2)
      throw "malformed newURL: " + hashChangeEvent.newURL + " --> must contains a hash (#)";

    return split[1];
  }
}
