#Init

#####initialScale:    
[integer] `0`  
Specifies the initial "height" of the zoom on the svg.   

#####initialTranslate:    
[2 element array] `[0,0]`  
Specifies the initial "pan" of the svg.

#####warningMessage: 
[string] `"There be no data!  What's going on?"`  
Specifies a custom warning message if there is no data.

____

#Editing

#####captionToggle: 
[bool] `false`    
Allow toggling of node captions to be visible or invisible.  By assigning `.hidden` to all nodes.  The `hidden` class can easily be overridden to allow different colors or opacities for node captions when hidden.

#####edgesToggle:
[bool] `false`    
Allow toggling of edges to be visible or invisible.  Assigns a `.hidden` to all edges.  The default Alchemy `hidden` class can easily be overridden to include different levels of opacity or color.

#####nodesToggle:
[bool] `false`
Allow toggling of nodes to be visible or invisible.  Assigns a `.hidden` to all edges.  The default Alchemy `hidden` class can easily be overridden to include different levels of opacity or color.

#####toggleRootNodes:   
[bool] `true`    
Chooses whether or not root nodes are affected by nodesToggle.

#####removeNodes:
[bool] `false`    
**not currently implemented** allow the removal of nodes with controls

___

#Filtering

#####edgeFilters:
[bool] `false`
If set to true, alchemy will load a set of filters that correspond to edge types defined in the [`alchemy.conf.edgeTypes`](https://github.com/GraphAlchemist/Alchemy/wiki/Edges#edgetypes) parameter.

#####nodeFilters:
[bool] `false`
If set to true, alchemy will load a set of filters that correspond to node types as defined in the [`alchemy.conf.nodeTypes`](https://github.com/GraphAlchemist/Alchemy/wiki/Nodes#nodetypes) parameter.

#####edgesTagsFilter:
[array of strings|object] `false`
**not currently implemented**

#####nodesTagsFilter:
[array of strings|object] `false`
**not currently implemented**

_____

#Helpers

##### afterLoad:     
[str, function] defaults to 'drawingComplete'.  If `afterLoad` receives a string, that string is passed to `alchemy` as a top level key that returns `true` when the graph has loaded.  This is helpful to be used as a flag to watch for in the context of a larger application.  If `afterLoad` receives a function, that function is simply run after the graph is drawn.  This is another way to signal that the graph has been drawn.

##### dataSource:     
[string, object], `null`
Does not receive a default value and is the single parameter that must be defined by the user in order to use Alchemy.js.  `dataSource` receives either a string specifying the location of a GraphJSON object, or a GraphJSON formatted object directly.  If the user specifies a string, Alchemy.js will use d3's [`d3.json` method](https://github.com/mbostock/d3/wiki/Requests#d3_json) with the string as the data source and the graph viz app as the callback.  If an object is specified, the graph viz will use the object directly as a data source.

____

#Layout

#####graphHeight:
[int] **not yet implemented**
Height of graph in pixels.  Unless specified, graph height defaults to the height of the current window.
#####graphWidth:
[int] **not yet implemented** 
Width of graph in pixels.  Unless specified, graph width defaults to the width of the current window.
#####alpha: 
[float] `.5`    
Is a part of the d3 force layout, `alpha` sets the cooling parameter for the force layout.  You can read more about how changing the default value for alpha can change the layout [here](https://github.com/mbostock/d3/wiki/Force-Layout#alpha).
#####cluster:
[string] `false` 
**fix to correspond to a key e.g. "cluster" or "type"**    
Clustering nodes will have an effect on layout and color.  To cluster nodes, simply set cluster to `true`. Alchemy.js will expect a 'cluster' object key for each node in the GraphJSON that will result in an integer when being looked up and will be used to look up an integer value off of `clusterColours`.

#####clusterColours: 
[array of strings]     
`["#DD79FF", "#FFFC00","#00FF30", "#5168FF","#00C0FF", "#FF004B", "#00CDCD", 
  "#f83f00", "#f800df", "#ff8d8f","#ffcd00", "#184fff","#ff7e00"])
`
Provides a list of colors that can be assigned to different clusters.  Elements are strings of hex or rgb values that can be assigned as css styles dynamically.  The above colors are the defaults that are randomly assigned to the clusters using the [d3.shuffle](https://github.com/mbostock/d3/wiki/Arrays#d3_shuffle) method.

#####forceLocked: 
[bool] `true`
force layout does not continue after initial node layout 
#####linkDistance: 
[integer|function] `2000`
Alchemy.js provides the ability for a user defined custom link distance function in the force layout.  If you wish to override the default value with a function or provide another static value, simply pass it as the value for linkDistance.  Read more about how linkDistance is used in d3's force layout [here](https://github.com/mbostock/d3/wiki/Force-Layout#linkDistance)
#####nodePositions:
[array] `null` 
**not currently implemented**
Per the [GraphJSON](http://www.graphjson.org/) specifications, users can provide GraphJSON with nodes that contain pre-calculated layout positions for nodes in pixel length.  The nodePositions parameter tells alchemy where to look up the node position.  The most obvious parameter for the user to pass would be `["x","y"]` telling alchemy to look for the `x` position for nodes with the `"x"` key on each node where available, and the `y` position with the "y" key.  A user could just as easily define a custom set of keys for their GraphJSON.  For example, ["apples","oranges"] would tell alchemy to look for the x position of nodes with the `"apples"` key and the `y` position of nodes with the `"oranges"` key.

____

#Nodes

#####caption:
[string|function] `"caption"` The configuration for the text that will appear as the caption.  A string should provide a key within the GraphJSON.  The default would be `caption`, however any key present on some or all of the nodes can be provided.  For instance, `firstname`.  The user can also provide a function, for instance:
    ```javascript
    caption: function(n) {
        return "" + n.firstName + " " + n.lastName;
      }
    ```
Where GraphJSON node objects contain "firstName" and "lastName".

#####fixNodes:
[bool] `false`     
All nodes are draggable by default.  Setting to `true` means that nodes cannot be dragged after their initial layout.

#####fixRootNodes:
[bool] `false`     
Root nodes are draggable by default. Setting to `true` means that root nodes cannot be dragged after their initial layout.

#####nodeColour:
[string] `null`  This is the default node colour assigned to all nodes and will overwrite any styles assigned by the css.  Alchemy js attempts to push all styling to the css as defined on the [styles wiki page](#).  However, for some use cases, where alchemy is assigning styles to the nodes dynamically, it makes sense to assign a default color, that will be invoked instead of a 'null' value.  For instance, if `conf.cluster` is set to `true` but some nodes do not have a `cluster` object in their corresponding GraphJSON, they will receive the `conf.nodeColour`.

#####nodeMouseOver:
defaults to caption...  User can provide another their own function...  e.g.  highlight all connected nodes...  ...on mouse over zoom in...
<!-- [string|function] `"caption"`  If a string is provided, this string is the key that alchemy will look and display on a mouseover interaction.  This defaults to 'caption' and will default to displaying whatever is defined by the `conf.caption` parameter. -->

#####nodeOverlap:    
** should default to "node radius"**
[integer] `20` Used in the collision detection function, nodeOverlap defaults so that the nodes are roughly 100% apart from their radius (double the default `alchemy.conf.nodeRadius`.  A number less than the 2x the radius would allow overlap.

#####nodeRadius:    
[integer|string|function] `10`  If the default or a user specified intege, the value will be the pixel size of a node that indicates node size.  If the user specifies a string, that string will be the key, used to look up the nodeRadius on individual nodes in the GraphJSON.  Additionally, the user can specify a function that will return node size.  For example, GraphJSON where nodes have the following values:
```json
{"nodes":[
    {"id": 1,
     "betweeness": 20}
    {"id": 2,
     "betweeness": 30},
    ...],
...}
```
If the user specifies `alchemy.conf.nodeRadius: "betweeness"` the nodes will be sized at 20 and 30 respectively.  Whereas if the user specifies: 
```javascript
alchemy.conf.nodeRadius: function(n) {
        return n.betweeness * 2/3
};
```
The nodes would be sized at 13.3 and 20 respectively.
#####rootNodeRadius:
[integer] `15` The default size of root node(s).

#####nodeTypes:
[array of strings|object] `null`    
Parameters passed correspond to keys and values in the GraphJSON that alchemy will use to, for instance, create filters. For Example, if working with the following GraphJSON:
```json
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
```
The user would pass the following object to alchemy.conf.nodeTypes for the "award" and "movie" nodes: `{type: ["award", "movie"]}`

_____

#Edges

#####edgeCaption:
**not currently implemented**
[string] `'caption'` Just like nodes, edges can store descriptive data.  The edgeCaption is the text that will display 'on hover' and by default alchemy looks for 'caption' in the corresponding edge object from the GraphJSON.

#####edgeColour:
[css color value] `null`  A colour to be passed to all edges.  If `alchemy.conf.cluster` is `true` then colors assigned by edge gradients take priority.  Read more about the [[`cluster` configuration|Layout#cluster]].

#####edgeTypes: 
[array of strings|object] `null`    
Parameters passed correspond to keys and values in the GraphJSON that alchemy will use to, for instance, create filters. For Example, if working with the following GraphJSON:
```json
"edges": [
 {
            "source": 95421,
            "target": 714293,
            "label": "acted in"
        },
        {
            "source": 95421,
            "taget": 95426,
            "label": "parent of"
        },
        {
            "source": 95421,
            "role": "Devlin Moran",
            "target": 603720,
            "label": "acted in"
        },...]
...}
```
The user would pass the following object to alchemy.conf.edgeTypes "parent of" and "acted in" edges: `{caption: ["acted in", "parent of"]}`

___