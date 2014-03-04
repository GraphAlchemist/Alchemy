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
    Q = {}
    for edge in edges
        # skip root
        continue if edge.source.node_type is "root" or edge.target.node_type is "root"
        # skip nodes from the same cluster
        continue if edge.source.cluster is edge.target.cluster
        if edge.target.cluster isnt edge.source.cluster
            # if (edge.source.id or edge.target.id) is "Y3v2tCCCgr"
            #     console.log(this)
            id = edge.source.cluster + "-" + edge.target.cluster
            if id of Q
                continue
            else if id not of Q
                startColour = styles.getClusterColour(edge.target.cluster)
                endColour = styles.getClusterColour(edge.source.cluster)
                Q[id] = {'startColour': startColour,'endColour': endColour}
    for ids of Q
        gradient_id = "cluster-gradient-" + ids
        gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
        gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
        gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']

styles.nodeStandOut = (nodes) ->
