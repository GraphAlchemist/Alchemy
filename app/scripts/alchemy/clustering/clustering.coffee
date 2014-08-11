class alchemy.clustering
    constructor: ->
        nodes = alchemy._nodes

        @clusterKey = alchemy.conf.clusterKey
        @identifyClusters()
    
        _charge = -500
        _linkStrength = (edge) ->
            if nodes[edge.source.id].properties[@clusterKey] is nodes[edge.target.id].properties[@clusterKey] then 1 else 1
        _friction = () ->
            0.7
        _linkDistancefn = (edge) ->
            nodes = alchemy._nodes
            if nodes[edge.source.id].properties.root or nodes[edge.target.id].properties.root
                300
            else if nodes[edge.source.id].properties[@clusterKey] is nodes[edge.target.id].properties[@clusterKey]
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

    identifyClusters: ->
        nodes = alchemy._nodes
        clusters = _.uniq _.map(_.values(nodes), (node)-> node.properties["#{alchemy.conf.clusterKey}"])
        @clusterMap = _.zipObject clusters, [0..clusters.length]
    
    getClusterColour: (clusterValue) ->
        # Modulo reuses colors if not enough are supplied
        index = @clusterMap[clusterValue] % alchemy.conf.clusterColours.length
        alchemy.conf.clusterColours[index]

    edgeGradient: (edges) ->
        defs = d3.select("#{alchemy.conf.divSelector} svg")
        Q = {}
        nodes = alchemy._nodes
        for edge in _.map(edges, (edge) -> edge._d3)
            # skip root
            continue if nodes[edge.source.id].properties.root or nodes[edge.target.id].properties.root
            # skip nodes from the same cluster
            continue if nodes[edge.source.id].properties[@clusterKey] is nodes[edge.target.id].properties[@clusterKey]
            if nodes[edge.target.id].properties[@clusterKey] isnt nodes[edge.source.id].properties[@clusterKey]
                id = nodes[edge.source.id].properties[@clusterKey] + "-" + nodes[edge.target.id].properties[@clusterKey]
                if id of Q
                    continue
                else if id not of Q
                    startColour = @getClusterColour(nodes[edge.target.id].properties[@clusterKey])
                    endColour = @getClusterColour(nodes[edge.source.id].properties[@clusterKey])
                    Q[id] = {'startColour': startColour,'endColour': endColour}
        for ids of Q
            gradient_id = "cluster-gradient-" + ids
            gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
            gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
            gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']
    
