    Alchemy::NodeUtils = (instance)->
            a = instance
            nodeStyle: (d) ->
                conf = a.conf          
                if conf.cluster
                    d.fill = do (d)->
                        clustering = a.layout._clustering
                        node = a._nodes[d.id].getProperties()
                        clusterMap = clustering.clusterMap
                        key = a.conf.clusterKey
                        colours = conf.clusterColours
                        # Modulo makes sure to reuse colors if it runs out
                        colourIndex = clusterMap[node[key]] % colours.length
                        colour = colours[colourIndex]
                        "#{colour}"
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
