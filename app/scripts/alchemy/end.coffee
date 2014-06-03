alchemy.begin = () ->
    if typeof alchemy.conf.dataSource == 'string'
        d3.json(alchemy.conf.dataSource, alchemy.startGraph)
    else if typeof alchemy.conf.dataSource == 'object'
        alchemy.startGraph(alchemy.conf.dataSource)
        