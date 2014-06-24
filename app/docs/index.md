# Philosophy
Alchemy.js is a graph drawing application, built with [d3](http://d3js.org/).

Alchemy.js was built so that developers could easily get up and running with Graph visualization applications, and minimal over head.  Additionally, Alchemy.js is built with d3 so that the core application can easily be extended with any of the other features included in d3.  You can see an example of how to extend Alchemy [here](#).

* **[Quick Start](#quick-start)**
* **[[Documentation]]**
* **[[Contributing]]** 

# Quick Start    
1. Include Alchemy in your app:    
    * Download most recent [Alchemy release](#).
    
    ```html
    <link rel="stylesheet" href="path/to/alchemy.css">
    ...
    <script type="text/javascript" src="path/to/vendor.js">
    <script type="text/javascript" src="path/to/alchemy.js">
    ```
    
    -OR-
   
    ```bash
    $ bower install Alchemy --save
    ```
    ```html
    <link rel="stylesheet" href="bower_components/alchemy/alchemy.css">
    ...
    <script type="text/javascript" src="bower_components/alchemy/Alchemy.js">
    ```

2. Alchemy.js consumes GraphJSON, read more about the formate [here](#).  Define a data source in your conf file or inline after the Alchemy files e.g:    
    ```html 
    <script>
    alchemy.conf = {
        dataSource: "yourGraphJSON.json"
    }
    </script>
    ```
    
3. Add an Alchemy div to the page:    
    ```html
    <div class="alchemy"></div>
    ```

4. start alchemy from your app:
    ```JavaScript
    alchemy.begin()
    ```

4. Be amazed by your sexy graph visualization.