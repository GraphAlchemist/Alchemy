class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)
        @_d3 = {
            'id': node.id
        }
        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        conf = alchemy.conf
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)