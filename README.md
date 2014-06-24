Alchemy
=======
#IN DEVELOPMENT 
[![Build Status](https://travis-ci.org/GraphAlchemist/Alchemy.svg?branch=master)](https://travis-ci.org/GraphAlchemist/Alchemy)
##Philosophy 
Alchemy.js is a graph drawing application, built with d3.

Alchemy.js was built so that developers could easily get up and running with Graph visualization applications, and minimal overhead. Additionally, because Alchemy.js is built with d3 the core application can easily be extended with any of other features included in the d3 API. You can see an example of how to extend Alchemy [here](#).


##Quick Start
1. Get Alchemy.js:    
    * Download most recent [Alchemy.js release](#).    
    -OR-
    * `bower install Alchemy --save`    
2. Include Alchemy and its dependencies:
    ```html
    <link rel="stylesheet" href="bower_components/alchemy/alchemy.css">
    ...
    <script type="text/javascript src="bower_components/alchemy/vendor.js">
    <script type="text/javascript src="bower_components/alchemy/Alchemy.js">
    ```

2. Alchemy.js consumes GraphJSON, read more about the format [here](#).  Define a data source in your conf file or inline after the Alchemy files e.g:    
    ```html
    <script>
    alchemy.conf = {
        dataSource: "yourGraphJSON.json"
    }
    </script>
    ```
    
3. Add an Alchemy classed div to the page:    
    `<div class="alchemy"></div>`

4. start the app:
    `alchemy.begin()`

4. Be amazed by your sexy graph visualization.

##Documentation
Read more about how to use alchemy in the [docs](#).

To build the docs locally install mkdocs and then serve them up.
```python
pip install mkdocs
mkdocs serve
```

##Contributing 
Read about how to contribute in the [docs](#).

##Licensing
The source is licensed under the AGPLv3 license for open source and open data projects.  For commercial licensing, get in touch with the [GraphAlchemist](#) team. 

    
