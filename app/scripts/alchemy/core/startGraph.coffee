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

alchemy.startGraph = (data) ->
    if d3.select(alchemy.conf.divSelector).empty()
        console.warn(alchemy.utils.warnings.divWarning())
    
    # see if data is ok
    if not data
        alchemy.utils.warnings.dataWarning()

    # Master Data
    alchemy._nodes = {}
    alchemy._edges = {}

    # create nodes map and update links
    data.nodes.forEach (n) ->
        alchemy._nodes[n.id] = new alchemy.models.Node(n)
    data.edges.forEach (e) ->
        if !e.id? then e.id = "#{e.source}-#{e.target}"
        alchemy._edges[e.id] = new alchemy.models.Edge(e)

    #create SVG
    alchemy.vis = d3.select(alchemy.conf.divSelector)
        .attr("style", "width:#{alchemy.conf.graphWidth()}px; height:#{alchemy.conf.graphHeight()}px")
        .append("svg")
            .attr("xmlns", "http://www.w3.org/2000/svg")
            .attr("pointer-events", "all")
            .on("dblclick.zoom", null)
            .on('click', alchemy.utils.deselectAll)
            .call(alchemy.interactions.zoom(alchemy.conf.scaleExtent))
            .append('g')
                .attr("transform","translate(#{alchemy.conf.initialTranslate}) scale(#{alchemy.conf.initialScale})")

    # force layout constant
    k = Math.sqrt(data.nodes.length / (alchemy.conf.graphWidth() * alchemy.conf.graphHeight()))

    # create layout
    alchemy.force = d3.layout.force()
        .charge(alchemy.layout.charge(k))
        .linkDistance((d) -> alchemy.conf.linkDistance(d,k))
        .theta(1.0)
        .gravity(alchemy.layout.gravity(k))
        .linkStrength(alchemy.layout.linkStrength)
        .friction(alchemy.layout.friction())
        .chargeDistance(alchemy.layout.chargeDistance())
        .size([alchemy.conf.graphWidth(), alchemy.conf.graphHeight()])
        .nodes(_.map(alchemy._nodes, (node) -> node._d3))
        .links(alchemy._edges)
        .on("tick", alchemy.layout.tick)

    alchemy.updateGraph()
    alchemy.controlDash.init()
    
    # alchemy.configuration for forceLocked
    if !alchemy.conf.forceLocked 
        alchemy.force
                .on("tick", alchemy.layout.tick)
                .start()


    # call user-specified functions after load function if specified
    # deprecate?
    if alchemy.conf.afterLoad?
        if typeof alchemy.conf.afterLoad is 'function'
            alchemy.conf.afterLoad()
        else if typeof alchemy.conf.afterLoad is 'string'
            alchemy[alchemy.conf.afterLoad] = true

    if alchemy.conf.initialScale isnt alchemy.defaults.initialScale
        alchemy.interactions.zoom().scale(alchemy.conf.initialScale)
        return

    if alchemy.conf.initialTranslate isnt alchemy.defaults.initialTranslate
        alchemy.interactions.zoom().translate(alchemy.conf.initialTranslate)
        return
