---
position: 2
title: Edges
---

### Edges

<p></p>

##### edgeStyle

[css style value] **default**: `null`

A function that assigns custom edge styling.  Should return a string that is a valid value to the "style" svg attribute in css.  If `alchemy.conf.cluster` is `true` then styling is assigned by edge gradients take priority.  Read more about the [`cluster` configuration](#cluster).

##### edgeTypes

[array of strings **OR** object] **default**: `null`

Similiar to [nodeTypes](#nodeTypes), a string value will cause Alchemy.js to create an index of edgeTypes based on looking up the values for the parameter on each edge in the GraphJSON.  Below **caption** would create edgeTypes based on the captions provided.  This is a convenience function and can become very costly on larger data sets.

The correct way to define edgeTypes is by passing an object.  The object passed should correspond to keys and values in the GraphJSON that alchemy will use to create filters. For Example, based on the following GraphJSON, you would pass `{"caption": ["acted in", "parent of"]}` to tell Alchemy.js to look for a "caption" key on each edge, and then build types for "acted in" and "parent of" edges.  These types can be used for [edge filters](#edgeFilters) as well as [styling](#Graph Styling).

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

##### edgeCaption
[string] `'caption'` Just like nodes, edges can store descriptive data.  The edgeCaption is the text that will display 'on hover' and by default alchemy looks for 'caption' in the corresponding edge object from the GraphJSON.

___
