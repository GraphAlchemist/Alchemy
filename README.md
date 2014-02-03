Alchemy
=======
##Philosophy 
Alchemy is a graph visualization application that plays nice with most modern browsers and is easily extensible.

Alchemy is built with a number of fantastic open-source technologies (like d3.js).  However, Alchemy itself is trying not to be another "library" or "toolkit".  

Visualizing your graph data in a browser should be as simple as including the javascript, and supplying properly formatted data (GraphJSON).


##Quick Start

* Download most recent [Alchemy release](#).
* Include Alchemy in your app:
    ```
    <script type="text/javascript src="path/to/vendor.js"> // To include dependencies
    <script type="text/javascript" src="path/to/youralchemyConf.js">    
    <script type="text/javascript src="path/to/alchemy.js">
    ```
    -OR-    
    `bower install Alchemy --save`

    `alchemy.js` includes the default alchemyConf file, which you can find [here](#).  `yourAlchemyconf.js` should include any of the defaults from `alchemyConf.js` that you would like to override.  

* Add an Alchemy div to the page:    
    `<div class="alchemy"></div>`

* Specify a data source in one of the following two ways: 
    1. In `youralchemyConf.js`, specify the `dataSource`.    
        ```
        {...,    
            dataSource: '/path/or/url/to/graph/json/endpoint',}    
            ...}    
        ```
    2. Inline:
        ```
        <script>
            alchemy.dataSource = '/path/or/url/to/graph/json/endpoint';
        </script>
        ```    

    **Note:**data should be a properly formatted GraphJSON document.  GraphJSON parameters currently supported by Alchemy are listed in the [API](#).    

*  Be amazed at your graph...


## Contributing 
1) Add new template locations in the Grunt file under watch `jade` task
2)