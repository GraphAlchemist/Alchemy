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
    app.node = vis.selectAll("g.node")
              .data(app.nodes, (d) -> d.id)
    
    app.drawing.drawedges(app.edge)
    app.drawing.drawnodes(app.node)

    vis
        .selectAll('.node text')
        #.text((d) -> return d.caption)
        .text((d) -> utils.nodeText(d))

    app.node
        .exit()
        .remove()
