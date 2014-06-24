#####edgeCaption:
**not currently implemented**
[string] `'caption'` Just like nodes, edges can store descriptive data.  The edgeCaption is the text that will display 'on hover' and by default alchemy looks for 'caption' in the corresponding edge object from the GraphJSON.

#####edgeColour:
[css color value] `null`  A colour to be passed to all edges.  If `alchemy.conf.cluster` is `true` then colors assigned by edge gradients take priority.  Read more about the [[`cluster` configuration|Layout#cluster]].

#####edgeTypes: 
[array of strings|object] `null`    
Parameters passed correspond to keys and values in the GraphJSON that alchemy will use to, for instance, create filters. For Example, if working with the following GraphJSON:
```json
"edges": [
 {
            "source": 95421,
            "target": 714293,
            "label": "acted in"
        },
        {
            "source": 95421,
            "taget": 95426,
            "label": "parent of"
        },
        {
            "source": 95421,
            "role": "Devlin Moran",
            "target": 603720,
            "label": "acted in"
        },...]
...}
```
The user would pass the following object to alchemy.conf.edgeTypes "parent of" and "acted in" edges: `{caption: ["acted in", "parent of"]}`