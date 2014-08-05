class alchemy.models.Node
    constructor: (node) ->
        conf = alchemy.conf
        @id = node.id
        @properties = node
        @_d3 = {
            'id': node.id
        }
        
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)
        @adjacentEdges = []
        # Add to node collection
        Node::all.push(@.id)
        # Stores edge.id for easy edge lookup

    # Stores edge.id for easy edge lookup
    addEdge: (edge) ->
        @adjacentEdges.push(edge)
        @adjacentEdges = _.uniq @adjacentEdges
    outDegree: () -> @adjacentEdges.length

    # Find connected nodes
    neighbors: ()->
        regex = new RegExp("[(#{@id}#{'\\'}-)(#{'\\'}-#{@id})]","g")
        _.map @adjacentEdges, (edgeID)->  edgeID.replace(regex, "")

    # Edit Node
    getProperties: =>
    	@properties
    setProperty: (property, value) =>
    	@properties[property] = value
    setD3Property: (property, value) =>
    	@_d3[property] = value
    removeProperty: (property) =>
    	if @properties.property?
    		_.omit(@properties, property)

    # Class properties
    all: []
