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
    conf = alchemy.conf

    if d3.select(conf.divSelector).empty()
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
        edge  = new alchemy.models.Edge(e)
        alchemy._edges[edge.id] = edge

    #create SVG
    alchemy.vis = d3.select(conf.divSelector)
        .attr("style", "width:#{conf.graphWidth()}px; height:#{conf.graphHeight()}px")
        .append("svg")
            .attr("xmlns", "http://www.w3.org/2000/svg")
            .attr("pointer-events", "all")
            .on("dblclick.zoom", null)
            .on('click', alchemy.interactions.deselectAll)
            .call(alchemy.interactions.zoom(conf.scaleExtent))
            .append('g')
                .attr("transform","translate(#{conf.initialTranslate}) scale(#{conf.initialScale})")

    d3.select("body")
        .on('keydown', alchemy.editor.interactions().deleteSelected)

    alchemy.layout = new alchemy.Layout  # refactor (obviously)
    # create layout
    alchemy.force = d3.layout.force()
        .size([conf.graphWidth(), conf.graphHeight()])
        .nodes(_.map(alchemy._nodes, (node) -> node._d3))
        .links(_.map(alchemy._edges, (edge) -> edge._d3))        

    alchemy.force
        .charge(alchemy.layout.charge())
        .linkDistance((link) -> alchemy.layout.linkDistancefn(link))
        .theta(1.0)
        .gravity(alchemy.layout.gravity())
        .linkStrength((link) -> alchemy.layout.linkStrength(link))
        .friction(alchemy.layout.friction())
        .chargeDistance(alchemy.layout.chargeDistance())
        .on("tick", alchemy.layout.tick)

    alchemy.updateGraph()
    alchemy.controlDash.init()
    
    # configuration for forceLocked
    if !conf.forceLocked 
        alchemy.force
                .on("tick", alchemy.layout.tick)
                .start()


    # call user-specified functions after load function if specified
    # deprecate?
    if conf.afterLoad?
        if typeof conf.afterLoad is 'function'
            conf.afterLoad()
        else if typeof conf.afterLoad is 'string'
            alchemy[conf.afterLoad] = true

    if conf.initialScale isnt alchemy.defaults.initialScale
        alchemy.interactions.zoom().scale(conf.initialScale)
        return

    if conf.initialTranslate isnt alchemy.defaults.initialTranslate
        alchemy.interactions.zoom().translate(conf.initialTranslate)
        return

    if conf.cluster or conf.directedEdges
        defs = d3.select("#{alchemy.conf.divSelector} svg").append("svg:defs")

    if conf.directedEdges
        arrowSize = conf.edgeArrowSize
        marker = defs.append("svg:marker")
            .attr("id", "arrow")
            .attr("viewBox", "0 -#{arrowSize * 0.4} #{arrowSize} #{arrowSize}")
            .attr('markerUnits', 'userSpaceOnUse')
            .attr("markerWidth", arrowSize)
            .attr("markerHeight", arrowSize)
            .attr("orient", "auto")
        marker.append("svg:path")
            .attr("d", "M #{arrowSize},0 L 0,#{arrowSize * 0.4} L 0,-#{arrowSize * 0.4}")
        if conf.curvedEdges
            marker.attr("refX", arrowSize + 1)
        else
            marker.attr('refX', 1)

