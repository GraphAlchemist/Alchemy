---
position: 7
title: API
---

# API

### Overview

While Alchemy is a fantastic plug and play solution to graph visualization with many features out of the box, certain users will want to extend functionality or interact with the graph directly to create a more specific user experience.  For this reason, we've exposed a few API endpoints that will let you easily access nodes and edges, allowing you to use them in your application.

If you find that you are implementing a certain feature over and over using the API endpoints, we invite you to [fork the repo](http://github.com/GraphAlchemist/Alchemy) and submit a pull request with the feature so that most work can be done by Alchemy and its configuration.

### getNodes()

`alchemy.getNodes(id1, id2, ...)`

`getNodes()` accepts one or more node ids and returns an array of those nodes which can then be directly acted upon.  This is useful for displaying or directly manipulating node data for batch property assignment, specific positioning, more specific filtering, and countless other special use cases.

It is important to realize that this returns the node data and not the elements used by the renderer such as an SVG element, which can easily be accessed using standard css selectors like `#node-id1`.

### getEdges()

`alchemy.getEdges(nodeId, targetID=null)`

`getEdges()`, if provided only a single node id, will return an array of all edges that are either the source or target of that node.  If two ids are provided (`nodeID` and `targetID`) then it will return a single edge that has `nodeID` as the source and `targetID` as the target, provided one exists.

It is important to realize that this returns the edge data and not the elements used by the renderer such as an SVG element, which can easily be accessed using standard css selectors like `#edge-nodeID-targetID`.

### allNodes()

`alchemy.allNodes()`

`allNodes()` takes no arguments and returns an array of all nodes that are loaded into Alchemy. This is useful for creating custom functions that act upon all nodes, however, keep in mind that directly working on datasets with large numbers of nodes could take a while, and care should be taken when doing so.

It is important to realize this returns an array of node data and not the elements used by the renderer such as SVG elements, which can easily be accessed using standard css selectors.  Please also note that the rendered 'state' of the node (such as `hidden`, `selected`, etc...) has no effect on the results of `allNodes()`, and if the node is loaded it will be returned.  If a node has been deleted in the editor, however, it is no longer loaded into Alchemy and will not appear in the result.

### allEdges()

`alchemy.allEdges()`

`allEdges()` takes no arguments and returns an array of all edges that are loaded into Alchemy.  This is useful for creating custom functions that act upon all edges, such as batch property assignment.  Keep in mind however, that directly working on datasets with large numbers of edges could take a while, and care should be taken when doing so.

It is important to realize that this returns an array of edge data and not the elements used by the renderer such as SVG elements, which can easily be accessed using standard css selectors.  Please also note that the rendered 'state' of the edges (such as `hidden`, `selected`, etc...) has no effect on the results of `allEdges()`, and if the edge is loaded it will be returned.  If an edge has been deleted in the editor (either directly, or indirectly be deleting it's source or target node) then it is no longer loaded into Alchemy and will not appear in the result.

---
