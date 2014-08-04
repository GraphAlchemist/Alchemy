class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        # Stores edge.id for easy edge lookup
        @edges = []

        @properties = node
        @_d3 = {
            'id': node.id
        }
        @state = { "active": true }
        
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)

        # Add to node collection
        Node::all.push(@.id)

    addEdge: (edge)->
        @edges.push(edge)
        @edges = _.uniq @edges
    outDegree: ()-> @edges.length

    # Find connected nodes
    neighbors: ()->
        regex = new RegExp("[(#{@id}#{'\\'}-)(#{'\\'}-#{@id})]","g")
        _.map @edges, (edgeID)->  edgeID.replace(regex, "")

    # Edit Node
    getProperties: =>
    	@properties
    setProperty: (property, value) =>
    	@[property] = value
    	@properties[property] = value
    setD3Property: (property, value) =>
    	@_d3[property] = value
    removeProperty: (property) =>
    	if @property?
    		_.omit(@, property)
    	if @properties.property?
    		_.omit(@properties, property)

    # Class properties
    all: []
