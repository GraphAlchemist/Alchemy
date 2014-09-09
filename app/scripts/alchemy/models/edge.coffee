class alchemy.models.Edge
    # takes an edge property map from GraphJSON
    # as well as an index, which is the position of the edge map in
    # the array of edges stored in alchemy._edges at each "source-target"
    # this is used to create the id for the individual node which will be "source-target-index"
    # e.g. 1-0-1
    constructor: (edge, index=null) ->
        conf = alchemy.conf
        @id = do ->
            if edge.id? 
                edge.id
            else 
                "#{edge.source}-#{edge.target}"
        
        @_index = index

        # Contains state of edge, used by renderers
        @state = {'active': true}

        # Edge properties, as provided by the user
        @_properties = edge
        @_style = alchemy.svgStyles.edge.populate edge

        caption = conf.edgeCaption
        edgeCaption = do (edge) -> 
            switch typeof caption
                when ('string' or 'number') then edge[caption]
                when 'function' then caption(edge)

        if caption
            @_properties.caption = edgeCaption

        @_d3 =
            'id': @id
            'pos': @_index
            'source': alchemy._nodes[@_properties.source]._d3
            'target': alchemy._nodes[@_properties.target]._d3
            'caption': edgeCaption

        # Add id to source/target's edgelist
        alchemy._nodes["#{edge.source}"]._addEdge @id
        alchemy._nodes["#{edge.target}"]._addEdge @id

    toPublic: =>
        keys = _.keys(@_properties)
        _.pick(@, keys)

    setProperty: (property, value) =>
        @_properties[property] = value
        if (property is 'source') or (property is 'target')
            # add properties to d3 internals
            @setD3Property(property, alchemy._nodes[value]._d3)
            # update node internals
            #node.addEdge(@id)

    setD3Property: (property, value) =>
        @_d3[property] = value

    getProperties: (key=null) =>
        if key?
            @_properties[key]
        else
            @_properties

    # Find if both endpoints are active
    allNodesActive: () =>
        source = d3.select("#node-#{@properties.source}")
        target = d3.select("#node-#{@properties.target}")

        !source.classed("inactive") && !target.classed("inactive")