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