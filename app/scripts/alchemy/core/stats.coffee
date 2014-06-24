# Alchemy.js is a graph drawing application for the web.
# Copyright (C) 2014  GraphAlchemist, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

alchemy.stats = 
    init: () -> 
        if alchemy.conf.showStats is true
            alchemy.stats.show()
            alchemy.stats.update()
    show: () -> 
        stats_html = """
                        <div id = "stats-header" data-toggle="collapse" data-target="#stats #all-stats">
                        <h3>
                            Statistics
                        </h3>
                        <span class = "fa fa-caret-right fa-2x"></span>
                        </div>
                        <div id="all-stats" class="collapse">
                            <ul class = "list-group" id="node-stats"></ul>
                            <ul class = "list-group" id="rel-stats"></ul>  
                    """
        d3.select('#stats').html(stats_html)
        d3.selectAll('#stats-header')
            .on('click', () ->
                if d3.select('#all-stats').classed("in")
                    d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-right")
                else d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-down")
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
        if alchemy.conf.nodeTypes
            nodeKey = Object.keys(alchemy.conf.nodeTypes)
            nodeTypes = ''
            for nodeType in alchemy.conf.nodeTypes[nodeKey]
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
        edgeData = []
        edgeNum = d3.selectAll(".edge")[0].length
        activeEdges = d3.selectAll(".edge.active")[0].length
        inactiveEdges = d3.selectAll(".edge.inactive")[0].length

        edgeGraph = "<li class = 'list-group-item gen_edge_stat'>Number of relationships: <span class='badge'>#{edgeNum}</span></li>
                    <li class = 'list-group-item gen_edge_stat'>Number of active relationships: <span class='badge'>#{activeEdges}</span></li>
                    <li class = 'list-group-item gen_edge_stat'>Number of inactive relationships: <span class='badge'>#{inactiveEdges}</span></li>
                    <li id='edge-stats-graph' class='list-group-item'></li>"

        #add stats for edge types
        if alchemy.conf.edgeTypes
            for e in d3.selectAll(".edge")[0]
                currentRelationshipTypes[[e].caption] = true

            for edgeType in alchemy.conf.edgeTypes
                if not edgeType then continue
                caption = edgeType.replace('_', ' ')
                edgeNum = d3.selectAll(".edge.#{edgeType}")[0].length
                edgeData.push(["#{caption}", edgeNum])

        $('#rel-stats').html(edgeGraph) 
        alchemy.stats.insertSVG("edge", edgeData)
        return edgeData

    nodeStats: () ->
        #general node stats
        nodeData = []
        totalNodes = d3.selectAll(".node")[0].length
        activeNodes = d3.selectAll(".node.active")[0].length
        inactiveNodes = d3.selectAll(".node.inactive")[0].length

        #add stats for all node types
        if alchemy.conf.nodeTypes
            nodeKey = Object.keys(alchemy.conf.nodeTypes)
            for nodeType in alchemy.conf.nodeTypes[nodeKey]
                nodeNum = d3.selectAll("g.node.#{nodeType}")[0].length
                nodeData.push(["#{nodeType}", nodeNum])

        #add the graph
        nodeGraph = "<li class = 'list-group-item gen_node_stat'>Number of nodes: <span class='badge'>#{totalNodes}</span></li>
                    <li class = 'list-group-item gen_node_stat'>Number of active nodes: <span class='badge'>#{activeNodes}</span></li>
                    <li class = 'list-group-item gen_node_stat'>Number of inactive nodes: <span class='badge'>#{inactiveNodes}</span></li>
                    <li id='node-stats-graph' class='list-group-item'></li>" 

        $('#node-stats').html(nodeGraph)
        alchemy.stats.insertSVG("node", nodeData)
        return nodeData

    insertSVG: (element, data) ->
        width = alchemy.conf.graphWidth * .25
        height = 250
        radius = width / 4
        color = d3.scale.category20()

        arc = d3.svg.arc()
            .outerRadius(radius - 10)
            .innerRadius(radius/2)

        pie = d3.layout.pie()
            .sort(null)
            .value((d) -> d[1])

        svg = d3.select("##{element}-stats-graph")
            .append("svg")
            .append("g")
            .style({"width": width, "height":height})
            .attr("transform", "translate(" + width/2 + "," + height/2 + ")")

        arcs = svg.selectAll(".arc")
            .data(pie(data))
            .enter().append("g")
            .attr("class", "arc")

        arcs.append("path")
            .attr("d", arc)
            .attr("stroke", (d, i) -> color(i)) 
            .attr("stroke-width", 2)
            .attr("fill", "none")

        arcs.append("text")
            .attr("transform", (d) -> "translate(" + arc.centroid(d) + ")")
            .attr("dy", ".35em")
            .text((d, i) -> data[i][0])


    update: () -> 
        if alchemy.conf.nodeStats is true
            alchemy.stats.nodeStats()
        if alchemy.conf.edgeStats is true
            alchemy.stats.edgeStats()
