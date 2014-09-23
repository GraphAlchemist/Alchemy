class alchemy.models.Edge
    # takes an edge property map from GraphJSON
    # as well as an index, which is the position of the edge map in
    # the array of edges stored in alchemy._edges at each "source-target"
    # this is used to create the id for the individual node which will be "source-target-index"
    # e.g. 1-0-1
    constructor: (edge, index=null) ->
        conf = alchemy.conf
        
        @id = @_setID edge
        
        @_index = index
        @_state = "active"
        @_properties = edge
        @_style = alchemy.svgStyles.edge.populate @
        @_d3 = 
            'id': @id
            'pos': @_index
            'source': alchemy._nodes[@_properties.source]._d3
            'target': alchemy._nodes[@_properties.target]._d3

        @_setCaption(edge, conf)
        # Add id to source/target's edgelist
        alchemy._nodes["#{edge.source}"]._addEdge "#{@id}-#{@_index}"
        alchemy._nodes["#{edge.target}"]._addEdge "#{@id}-#{@_index}"

    _setD3Properties: (props) => _.assign @_d3, props
    _setID: (e) => if e.id? then e.id else "#{e.source}-#{e.target}"

    _setCaption: (edge, conf) =>
        cap = conf.edgeCaption
        edgeCaption = do (edge) -> 
            switch typeof cap
                when ('string' or 'number') then edge[cap]
                when 'function' then cap(edge)
        if edgeCaption
            @_d3.caption = edgeCaption

    setProperties: (property, value=null) =>
        if _.isPlainObject property
            _.assign @_properties, property
            if 'source' of property then @_setD3Properties {'source': alchemy._nodes[property.source]._d3}
            if 'target' of property then @_setD3Properties {'target': alchemy._nodes[property.target]._d3}
        else
            @_properties[property] = value
            if (property is 'source') or (property is 'target')
                @_setD3Property property, alchemy._nodes[value]._d3
        @

    getProperties: (key=null, keys...) =>
        if not key? and (keys.length is 0)
            @_properties
        else if keys.length isnt 0
            query = _.union [key], keys
            _.pick @_properties, query
        else
            @_properties[key]

    # Style methods
    getStyles: (key=null) => if key? then @_style[key] else @_style
    setStyles: (key, value=null) =>
        # If undefined, set styles based on state
        if key is undefined
            key = alchemy.svgStyles.edge.populate @

        # takes a key, value or map of key values
        # the user passes a map of styles to set multiple styles at once
        if _.isPlainObject key
            value = ""
            _.assign @_style, key
        else
            @_style[key] = value
        @_setD3Properties @_style
        alchemy._drawEdges.updateEdge @_d3
        @
    toggleHidden: ()->
        @._state = if @._state is "active" then "hidden" else "active"
        @.setStyles()

    # Find if both endpoints are active
    # there are probably better ways to do this
    allNodesActive: () =>
        source = d3.select "#node-#{@properties.source}"
        target = d3.select "#node-#{@properties.target}"

        !source.classed("inactive") && !target.classed("inactive")
