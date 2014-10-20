    class alchemy.models.Edge
        # takes an edge property map from GraphJSON
        # as well as an index, which is the position of the edge map in
        # the array of edges stored in alchemy._edges at each "source-target"
        # this is used to create the id for the individual node which will be "source-target-index"
        # e.g. 1-0-1
        constructor: (edge, index=null) ->
            a = alchemy
            conf = a.conf

            @id = @_setID edge
            @_index = index
            @_state = "active"
            @_properties = edge
            @_edgeType = @_setEdgeType()
            @_style =
                if conf.edgeStyle[@_edgeType]?
                    _.merge _.clone(conf.edgeStyle["all"]), conf.edgeStyle[@_edgeType]
                else
                    _.clone conf.edgeStyle["all"]
            @_d3 = _.merge
                'id': @id
                'pos': @_index
                'edgeType': @_edgeType
                'source': a._nodes[@_properties.source]._d3
                'target': a._nodes[@_properties.target]._d3
                , a.svgStyles.edge.populate @
            @_setCaption(edge, conf)
            # Add id to source/target's edgelist
            a._nodes["#{edge.source}"]._addEdge "#{@id}-#{@_index}"
            a._nodes["#{edge.target}"]._addEdge "#{@id}-#{@_index}"

        _setD3Properties: (props) => _.merge @_d3, props
        _setID: (e) => if e.id? then e.id else "#{e.source}-#{e.target}"

        _setCaption: (edge, conf) =>
            cap = conf.edgeCaption
            edgeCaption = do (edge) ->
                switch typeof cap
                    when ('string' or 'number') then edge[cap]
                    when 'function' then cap(edge)
            if edgeCaption
                @_d3.caption = edgeCaption
        _setEdgeType: ->
            conf = alchemy.conf
            if conf.edgeTypes
                if _.isPlainObject conf.edgeTypes
                    lookup = Object.keys alchemy.conf.edgeTypes
                    edgeType = @_properties[lookup]
                else if _.isArray conf.edgeTypes
                    edgeType = @_properties["caption"]
                else if typeof conf.edgeTypes is 'string'
                    edgeType = @_properties[conf.edgeTypes]
            if edgeType is undefined then edgeType = "all"
            @_setD3Properties 'edgeType', edgeType
            edgeType

        setProperties: (property, value=null) =>
            if _.isPlainObject property
                _.assign @_properties, property
                if 'source' of property then @_setD3Properties {'source': alchemy._nodes[property.source]._d3}
                if 'target' of property then @_setD3Properties {'target': alchemy._nodes[property.target]._d3}
            else
                @_properties[property] = value
                if (property is 'source') or (property is 'target')
                    @_setD3Properties {property: alchemy._nodes[value]._d3}
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
        getStyles: (key=null) =>
            if key?
                @_style[key]
            else
                @_style

        setStyles: (key, value=null) ->
            # If undefined, set styles based on state
            if key is undefined
                key = alchemy.svgStyles.edge.populate @

            # takes a key, value or map of key values
            # the user passes a map of styles to set multiple styles at once
            if _.isPlainObject key
                _.assign @_style, key
            else if typeof key is "string"
                @_style[key] = value

            @_setD3Properties alchemy.svgStyles.edge.update(@)
            alchemy._drawEdges.updateEdge @_d3
            @

        toggleHidden: ()->
            @._state = if @._state is "hidden" then "active" else "hidden"
            @.setStyles()

        # Find if both endpoints are active
        # there are probably better ways to do this
        allNodesActive: () =>
            source = alchemy.vis.select "#node-#{@properties.source}"
            target = alchemy.vis.select "#node-#{@properties.target}"

            !source.classed("inactive") && !target.classed("inactive")
