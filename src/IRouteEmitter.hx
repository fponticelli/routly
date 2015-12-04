import js.html.HashChangeEvent;
///
/// IRouteDispatcher wraps window.onhashchange, which allows to easier testing on the server.
/// Probably poorly named
///
interface IRouteEmitter {
  public var subscribers : Array<Routly>;
  public function emit(?path : String) : Void;
  public function subscribe(router : Routly) : Void;
}
