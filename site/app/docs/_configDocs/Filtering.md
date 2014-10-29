---
position: 5
title: Filtering
---

# Filtering

<p></p>

##### edgeFilters

[`bool`] default:`false`

If set to true, alchemy will load a set of filters that correspond to edge types, defined in the [`edgeTypes`](#edgetypes) parameter, into the filters section of the control dash.

##### nodeFilters 

[`bool`] default:`false`  

If set to true, alchemy will load a set of filters that correspond to node types, as defined in the [`nodeTypes`](#nodetypes) parameter, into the filters section of the control dash.

##### captionsToggle 

[`bool`] default:`false`

Allows toggling of caption visibility.

##### edgesToggle

[`bool`] default:`false` 

Allows toggling of edge visibility.  When toggled, `.hidden` is assigned to all edges.  The default `hidden` class can easily be overwritten to include different levels of opacity or color upon toggle.  See [graph styling](#Graph-Styling) for examples of use cases.

##### nodesToggle 

[`bool`] default:`false`

Allows toggling of node visibility.  When toggled, `.hidden` is assigned to all nodes.  The default `hidden` class can easily be overwritten to include different levels of opacity or color upon toggle.  When used in tandem with [edgesToggle](#edgestoggle), nodes can be removed with edges still being visible.   `nodesToggle` is also useful for applying a custom set of styles for the `.hidden` class that is applied to all nodes on toggle.  See [graph styling](#Graph-Styling) for examples of use cases.
 
_____
