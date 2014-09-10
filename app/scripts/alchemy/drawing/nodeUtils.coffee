alchemy.drawing.NodeUtils =
        nodeStyle: (styles) ->
            conf = alchemy.conf           
            if conf.cluster
                nodeColours = ->
                    d = alchemy._nodes[d.id].properties
                    clusterMap = alchemy.layout._clustering.clusterMap
                    key = alchemy.conf.clusterKey
                    colours = conf.clusterColours
                    # Modulo makes sure to reuse colors if it runs out
                    colourIndex = clusterMap[d[key]] % colours.length
                    colour = colours[colourIndex]
                    "#{colour}"
            else
                nodeColours = -> if conf.nodeColour then conf.nodeColour else ''

            if nodeColours is not '' then styles.fill = nodeColours
            styles

        nodeText: (d) ->
            conf = alchemy.conf
            nodeProps = alchemy._nodes[d.id]._properties
            if conf.nodeCaption and typeof conf.nodeCaption is 'string'
                if nodeProps[conf.nodeCaption]?
                    nodeProps[conf.nodeCaption]
                else
                    ''
            else if conf.nodeCaption and typeof conf.nodeCaption is 'function'
                caption = conf.nodeCaption(nodeProps)
                if caption is undefined or String(caption) is 'undefined'
                    alchemy.log["caption"] = "At least one caption returned undefined"
                    conf.caption = false
                caption
