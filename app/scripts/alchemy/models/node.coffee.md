    Alchemy::Node = (instance)->
        class Node
            constructor: (node) ->
                @a = instance
                conf = @a.conf

                @id = node.id
                @_properties = node
                @_d3 = _.merge
                    'id': @id
                    'root': @_properties[conf.rootNodes]
                    'self': @
                    , @a.svgStyles.node.populate @
                @_nodeType = @_setNodeType()
                @_style =
                    if conf.nodeStyle[@_nodeType]
                        conf.nodeStyle[@_nodeType]
                    else
                        conf.nodeStyle["all"]
                @_state = "active"

                @_adjacentEdges = []

            # internal methods
            _setNodeType: =>
                conf = @a.conf
                if conf.nodeTypes
                    if _.isPlainObject conf.nodeTypes
                        lookup = Object.keys @a.conf.nodeTypes
                        types = _.values conf.nodeTypes
                        nodeType = @_properties[lookup]
                    else if typeof conf.nodeTypes is 'string'
                        nodeType = @_properties[conf.nodeTypes]
                if nodeType is undefined then nodeType = "all"
                @_setD3Properties 'nodeType', nodeType
                nodeType

            _setD3Properties: (props) =>
                _.merge @_d3, props

            _addEdge: (edgeDomID) ->
                # Stores edge.id for easy edge lookup
                @_adjacentEdges = _.union @_adjacentEdges, [edgeDomID]

            # Edit node properties
            getProperties: (key=null, keys...) =>
                if not key? and (keys.length is 0)
                    @_properties
                else if keys.length isnt 0
                    query = _.union [key], keys
                    _.pick @_properties, query
                else
                    @_properties[key]

            setProperty: (property, value=null) =>
                if _.isPlainObject property
                    _.assign @_properties, property
                else
                    @_properties[property] = value
                @

            removeProperty: (property) ->
                delete @_properties[property]
                @


            # Style methods
            getStyles: (key=null) =>
                if key?
                    @_style[key]
                else
                    @_style

            setStyles: (key, value=null) ->
                # If undefined, set styles based on state
                if key is undefined
                    key = @a.svgStyles.node.populate @
                # takes a key, value or map of key values
                # the user passes a map of styles to set multiple styles at once
                else if _.isPlainObject key
                    _.assign @_style, key
                else
                    @_style[key] = value
                @_setD3Properties @a.svgStyles.node.populate @
                @a._drawNodes.updateNode @_d3
                @

            toggleHidden: ->
                a = @a
                @_state = if @_state is "hidden" then "active" else "hidden"
                @setStyles()
                _.each @_adjacentEdges, (id)->
                    [source, target, pos] = id.split("-")
                    e = a._edges["#{source}-#{target}"][pos]
                    sourceState = a._nodes["#{source}"]._state
                    targetState = a._nodes["#{target}"]._state
                    if e._state is "hidden" and (sourceState is "active" and targetState is "active")
                        e.toggleHidden()
                    else if e._state is "active" and (sourceState is "hidden" or targetState is "hidden")
                        e.toggleHidden()

            # Convenience methods
            outDegree: () -> @_adjacentEdges.length