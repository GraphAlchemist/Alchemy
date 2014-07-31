class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        @properties = node
        @_d3 = {
        }
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)

    getProperties: =>
    	@properties

    setProperty: (property, value) =>
    	@[property] = value
    	@properties[property] = value

    setD3Property: (property, value) =>
    	@_d3[property] = value

    removeProperty: (property) =>
    	if @property?
    		_.omit(@, property)
    	if @properties.property?
    		_.omit(@properties, property)
