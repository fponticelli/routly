
import js.Browser.*;
import js.html.HashChangeEvent;

class Routly {

	var mappings : Map<String, ?RouteDescriptor -> Void>;
	var emitter : IRouteEmitter;

	public function new(?emitter : IRouteEmitter) {
		
		// if no IRouteEmitter is passed in, we default to using
		// an HtmlRouteEmitter, which simply wraps window.onhashchange
		if (emitter == null) 
			emitter = new HtmlRouteEmitter();

		// keep track of our emitter
		this.emitter = emitter;
	}

	public function routes(mappings : Map<String, ?RouteDescriptor -> Void>) {
		if (mappings == null) 
			mappings = new Map<String, ?RouteDescriptor -> Void>();

		// assign the passed-in map to private var
		this.mappings = mappings;
	}

	public function fire(path : String) {
		
		// if route does not exist, 
		// maybe display a 404 view?
		var descriptor = findMatch(path);
		if (descriptor == null) {
			// TODO: call some "unknown/bad path" callback:
			// callback404(new Descriptor404(path))
			return;
		}

		// invoke the callback associated with the descriptor of hte matched route
		var key = descriptor.virtual;
		mappings.get(key)(descriptor);
	}

	public function listen(fireEventForCurrentPath = true) {
		// to listen for changes, subscribe the router to the emitter,
		// which calls the router's fire method upon route changes
		emitter.subscribe(this);

		// if we want to fire based on the current route (i.e., on page load),
		// just tell our emitter to fire whatever the current hash is
		if (fireEventForCurrentPath) 
			emitter.emit();
	}

	private function findMatch(path : String) : RouteDescriptor {

		// check each registered route for a match against 
		// the raw path, return the matching key if one is found
		for(virtualPath in mappings.keys()) {

			// SHOULD THE matches METHOD INSTEAD TAKE 2 ARRAYS?
			// THIS WAY WE DON'T SPLIT THE RAW PATH OVER AND OVER 
			var descriptor = matches(path, virtualPath);
			if (descriptor != null) 
				return descriptor;
		}

		return null;
	}

	private function matches (rawPath : String, virtualPath : String) : RouteDescriptor {

		// compare the raw route with the parameterized route
		// "/test/:id" becomes ["test", ":id"]
		var routeSplit = virtualPath.split("/");
		if (routeSplit == null || routeSplit.length == 0)
			throw "we have registered an empty route apparently?";

		// split up the raw route, e.g., "/test/1" becomes ["test", "1"]
		var rawSplit = rawPath.split("/");
		if (rawSplit == null || rawSplit.length == 0) 
			throw "bad path, where are the slashes?! : " + rawPath;

		// simple check against lengths, which must be equal to match
		if (routeSplit.length != rawSplit.length) return null;

		// since the lengths match, we now must walk the path and check that 
		// each part is equal OR the raw part begins with a colon
		for(i in 0...rawSplit.length) {
			if (routeSplit[i].charAt(0) != ":" && routeSplit[i] != rawSplit[i])
				continue;

			// if this is the last part of the path, we've found a match!
			if (i == routeSplit.length - 1) {
				var arguments = parseArguments(rawSplit, routeSplit);
				return new RouteDescriptor(rawPath, virtualPath, arguments);
			}
		}

		// the raw path does NOT match the given virtual path
		return null;
	}

	// takes in the split virtual and raw paths and returns an array of IDs
	// i.e., raw path /test/123/foo/456/bar/789 will return ["123", "456", "789"]
	private function parseArguments(raw : Array<String>, virtual : Array<String>) : Array<String> {

		if (raw == null || virtual == null || raw.length != virtual.length)
			throw "invalid arrays passed to buildDescriptor.  must be non-null and equal length.";

		var arguments = new Array<String>();
		for(i in 0...raw.length) 
			if (virtual[i].charAt(0) == ":") 
				arguments.push(raw[i]);

		return arguments;
	}
}


