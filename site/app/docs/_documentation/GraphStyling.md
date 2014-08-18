---
position: 4
title: Graph Styling
---

# Graph Styling: Overview

Alchemy.js uses a combination of the GraphJSON exposed to the app and the configurations defined to make it intuitive to style the graph visualization with css like you would style any other svg.  However, there are a few styles that have to be assigned dynamically via JavaScript and the Alchemy configurations.

## Alchemy.conf properties that affect Graph Styling

Some of the different ways the graph is *styled* in [alchemy.conf](#Configuration): 

  * [nodeColour](#nodecolour)
  * [nodeRadius](#noderadius)
  * [rootNodeRadius](#rootnoderadius)
  * [graphHeight](#graphheight)
  * [graphWidth](#graphwidth)
  * [clusterColours](#clustercolours)

CSS can be used to style the graph in tandem with [nodeTypes](#nodetypes) and [edgeTypes](#edgetypes).

## Styling the graph using node and edge types

As always, check out the [examples gallery](/#/examples) for full examples.  Below is a short example to give you an idea of the possibilities.


## Sample Data

The following data source of Alchemy.js contributors would, by default, result in the graph viz that follows:

~~~ json
{
    "comment": "AlchemyJS contributors",
    "nodes": [
        {
            "id": 0,
            "caption": "AlchemyJS",
            "role": "project",
            "root": true
        },
        {
            "id": 1,
            "caption": "Huston Hedinger",
            "github": "hustonhedinger",
            "role": "Maintainer",
            "fun_fact": "hooligan"
        },
        {
            "id": 2,
            "caption": "Grace Andrews",
            "github": "Grace-Andrews",
            "role": "Maintainer",
            "fun_fact": "was born left handed, now right handed."
        },
        {
            "id": 3,
            "caption": "Isabella Jorissen",
            "github": "ifjorissen",
            "role": "Maintainer",
            "fun_fact": "knows a lot of digits of pi. Also loves pie."
        },
        {
            "id": 4,
            "caption": "Matt Cox",
            "github": "MDCox",
            "role": "Maintainer",
            "fun_fact": "is not fun"
        },
        {
            "id": 5,
            "caption": "Dave Torbeck",
            "github": "DaveTorbeck",
            "role": "Contributor",
            "fun_fact": ""
        }
    ],
    "edges": [
        {
            "source": 1,
            "target": 0,
            "caption": "Maintains"
        },
        {
            "source": 2,
            "target": 0,
            "caption": "Maintains"
        },
        {
            "source": 3,
            "target": 0,
            "caption": "Maintains"
        },
        {
            "source": 4,
            "target": 0,
            "caption": "Often Breaks"
        },
        {
            "source": 5,
            "target": 0,
            "caption": "contributes"
        }
    ]
}
~~~ 


## Default Visualization 

![Contrib Default Styles](img/graphstyling1.png)    

## Overriding Default Styles

To give the graph some classes we can play with define the node types and edge types in your conf.  For our sample data, you might end up with something like the following:

~~~ json
var conf = {
    "dataSource": "sample_data/contrib.json",
    "nodeTypes": {"role": ["Maintainer",
                           "Contributor",
                           "project"]},
    "edgeTypes": "caption"
};
alchemy.begin(conf)
~~~

Now the nodes and edges receive classes that correspond to the data, and so you can assign css styles based on those classes.  Based on our data and this example we can use this css to generate the graph that follows:

~~~ css
        /* Nodes */
        .Maintainer circle {
            fill: #00ff0e;
            stroke: #00ffda;
        }

        .Contributor circle {
            fill: #ff7921;
            stroke: #4f07ff;
        }
        
        /* Node Captions */
        .Contributor text {
            display: block;
            font-size: 30px;
            fill: #00fff7;
        }

        /* Root Node Caption */
        .root.project text {
            display: block;
            font-size: 40px;
            fill: #ff6e00;
        }

        /* Edges */
        line.Maintains {
            stroke: #00fffa;
            stroke-width: 5px;
            stroke-opacity: 1;
        }

        line.Often.Breaks{
            stroke: #ff0000;#ff00f3;
            stroke-width: 10px;
            stroke-opacity: 1;
        }

        line.contributes {
            stroke: #ff00f3;
            stroke-width: 10px;
            stroke-opacity: 1;
        }
~~~

![Wild Graph Styles](img/graphstyling2.png)

____
