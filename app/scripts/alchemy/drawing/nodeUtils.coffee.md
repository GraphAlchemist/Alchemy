    Alchemy::NodeUtils = (instance)->
            a = instance
            nodeStyle: (d) ->
                conf = a.conf
                node = d.self
                if conf.cluster and (node._state isnt "hidden")
                    d.fill = do (d)->
                        clustering = a.layout._clustering
                        nodeProp = node.getProperties()
                        clusterMap = clustering.clusterMap
                        key = conf.clusterKey
                        colours = conf.clusterColours
                        # Modulo makes sure to reuse colors if it runs out
                        colourIndex = clusterMap[nodeProp[key]] % colours.length
                        colour = colours[colourIndex]
                        "#{colour}"
                    d.stroke = d.fill
                d

            nodeText: (d) ->
                conf = a.conf
                nodeProps = a._nodes[d.id]._properties
                if conf.nodeCaption and typeof conf.nodeCaption is 'string'
                    if nodeProps[conf.nodeCaption]?
                        nodeProps[conf.nodeCaption]
                    else
                        ''
                else if conf.nodeCaption and typeof conf.nodeCaption is 'function'
                    caption = conf.nodeCaption(nodeProps)
                    if caption is undefined or String(caption) is 'undefined'
                        a.log["caption"] = "At least one caption returned undefined"
                        conf.caption = false
                    caption
