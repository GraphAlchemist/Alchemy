    alchemy.drawing.NodeUtils =
            nodeStyle: (d) ->
                conf = alchemy.conf          
                if conf.cluster
                    d.fill = do (d)->
                        clustering = alchemy.layout._clustering
                        node = alchemy._nodes[d.id].getProperties()
                        clusterMap = clustering.clusterMap
                        key = alchemy.conf.clusterKey
                        colours = conf.clusterColours
                        # Modulo makes sure to reuse colors if it runs out
                        colourIndex = clusterMap[node[key]] % colours.length
                        colour = colours[colourIndex]
                        "#{colour}"
                d

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
