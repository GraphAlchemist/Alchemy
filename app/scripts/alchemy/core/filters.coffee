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
alchemy.filters = 
    init: () -> 
        alchemy.filters.show()
        
        if alchemy.conf.edgeFilters then alchemy.filters.showEdgeFilters()
        if alchemy.conf.nodeFilters then alchemy.filters.showNodeFilters()
        #generate filter forms
        if alchemy.conf.nodeTypes
            nodeKey = Object.keys(alchemy.conf.nodeTypes)

            nodeTypes = ''
            for nodeType in alchemy.conf.nodeTypes[nodeKey]
                # Add to @state for tracking
                alchemy.state.filters.nodes["#{nodeType}"] = {"active": true}

                # Create Filter list element
                caption = nodeType.replace('_', ' ')
                nodeTypes += "<li class = 'list-group-item nodeType' role = 'menuitem' id='li-#{nodeType}' name = #{nodeType}>#{caption}</li>"
            $('#node-dropdown').append(nodeTypes)

        if alchemy.conf.edgeTypes
            for e in d3.selectAll(".edge")[0]
                currentRelationshipTypes[[e].caption] = true

            edgeTypes = ''
            for edgeType in alchemy.conf.edgeTypes
                # Add to @state for tracking
                alchemy.state.filters.edges["#{edgeType}"] = {"active": true}

                # Create Filter list element
                caption = edgeType.replace('_', ' ')
                edgeTypes += "<li class = 'list-group-item edgeType' role = 'menuitem' id='li-#{edgeType}' name = #{edgeType}>#{caption}</li>"
            $('#rel-dropdown').append(edgeTypes)
        
        if alchemy.conf.captionsToggle then alchemy.filters.captionsToggle()
        if alchemy.conf.edgesToggle then alchemy.filters.edgesToggle()
        if alchemy.conf.nodesToggle then alchemy.filters.nodesToggle()
        alchemy.filters.update()

    show: () ->
        filter_html = """
                    <div id = "filter-header" data-toggle="collapse" data-target="#filters form">
                        <h3>Filters</h3>
                        <span class = "fa fa-2x fa-caret-right"></span>
                    </div>
                        <form class="form-inline collapse">
                        </form>
                      """
        d3.select('#control-dash #filters').html(filter_html)
        d3.selectAll('#filter-header')
            .on('click', () ->
                if d3.select('#filters>form').classed("in")
                    d3.select("#filter-header>span").attr("class", "fa fa-2x fa-caret-right")
                else d3.select("#filter-header>span").attr("class", "fa fa-2x fa-caret-down")
            )
        $('#filters form').submit(false)

    #create relationship filters
    showEdgeFilters: () ->
        rel_filter_html = """
                           <div id="filter-relationships">
                                <div id="filter-rel-header" data-target = "#rel-dropdown" data-toggle="collapse">
                                    <h4>
                                        Edge Types
                                    </h4>
                                    <span class="fa fa-lg fa-caret-right"></span>
                                </div>
                                <ul id="rel-dropdown" class="collapse list-group" role="menu">
                                </ul>
                           </div>

                           """
        $('#filters form').append(rel_filter_html)
        d3.select("#filter-rel-header")    
            .on('click', () ->
                if d3.select('#rel-dropdown').classed("in")
                    d3.select("#filter-rel-header>span").attr("class", "fa fa-lg fa-caret-right")
                else d3.select("#filter-rel-header>span").attr("class", "fa fa-lg fa-caret-down")
            )

    #create node filters
    showNodeFilters: () ->
        node_filter_html = """
                            <div id="filter-nodes">
                                <div id="filter-node-header" data-target = "#node-dropdown" data-toggle="collapse">
                                    <h4>
                                        Node Types
                                    </h4>
                                    <span class="fa fa-lg fa-caret-right"></span>
                                </div>
                                <ul id="node-dropdown" class="collapse list-group" role="menu">
                                </ul>
                           </div>
                           """
        $('#filters form').append(node_filter_html)
        d3.select("#filter-node-header")    
            .on('click', () ->
                if d3.select('#node-dropdown').classed("in")
                    d3.select("#filter-node-header>span").attr("class", "fa fa-lg fa-caret-right")
                else d3.select("#filter-node-header>span").attr("class", "fa fa-lg fa-caret-down")
            )

    #create captions toggle
    captionsToggle: () ->
        d3.select("#filters form")
          .append("li")
          .attr({"id":"toggle-captions","class":"list-group-item active-label toggle"})
          .html("Show Captions")
          .on("click", ->
            isDisplayed = d3.select("g text").attr("style")

            if isDisplayed == "display: block" || null
                d3.selectAll("g text").attr("style", "display: none")
            else
                d3.selectAll("g text").attr("style", "display: block")
            )

    #create edges toggle
    edgesToggle: () ->
        d3.select("#filters form")
          .append("li")
          .attr({"id":"toggle-edges","class":"list-group-item active-label toggle"})
          .html("Toggle Edges")
          .on("click", ->
            if d3.selectAll(".edge.hidden")[0].length == 0
                d3.selectAll(".edge")
                  .classed("hidden", true)
            else
                d3.selectAll(".edge")
                  .classed("hidden", false)
            )

    #create nodes toggle
    nodesToggle: () ->
        d3.select("#filters form")
          .append("li")
          .attr({"id":"toggle-nodes","class":"list-group-item active-label toggle"})
          .html("Toggle Nodes")
          .on("click", ->

            affectedNodes = if alchemy.conf.toggleRootNodes then ".node,.edge" else ".node:not(.root),.edge"

            if d3.selectAll(".node.hidden")[0].length == 0
                d3.selectAll(affectedNodes)
                  .classed("hidden", true)
            else
                d3.selectAll(affectedNodes)
                  .classed("hidden", false)
            )

    #update filters
    update: () ->
        identifyFilter = (element) ->
            tag = element.attr("name")
            isDisabled = !element.classed("disabled")
            filterType = if element.classed("nodeType") then "nodes" else "edges"
            [tag, filterType, isDisabled]

        reFilter = (tag, filterType, isDisabled, highlight) ->
            # Stop running if during graph initialization
            if typeof tag == "object" then return

            elements = d3.selectAll(".#{tag}")
            elements.classed({"inactive": isDisabled, "highlight": highlight})

            if filterType == "nodes"
                for node in elements.data()
                    for edge in alchemy._nodes[node.id].adjacentEdges
                        edgeData = alchemy._edges[edge]

                        # If either node is disabled then the edge is inactive
                        if !edgeData.allNodesActive() then isDisabled = true

                        d3.select("[source-target='#{edge}']")
                          .classed({"inactive": isDisabled, "highlight": highlight})
            if filterType == "edges"
                elements.classed({"inactive": (d, i)-> 
                    allNodesActive = alchemy._edges[d.id].allNodesActive()
                    isDisabled || !allNodesActive
                })
            #update stats
            alchemy.stats.update()

        # filter previews
        d3.selectAll(".nodeType, .edgeType")
            .on "mouseenter", () ->
                element = d3.select(this)
                [tag, filterType, isDisabled] = identifyFilter(element)

                d3.selectAll(".#{tag}").classed("highlight", true)

            .on "mouseleave", () ->
                element = d3.select(this)
                [tag, filterType, isDisabled] = identifyFilter(element)

                d3.selectAll(".#{tag}").classed("highlight", false)

            .on "click", () ->
                element = d3.select(this)
                [tag, filterType, isDisabled] = identifyFilter(element)
                highlight = false

                #toggle disabled class
                element.classed({'disabled': isDisabled})
                reFilter(tag, filterType, isDisabled, highlight)