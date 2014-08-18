class alchemy.models.Node
    constructor: (node) ->
        conf = alchemy.conf
        nodeAttr = new alchemy.models.NodeAttributes
        radius = nodeAttr.nodeSize(node)
        
        @id = node.id
        @properties = node
        @state = { "active": true }

        @_d3 = {
            'id': node.id,
            'r' : radius
            'stroke-width': nodeAttr.strokeWidth(radius) # should nest 'style' related properties and attributes
            'root': @properties[conf.rootNodes]
        }
        
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)
        @adjacentEdges = []
        # Add to node collection
        Node::all.push(@.id)

        if conf.nodeTypes
            @nodeType = @properties[Object.keys(alchemy.conf.nodeTypes)]
            if @nodeType then @_d3['nodeType'] = @nodeType

   
    addEdge: (edge) ->
         # Stores edge.id for easy edge lookup
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
