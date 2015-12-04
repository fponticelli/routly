class RouteDescriptor {

  public var raw : String;
  public var virtual : String;
  public var arguments : Array<String>;
  public var query : Map<String, String>;

  public function new(_rawPath : String = null, _virtualPath : String = null, _arguments : Array<String> = null, queryString : Map<String, String> = null) {
    raw = _rawPath;
    virtual = _virtualPath;
    arguments = _arguments;
    query = queryString;
  }
}
