alchemy.svgStyles =
    node:
        populate: (node) ->
            conf = alchemy.conf
            defaultStyle = conf.nodeStyle.all
            d = node

            radius = if node.root then conf.rootNodeRadius(d) else defaultStyle.radius(d)
            fill = defaultStyle.color d
            stroke = defaultStyle.borderColor d
            strokeWidth = defaultStyle.borderWidth d, radius
            
            svgStyles =
                "radius": radius
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