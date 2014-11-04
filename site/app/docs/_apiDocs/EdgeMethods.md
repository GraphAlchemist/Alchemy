---
position: 4
title: Edge Methods
---

# Edge Methods

When **edge** data is added to Alchemy through GraphJSON from the data source, or through the API, Alchemy adds methods to the nodes that can be used universally.  These methods are then interpreted by the SVG and WebGL Renders to apply the commands appropriately.

##### edge.getProperties
<!--  -->

`edge.getProperties([property])`<br>
If no parameter is specified, returns all of the properties of a given edge, including any properties edited or changed by the application.  If a single parameter, or multiple parameters are specified, the method will return an object with the specified properties and their parameters.

For example:

~~~ javascript
// Grab the node with id 1 
var node = alchemy.get.edge(1);
// Return all properties
node.getProperties();
// Return only the value of property 'firstName'
node.getProperties('firstName');
// Return only the value of property 'firstName', 'lastName', and 'age'
node.getProperties(['firstName', 'lastName', 'age']);
~~~

##### edge.setProperties
<!--  -->

`edge.setProperties(['property', 'value']|[Object])`<br>
Set the property of an edge with the supplied value, or set the value of multiple properties at once by providing a map of key values.  

For example:

~~~ javascript
// Grab the edge that has a source node of id 1
// and a target of id 2
var edge = alchemy.get.edge(1, 2);
// Set property 'startDate' to 'yesterday'
node.setProperties('startDate', 'yesterday');
// Set multiple properties at once
node.setProperties({
    'startDate': 'yesterday', 
    'endDate': null, 
    'role': 'Engineer'
});
~~~

##### edge.getStyles
<!--  -->

`edge.getStyles(['property'])`<br>

To get the styles of a particular edge, you can call the getStyles() method.  If `property` is blank, it will return an object consisting of all the styles.  If a specific property is passed, it will return the current setting for that style.

~~~ javascript
// Get edge
var some_edge = alchemy.getEdges(1, 2);
// Check the edge radius
some_edge.getStyles('radius')
// See all styles for some_edge
some_edge.getStyles()
~~~


##### edge.setStyles
<!-- -->

`edge.setStyle(['edgeStyleKey', 'edgeStyleValue'| Map of edgeStyles)`<br>
Alchemy abstracts the styles of the graph, making it easy to access them programatically.  A complete set of "edgeStyles" are referenced in the [edgeStyle](#edgeStyle) section.  Multiple styles can be assigned at once by passing in an object with the keys being the name of the style. If no arguments are passed, the edge is restyled based on the styles set in the configuration for it's current state.

~~~ javascript
// Get edge
var some_edge = alchemy.getEdges(1, 2);

// Change the width of the edge to 10 pixels
some_edge.setStyle('width', 10);

// Change multiple styles at once.
some_edge.setStyle({'width': 10, 'color': 'white'});

// Refresh/reload style based on current state
some_edge.setStyle(new_styles);
~~~


##### edge.toggleHidden
<!-- -->

`edge.toggleHidden()`

Toggles the state of the edge between `hidden` and `active`, and then renders the correct styles for that state.

##### edge.allNodesActive
<!-- -->

`edge.allNodesActive()`

Returns true or false based on whether both the source and target node are active.

##### edge.remove
<!-- -->

`edge.remove()`

Deletes the edge from Alchemy.  The edge is removed from both the edge data and the rendered visual.  It cannot be readded without reloading the data or creating it manually with alchemy.create.edges() 

_______