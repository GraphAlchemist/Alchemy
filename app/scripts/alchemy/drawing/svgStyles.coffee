alchemy.svgStyles =
    node:
        populate: (node)->
            conf = alchemy.conf
            defaultStyle = conf.nodeStyle.all
            d = node

            nodeTypeKey = _.keys(conf.nodeTypes)[0]
            nodeType = node.getProperties()[nodeTypeKey]

            style = _.assign(_.cloneDeep(defaultStyle), conf.nodeStyle[nodeType])

            radius = if node.root then conf.rootNodeRadius(d) else style.radius(d)
            fill = style.color d
            stroke = style.borderColor d
            strokeWidth = style.borderWidth d, radius
            
            svgStyles =
                "r": radius
                "fill": fill
                "stroke": stroke
                "stroke-width": strokeWidth

            return svgStyles

    edge:
        populate: (edge) ->
            conf = alchemy.conf
            defaultStyle = conf.edgeStyle.all
            d = edge.properties

            edgeTypeKey = _.keys(conf.edgeTypes)[0]
            edgeType = edge[edgeTypeKey]

            style = _.assign _.cloneDeep(defaultStyle), conf.edgeStyle[edgeType]

            width = style.width(d)
            color = style.color(d)
            opacity = style.opacity(d)
            directed = style.directed(d)
            curved = style.curved(d)

            svgStyles =
                "stroke": color
                "stroke-width": width
                "opacity": opacity

            return svgStyles