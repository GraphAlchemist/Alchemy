app.updateGraph = (start=true) ->
    # TODO - currently we are displaying all nodes/edges, not a subset
    # set currentNodes/currentEdges and call force.nodes(currentNodes).edges(currentEdges).start();
    # tick should also examine just the visible nodes
    force = app.force
    vis = app.vis
    force.nodes(app.nodes).links(app.edges)
    if start then force.start()
        # debugger
    if not initialComputationDone
        while force.alpha() > 0.005
            force.tick()
        initialComputationDone = true
        $('#loading-spinner').hide()
        $('#loading-spinner').removeClass('middle')
        console.log(Date() + ' completed initial computation')
        if(conf.locked) then force.stop()

    styles.edgeGradient(app.edges)

    #enter/exit nodes/edges
    app.edge = vis.selectAll("line")
            .data(app.edges, (d) ->
                d.source.id + '-' + d.target.id)
    app.edge.enter()
        .insert("line", 'g.node')
        .attr("class", (d) -> "edge #{if d.shortest then 'highlighted' else ''}")
        .attr('id', (d) -> d.source.id + '-' + d.target.id)
        .on('click', interactions.edgeClick)
    app.edge.exit().remove()

    app.edge.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)
        .attr "style", (d) ->
            index = undefined
            if d.source.node_type is "root" or d.target.node_type is "root"
                index = (if d.source.node_type is "root" then d.target.cluster else d.source.cluster)
            else if d.source.cluster is d.target.cluster
                index = d.source.cluster
            else
                # use gradient between the two clusters' colours
                if d.target.cluster < d.source.cluster
                    id = d.target.cluster + "-" + d.source.cluster
                else
                    id = d.source.cluster + "-" + d.target.cluster
                id = "cluster-gradient-" + id
            return "stroke: url(#" + id + ")"
            "stroke: " + styles.getClusterColour(index)


    app.node = vis.selectAll("g.node")
              .data(app.nodes, (d) -> d.id)
    #bind node data to d3
    nodeEnter = app.node.enter().append("g")
                    .attr('class', (d) -> "node #{if d.category? then d.category.join ' ' else ''}")
                    .attr('id', (d) -> "node-#{d.id}")
                    .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', interactions.nodeMouseOver)
                    .on('dblclick', interactions.nodeDoubleClick)
                    # .on "click", ->
                    #     return if d3.event.defaultPrevented
                    #     console.log("clicked!")
                    #     return
                    .on('click', interactions.nodeClick)
                    .call(interactions.drag)
                    
    # if conf.locked then nodeEnter.call node_drag else nodeEnter.call force.drag

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
        .text((d) -> d.caption)
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if d.node_type is 'root' then rootNodeRadius / 2 else nodeRadius * 2 - 5)

    vis
        .selectAll('.node text')
        .text((d) -> return d.caption)
    
    app.node
        .exit()
        .remove()
