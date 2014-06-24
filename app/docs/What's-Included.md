Release:

**`alchemy.js`**: is a compilation of all files in the **[alchemy](https://github.com/GraphAlchemist/Alchemy/tree/master/app/scripts/alchemy)** directory.  This includes the **alchemyConf** file, which includes all of the alchemy defaults.  Read more about how to override defaults [[here|Overriding-Defaults]]    

**`alchemy.css`** contains all of the default styles for the alchemy graph application.  Default styles can be overidden by providing custom css *after* alchemy css and vendor css.    

Development:    
`tree -I 'bower_components|404.html|images|robots.txt|favicon.ico|index.html'`
```
.
├── sample_data
│   └── charlize.json
├── scripts
│   └── alchemy
│       ├── alchemyConf.coffee
│       ├── errors.coffee
│       ├── filters.coffee
│       ├── init.coffee
│       ├── interactions.coffee
│       ├── layout.coffee
│       ├── search.coffee
│       ├── startGraph.coffee
│       ├── styles.coffee
│       ├── update.coffee
│       ├── utils.coffee
│       └── visualcontrols.coffee
└── styles
    ├── alchemy.css
    └── main.scss
```
