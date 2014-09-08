class alchemy.models.Edge
    constructor: (edge) ->
        conf = alchemy.conf
        @id = if edge.id? then edge.id else "#{edge.source}-#{edge.target}"

        # Contains state of edge, used by renderers
        @state = {'active': true}

        # Edge properties, as provided by the user
        @_properties = edge
        @style = alchemy.svgStyleTranslator.edge.populate edge

        caption = conf.edgeCaption
        @edgeCaption = (edge) -> switch typeof caption
            when ('string' or 'number') then edge[caption]
            when 'function' then caption(edge)

        if caption
            @_properties.caption = @edgeCaption

        @_d3 =
            'id': @id
            'source': alchemy._nodes[@_properties.source]._d3
            'target': alchemy._nodes[@_properties.target]._d3
            'caption': @edgeCaption

        # Add id to source/target's edgelist
        alchemy._nodes["#{edge.source}"].addEdge @id
        alchemy._nodes["#{edge.target}"].addEdge @id

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