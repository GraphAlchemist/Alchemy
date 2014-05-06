Alchemy
=======
##Philosophy 
Alchemy.js is a graph drawing application, built with d3.

Alchemy.js was built so that developers could easily get up and running with Graph visualization applications, and minimal overhead. Additionally, because Alchemy.js is built with d3 the core application can easily be extended with any of other features included in d3. You can see an example of how to extend Alchemy [here](#).


##Quick Start
1. Include Alchemy in your app:    
    * Download most recent [Alchemy release](#).
    
    ```
    <link rel="stylesheet" href="path/to/alchemy.css">
    ...
    <script type="text/javascript src="path/to/vendor.js">
    <script type="text/javascript src="path/to/alchemy.js">
    ```
    
    -OR-
    
    * `bower install Alchemy --save`    
    ```
    <link rel="stylesheet" href="bower_components/alchemy/alchemy.css">
    ...
    <script type="text/javascript src="bower_components/alchemy/Alchemy.js">
    ```

2. Alchemy.js consumes GraphJSON, read more about the formate [here](#).  Define a data source in your conf file or inline after the Alchemy files e.g:    
    ```
    <script>
    alchemy.conf = {
        dataSource: "yourGraphJSON.json"
    }
    </script>
    ```
    
3. Add an Alchemy div to the page:    
    `<div class="alchemy"></div>`

4. start the app:
    `alchemy.begin()`

4. Be amazed by your sexy graph visualization.


## Contributing 
Read about how to contribute in the [wiki](#).


    