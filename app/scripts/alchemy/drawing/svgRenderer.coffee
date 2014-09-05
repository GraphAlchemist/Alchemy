alchemy.svgRenderer =
    node:
        populate: (node)->
            defaultStyle = alchemy.conf.nodeStyle.all
            d = node.properties

            radius = defaultStyle.radius d
            fill = defaultStyle.color d
            stroke = defaultStyle.borderColor d
            strokeWidth = defaultStyle.borderWidth d, radius
            
            svgStyles =
                "fill": fill
                "stroke": stroke
                "stroke-width": strokeWidth

            node.renderedStyles = svgStyles

    edge:
        populate: (edge) ->
            defaultStyle = alchemy.conf.edgeStyle.all
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

            edge.renderedStyles = svgStyles

    jsonToCSS: (json) ->
            str = JSON.stringify json
            str = str.replace ",", ";"
            str = str.replace "{", ""
            str = str.replace "}", ""
            str = str.replace '"', ""

            str.split(",").join(";")
               .split("{").join("")
               .split("}").join("")
               .split('"').join("")