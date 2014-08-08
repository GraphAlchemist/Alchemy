class alchemy.models.Edge
    constructor: (edge) ->
        # Merge undefined edgeStyle keys from conf.
        # Works with undefined @edgeStyle
        conf = alchemy.conf
        @id = if edge.id? then edge.id else "#{edge.source}-#{edge.target}"
        @edgeStyle = _.merge(conf.edgeStyle, @edgeStyle)
        
        # Contains state of edge, used by renderers
        @state = {'active': true} 

        @properties = edge
        @_d3 =
            'id': @id
            'source': alchemy._nodes[@properties.source]._d3,
            'target': alchemy._nodes[@properties.target]._d3

        # Add id to source/target's edgelist
        alchemy._nodes["#{edge.source}"].addEdge @id
        alchemy._nodes["#{edge.target}"].addEdge @id

    toPublic: =>
        keys = _.keys(@properties)
        _.pick(@, keys)

    setProperty: (property, value) =>
        @properties[property] = value

    setD3Property: (property, value) =>
        @_d3[property] = value
        
    # Find if both endpoints are active
    allNodesActive: () =>
        source = d3.select("#node-#{@properties.source}")
        target = d3.select("#node-#{@properties.target}")

        !source.classed("inactive") && !target.classed("inactive")
