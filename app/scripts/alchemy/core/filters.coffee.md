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
    Alchemy::filters = (instance)=>
        a = instance
        init: () ->
            a.filters.show()

            if a.conf.edgeFilters then a.filters.showEdgeFilters()
            if a.conf.nodeFilters then a.filters.showNodeFilters()
            #generate filter forms
            if a.conf.nodeTypes
                nodeKey = Object.keys a.conf.nodeTypes

                nodeTypes = ''
                for nodeType in a.conf.nodeTypes[nodeKey]
                    # Create Filter list element
                    caption = nodeType.replace '_', ' '
                    nodeTypes += "<li class='list-group-item nodeType' role='menuitem' id='li-#{nodeType}' name=#{nodeType}>#{caption}</li>"
                a.dash.select '#node-dropdown'
                       .html nodeTypes

            if a.conf.edgeTypes
                if _.isPlainObject a.conf.edgeTypes
                    types = _.values(a.conf.edgeTypes)[0]
                else
                    types = a.conf.edgeTypes

                edgeTypes = ''
                for edgeType in types
                    # Create Filter list element
                    caption = edgeType.replace '_', ' '
                    edgeTypes += "<li class='list-group-item edgeType' role='menuitem' id='li-#{edgeType}' name=#{edgeType}>#{caption}</li>"
                a.dash.select '#rel-dropdown'
                       .html edgeTypes

            if a.conf.captionsToggle then a.filters.captionsToggle()
            if a.conf.edgesToggle then a.filters.edgesToggle()
            if a.conf.nodesToggle then a.filters.nodesToggle()
            a.filters.update()

        show: ->
            filter_html = """
                        <div id = "filter-header" data-toggle="collapse" data-target="#filters form">
                            <h3>Filters</h3>
                            <span class = "fa fa-2x fa-caret-right"></span>
                        </div>
                            <form class="form-inline collapse">
                            </form>
                          """
            a.dash.select('#control-dash #filters').html filter_html
            a.dash.selectAll '#filter-header'
                .on 'click', () ->
                    if a.dash.select('#filters>form').classed "in"
                        a.dash.select "#filter-header>span"
                               .attr "class", "fa fa-2x fa-caret-right"
                    else
                        a.dash.select "#filter-header>span"
                               .attr "class", "fa fa-2x fa-caret-down"

            a.dash.select '#filters form'
                   # .submit false

        #create relationship filters
        showEdgeFilters: () ->
            rel_filter_html = """
                            <div id="filter-rel-header" data-target = "#rel-dropdown" data-toggle="collapse">
                                <h4>
                                    Edge Types
                                </h4>
                                <span class="fa fa-lg fa-caret-right"></span>
                            </div>
                            <ul id="rel-dropdown" class="collapse list-group" role="menu">
                            </ul>
                               """
            a.dash.select '#filters form'
                   .append "div"
                   .attr "id", "filter-relationships"
                   .html rel_filter_html
            a.dash.select "#filter-rel-header"
                .on 'click', () ->
                    if a.dash.select('#rel-dropdown').classed "in"
                        a.dash.select "#filter-rel-header>span"
                               .attr "class", "fa fa-lg fa-caret-right"
                    else
                        a.dash.select "#filter-rel-header>span"
                               .attr "class", "fa fa-lg fa-caret-down"

        #create node filters
        showNodeFilters: () ->
            node_filter_html = """
                                <div id="filter-node-header" data-target = "#node-dropdown" data-toggle="collapse">
                                    <h4>
                                        Node Types
                                    </h4>
                                    <span class="fa fa-lg fa-caret-right"></span>
                                </div>
                                <ul id="node-dropdown" class="collapse list-group" role="menu">
                                </ul>
                               """
            a.dash.select '#filters form'
                   .append "div"
                   .attr "id", "filter-nodes"
                   .html node_filter_html
            a.dash.select "#filter-node-header"
                .on 'click', () ->
                    if a.dash.select('#node-dropdown').classed "in"
                        a.dash.select "#filter-node-header>span"
                               .attr "class", "fa fa-lg fa-caret-right"
                    else
                        a.dash.select "#filter-node-header>span"
                               .attr "class", "fa fa-lg fa-caret-down"

        #create captions toggle
        captionsToggle: () ->
            a.dash.select "#filters form"
              .append "li"
              .attr {"id":"toggle-captions","class":"list-group-item active-label toggle"}
              .html "Show Captions"
              .on "click", ->
                isDisplayed = a.dash.select("g text").attr("style")

                if isDisplayed is "display: block" || null
                    a.dash.selectAll "g text"
                           .attr "style", "display: none"
                else
                    a.dash.selectAll "g text"
                           .attr "style", "display: block"

        #create edges toggle
        edgesToggle: () ->
            a.dash.select "#filters form"
              .append "li"
              .attr {"id":"toggle-edges","class":"list-group-item active-label toggle"}
              .html "Toggle Edges"
              .on "click", ->
                  if _.contains(_.pluck(_.flatten(_.values(a._edges)), "_state"), "active")
                    _.each _.values(a._edges), (edges)->
                        _.each edges, (e)-> if e._state is "active" then e.toggleHidden()
                  else
                    _.each _.values(a._edges), (edges)->
                        _.each edges, (e)->
                            source = a._nodes[e._properties.source]
                            target = a._nodes[e._properties.target]
                            if source._state is "active" and target._state is "active"
                              e.toggleHidden()

        #create nodes toggle
        nodesToggle: () ->
            a.dash.select "#filters form"
                .append "li"
                .attr {"id":"toggle-nodes","class":"list-group-item active-label toggle"}
                .html "Toggle Nodes"
                .on "click", ->
                    nodes = _.values(a._nodes)
                    if _.contains _.pluck(nodes, "_state"), "active"
                        _.each nodes, (n)->
                            if a.conf.toggleRootNodes and n._d3.root then return
                            if n._state is "active" then n.toggleHidden()
                    else
                        _.each _.values(a._nodes), (n)->
                            if a.conf.toggleRootNodes and n._d3.root then return
                            n.toggleHidden()

        #update filters
        update: () ->
            a.dash.selectAll ".nodeType, .edgeType"
                .on "click", () ->
                    element = d3.select this
                    tag = element.attr "name"
                    a.vis.selectAll ".#{tag}"
                        .each (d)->
                            if a._nodes[d.id]?
                                node = a._nodes[d.id]
                                node.toggleHidden()
                            else
                                edge = a._edges[d.id][0]
                                source = a._nodes[edge._properties.source]
                                target = a._nodes[edge._properties.target]
                                if source._state is "active" and target._state is "active"
                                    edge.toggleHidden()
                    a.stats.nodeStats()
