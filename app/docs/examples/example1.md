
Example 1
---------------------
### Simple Graph

This example shows how easy it is to get an alchemy visualization up and running with minimal effort.
A setup like this would be perfect for creating examples to accompany text and illustrate a point.  
Because you can define the size with the graphWidth and graphHeight attributes, they fit seamlessly into an existing webpage.

The graph is draggable and zoomable by default, and nodes can be repositioned.

By defining the caption and the node types, you allow Alchemy to reveal the captions as your user mouses over the node.

**index.html**
```html
<html>
<head>
    <link rel="stylesheet" href="../dist/styles/vendor.css"/>
    <link rel="stylesheet" href="../dist/alchemy.min.css"/>
</head>
<body>
    <div class="alchemy" id="graph"></div>
</body>
    <script src="../dist/scripts/vendor.js"></script>
    <script src="../dist/alchemy.min.js"></script>
    <script type="text/javascript">

        config = _.assign({}, {
            
            graphWidth: "400px",
            graphHeight: "400px",

            dataSource: '/sample_data/team.json',
            
            caption: function(n) { return n.caption; },
            
            nodeTypes: {
              "node_type": ["movie", "award", "person"]
            }
          });

        alchemy.begin(config)
    </script>
</html>
```