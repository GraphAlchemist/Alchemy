class alchemy.drawing.NodeUtils
        constructor: ->
            nodes = alchemy._nodes
            conf = alchemy.conf
            
            if conf.cluster
                @nodeColours = (d) ->
                    node_data = nodes[d.id].getProperties()
                    if (isNaN parseInt node_data.cluster) or (node_data.cluster > conf.clusterColours.length)
                        colour = conf.clusterColours[conf.clusterColours.length - 1]
                    else
                        colour = conf.clusterColours[node_data.cluster]
                    "#{colour}"
            else
                @nodeColours = (d) ->
                    if conf.nodeColour
                        colour = conf.nodeColour
                    else
                        ''
        
        nodeStyle: (d, radius) ->
            color = @nodeColours(d)
            stroke = if alchemy.getState("interactions") is "editor" then "#E82C0C" else color
            "fill: #{color}; stroke: #{color}; stroke-width: #{ radius / 3 };"