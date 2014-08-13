---
position: 5
title: Filtering
---


# Filtering

<p></p>

##### showFilters 

[bool] **default**: `false`

When both `showFilters` and `showControlDash` are true, creates a filter menu that contains different types of graph filters.  [`showControlDash`](#showControlDash) must be true in order for the filters menu to be visible.  Current elements in the filters menu are [edgeFilters](#edgeFilters), [nodeFilters](#nodeFilters), [captionToggle](#captionToggle), [edgesToggle](#edgesToggle), [nodesToggle](#nodesToggle), and [toggleRootNodes](#toggleRootNodes).

##### edgeFilters

[bool] **default**: `false`

If set to true, alchemy will load a set of filters that correspond to edge types defined in the [`edgeTypes`](#edgetypes) parameter, into the filters section of the control dash.

##### nodeFilters 

[bool] **default**: `false`  

If set to true, alchemy will load a set of filters that correspond to node types as defined in the [`nodeTypes`](#nodetypes) into the filters section of the control dash.

##### captionsToggle 

[bool] **default**: `false`

Allow toggling of caption visibility.  When toggled, `.hidden` is assigned to all captions.  The default `hidden` class can easily be overwritten to allow different colors or opacities for node captions when hidden.  See [graph styling](../GraphStyling) for examples of use cases.

##### edgesToggle

[bool] **default**: `false` 

Allow toggling of edge visibility.  When toggled, `.hidden` is assigned to all edges.  The default `hidden` class can easily be overwritten to include different levels of opacity or color upon toggle.  See [graph styling](../GraphStyling) for examples of use cases.

##### nodesToggle 

[bool] **default**: `false`

Allow toggling of node visibility.  When toggled, `.hidden` is assigned to all nodes.  The default `hidden` class can easily be overwritten to include different levels of opacity or color upon toggle.  When used in tandem with [edgesToggle](#edgesToggle) nodes can be removed with edges still being visible.  Nodes toggle is also useful for applying a custom set of styles for the `.hidden` class that is applied to all nodes on toggle.  See [graph styling](../GraphStyling) for examples of use cases.

<!-- ##### toggleRootNodes 

[bool] `true`    

If true a t -->

<!-- ##### edgesTagsFilter 

[array of strings|object] `false`

**not currently implemented**
 -->
<!-- ##### nodesTagsFilter 

[array of strings|object] `false`

**not currently implemented**
 -->
 
_____
