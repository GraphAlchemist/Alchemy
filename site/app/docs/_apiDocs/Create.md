---
position: 2
title: Create
---

# Create
<p></p>

##### alchemy.createNodes
<!--  -->
`alchemy.createNodes(node map[, another node map])`<br>
This method receives objects which are property maps of nodes as defined in [GraphJSON](#GraphJSON).  For example:

~~~ json
{
    "id": 1,
    "firstName": "Grace",
    "lastName": "Andrews",
    "age": 27,
    "homeTown": "Accra"
} 
~~~

This method can be used to create one or more nodes at a time.  For example:
~~~ javascript
// Create one node
var grace = {"id": 1, "firstName": "Grace", ...};
alchemy.createNodes(grace);
// Create multiple nodes
var matt = {"id": 2, "firstName": "Matt", ...};
alchemy.createNodes(grace, matt);
~~~

##### alchemy.createEdges
<!--  -->

`alchemy.createEdges(edge map[, another edge map])`<br>
This method receives objects which are property maps of edges as defined in [GraphJSON](#GraphJSON).  For example:

~~~ json
{
    "source": 1,
    "target": 2,
    "strength": 20,
    "relationship": "Loves"
}
~~~

An unlimited number of edges can exist between the same source and target node, and in the same direction.  Alchemy will generate internal unique ids for each edge created.  However, if an "id" is provided in the *edge map* provided to the *createEdge* method, new edges will only be created if the same "id" **does not already exist**.  

Examples:

~~~ javascript
// create a single edge
var someEdgeMap = {"source": 1, "target": 2, ...}
alchemy.createEdges(someEdgeMap);
// create two more edges with exactly the same properties -
// in the same direction - 3 edges total!
alchemy.createEdges(someEdgeMap, someEdgeMap);
// edgemap with an id
var edgeWithId = {"id": 100, "source": 1, "target": 2};
// create a single edge if the provided id 
// does not already exist, 
// and create an edge with "edgeMap" properties
alchemy.createEdges(edgeWithId, someEdgeMap);
~~~
