alchemy.svgRenderer =
    populate: (node, d)->
        defaultStyle = alchemy.conf.nodeStyle.all

        radius = defaultStyle.radius d
        fill = defaultStyle.color d
        stroke = defaultStyle.borderColor d
        strokeWidth = defaultStyle.borderWidth d, radius
        
        svgStyles = {
            "fill": fill
            "stroke": stroke
            "stroke-width": strokeWidth
        }

        node.renderedStyles = svgStyles