
import js.Browser.*;
import js.html.HashChangeEvent;

class Routely {

	var mappings : Map<String, Void -> Void>;

	public function new(?dispatcher : IRouteEmitter) {
		// if no dispatcher is passed in, we default to using
		// an HtmlRouteEmitter, which simply wraps window.onhashchange
		if (dispatcher == null) 
			dispatcher = new HtmlRouteEmitter();

		// our router subscribes to the dispatcher
		// which calls the router's fire method upon route changes
		dispatcher.subscribe(this);
	}

	public function map(_mappings : Map<String, Void -> Void>) {
		if (mappings == null) 
			mappings = new Map<String, Void -> Void>();

		// assign the passed-in map to private var
		mappings = _mappings;
	}

	public function fire(path : String) {
		trace("in Routely.fire() for path: " + path);

		// if route does not exist, maybe display a 404 view?
		if (!mappings.exists(path)) 
			return;

		// the meat: invoke the callback associated with the matched route
		mappings.get(path)(/* RouteDescriptor */);
	}
}


