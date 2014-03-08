#bind node data to d3
app.drawing.drawnodes = (node) ->
    
    nodeEnter = node.enter().append("g")
                    .attr('class', (d) -> "node #{if d.category? then d.category.join ' ' else ''}")
                    .attr('id', (d) -> "node-#{d.id}")
                    .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', interactions.nodeMouseOver)
                    .on('mouseout', interactions.nodeMouseOut)
                    .on('dblclick', interactions.nodeDoubleClick)
                    .on('click', interactions.nodeClick)
                    .call(interactions.drag)
                    
    # if conf.locked then nodeEnter.call node_drag else nodeEnter.call force.drag

    nodeEnter
        .append('circle')
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) -> utils.nodeSize(d))#app.drawing.nodeSize(d))
        .attr('shape-rendering', 'optimizeSpeed')
        .attr('style', (d) -> #TODO - everything should be css
            if conf.cluster
                if isNaN parseInt d.cluster
                    colour = '#EBECE4'
                else if d.cluster < conf.colours.length
                    colour = conf.colours[d.cluster]
                else
                    ''
            else if conf.colours
                if d[conf.colourProperty]? and conf.colours[d[conf.colourProperty]]?
                    colour = conf.colours[d[conf.colourProperty]]
                else
                    colour = conf.colours['default']
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
        .text((d) -> utils.nodeText(d))
