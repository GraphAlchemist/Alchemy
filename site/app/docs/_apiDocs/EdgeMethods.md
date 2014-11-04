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
_______