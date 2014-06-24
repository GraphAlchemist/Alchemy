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
