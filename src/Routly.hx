
import js.Browser.*;
import js.html.HashChangeEvent;

class Routly {

	var mappings : Map<String, Void -> Void>;
	var emitter : IRouteEmitter;

	public function new(?_emitter : IRouteEmitter) {
		
		// if no IRouteEmitter is passed in, we default to using
		// an HtmlRouteEmitter, which simply wraps window.onhashchange
		if (_emitter == null) 
			_emitter = new HtmlRouteEmitter();

		// keep track of our emitter
		emitter = _emitter;
	}

	public function routes(_mappings : Map<String, Void -> Void>) {
		if (mappings == null) 
			mappings = new Map<String, Void -> Void>();

		// assign the passed-in map to private var
		mappings = _mappings;
	}

	public function fire(path : String) {
		
		// if route does not exist, maybe display a 404 view?
		if (!mappings.exists(path)) 
			return;

		// invoke the callback associated with the matched route
		mappings.get(path)(/* RouteDescriptor */);
	}

	public function listen(fireEventForCurrentPath = true) {
		// to listen for changes,
		// subscribe the router subscribes to the emitter
		// which calls the router's fire method upon route changes
		emitter.subscribe(this);

		// if we want to fire based on the current route (i.e., on page load),
		// just tell our emitter to fire whatever the current hash is
		if (fireEventForCurrentPath) 
			emitter.emit();
	}
}


