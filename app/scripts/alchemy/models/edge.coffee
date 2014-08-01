class alchemy.models.Edge
    constructor: (edge) ->
        _.merge(@, edge)

        # Merge undefined edgeStyle keys from conf.
        # Works with undefined @edgeStyle
        conf = alchemy.conf
        @edgeStyle = _.merge(conf.edgeStyle, @edgeStyle)

        @_rawEdge = edge
        @_d3 = {
            'id': edge.id
            'source': @source,
            'target': @target
            }

        # Add id to source/target's edgelist
        alchemy._nodes[edge.source].addEdge edge.id
        alchemy._nodes[edge.target].addEdge edge.id

    toPublic: =>
        keys = _.keys(@_rawEdge)
        _.pick(@, keys)

    setProperty: (property, value) =>
        @[property] = value
        # @_rawEdge[property] = value

    setD3Property: (property, value) =>
        @_d3[property] = value