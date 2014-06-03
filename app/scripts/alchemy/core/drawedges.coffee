alchemy.drawing.drawedges = (edge) ->  
    if conf.cluster
        edgeStyle = (d) ->
            if d.source.node_type is "root" or d.target.node_type is "root"
                index = (if d.source.node_type is "root" then d.target.cluster else d.source.cluster)
            else if d.source.cluster is d.target.cluster
                index = d.source.cluster
            else if d.source.cluster isnt d.target.cluster
                # use gradient between the two clusters' colours
                id = "#{d.source.cluster}-#{d.target.cluster}"
                gid = "cluster-gradient-#{id}"
                return "stroke: url(##{gid})"
            "stroke: #{alchemy.styles.getClusterColour(index)}"
    else if conf.edgeColour and not conf.cluster
        edgeStyle = (d) ->
            "stroke: #{conf.edgeColour}"
    else
        edgeStyle = (d) -> 
            ""
    
    edge.enter()
        .insert("line", 'g.node')
        .attr("class", (d) -> "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
        .attr('id', (d) -> d.source.id + '-' + d.target.id)
        .on('click', alchemy.interactions.edgeClick)
    edge.exit().remove()

    edge.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)
        .attr('shape-rendering', 'optimizeSpeed')
        .attr "style", (d) -> edgeStyle(d)

