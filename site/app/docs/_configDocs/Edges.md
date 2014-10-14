---
position: 2
title: Edges
---

# Edges

<p></p>

By default, edges do not require an ID, only a source and target.  If, however, there are multiple edges that share the same source and target, a unique ID will be required.

##### edgeCaption

[`string`] default:`'caption'` 

Just like nodes, edges can store descriptive data.  The edgeCaption is the text that will display 'on hover' and by default alchemy looks for 'caption' in the corresponding edge object from the GraphJSON.

##### edgeClick

[`"default"|function`] default:`'default'`

The action that occurs when the user clicks an edge.  When the string `'default'` is passed in, edges and their captions (if specified) select upon click, and deselects when reclicked. This is the same as the default interaction for nodes.  If a different interaction is desired, a function can be passed in.

##### edgeStyle

[`edgeType`: { `list of css style values` }] default edgeType:`all`

A set of configuration options that assigns custom edge styling.  Should return an object whose key is an edgeType, and whose value is a list of valid css styles.  

Current default configuration:

~~~ javascript
{
  edgeStyle: {
    "all": {
      "width": 4,
      "color": "#CCC",
      "opacity": 0.2,
      "selected": {
          "opacity": 1
        },
      "highlighted": {
          "opacity": 1
        },
      "hidden": {
          "opacity": 0
        }
    }
  }
}
~~~

By default edgeStyles apply to "all" edges.  This can be changed to be any valid [`edgeType` value](#edgeTypes).  Different styles may be applied to different edgeTypes at user's discretion.

"selected", "highlighted", and "hidden" are conditional stylings based on current edge state.  

If `alchemy.conf.cluster` is `true` then styling is assigned by edge gradients take priority.  Read more about the [`cluster` configuration](#cluster).

##### edgeTypes

[`array of strings|object`] default:`null`

Similiar to [nodeTypes](#nodetypes), a string value will cause Alchemy.js to create an index of edgeTypes based on looking up the values for the parameter on each edge in the GraphJSON.  Below **caption** would create edgeTypes based on the captions provided.  This is a convenience function and can become very costly on larger data sets.

The correct way to define edgeTypes is by passing an object.  The object passed should correspond to keys and values in the GraphJSON that alchemy will use to create filters. For Example, based on the following GraphJSON, you would pass `{"caption": ["acted in", "parent of"]}` to tell Alchemy.js to look for a "caption" key on each edge, and then build types for "acted in" and "parent of" edges.  These types can be used for [edge filters](#edgefilters) as well as [styling](#Graph-Styling).

~~~ json
"edges": [
 {
            "source": 95421,
            "target": 714293,
            "caption": "acted in"
        },
        {
            "source": 95421,
            "taget": 95426,
            "caption": "parent of"
        },
        {
            "source": 95421,
            "role": "Devlin Moran",
            "target": 603720,
            "caption": "acted in"
        },...]
...}
~~~

##### curvedEdges

[`bool`] default:`false`

The boolean value of `curvedEdges` determines whether the edges are rendered as straight lines or curved.  Currently, this feature is mainly aesthetic, though down the line it will allow more flexability in how to show multiple edges shared between the same two nodes.

##### edgeWidth

[`int|function`] default:`4`

Width, in pixels, of the rendered edge. If passed a function, the first callback variable is the data, and the second is the index which can be used to return the integer that defines the edge width.

##### edgeOverlayWidth
[`int`] default:`20`

To make it easier for the end user to click on an edge, each edge has an invisible overlay to which event handlers are applied.  The edgeOverlayWidth will control the width of this overlay, in effect creating an accuracy level for edge clicks.  The default value of `20` will be good for most graphs, but for use cases where there will be extreme amounts of edges, decreasing this value will allow more accurate targeting. 

##### directedEdges
[`bool`] default:`false`

Determines whether arrows are drawn on the rendered edge.  Direction is implied from the initial `source` and `target` keys set in the GraphJSON.

For example:

~~~ json
{
  "edges": [
    {
      "source": 95421,
      "target": 714293,
      "caption": "acted in"
    }
  ]
}
~~~

The arrow will point toward the `target` node and away from the `source` node.

##### edgeArrowSize
[`int`] default:`5`

Size, in pixels, of the arrow applied to directed edges.  Only relevant if `directedEdges` is `true`. 

_______
