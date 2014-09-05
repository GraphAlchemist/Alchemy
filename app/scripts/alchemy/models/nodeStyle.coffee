class alchemy.models.NodeStyle
    constructor: (node) ->
        conf = alchemy.conf
        rootKey = conf.rootNodes
        if typeof conf.nodeRadius is 'function'
            @nodeSize = (node) ->
                if node[rootKey]? and d[rootKey]
                    conf.rootNodeRadius(node)
                else
                    conf.nodeRadius(node)
        else if typeof conf.nodeRadius is 'string'
            @nodeSize = (node) ->
                key = conf.nodeRadius
                if node[rootKey]?
                    conf.rootNodeRadius
                else if node[key]?
                    node[key]
                else
                    defaults.rootNodeRadius
        else if typeof conf.nodeRadius is 'number'
            @nodeSize = (node) ->
                if node[rootKey]?
                    conf.rootNodeRadius
                else
                    conf.nodeRadius
        
        if conf.renderer is "svg"
            alchemy.svgRenderer.populate(node)

    strokeWidth: (radius) -> radius / 3
