class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        @properties = node
        @_d3 = {}
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)

    getProperties: ->
    	@properties

    setProperty: (property) ->
    	console.log "set property: " + "#{property}"

    removeProperty: (property) ->
    	console.log "remove property: " + "#{property}"