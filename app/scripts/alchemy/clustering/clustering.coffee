class alchemy.clustering
    constructor: ->
        nodes = alchemy._nodes
        _charge = -500
        _linkStrength = (edge) ->
            if nodes[edge.source.id].cluster is nodes[edge.target.id].cluster then 1 else 0.1
        _friction = () ->
            0.7
        _linkDistancefn = (edge) ->
            nodes = alchemy._nodes
            if nodes[edge.source.id].root or nodes[edge.target.id].root
                300
            else if node[edge.source.id].cluster is nodes[edge.target.id].cluster
                10
            else 
                600

        @layout = 
            charge: _charge
            linkStrength: (edge) -> _linkStrength(edge)
            friction: () -> _friction()
            linkDistancefn: (edge) -> _linkDistancefn(edge)



    getClusterColour: (index) ->
        if alchemy.conf.clusterColours[index]?
            alchemy.conf.clusterColours[index]
        else
            '#EBECE4'

    edgeGradient: (edges) ->
        defs = d3.select("#{alchemy.conf.divSelector} svg").append("svg:defs")
        Q = {}
        for edge in edges
            # skip root
            continue if edge.source.root or edge.target.root
            # skip nodes from the same cluster
            continue if edge.source.cluster is edge.target.cluster
            if edge.target.cluster isnt edge.source.cluster
                id = edge.source.cluster + "-" + edge.target.cluster
                if id of Q
                    continue
                else if id not of Q
                    startColour = @getClusterColour(edge.target.cluster)
                    endColour = @getClusterColour(edge.source.cluster)
                    Q[id] = {'startColour': startColour,'endColour': endColour}
        for ids of Q
            gradient_id = "cluster-gradient-" + ids
            gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
            gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
            gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']
    