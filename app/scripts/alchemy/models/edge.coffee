class alchemy.models.Edge
    constructor: (edge) ->
        _.merge(@, edge)
        # @_id = _.uniqueID("edge_")
        # Merge undefined edgeStyle keys from conf.
        # Works with undefined @edgeStyle
        conf = alchemy.conf
        @edgeStyle = _.merge(conf.edgeStyle, @edgeStyle)
        @classes = {'active': true} #assign active class to edges by default
        @_rawEdge = edge
        @_d3 = {
            'id': edge.id
            'source': @source,
            'target': @target,
            }

    toPublic: =>
        keys = _.keys(@_rawEdge)
        _.pick(@, keys)

    setProperty: (property, value) =>
        @[property] = value
        # @_rawEdge[property] = value

    setD3Property: (property, value) =>
        @_d3[property] = value
        