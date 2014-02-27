# not sure that we sorts of things we really want to let the controllers
# do with the styles... we should leave most styling to the css.  
# Even user defined over rides...

styles.getClusterColour = (index) ->
    if conf.colours[index]?
        conf.colours[index]
    else
        '#EBECE4'

styles.edgeGradient = (edges) ->
    defs = d3.select(".alchemy svg").append("svg:defs")
    for edge in edges
        # skip root
        continue if edge.source.node_type is "root" or edge.target.node_type is "root"
        # skip nodes from the same cluster
        if edge.source.cluster is edge.target.cluster
            continue
        if edge.target.cluster < edge.source.cluster
            id = edge.target.cluster + "-" + edge.source.cluster
            startColour = styles.getClusterColour(edge.target.cluster)
            endColour = styles.getClusterColour(edge.source.cluster)
        else if edge.target.cluster > edge.source.cluster
            id = edge.source.cluster + "-" + edge.target.cluster
            endColour = styles.getClusterColour(edge.target.cluster)
            startColour = styles.getClusterColour(edge.source.cluster)
            id = "cluster-gradient-" + id
            gradient = defs.append("svg:linearGradient").attr("id", id)
            gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", startColour
            gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", endColour
