# Philosophy
Alchemy.js is a graph drawing application built almost entirely in [d3](http://d3js.org/).

Alchemy.js was built so that developers could easily get up and running with Graph visualization applications, and not much over head.  Minimal code is actually required to generate Alchemy.js graphs with most projects. Most customization of the application takes place by overriding default configurations, rather than direct implementation via JavaScript.

Additionally, because Alchemy.js is built with d3, the core application can easily be extended with any of the other features included in d3.

---
# Quick Start
Alchemy.js requires 3 things, **alchemy.css**, **alchemy.js**, and **data**.  The following are 3 different ways to get started with Alchemy.js.

## 1. Include the Alchemy CDNs in your code:
The CDN's include the vendor code.

```html
<link rel="stylesheet" href="http://cdn.graphalchemist.com/alchemy.min.css">
<script type="text/javascript" src="http://cdn.graphalchemist.com/alchemy.min.js">
```

**Include an element with "alchemy" as the id and class**
```html
<div id="alchemy" class="alchemy"></div>
```

** Provide Alchemy.js with a graphJSON dataSource: **

```json
var some_data = 
    {
      "nodes": [
        {
          "id": 1
        },
        {
          "id": 2
        },
        {
          "id": 3
        }
      ],
      "edges": [
        {
          "source": 1,
          "target": 2
        },
        {
          "source": 1,
          "target": 3,
        }
      ]
    };
```
** start Alchemy.js: **
```html
<script>
  alchemy.begin({"dataSource": some_data})
</script>
```

** Be amazed: **    
![Two Nodes](img/threenodes.png)

## 2.  Download and include Alchemy.js:

```html
<link rel="stylesheet" type="text/css" href="path/to/vendor.css">
<link rel="stylesheet" href="path/to/alchemy.css">

<script type="text/javascript" src="path/to/vendor.js">
<script type="text/javascript" src="path/to/alchemy.js">
```

Repeat from above:   

* ** Add an element with "alchemy" as the id and class**    
* ** Provide Alchemy.js with a graphJSON dataSource.**    
* ** start Alchemy.js.**    
* ** Be amazed.**        
  

## 3. Install with Bower
Alchemy.js itself is a yeoman project and can easily be installed with bower.
```bash
bower install alchemyjs --save
```

# Next Steps
Alchemy.js relies on a flexible and open data format called **[GraphJSON](graphjson)** and can do a lot more than draw small graphs.  Alchemy.js includes a large and growing set of default configurations that can be easily overridden.  Check out the **[configuration](configuration)** documentation to learn about all of the ways Alchemy.js can be configured out of the box.