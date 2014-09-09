class alchemy.drawing.NodeUtils
        constructor: ->
            nodes = alchemy._nodes
            conf = alchemy.conf
            
            if conf.cluster
                @nodeColours = (d) ->
                    node_data = alchemy._nodes[d.id].properties
                    clusterMap = alchemy.layout._clustering.clusterMap
                    clusterKey = alchemy.conf.clusterKey
                    # Modulo makes sure to reuse colors if it runs out
                    colourIndex = clusterMap[node_data[clusterKey]] % conf.clusterColours.length

                    colour = conf.clusterColours[colourIndex]
                    "#{colour}"
            else
                @nodeColours = (d) ->
                    if conf.nodeColour
                        colour = conf.nodeColour
                    else
                        ''
        
        nodeStyle: (styles) ->
            if @nodeColours(styles) is not ''
                styles.fill = @nodeColours styles
            styles

        nodeText: (d) ->
            node = alchemy._nodes[d.id]
            if alchemy.conf.nodeCaption and typeof alchemy.conf.nodeCaption is 'string'
                if node._properties[alchemy.conf.nodeCaption]?
                    node._properties[alchemy.conf.nodeCaption]
                else
                    ''
            else if alchemy.conf.nodeCaption and typeof alchemy.conf.nodeCaption is 'function'
                caption = alchemy.conf.nodeCaption(node._properties)
                if caption == undefined or String(caption) == 'undefined'
                    alchemy.log["caption"] = "At least one caption returned undefined"
                    alchemy.conf.caption = false
                caption
