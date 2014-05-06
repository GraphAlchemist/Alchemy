alchemy.begin = () ->
    if typeof alchemy.conf.dataSource == 'string'
        d3.json(alchemy.conf.dataSource, startGraph)
    else if typeof alchemy.conf.dataSource == 'object'
        startGraph(alchemy.conf.dataSource)
        