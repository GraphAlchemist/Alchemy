class alchemy.models.NodeAttributes
    constructor: ->
        rootKey = alchemy.conf.rootNodes
        if typeof alchemy.conf.nodeRadius is 'function'
            @nodeSize = (node) ->
                if node[rootKey]? and d[rootKey]
                    alchemy.conf.rootNodeRadius(node)
                else                
                    alchemy.conf.nodeRadius(node)
        else if typeof alchemy.conf.nodeRadius is 'string'
            @nodeSize = (node) ->
                key = alchemy.conf.nodeRadius
                if node[rootKey]?
                    alchemy.conf.rootNodeRadius
                else if node[key]?
                    node[key]
                else
                    alchemy.defaults.rootNodeRadius
        else if typeof alchemy.conf.nodeRadius is 'number'
            @nodeSize = (node) ->
                if node[rootKey]?
                    alchemy.conf.rootNodeRadius
                else
                    alchemy.conf.nodeRadius