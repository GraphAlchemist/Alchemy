class alchemy.models.EdgeAttributes
    constructor: ->
        conf = alchemy.conf
        caption = conf.edgeCaption
        if typeof caption is ('string' or 'number')
            @edgeCaption = (edge) -> edge[caption]
        else if typeof caption is 'function'
            @edgeCaption = (edge) -> caption(edge)