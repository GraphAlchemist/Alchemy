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

            width = defaultStyle.width(d)
            color = defaultStyle.color(d)
            opacity = defaultStyle.opacity(d)
            directed = defaultStyle.directed(d)
            curved = defaultStyle.curved(d)

            svgStyles =
                "stroke": color
                "stroke-width": width
                "opacity": opacity

            return svgStyles