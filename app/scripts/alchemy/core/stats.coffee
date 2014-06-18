alchemy.stats = 
    init: () -> 
        if conf.showStats is true
            alchemy.stats.show()
            alchemy.stats.update()
            alchemy.stats.insertSVG()
    show: () -> 
        stats_html = """
                        <h3 data-toggle="collapse" data-target="#stats #all-stats">
                            Statistics
                            <span class = "fa fa-caret-right"></span>
                        </h3>
                        <div id="all-stats" class="collapse">
                            <ul class = "list-group" id="node-stats"></ul>
                            <ul class = "list-group" id="rel-stats"></ul>  
                    """
        d3.select('#stats').html(stats_html)
        d3.select('#stats>h3')
            .on('click', () ->
                if d3.select('#all-stats').classed("in")
                    d3.select("#stats>h3").html("Statistics<span class = 'fa fa-caret-right'></span>")
                else d3.select("#stats>h3").html("Statistics<span class = 'fa fa-caret-down'></span>")
            )

    nodeStats: () ->
        #general node stats
        nodeStats = ''
        nodeNum = d3.selectAll(".node")[0].length
        activeNodes = d3.selectAll(".node.active")[0].length
        inactiveNodes = d3.selectAll(".node.inactive")[0].length
        nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of nodes: <span class='badge'>#{nodeNum}</span></li>"            
        nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of active nodes: <span class='badge'>#{activeNodes}</span></li>"
        nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of inactive nodes: <span class='badge'>#{inactiveNodes}</span></li>"

        #add stats for all node types
        if conf.nodeTypes
            nodeKey = Object.keys(conf.nodeTypes)
            nodeTypes = ''
            for nodeType in conf.nodeTypes[nodeKey]
                # if not currentNodeTypes[t] then continue
                caption = nodeType.replace('_', ' ')
                nodeNum = d3.selectAll("g.node.#{nodeType}")[0].length
                nodeTypes += "<li class = 'list-group-item nodeType' id='li-#{nodeType}' 
                                name = #{caption}>Number of nodes of type #{caption}: <span class='badge'>#{nodeNum}</span></li>"
            nodeStats += nodeTypes

        #add the graph
        nodeGraph = "<li id='node-stats-graph' class='list-group-item'></li>" 

        nodeStats += nodeGraph
        
        $('#node-stats').html(nodeStats)

    edgeStats: () ->
        #general edge stats
        edgeStats = ''
        edgeNum = d3.selectAll(".edge")[0].length
        activeEdges = d3.selectAll(".edge.active")[0].length
        inactiveEdges = d3.selectAll(".edge.inactive")[0].length
        edgeStats += "<li class = 'list-group-item gen_edge_stat'>Number of relationships: <span class='badge'>#{edgeNum}</span></li>"            
        edgeStats += "<li class = 'list-group-item gen_edge_stat'>Number of active relationships: <span class='badge'>#{activeEdges}</span></li>"
        edgeStats += "<li class = 'list-group-item gen_edge_stat'>Number of inactive relationships: <span class='badge'>#{inactiveEdges}</span></li>"

        #add stats for edge types
        if conf.edgeTypes
            for e in d3.selectAll(".edge")[0]
                currentRelationshipTypes[[e].caption] = true

            edgeTypes = ''
            for edgeType in conf.edgeTypes
                if not edgeType then continue
                caption = edgeType.replace('_', ' ')
                edgeNum = d3.selectAll(".edge.#{edgeType}")[0].length
                edgeTypes += "<li class = 'edgeType list-group-item' id='li-#{edgeType}' name = #{caption}>Number of relationships of type #{caption}: <span class='badge'>#{edgeNum}</span></li>"
            $('#rel-stats').html(edgeTypes)
            edgeStats += edgeTypes

        $('#rel-stats').html(edgeStats)

    insertSVG: () ->
        width = conf.graphWidth * .25
        height = 250
        radius = width / 2
        arc = d3.svg.arc()
            .outerRadius(radius - 10)
            .innerRadius(0)

        pie = d3.layout.pie()
            .sort(null)
            .value(() -> 10)

        svg = d3.select("#node-stats-graph")
            .append("svg")
            .attr("style", "width:#{width}px; height:#{height}px")
            .append("g")
            # .attr("transform", "translate(" + width / 2 + "," + 100 + "%)")


    update: () -> 
        if conf.nodeStats is true
            alchemy.stats.nodeStats()
        if conf.edgeStats is true
            alchemy.stats.edgeStats()
