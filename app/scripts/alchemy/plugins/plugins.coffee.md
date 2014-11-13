## Initiates all plugins
When an a new instance of Alchemy is invoked, the conf is checked for plugins
and any defined plugins are initialized.  For example: `

foo = new Alchemy({plugins: {'barPlugin':{}})

will expect`Alchemy.plugins["barPlugin"]() to initialize the respective plugins.

    Alchemy::plugins = (instance)->
        init: () ->
            _.each _.keys(instance.conf.plugins), (key)->
                instance.plugins[key] = Alchemy::plugins[key] instance
                if instance.plugins[key].init? then instance.plugins[key].init()
