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
            alchemy.stats.update()

        nodeStats: () ->
            #general node stats
            nodeStats = ''
            nodeData = []

            allNodes = alchemy.get.allNodes().length
            activeNodes = alchemy.get.activeNodes().length
            inactiveNodes = allNodes - activeNodes

            nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of nodes: <span class='badge'>#{allNodes}</span></li>"            
            nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of active nodes: <span class='badge'>#{activeNodes}</span></li>"
            nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of inactive nodes: <span class='badge'>#{inactiveNodes}</span></li>"

            #add stats for all node types
            if alchemy.conf.nodeTypes
                nodeKeys = Object.keys(alchemy.conf.nodeTypes)
                nodeTypes = ''
                for nodeType in alchemy.conf.nodeTypes[nodeKeys]
                    caption = nodeType.replace('_', ' ')
                    nodeNum = alchemy.vis.selectAll("g.node.#{nodeType}")[0].length
                    nodeTypes += "<li class = 'list-group-item nodeType' id='li-#{nodeType}' 
                                    name = #{caption}>Number of <strong style='text-transform: uppercase'>#{caption}</strong> nodes: <span class='badge'>#{nodeNum}</span></li>"
                    nodeData.push(["#{nodeType}", nodeNum])
                nodeStats += nodeTypes

            #add the graph
            nodeGraph = "<li id='node-stats-graph' class='list-group-item'></li>" 
            nodeStats += nodeGraph
            alchemy.dash
                   .select '#node-stats'
                   .html nodeStats
            @insertSVG "node", nodeData

        edgeStats: () ->
            #general edge stats
            edgeData = null
            edgeNum = alchemy.vis.selectAll(".edge")[0].length
            activeEdges = alchemy.vis.selectAll(".edge.active")[0].length
            inactiveEdges = alchemy.vis.selectAll(".edge.inactive")[0].length

            edgeGraph = "<li class = 'list-group-item gen_edge_stat'>Number of relationships: <span class='badge'>#{edgeNum}</span></li>
                        <li class = 'list-group-item gen_edge_stat'>Number of active relationships: <span class='badge'>#{activeEdges}</span></li>
                        <li class = 'list-group-item gen_edge_stat'>Number of inactive relationships: <span class='badge'>#{inactiveEdges}</span></li>
                        <li id='edge-stats-graph' class='list-group-item'></li>"

            #add stats for edge types
            if alchemy.conf.edgeTypes
                edgeData = []
                for e in alchemy.vis.selectAll(".edge")[0]
                    alchemy.currentRelationshipTypes[[e].caption] = true

                for edgeType in alchemy.conf.edgeTypes
                    if not edgeType then continue
                    caption = edgeType.replace('_', ' ')
                    edgeNum = alchemy.vis.selectAll(".edge.#{edgeType}")[0].length
                    edgeData.push(["#{caption}", edgeNum])

            alchemy.dash
                   .select '#rel-stats'
                   .html edgeGraph 
            alchemy.stats.insertSVG "edge", edgeData
            return edgeData

        insertSVG: (element, data) ->
            if data is null 
                alchemy.dash
                       .select "##{element}-stats-graph"
                       .html "<br><h4 class='no-data'>There are no #{element}Types listed in your conf.</h4>"
            else
                width = alchemy.conf.graphWidth() * .25
                height = 250
                radius = width / 4
                color = d3.scale.category20()

                arc = d3.svg.arc()
                    .outerRadius(radius - 10)
                    .innerRadius(radius/2)

                pie = d3.layout.pie()
                    .sort(null)
                    .value((d) -> d[1])

                svg = alchemy.dash
                             .select "##{element}-stats-graph"
                             .append "svg"
                             .append "g"
                             .style {"width": width, "height":height}
                             .attr "transform", "translate(" + width/2 + "," + height/2 + ")"

                arcs = svg.selectAll ".arc"
                    .data pie(data)
                    .enter()
                    .append "g"
                    .classed "arc", true
                    .on "mouseover", (d,i) -> 
                        alchemy.dash
                          .select "##{data[i][0]}-stat"
                          .classed "hidden", false
                    .on "mouseout", (d,i) -> 
                        alchemy.dash
                          .select "##{data[i][0]}-stat"
                          .classed "hidden", true

                arcs.append "path"
                    .attr "d", arc
                    .attr "stroke", (d, i) -> color(i)
                    .attr "stroke-width", 2
                    .attr "fill-opacity", "0.3"

                arcs.append "text"
                    .attr "transform", (d) -> "translate(" + arc.centroid(d) + ")"
                    .attr "id", (d, i)-> "#{data[i][0]}-stat"
                    .attr "dy", ".35em"
                    .classed "hidden", true
                    .text (d, i) -> data[i][0]

        update: () -> 
            if alchemy.conf.nodeStats then alchemy.stats.nodeStats()
            if alchemy.conf.edgeStats then alchemy.stats.edgeStats()