<script src=""></script>

Example 2
---------------------
### Full Graph Application

Using Alchemy.js, you can create an entire interactive application by simply uploading your dataset and creating a configuration file!

<div class="alchemy"></div>

If graphWidth and graphHeight are not set, and the alchemy div is a direct child of the body tag, the created visualization will fill the browser.  

Features such as

  - node and edge filters
  - statistics
  - element removal
  - caption toggeling
  - search

and many more are available via an intuitive and customizeable control panel.
 
To keep things modular, we've broken the configuration out into it's own file which is then called in index.html

**config.js**
```js

var config = {
    # datasource
    dataSource: '/sample_data/movies.json',

    # graph options
    initialScale: 1,
    forceLocked: false,

    # control options
    showControlDash: true,
    showFilters: true,
    nodeFilters: true,
    edgeFilters: true,
    zoomControls: true,
    captionsToggle: true,
    edgesToggle: true,
    nodesToggle: true,

    # node configuration
    nodeTypes: {
      "node_type": ["movie", "award", "person"]
    },
    nodeMouseOver: function(n) {
      return $("#node-" + n.id)[0].popover({
        title: "title",
        container: 'body'
      });
    },
    caption: function(n) {
      return "" + n.caption;
    },
    
    # edge configuration
    edgeTypes: ["ACTED_IN", "NOMINATED", "RECEIVED", "PARENT_OF", "PARTNER_OF", "BORN_AT", "PRODUCED"],
    
};

```

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
    <script src="../dist/alchemy/config.js"></script>
    <script type="text/javascript">
        alchemy.begin(config)
    </script>
</html>
```