---
position: 3
title: Layout
---

# Layout

<p></p>

##### graphHeight 

[`function`] default: [See source.](https://github.com/GraphAlchemist/Alchemy/blob/master/app/scripts/alchemy/defaultConf.coffee#L20)

Defaults to a function that selects the height of the enclosing div.  If there is no enclosing div, the function returns the screen height on load.  The user can define their own custom function for graphHeight or a function that returns an integer to be converted to pixels.  e.g. `function() {return 500}`

##### graphWidth 

[`function`] default: [See source.](https://github.com/GraphAlchemist/Alchemy/blob/master/app/scripts/alchemy/defaultConf.coffee#L22)

Defaults to a function that selects the height of the enclosing div.  If there is no enclosing div, the function returns the screen width on load.  The user can define their own custom function for graphWidth or a function that returns an integer to be converted to pixels.  e.g. `function() {return 500}`

##### alpha 

[`float`] default:`0.5`  

Part of the d3 force layout. `alpha` sets the cooling parameter for the force layout.  You can read more about how changing the default value for alpha can change the force layout in the [d3 docs](https://github.com/mbostock/d3/wiki/Force-Layout#alpha).

##### cluster 

[`bool`] default:`false` 

Clustering nodes will have a major effect on layout and color. This is one of Alchemy's most powerful off the shelf features. To cluster nodes, simply set cluster to `true`. Alchemy.js will expect a 'cluster' key for each node in the provided GraphJSON whose value is an integer.  For example: 

~~~ json
{
    "edges":[...
    ],    
    "nodes": [
        {
            "cluster": 4,
            "degree": 8,
            "id": "P7jQJNVTAG",
            "firstName": "Kate",
        },
        {
            "cluster": 0,
            "degree": 19,
            "id": "fPKtFfXDds",
            "firstName": "Katherine",
        },
        {
            "cluster": 0,
            "degree": 4,
            "id": "QgVAXaBQg2",
            "firstName": "Duane",
        },...
    ]
}
~~~

The value for cluster will be used to look up a color from [`alchemy.conf.clusterColors`](#clustercolors).  All nodes of the same cluster will receive the same color.  Edges between nodes of the same cluster will receive that cluster's color, while edges that span between two nodes in different clusters will receive an inverse gradient of the two colors.  This makes it easy to visually identify 'boundary spanners' in social networks, unexpected links in a host of network analysis and link analysis use cases, and even to visually illustrate results of gene co-expression networks.  For example:
![cluster](img/cluster.png)    
<!-- TODO: cluster should accept a string e.g. "community" "category" etc. that would correspond to the key in the graph JSON-->

##### clusterKey
[`string`] default:`"cluster"`

The key that Alchemy will use to determine the initial clusters if `cluster` is set to true.  If `clusterControl` is true, then this can be set dynamically from within the running alchemy visualization itself.  The type of the value that the `clusterKey` points to is not taken into account. 

##### clusterControl
[`bool`] default:`true`

`clusterControl` adds a form to the control dash allowing you to specify different cluster keys.  Any property of a node in your GraphJSON can be used.

##### clusterColors 

[`array of css colors`] default:

~~~ javascript
d3.shuffle(["#DD79FF", "#FFFC00", "#00FF30", "#5168FF", "#00C0FF", 
            "#FF004B", "#00CDCD", "#f83f00", "#f800df", "#ff8d8f",
            "#ffcd00", "#184fff", "#ff7e00"])
~~~

Provides a list of colors that can be assigned to different clusters.  The above colors are the defaults that are randomly assigned to the clusters using the [d3.shuffle](https://github.com/mbostock/d3/wiki/Arrays#d3_shuffle) method.  Colors can be predictably assigned to colors by simply providing the colors in the position of the corresponding cluster.  For instance, in an array of the following colors `[red, green, yellow, orange]`, cluster 0 would be red, cluster 1 would be green, cluster 2 would be yellow, cluster 3 would be orange, etc.  See [cluster](#cluster) for more information on how clustering works in Alchemy.js.

##### collisionDetection

[`bool`] default:`true`

Turns collision detection on or off.  The function used for collision detection can be found [here](https://github.com/GraphAlchemist/Alchemy/blob/master/app/scripts/alchemy/core/layout.coffee), in the `collide` method.

##### forceLocked 

[`bool`] default:`true` 

By default the force layout does not continue after initial layout is performed.  Setting forceLocked to `false` will allow the force layout to run on node drag, click, and other interactions.

##### linkDistancefn 

[`function`] default: [See source.](https://github.com/GraphAlchemist/Alchemy/blob/master/app/scripts/alchemy/core/layout.coffee#L137) 

Alchemy.js provides the ability for a user defined custom link distance function in the force layout.  If you wish to override the default value with a function or provide another static value, simply pass it as the value for linkDistance in the config.  Your custom function will have the edge as well as our layout constant [k](https://github.com/GraphAlchemist/Alchemy/blob/release-0.3/app/scripts/alchemy/core/layout.coffee.md) available.  For example, `yourLinkDistanceFn: function(edge, k) { return edge.something * k}`
Read more about how linkDistance is used in d3's force layout [here](https://github.com/mbostock/d3/wiki/Force-Layout#linkDistance).

<!-- ##### nodePositions 

[`array`] default:`null` 

**not currently implemented**
Per the [GraphJSON](http://www.graphjson.org/) specifications, users can provide GraphJSON with nodes that contain pre-calculated layout positions for nodes in pixel length.  The nodePositions parameter tells alchemy where to look up the node position.  The most obvious parameter for the user to pass would be `["x","y"]` telling alchemy to look for the `x` position for nodes with the `"x"` key on each node where available, and the `y` position with the "y" key.  A user could just as easily define a custom set of keys for their GraphJSON.  For example, ["apples","oranges"] would tell alchemy to look for the x position of nodes with the `"apples"` key and the `y` position of nodes with the `"oranges"` key. -->

____
