class alchemy.models.Node
    constructor: (node) ->
        conf = alchemy.conf

        @id = node.id
        @properties = node
        @_style = alchemy.svgStyles.node.populate(@)
        @state = { "active": true }
        @_d3 = # the data packet that is sent to the DOM to be rendered by d3
            _.assign({'id': node.id, 'root': @properties[conf.rootNodes]}, @_style)

        @adjacentEdges = []

        # commented out just in case it breaks something        
        # Add to node collection
        # Node::all.push(@.id)

        if conf.nodeTypes
            @nodeType = @properties[Object.keys(alchemy.conf.nodeTypes)]
            if @nodeType then @_d3['nodeType'] = @nodeType

    addEdge: (edge) ->
        # Stores edge.id for easy edge lookup
        @adjacentEdges.push(edge)
        @adjacentEdges = _.uniq @adjacentEdges
    
    outDegree: () -> @adjacentEdges.length

    # Find connected nodes
    neighbors: () ->
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

    # Style methods
    getStyles: (key=null) =>
        if key?
            @_style[key]
        else
            @_style

    setStyles: (key, value) =>
        @_style[key] = value