---
position: 1
title: Nodes
---

# Nodes

<p></p>

Various configuration properties for nodes are available in the Alchemy.conf, including:

##### nodeCaption 

[`string|function`] default:`"caption"` 

The configuration for the text that will appear as the caption on a node used during filtering and searching.  The string parameter defined should provide a key within the GraphJSON.  By default alchemy will look for a "caption" key on each node in the graphJSON, however any key present on *some* or *all* of the nodes can be provided.  The user can also provide a function.  The function can take **node** as a parameter and that will use the node objects in the GraphJSON to build the caption.  For example, where the GraphJSON node objects contain "firstName" and "lastName":  

~~~javascript
caption: function(node) {
    return "" + node.firstName + " " + node.lastName;
  }
~~~
    
    
~~~json
"nodes": [
        {
            ...
            "firstName": "Kate",
            "lastName": "Smith"
        },
            ...]
~~~
##### nodeStyle

[`nodeType`: { `list of css style values` }] default nodeType:`all`

A set of configuration options that assigns custom node styling.  Should return an object whose key is an nodeType, and whose value is a list of valid css styles.  

Current default configuration:

~~~ javascript
{
    nodeStyle: {
        "all": {
            "radius": 10,
            "color"  : "#68B9FE",
            "borderColor": "#127DC1",
            "borderWidth": function (d, radius) { radius / 3 },
            "captionColor": "#FFFFFF",
            "captionBackground": null,
            "captionSize": 12,
            "selected": {
                "color" : "#FFFFFF"
                "borderColor": "#349FE3"
            },
            "highlighted": {
                "color" : "#EEEEFF"
            },
            "hidden": {
                "color": "none" 
                "borderColor": "none"
            }
        }
    }
}
~~~

By default nodeStyles apply to "all" nodes.  This can be changed to be any valid [`nodeType` value](#nodeTypes).  Different styles may be applied to different nodeTypes at user's discretion.

"selected", "highlighted", and "hidden" are conditional stylings based on current node state.  

##### nodeColour 

[`css color value`] default:`null`  

This is a convenience parameter to quickly assign a default color to all nodes.  This method will overwrite any styles assigned by the css.  For more on how to assign colors to specific nodes read about [nodeTypes](#nodetypes) and our [guide to graph styling](#Graph-Styling).

##### fixNodes 

[`bool`] default:`false`  

All nodes are draggable by default.  Setting to `true` means that nodes will not be draggable after their initial layout.

##### fixRootNodes 

[`bool`] default:`false`

Root nodes are draggable by default. Setting to `true` means that root nodes cannot be dragged after their initial layout.  You can find more information on how to define root nodes in the GraphJSON [here](#defining-root-nodes).

##### nodeMouseOver 

[`string|function`] default:`"caption"`  

This defines the text that will be displayed when a user mouses over a node element.  Similiar to the [alchemy.conf.nodeCaption](#nodecaption) parameter, alchemy.conf.nodeMouseOver can receive a *string* or a *function*.  If it receives a string as in the default, it will look for that string on nodes in the graphJSON and display the text when that node is moused over.  If a function is passed, that function will be called with the **node** as an optional parameter.

For instance:

~~~ js
{ 
    "nodeMouseOver": function(node) {
        return node.someData + node.someOtherData
}
~~~

##### nodeOverlap

[`int`] default:`24`  

Used in the collision detection function, should be a number slightly more than double the size of the [nodeRadius](#noderadius) and will cause the center of all nodes to be no closer than the specified distance.     

***Note***: Keep in mind that the stroke-width of the svg element is in addition to the radius of the circle svg element and therefore nodes will overlap with a value of only 2 x the nodeRadius.  For this reason, pick a number slightly greater.

##### nodeRadius

[`int|string|function`] default:`10`  

If the default or a user specified integer, the value will be the pixel size of a node that indicates node size.  If the user specifies a string, that string will be the key, used to look up the nodeRadius on individual nodes in the GraphJSON.  For example, GraphJSON where nodes have the following values:

~~~ json
{"nodes":[
    {"id": 1,
     "betweeness": 0.2}
    {"id": 2,
     "betweeness": 0.3},
    ...],
...}
~~~

If the user specifies `alchemy.conf.nodeRadius: "betweeness"` the nodes will be sized at 0.2px and 0.3px respectively - which will not be super useful from a visualization perspective.  So, additionally the user can specify a function that will return node size.  If the user specifies the following function, they will get something more useful for visualization - a range of values between 15px and 30px scaled based on the betweenness value of the nodes:

~~~ javascript
alchemy.conf.nodeRadius: function(n) {
        return Math.max(15, Math.min(Math.floor(n.betweeness * 100), 30))
};
~~~

##### rootNodeRadius

[`int`] default:`15`   

The default size of root node(s).  Read more about how to define root nodes in your GraphJSON [here](#defining-root-nodes).

##### nodeTypes

[`object|string`] default:`null`   

Passing a string will cause Alchemy.js to build and assign node types based on all possible filters from the GraphJSON.  For instance, if you assign "_type", "category", "foobar", etc. Alchemy.js will look for that key on every node in the GraphJSON.  This is a convenience feature and can be costly with larger data sets.

The better way to build node parameters is to pass an object for the **nodeTypes** parameter. The object passed will correspond to keys and values in the GraphJSON that alchemy will use to build and create node types. For Example, based on the following GraphJSON, the user would pass the following object to alchemy.conf.nodeTypes for the "award" and "movie" nodes: `{type: ["award", "movie"]}`.  Visit our [examples gallery](/#/examples) for full examples using nodeTypes for filters and [styling](#Graph-Styling).


~~~ json
{"nodes": [
        {
            "name": "Making Sandwiches",
            "mid": "/m/09v95qs",
            "label": "Making Sandwiches",
            "node_type": "movie",
            "genre": [
                "Short Film"
            ],
            "type": "movie",
            "id": 670298
        },
        {
            "name": "Academy Award for Actress in a Leading Role",
            "mid": "/m/0gqwc",
            "label": "Academy Award for Actress in a Leading Role",
            "node_type": "award",
            "genre": [],
            "type": "award",
            "id": 593781
        },
        {
            "name": "Religion, Inc.",
            "mid": "/m/0g5q35v",
            "label": "Religion, Inc.",
            "node_type": "movie",
            "genre": [
                "Parody",
                "Comedy"
            ],
            "type": "movie",
            "id": 778069
        },...],
...}
~~~

##### rootNodes

[`string`] default:`"root"`

This is the name of key supplied in the GraphJSON that will be used to determine if a node is a root node or not.  The GraphJSON value of the supplied key is a boolean value.

##### rootNodeRadius

[`int`] default:`15`

The default radius of root nodes.  Only applied if the key specified in rootNodes returns a boolean.

_____
