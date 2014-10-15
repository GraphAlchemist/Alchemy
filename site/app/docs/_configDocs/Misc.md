---
position: 7
title: Other
---

# Other

<p></p>

##### dataSource

[`string, object`] default:`null`  

Does not receive a default value and is the single parameter that **must** be defined by the user in order to use Alchemy.js.  `dataSource` receives either a string specifying the location of a GraphJSON object, or a GraphJSON formatted object directly.  If the user specifies a string, Alchemy.js will use d3's [`d3.json` method](https://github.com/mbostock/d3/wiki/Requests#d3_json) with the string as the data source and the graph viz app as the callback.  If an object is specified, the graph viz will use the object directly as a data source.

##### divSelector

[`any css3 selector`] default:`#alchemy`  

This is the element that Alchemy.js will look for when creating the visualization.  By default alchemy looks for an element with id "alchemy."


##### initialScale

[`integer`] default:`1`

Specifies the initial distance of the zoom on the svg.  A value assiged here initiates "scale" value directly in the svg's "transform" attribute.

##### initialTranslate 

[`2 int array`] default:`[0,0]`

Specifies the initial "pan" of the svg, corresponding directly to the "translate" value in the svg's "transform" attribute.  Because graphs layout differently every time, and because there is currently not support for setting initial node positions, there is limited utility to setting different values for the "translate" of the svg.

##### warningMessage 

[`string`] default:`"There be no data!  What's going on?"` 

Specifies a custom warning message if there is no data.

##### afterLoad 

[`string, function`] default:`"afterLoad"` 

If `afterLoad` receives a string, that string is passed to `alchemy` as a top level key that returns `true` when the graph has loaded.  This maybe helpful for certain applications where the graph context is being watch and events can be fired when `alchemy.afterLoad` or `alchemy.someOtherString` is `true`.

If `afterLoad` receives a function, that function is simply run after the graph is drawn.  E.g. `alchemy.someFunction()`

##### scaleExtent 

[`two int array`] default:`[0.5, 2.4]`

Defines the farthest that the user will be able to zoom in and out.  This applies minmimum and maximum values directly to the transform "scale()" attr of the svg.

##### zoomControls

[`bool`] default:`false` 

When set to true, adds zoom in, zoom out, and reset buttons to the svg.

____
