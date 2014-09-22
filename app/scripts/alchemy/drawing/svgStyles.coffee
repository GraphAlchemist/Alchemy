alchemy.svgStyles =
    node:
        populate: (node) ->
            conf = alchemy.conf
            defaultStyle = _.omit conf.nodeStyle.all, "selected", "highlighted", "hidden"
            d = node

            nodeTypeKey = _.keys(conf.nodeTypes)[0]
            nodeType = node.getProperties()[nodeTypeKey]

            if conf.nodeStyle[nodeType] is undefined
                nodeType = "all"

            typedStyle = _.assign _.cloneDeep(defaultStyle), conf.nodeStyle[nodeType]
            style = _.assign typedStyle, conf.nodeStyle[nodeType][node._state]

            radius = if node.root then conf.rootNodeRadius d else style.radius d
            fill = style.color d
            stroke = style.borderColor d
            strokeWidth = style.borderWidth d, radius
            
            svgStyles =
                "radius": radius
                "fill": fill
                "stroke": stroke
                "stroke-width": strokeWidth
            console.log node._state, svgStyles
            svgStyles

    edge:
        populate: (edge) ->
            conf = alchemy.conf
            defaultStyle = conf.edgeStyle.all
            d = edge.properties

            edgeTypeKey = _.keys(conf.edgeTypes)[0]
            edgeType = edge[edgeTypeKey]

            style = _.assign _.cloneDeep(defaultStyle), conf.edgeStyle[edgeType]

            width = style.width d
            color = style.color d
            opacity = style.opacity d
            directed = style.directed d
            curved = style.curved d

            svgStyles =
                "stroke": color
                "stroke-width": width
                "opacity": opacity

            svgStyles