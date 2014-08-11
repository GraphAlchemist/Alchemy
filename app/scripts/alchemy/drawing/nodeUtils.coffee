class alchemy.drawing.NodeUtils
        constructor: ->
            nodes = alchemy._nodes
            conf = alchemy.conf
            
            if conf.cluster
                @nodeColours = (d) ->
                    node_data = alchemy._nodes[d.id]
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
        
        nodeStyle: (d) ->
            color = @nodeColours(d)
            stroke = if alchemy.getState("interactions") is "editor" then "#E82C0C" else color

            "fill: #{color}; stroke: #{color}; stroke-width: #{d['stroke-width']};"