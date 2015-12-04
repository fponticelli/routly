class RouteDescriptor {

  public var raw : String;
  public var virtual : String;
  public var arguments : Array<String>;
  public var query : Map<String, String>;

  public function new(rawPath : String = null, virtualPath : String = null, arguments : Array<String> = null, queryString : Map<String, String> = null) {
    this.raw = rawPath;
    this.virtual = virtualPath;
    this.arguments = arguments;
    this.query = queryString;
  }
}
