alchemy.updateGraph = (start=true) ->
    # TODO - currently we are displaying all nodes/edges, not a subset
    # set currentNodes/currentEdges and call force.nodes(currentNodes).edges(currentEdges).start();
    # tick should also examine just the visible nodes
    if start then @force.start()
    if not initialComputationDone
        while @force.alpha() > 0.005
            alchemy.force.tick()
        initialComputationDone = true
        console.log(Date() + ' completed initial computation')
        if(conf.locked) then alchemy.force.stop()
    
    alchemy.styles.edgeGradient(alchemy.edges)
    
    #enter/exit nodes/edges
    alchemy.edge = alchemy.vis.selectAll("line")
               .data(alchemy.edges, (d) -> d.source.id + '-' + d.target.id)
    alchemy.node = alchemy.vis.selectAll("g.node")
              .data(alchemy.nodes, (d) -> d.id)
    #draw node and edge objects with all of their interactions
    alchemy.drawing.drawedges(alchemy.edge)
    alchemy.drawing.drawnodes(alchemy.node)
        
    alchemy.vis.selectAll('g.node')
           .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")

    alchemy.vis.selectAll('.node text')
        .text((d) => @utils.nodeText(d))

    alchemy.node
           .exit()
           .remove()

    # initialize graph to size of window
    alchemy.utils.resize() 
    # resize svg on resizing of the window - if the div changes 
    window.onresize = alchemy.utils.resize