## Initiates all plugins
When an a new instance of Alchemy is invoked, the conf is checked for plugins
and any defined plugins are initialized.  For example: `foo = new Alchemy({plugins: 
    ['barPlugin', 'searchPlugin']})` will expect `Alchemy.plugins.barPlugin
()` and `Alchemy.plugins.searchPlugin()` to initialize the respective plugins.    

    Alchemy::plugins = 
        init: (conf, instance) ->
            if conf.plugins
                for p in conf.plugins
                    if not instance.plugins[p]
                        console.warn("It looks like the plugin, #{p} you are trying to load, has not been included.")
                    else
                        instance.plugins[p]()
                    
                    # console.log("foo")
