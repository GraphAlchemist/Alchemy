class alchemy.models.NodeStyle
    constructor: (node) ->
        conf = alchemy.conf
        rootKey = conf.rootNodes
        
        @nodeSize = (node) ->
            switch typeof conf.nodeRadius
                when 'function'
                    if node[rootKey]? and d[rootKey]
                        conf.rootNodeRadius(node)
                    else
                        conf.nodeRadius(node)
                when 'string'
                    key = conf.nodeRadius
                    if node[rootKey]?
                        conf.rootNodeRadius
                    else if node[key]?
                        node[key]
                when 'number'
                    if node[rootKey]?
                        conf.rootNodeRadius
                    else
                        conf.nodeRadius

        alchemy.svgRenderer.node.populate(node) if conf.renderer is "svg"