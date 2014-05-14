#bind node data to d3
alchemy.drawing.drawnodes = (node) ->
    
    nodeEnter = node.enter().append("g")
                    .attr('class', (d) -> "node #{if d.category? then d.category.join ' ' else ''}")
                    .attr('id', (d) -> "node-#{d.id}")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', alchemy.interactions.nodeMouseOver)
                    .on('mouseout', alchemy.interactions.nodeMouseOut)
                    .on('dblclick', alchemy.interactions.nodeDoubleClick)
                    .on('click', alchemy.interactions.nodeClick)
                    .call(alchemy.interactions.drag)
                    
    # if conf.locked then nodeEnter.call node_drag else nodeEnter.call force.drag

    nodeEnter
        .append('circle')
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) -> alchemy.utils.nodeSize(d))#app.drawing.nodeSize(d))
        .attr('shape-rendering', 'optimizeSpeed')
        .attr('style', (d) -> #TODO - everything should be css
            if conf.cluster
                if isNaN parseInt d.cluster
                    colour = '#EBECE4'
                else if d.cluster < conf.clusterColours.length
                    colour = conf.clusterColours[d.cluster]
                else
                    ''
            else if conf.clusterColours
                if d[conf.colourProperty]? and conf.clusterColours[d[conf.colourProperty]]?
                    colour = conf.clusterColours[d[conf.colourProperty]]
                else
                    colour = conf.clusterColours['default']
            else
                ''
            "fill: #{colour}; stroke: #{colour};"
            )

    #append caption to the node
    nodeEnter
        .append('svg:text')
        #.text((d) -> d.caption)
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if d.node_type is 'root' then rootNodeRadius / 2 else nodeRadius * 2 - 5)
        .text((d) -> alchemy.utils.nodeText(d))
