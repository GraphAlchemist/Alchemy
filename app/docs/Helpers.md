### Helpers
##### afterLoad:     
[str, function] defaults to 'drawingComplete'.  If `afterLoad` receives a string, that string is passed to `alchemy` as a top level key that returns `true` when the graph has loaded.  This is helpful to be used as a flag to watch for in the context of a larger application.  If `afterLoad` receives a function, that function is simply run after the graph is drawn.  This is another way to signal that the graph has been drawn.

##### dataSource:     
[string, object], `null`
Does not receive a default value and is the single parameter that must be defined by the user in order to use Alchemy.js.  `dataSource` receives either a string specifying the location of a GraphJSON object, or a GraphJSON formatted object directly.  If the user specifies a string, Alchemy.js will use d3's [`d3.json` method](https://github.com/mbostock/d3/wiki/Requests#d3_json) with the string as the data source and the graph viz app as the callback.  If an object is specified, the graph viz will use the object directly as a data source.