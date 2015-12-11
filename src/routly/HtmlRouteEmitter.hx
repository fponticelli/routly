package routly;

import routely.*;
import js.Browser.*;
import js.html.HashChangeEvent;

class HtmlRouteEmitter implements IRouteEmitter {
  public var subscribers = new Array<Routly>();

  public function new() {

    // wrap the browser's window.onhashchange, which fires a
    // js.html.HashChangeEvent, which must be converted to a regular
    // string representing the new hash-path.  E.g., if the url is changed
    // to http://blah.com/#/test, then emit will be called with path "/test"
    window.onhashchange = function(changeEvent : HashChangeEvent) {
      var path = parsePath(changeEvent);
      emit(path);
    }
  }

  public function emit(?path : String) {

    // if a path is NOT passed in,
    // grab the current hash and use it
    // if no hash exist, return the base path
    if (path == null) {
      path = window.location.hash;
      if (path == "") {
        path = "/";
      }
    }

    // one final manipulation:
    // if we have a hash, it is of the form "#/asdf"
    // but we only want to pass "/asdf" -- so strip the #
    if (path.charAt(0) == "#") {
      path = path.substring(1);
    }

    // to emit, we must call .fire() on
    // all our subscribers, passing in the path
    for(subscriber in subscribers) {
      subscriber.fire(path);
    }
  }

  // add subscribers, which are routers
  public function subscribe(router : Routly) {
    subscribers.push(router);
  }

  // helper method: takes a HashChangeEvent
  // and returns the new hash path
  private function parsePath(hashChangeEvent : HashChangeEvent) {
    var split = hashChangeEvent.newURL.split("#");
    if (split == null || split.length < 2)
      throw "malformed newURL: " + hashChangeEvent.newURL + " --> must contains a hash (#)";

    return split[1];
  }
}
