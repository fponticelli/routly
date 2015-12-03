class RouteDescriptor {

	public var path : String;
	public var arguments : Array<String>;
	public var query : Map<String, String>;

	public function new(_path : String = null, _arguments : Array<String> = null, queryString : Map<String, String> = null) {
		path = _path;
		arguments = _arguments;
		query = queryString;
	}
}

