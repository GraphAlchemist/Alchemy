updateGraph = (start=true) ->
    # TODO - currently we are displaying all nodes/edges, not a subset
    # set currentNodes/currentEdges and call force.nodes(currentNodes).edges(currentEdges).start();
    # tick should also examine just the visible nodes

    force.nodes(allNodes).links(allEdges)
    if start then force.start()

    if not initialComputationDone
        while force.alpha() > 0.005
            force.tick()
        initialComputationDone = true
        $('#loading-spinner').hide()
        $('#loading-spinner').removeClass('middle')
        console.log(Date() + ' completed initial computation')
        if(conf.locked) then force.stop()

    #enter/exit nodes/edges
    path = vis.selectAll("line")
            .data(allEdges, (d) ->
                d.source.id + '-' + d.target.id)
    path.enter()
        .insert("svg:line", 'g.node')
        .attr("class", (d) -> "edge #{if d.shortest then 'highlighted' else ''}")
        .attr('id', (d) -> d.source.id + '-' + d.target.id)
        .on('click', edgeClick)
    path.exit().remove()

    path.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)

    node = vis.selectAll("g.node")
              .data(allNodes, (d) -> d.id)

    nodeEnter = node.enter()
                    .append("svg:g")
                    .attr('class', (d) -> "node #{if d.category? then d.category.join ' ' else ''}")
                    .attr('id', (d) -> "node-#{d.id}")
                    .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', nodeMouseOver)
                    .on('dblclick', nodeDoubleClick)
                    .on('click', nodeClick)

    if conf.locked then nodeEnter.call node_drag else nodeEnter.call force.drag

    nodeEnter
        .append('circle')
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) ->
            if d.node_type is 'root'
                rootNodeRadius
            else
                if not conf.scaleNodes then nodeRadius else scale d.count
            )
        .attr('style', (d) ->
            if conf.cluster
                if isNaN parseInt d.cluster
                    colour = '#EBECE4'
                else if d.cluster < colours.length
                    colour = colours[d.cluster]
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

    nodeEnter
        .append('svg:text')
        .text((d) -> rod.caption)
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if d.node_type is 'root' then rootNodeRadius / 2 else nodeRadius * 2 - 5)

    vis
        .selectAll('.node text')
        .text((d) -> return d.caption)

    node
        .exit()
        .remove()
