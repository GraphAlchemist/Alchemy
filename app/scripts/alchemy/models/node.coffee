class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        @_d3 = {}

        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)

        # Add to node collection
        Node::all.push(@.id)

    # Stores edge.id for easy edge lookup
    edges: []
    addEdge: (edge)-> @edges.push(edge)
    outDegree: ()-> @edges.length

    # Find neighbors
    neighbors: ()->
        regex = new RegExp("[(#{@id}#{'\\'}-)(#{'\\'}-#{@id})]","g")
        _.map @edges, (edgeID)->  edgeID.replace(regex, "")

    # Class properties
    all: []