    Alchemy::svgStyles = (instance)->
        a: instance

        node:
            a: @a
            populate: (node) ->
                conf = @a.conf
                defaultStyle = _.omit conf.nodeStyle.all, "selected", "highlighted", "hidden"
                d = node

                # if user put in hard value, turn into a function
                toFunc = (inp)->
                    return inp if typeof inp is "function"
                    return -> inp

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

                svgStyles = {}
                svgStyles["radius"] = radius d
                svgStyles["fill"] = fill d
                svgStyles["stroke"] = stroke d
                svgStyles["stroke-width"] = strokeWidth d, radius(d)
                
                svgStyles

        edge:
            a: @a
            populate: (edge) ->
                conf = @a.conf
                defaultStyle = _.omit conf.edgeStyle.all, "selected", "highlighted", "hidden"

                # if user put in hard value, turn into a function
                toFunc = (inp)->
                    if typeof inp is "function"
                        return inp
                    return -> inp

                edgeType = edge._edgeType

                if conf.edgeStyle[edgeType] is undefined
                    edgeType = "all"

                typedStyle = _.assign _.cloneDeep(defaultStyle), conf.edgeStyle[edgeType]
                style = _.assign typedStyle, conf.edgeStyle[edgeType][edge._state]

                width = toFunc style.width
                color = toFunc style.color
                opacity = toFunc style.opacity

                svgStyles =
                    "stroke": color edge
                    "stroke-width": width edge
                    "opacity": opacity edge
                    "fill": "none"
                    # Uncomment for flower
                    # "fill": color edge

                svgStyles

            update: (edge) ->
                conf = @a.conf
                style = edge._style
                toFunc = (inp)->
                    if typeof inp is "function"
                        return inp
                    return -> inp

                width = toFunc style.width
                color = toFunc style.color
                opacity = toFunc style.opacity

                svgStyles =
                    "stroke": color edge
                    "stroke-width": width edge
                    "opacity": opacity edge
                    "fill": "none"

                svgStyles