    class warnings
        constructor: (instance) ->
            @a = instance
        
        dataWarning: =>
            if @a.conf.dataWarning and typeof @a.conf.dataWarning is 'function'
                @a.conf.dataWarning()
            else if @a.conf.dataWarning is 'default'
                console.log "No dataSource was loaded"

        divWarning: ->
            """
                create an element that matches the value for 'divSelector' in your conf.
                For instance, if you are using the default 'divSelector' conf, simply provide
                <div id='#alchemy'></div>.
            """
