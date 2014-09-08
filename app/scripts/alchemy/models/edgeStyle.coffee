class alchemy.models.EdgeStyle
    constructor: (edge, data) ->
        conf = alchemy.conf

        caption = conf.edgeCaption
        @edgeCaption = (edge) -> switch typeof caption
            when ('string' or 'number') then edge[caption]
            when 'function' then caption(edge)

        alchemy.svgStyleTranslator.edge.populate(edge) if conf.renderer is "svg"