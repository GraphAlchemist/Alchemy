class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        @_d3 = {}
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)

    # Stores edge.id for easy edge lookup
    edges: []
    addEdge: (edge)-> @edges.push(edge)

    # Neighbors
    neighbors: ()->
        regex = new RegExp("[(#{@id}#{'\\'}-)(#{'\\'}-#{@id})]","g")
        _.map @edges, (edgeID)->  edgeID.replace(regex, "")