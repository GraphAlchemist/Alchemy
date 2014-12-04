    Alchemy::Edge = (instance)->
        class Edge
            # takes an edge property map from GraphJSON
            # as well as an index, which is the position of the edge map in
            # the array of edges stored in @a._edges at each "source-target"
            # this is used to create the id for the individual node which will be "source-target-index"
            # e.g. 1-0-1
            constructor: (edge, index=null) ->
                @a = instance
                conf = @a.conf

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
                    'source': @a._nodes[@_properties.source]._d3
                    'target': @a._nodes[@_properties.target]._d3
                    'self': @
                    , @a.svgStyles.edge.populate @
                
                @_setCaption(edge, conf)
                # Add id to source/target's edgelist
                @a._nodes["#{edge.source}"]._addEdge @
                @a._nodes["#{edge.target}"]._addEdge @

            _setD3Properties: (props) => _.merge @_d3, props

            _setID: (e) => if e.id? then e.id else "#{e.source}-#{e.target}"

            _setCaption: (edge, conf) ->
                cap = conf.edgeCaption
                edgeCaption = do (edge) ->
                    switch typeof cap
                        when ('string' or 'number') then edge[cap]
                        when 'function' then cap(edge)
                if edgeCaption
                    @_d3.caption = edgeCaption

            _setEdgeType: ->
                conf = @a.conf
                if conf.edgeTypes
                    if _.isPlainObject conf.edgeTypes
                        lookup = Object.keys @a.conf.edgeTypes
                        edgeType = @_properties[lookup]
                    else if _.isArray conf.edgeTypes
                        edgeType = @_properties["caption"]
                    else if typeof conf.edgeTypes is 'string'
                        edgeType = @_properties[conf.edgeTypes]
                if edgeType is undefined then edgeType = "all"
                @_setD3Properties 'edgeType', edgeType
                edgeType

            getProperties: (key=null, keys...) =>
                if not key? and (keys.length is 0)
                    @_properties
                else if keys.length isnt 0
                    query = _.union [key], keys
                    _.pick @_properties, query
                else
                    @_properties[key]

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

            getStyles: (key, keys...) =>
                edge = @
                return edge._style if key is undefined
                _.map arguments, (arg)-> edge._style[arg]

            setProperties: (property, value=null) =>
                if _.isPlainObject property
                    _.assign @_properties, property
                    if 'source' of property then @_setD3Properties {'source': @a._nodes[property.source]._d3}
                    if 'target' of property then @_setD3Properties {'target': @a._nodes[property.target]._d3}
                else
                    @_properties[property] = value
                    if (property is 'source') or (property is 'target')
                        @_setD3Properties {property: @a._nodes[value]._d3}
                @

            setStyles: (key, value=null) ->
                # If undefined, set styles based on state
                if key is undefined
                    key = @a.svgStyles.edge.populate @

                # takes a key, value or map of key values
                # the user passes a map of styles to set multiple styles at once
                else if _.isPlainObject key
                    _.assign @_style, key
                else
                    @_style[key] = value

                @_setD3Properties @a.svgStyles.edge.update(@)
                @a._drawEdges.updateEdge @_d3
                @

            toggleHidden: ()->
                @._state = if @._state is "hidden" then "active" else "hidden"
                @.setStyles()

            allNodesActive: () =>
                sourceId = @_properties.source
                targetId = @_properties.target
                sourceNode = alchemy.get.nodes(sourceId)[0]
                targetNode = alchemy.get.nodes(targetId)[0]
                sourceNode._state is "active" and targetNode._state is "active"

            remove: ->
                edge = @
                delete @a._edges[edge.id]

                if @a._nodes[edge._properties.source]?
                    _.remove @a._nodes[edge._properties.source]._adjacentEdges, (e) -> e if e.id is edge.id
                if @a._nodes[edge._properties.target]?
                    _.remove @a._nodes[edge._properties.target]._adjacentEdges, (e) -> e if e.id is edge.id
                @a.vis.select("#edge-" + edge.id + "-" + edge._index).remove()
                filteredLinkList = _.filter @a.force.links(), (link) -> link if link.id != edge.id
                @a.force.links(filteredLinkList)
