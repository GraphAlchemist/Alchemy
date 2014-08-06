class alchemy.clustering
    constructor: ->
        nodes = alchemy._nodes
        _charge = -500
        _linkStrength = (edge) ->
            if nodes[edge.source.id].properties.cluster is nodes[edge.target.id].properties.cluster then 1 else 1
        _friction = () ->
            0.7
        _linkDistancefn = (edge) ->
            nodes = alchemy._nodes
            if nodes[edge.source.id].properties.root or nodes[edge.target.id].properties.root
                300
            else if nodes[edge.source.id].properties.cluster is nodes[edge.target.id].properties.cluster
                10
            else 
                600
        _gravity = (k) -> 8 * k

        @layout = 
            charge: _charge
            linkStrength: (edge) -> _linkStrength(edge)
            friction: () -> _friction()
            linkDistancefn: (edge) -> _linkDistancefn(edge)
            gravity: (k) -> _gravity(k)



    getClusterColour: (index) ->
        if alchemy.conf.clusterColours[index]?
            alchemy.conf.clusterColours[index]
        else
            '#EBECE4'

    edgeGradient: (edges) ->
        defs = d3.select("#{alchemy.conf.divSelector} svg").append("svg:defs")
        Q = {}
        nodes = alchemy._nodes
        for edge in _.map(edges, (edge) -> edge._d3)
            # skip root
            continue if nodes[edge.source.id].properties.root or nodes[edge.target.id].properties.root
            # skip nodes from the same cluster
            continue if nodes[edge.source.id].properties.cluster is nodes[edge.target.id].properties.cluster
            if nodes[edge.target.id].properties.cluster isnt nodes[edge.source.id].properties.cluster
                id = nodes[edge.source.id].properties.cluster + "-" + nodes[edge.target.id].properties.cluster
                if id of Q
                    continue
                else if id not of Q
                    startColour = @getClusterColour(nodes[edge.target.id].properties.cluster)
                    endColour = @getClusterColour(nodes[edge.source.id].properties.cluster)
                    Q[id] = {'startColour': startColour,'endColour': endColour}
        for ids of Q
            gradient_id = "cluster-gradient-" + ids
            gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
            gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
            gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']
    