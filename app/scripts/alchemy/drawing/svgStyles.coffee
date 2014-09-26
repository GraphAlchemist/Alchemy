alchemy.svgStyles =
    node:
        populate: (node) ->
            conf = alchemy.conf
            defaultStyle = _.omit conf.nodeStyle.all, "selected", "highlighted", "hidden"
            d = node
            # if user put in hard value, turn into a function
            toFunc = (inp)->
                if typeof inp is "function"
                    return inp
                return (d)-> inp

            nodeTypeKey = _.keys(conf.nodeTypes)[0]
            nodeType = node.getProperties()[nodeTypeKey]

            if conf.nodeStyle[nodeType] is undefined
                nodeType = "all"

            typedStyle = _.assign _.cloneDeep(defaultStyle), conf.nodeStyle[nodeType]
            style = _.assign typedStyle, conf.nodeStyle[nodeType][node._state]

            radius = toFunc style.radius
            fill = toFunc style.color
            stroke = toFunc style.borderColor
            strokeWidth = toFunc style.borderWidth
            svgStyles =
                "radius": radius d
                "fill": fill d
                "stroke": stroke d
                "stroke-width": strokeWidth d, radius(d)
            
            svgStyles

    edge:
        populate: (edge) ->
            conf = alchemy.conf
            defaultStyle = _.omit conf.edgeStyle.all, "selected", "highlighted", "hidden"
            d = edge.getProperties()

            toFunc = (inp)->
                if typeof inp is "function"
                    return inp
                return -> inp

            edgeTypeKey = _.keys(conf.edgeTypes)[0]
            edgeType = edge[edgeTypeKey]

            if conf.edgeStyle[edgeType] is undefined
                edgeType = "all"

            typedStyle = _.assign _.cloneDeep(defaultStyle), conf.edgeStyle[edgeType][edge._state]
            style = _.assign typedStyle, conf.edgeStyle[edgeType][edge._state]

            width = toFunc style.width
            color = toFunc style.color
            opacity = toFunc style.opacity
            directed = toFunc style.directed
            curved = toFunc style.curved

            svgStyles =
                "stroke": color d
                "stroke-width": width d
                "opacity": opacity d
                "fill": "none"

            svgStyles