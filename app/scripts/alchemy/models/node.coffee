class alchemy.models.Node
    constructor: (node) ->
        _.merge(@, node)

        conf = alchemy.conf

        # Merge undefined nodeStyle keys from conf.
        # Works with undefined @nodeStyle
        @nodeStyle = _.merge(conf.nodeStyle, @nodeStyle)