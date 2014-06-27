#Alchemy.js Documenation
##More Philosophy
The major goal of Alchemy.js is that you, as a developer, do not have to write much code in order to get up and running with a viz app.  Nor, should you have to understand the app, our reasons for doing things the way we've done them, etc.  The very small amount of your work you do will actually just be in configuring Alchemy.js to visualize your data, along with whatever features you want to include in the app.

Below you will find a detailed description of each configuration parameters for Alchemy.js.  [Configuration](#configuration) details the different ways to configure the application, while [Styles](#styles) outlines the alchemy.css styles and how to easily override them. 

If you are familiar with d3.js and decide that you do want to extend Alchemy, our [contributor documentation](#) should give you a solid idea of how to dig in.

##Configuration
Alchemy configurations are stored in a JavaScript object that can be overridden or extended at `alchemy.conf`.  The only user defined parameter that is required is `dataSource`.  The following are the current ways that Alchemy.js can be configured:

* [[Init]]
* [[Editing]]
* [[Filtering]]
* [[Helpers]]
* [[Layout]]
* [[Nodes]]
* [[Edges]]

## Styles
Alchemy.js makes every attempt to push styling of the graph visualization to the css.  There are some cases where styles are assigned dynamically, and therefore css styles are overridden.  For instance, in the case of [`conf.cluster`](#).  All of the styles can be found in the app folder [here](https://github.com/GraphAlchemist/Alchemy/tree/master/app/styles).  Additionally, read a little bit more about the styles on the [[Styles Documentation]] page.