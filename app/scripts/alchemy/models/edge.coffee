class alchemy.models.Edge
    constructor: (edge) ->
        conf = alchemy.conf

        debugger
        @style = new alchemy.models.EdgeStyle(@, edge)
        @id = if edge.id? then edge.id else "#{edge.source}-#{edge.target}"
        @edgeStyle = _.merge(conf.edgeStyle, @edgeStyle)
        
        # Contains state of edge, used by renderers
        @state = {'active': true}

        # Edge properties, as provided by the user
        @properties = edge
        # @_edgeAttributes = new alchemy.models.EdgeAttributes
        # caption = @_edgeAttributes.edgeCaption(@properties)
        # if caption       
        #     @properties.caption = caption

        @_d3 =
            'id': @id
            'source': alchemy._nodes[@properties.source]._d3
            'target': alchemy._nodes[@properties.target]._d3
            'caption': @style.edgeCaption

        # Add id to source/target's edgelist
        alchemy._nodes["#{edge.source}"].addEdge @id
        alchemy._nodes["#{edge.target}"].addEdge @id

    toPublic: =>
        keys = _.keys(@properties)
        _.pick(@, keys)

    setProperty: (property, value) =>
        @properties[property] = value
        if (property is 'source') or (property is 'target')
            # add properties to d3 internals
            @setD3Property(property, alchemy._nodes[value]._d3)
            # update node internals
            #node.addEdge(@id)

    setD3Property: (property, value) =>
        @_d3[property] = value
    
    getProperties: () =>
        @properties

    # Find if both endpoints are active
    allNodesActive: () =>
        source = d3.select("#node-#{@properties.source}")
        target = d3.select("#node-#{@properties.target}")

        !source.classed("inactive") && !target.classed("inactive")