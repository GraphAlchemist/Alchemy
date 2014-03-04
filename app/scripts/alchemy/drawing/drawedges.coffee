app.drawing = {}

app.drawing.drawedges = (edge) -> 
    
    edge.enter()
        .insert("line", 'g.node')
        .attr("class", (d) -> "edge #{if d.shortest then 'highlighted' else ''}")
        .attr('id', (d) -> d.source.id + '-' + d.target.id)
        .on('click', interactions.edgeClick)
    edge.exit().remove()

    edge.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)
        .attr('shape-rendering', 'optimizeSpeed')
        .attr "style", (d) ->
            index = undefined
            if d.source.node_type is "root" or d.target.node_type is "root"
                index = (if d.source.node_type is "root" then d.target.cluster else d.source.cluster)
            else if d.source.cluster is d.target.cluster
                index = d.source.cluster
            else if d.source.cluster isnt d.target.cluster
                # if (d.source.cluster is 4) and (d.target.cluster is 5)
                #     # debugger 
                # use gradient between the two clusters' colours
                id = "#{d.source.cluster}-#{d.target.cluster}"
                gid = "cluster-gradient-#{id}"
                return "stroke: url(##{gid})"
            "stroke: #{styles.getClusterColour(index)}"

            # "source": "753kADQEmt", Athena cluster 0
            # "target": "xuf1qr68xz", Shabnam cluster 4
