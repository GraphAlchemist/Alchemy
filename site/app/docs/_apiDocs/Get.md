---
position: 1
title: Get
---

# Get

<p></p>

##### alchemy.getNodes
<!--  Method should return Alchemy node object, not just properties -->

`alchemy.getNodes(nodeId[, nodeIDn])`<br>
Accepts one or more node ids and returns an array of those nodes which can then be directly acted upon.  This is useful for displaying or directly manipulating node data for batch property assignment, specific positioning, more specific filtering, and countless other special use cases.

~~~ javascript
// Get the node with id 1
some_node = alchemy.getNodes(1);
// Get multiple nodes at once, returning an array
a_bunch_of_nodes = alchemy.getNodes(1, 2, 3, ... id);
~~~

This API call returns the Alchemy node object and not the elements used by the renderer such as an SVG element.  

Future releases will include many more convenience functions for pragmatically accessing DOM elements.  In the meantime, the elements can be accessed directly using standard css selectors like `#node-id1`.

##### alchemy.getEdges
<!--  -->

`alchemy.getEdges(nodeId[, targetID])`<br>
If provided only a single node id, this method will return an array of all edges that are either the *source* or *target* of that node.  For example:

~~~ javascript
/* returns all edges with source or target id 1 */
alchemy.getEdges(1);
~~~

If two ids are provided then it will return only edges that have the source node and as target node of the ids provided, provided one exists.  For example:
~~~ javascript
/* returns only edges where node with id 1 is the source
and node with id 2 is the target */
some_edges = alchemy.getEdges(1,2);

/* returns only edges where node with id 2 is the source
and node with id 1 is the target */
some_other_edges = alchemy.getEdges(2,1);
~~~

It is important to realize that this returns the Alchemy Edge object.  Currently there are a number of methods for working with Edge data and edge styles.  Future releases will include even more ways to work with the DOM elements directly. In the meantime, if you wish to access the SVG elements directly, use standard css selectors like `#edge-nodeID-targetID`.  For example:

~~~ javascript
// use jquery to select an edge group <g> element
var some_edge = $("#edge-1-2");

/* use d3 to select an edge group element */
var some_edge = d3.select("#edge-1-2");
~~~

##### alchemy.allNodes
<!-- change to reflect #359? -->
<!-- change to getAllNodes() in 1.0 release -->

`alchemy.allNodes()`<br>
Currently, takes no arguments and returns an array of all nodes that are loaded into Alchemy. This is useful for creating custom functions that act upon all nodes, however, keep in mind that directly working on datasets with large numbers of nodes could take a while, and care should be taken when doing so.

It is important to realize this returns an array of node data and not the elements used by the renderer such as SVG elements, which can easily be accessed using standard css selectors.  Please also note that the rendered 'state' of the node (such as `hidden`, `selected`, etc...) has no effect on the results of `allNodes()`, and if the node is loaded it will be returned.  If a node has been deleted in the editor, however, it is no longer loaded into Alchemy and will not appear in the result.

##### alchemy.allEdges
<!-- change to reflect #359? -->
<!-- change to getAllEdges() in 1.0 release -->

`alchemy.allEdges()`<br>
Currently, takes no arguments and returns an array of all edges that are loaded into Alchemy.  This is useful for creating custom functions that act upon all edges, such as batch property assignment.  Keep in mind however, that directly working on datasets with large numbers of edges could take a while, and care should be taken when doing so.

It is important to realize that this returns an array of edge data and not the elements used by the renderer such as SVG elements, which can easily be accessed using standard css selectors.  Please also note that the rendered 'state' of the edges (such as `hidden`, `selected`, etc...) has no effect on the results of `allEdges()`, and if the edge is loaded it will be returned.  If an edge has been deleted in the editor (either directly, or indirectly be deleting it's source or target node) then it is no longer loaded into Alchemy and will not appear in the result.

##### alchemy.get.clusters()
<!--  -->

`alchemy.get.clusters()`<br>
API method which returns a dictionary whose keys are the cluster names, and whose values are arrays of all the nodes in that cluster
  For example:

~~~ javascript
/* returns all clusters, and their associated nodes */
alchemy.get.clusters();
~~~

##### alchemy.get.clusterColours()
<!--  -->

`alchemy.get.clusterColours()`<br>
API method which returns a dictionary whose keys are the cluster names, and whose values the hex code of the color used for that cluster
  For example:

~~~ javascript
/* returns all clusters, and their associated color codes */
alchemy.get.clusterColours();
~~~
_______
