package routly;

import js.Browser.*;
import js.html.HashChangeEvent;
using thx.Strings;

class Routly {

  var mappings : Map<String, RouteDescriptor -> Void>;
  var unknownPathCallback : RouteDescriptor -> Void;
  var emitter : IRouteEmitter;

  public function new(?emitter : IRouteEmitter) {

    // if no IRouteEmitter is passed in, we default to using
    // an HtmlRouteEmitter, which simply wraps window.onhashchange
    if (emitter == null)
      emitter = new HtmlRouteEmitter();

    // keep track of our emitter
    this.emitter = emitter;
  }

  public function routes(mappings : Map<String, RouteDescriptor -> Void>) {
    if (mappings == null)
      mappings = new Map<String, RouteDescriptor -> Void>();

    // assign the passed-in map to private var
    this.mappings = mappings;
  }

  public function unknown(callback : RouteDescriptor -> Void) {
    unknownPathCallback = callback;
  }

  public function fire(path : String) {

    // WART
    if (path == null || path == "")
      path = "/";

    // if route does not exist,
    // maybe display a 404 view?
    var descriptor = findMatch(path);
    if (descriptor == null) {
      // TODO: call some "unknown/bad path" callback:
      // callback404(new Descriptor404(path))
      if (unknownPathCallback != null) unknownPathCallback(new RouteDescriptor(path));
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

    // we want to strip everything after the question mark
    var questionMarkIndex = rawPath.lastIndexOf("?");
    var formatted = if (questionMarkIndex > 0) rawPath.substring(0, questionMarkIndex) else rawPath;

    // compare the raw route with the parameterized route
    // "/test/:id" becomes ["test", ":id"]
    var routeSplit = virtualPath.trimCharsLeft("/").split("/");
    if (routeSplit == null || routeSplit.length == 0)
      throw "we have registered an empty route apparently?";

    // split up the raw route, e.g., "/test/1" becomes ["test", "1"]
    var rawSplit = formatted.trimCharsLeft("/").split("/");
    if (rawSplit == null || rawSplit.length == 0)
      throw "bad path, where are the slashes?! : " + formatted;

    // simple check against the # of segments, which must be equal
    if (routeSplit.length != rawSplit.length) return null;

    // since the lengths match, we now must walk the path and check that
    // each segment is identical OR the raw segment contains a colon (but the content of the segment BEFORE
    // the colon must still match)
    for(i in 0...rawSplit.length) {
      var colonIndex = routeSplit[i].indexOf(":");
      var segmentMismatch = colonIndex == -1 && rawSplit[i] != routeSplit[i];
      if (segmentMismatch) return null;

      var argumentSegmentMismatch = colonIndex != -1 && rawSplit[i].substring(0, colonIndex) != routeSplit[i].substring(0, colonIndex);
      if (argumentSegmentMismatch) return null;
    }

    // the raw path does match the given virtual path
    return new RouteDescriptor(
      rawPath,
      virtualPath,
      parseArguments(rawSplit, routeSplit),
      parseQueryString(rawPath)
    );
  }

  // takes in the split virtual and raw paths and returns an array of IDs
  // i.e., raw path /test/123/foo/456/bar/789 will return ["123", "456", "789"]
  private function parseArguments(raw : Array<String>, virtual : Array<String>) : Map<String, String> {

    if (raw == null || virtual == null || raw.length != virtual.length)
      throw "invalid arrays passed to buildDescriptor.  must be non-null and equal length.";

    var arguments = new Map<String, String>();
    for(i in 0...raw.length) {
      var colonIndex = virtual[i].indexOf(":");
      if (colonIndex > -1)
        arguments.set(virtual[i].substring(colonIndex + 1), raw[i].substring(colonIndex));
    }

    return arguments;
  }

  private function parseQueryString(rawPath : String) : Map<String, String> {
    if (rawPath == null)
      throw "Invalid url passed to parseQueryString: " + rawPath;

    var results = new Map<String, String>();

    // strip everything to to the left of (and including) the question mark
    var startIndex = rawPath.lastIndexOf("?");
    if (startIndex > -1) {

      // split into key-values separate by ampersands
      var pairs = rawPath.substring(startIndex + 1).split("&");

      // build our dictionary
      for(pair in pairs) {
        var split = pair.split("=");

        // simply add each key-value-air or flag to the dictionary
        results.set(StringTools.urlDecode(split[0]), if (split.length == 2) StringTools.urlDecode(split[1]) else "");
      }
    }

    return results;
  }
}
