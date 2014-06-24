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

nodeDragStarted = (d, i) ->
    d3.event.sourceEvent.stopPropagation()
    d3.select(this).classed("dragging", true)
    return

nodeDragged = (d, i) ->
    d.x += d3.event.dx
    d.y += d3.event.dy
    d.px += d3.event.dx
    d.py += d3.event.dy
    d3.select(this).attr("transform", "translate(#{d.x}, #{d.y})")
    if !alchemy.conf.forceLocked  #alchemy.configuration for forceLocked
        alchemy.force.start() #restarts force on drag

    alchemy.edge.attr("x1", (d) -> d.source.x )
        .attr("y1", (d) -> d.source.y )
        .attr("x2", (d) -> d.target.x )
        .attr("y2", (d) -> d.target.y )
        .attr "cx", d.x = d3.event.x
        .attr "cy", d.y = d3.event.y
    return

nodeDragended = (d, i) ->
    d3.select(this).classed "dragging", false
    return

alchemy.interactions =
    edgeClick: (d) ->
        vis = alchemy.vis
        vis.selectAll('line')
            .classed('highlight', false)
        d3.select(this)
            .classed('highlight', true)
        d3.event.stopPropagation
        if typeof alchemy.conf.edgeClick? is 'function'
            alchemy.conf.edgeClick()

    nodeMouseOver: (n) ->
        if alchemy.conf.nodeMouseOver?
            if typeof alchemy.conf.nodeMouseOver == 'function'
                alchemy.conf.nodeMouseOver(n)
            else if typeof alchemy.conf.nodeMouseOver == ('number' or 'string')
                # the user provided an integer or string to be used
                # as a data lookup key on the node in the graph json
                return n[alchemy.conf.nodeMouseOver]
        else
            null

    nodeMouseOut: (n) ->
        if alchemy.conf.nodeMouseOut? and typeof alchemy.conf.nodeMouseOut == 'function'
            alchemy.conf.nodeMouseOut(n)
        else
            null

    #not currently implemented
    nodeDoubleClick: (c) ->
        if not alchemy.conf.extraDataSource or
            c.expanded or
            alchemy.conf.unexpandable.indexOf c.type is not -1 then return

        $('<div id="loading-spi"></div>nner').show()
        console.log "loading more data for #{c.id}"
        c.expanded = true
        d3.json alchemy.conf.extraDataSource + c.id, loadMoreNodes

        links = findAllEdges c
        for e of edges
            edges[e].distance *= 2

    nodeClick: (c) ->
        d3.event.stopPropagation()
        alchemy.vis.selectAll('line')
            .classed('selected', (d) -> return c.id is d.source.id or c.id is d.target.id)
        alchemy.vis.selectAll('.node')
            .classed('selected', (d) -> return c.id is d.id)
            # also select 1st degree connections
            .classed('selected', (d) ->
                return d.id is c.id or alchemy.edges.some (e) ->
                    return ((e.source.id is c.id and e.target.id is d.id) or 
                            (e.source.id is d.id and e.target.id is c.id)) and 
                            d3.select(".edge[id*='#{d.id}']").classed("active"))

        if typeof alchemy.conf.nodeClick == 'function'
            alchemy.conf.nodeClick(c)
            return

    drag: d3.behavior.drag()
                          .origin(Object)
                          .on("dragstart", nodeDragStarted)
                          .on("drag", nodeDragged)
                          .on("dragend", nodeDragended)

    zoom: d3.behavior.zoom()
                          # to do, allow UDF initial scale and zoom
                          # .translate alchemy.conf.initialTranslate
                          # .scale alchemy.conf.initialScale
                          .scaleExtent [0.2, 2.4]
                          .on "zoom", ->
                            alchemy.vis.attr("transform", "translate(#{ d3.event.translate }) 
                                                                scale(#{ d3.event.scale })" )
                            return

    clickZoom:  (direction) ->
                    graph = d3.select(".alchemy svg g")
                    startTransform = graph.attr("transform")
                                           .match(/(-*\d+\.*\d*)/g)
                                           .map( (a) -> return parseFloat(a) )
                    endTransform = startTransform
                    graph
                        .attr("transform", ->
                            if direction == "in"
                                return "translate(#{ endTransform[0..1]}) scale(#{ endTransform[2] = endTransform[2]+0.2 })" 
                            else if direction == "out" 
                                return "translate(#{ endTransform[0..1]}) scale(#{ endTransform[2] = endTransform[2]-0.2 })" 
                            else if direction == "reset"
                                return "translate(0,0) scale(1)"
                            else 
                                console.log 'error'
                            )
                    @.zoom.scale(endTransform[2])
                    @.zoom.translate(endTransform[0..1])

    toggleControlDash: () ->
        #toggle off-canvas class on click
        offCanvas = d3.select("#control-dash-wrapper").classed("off-canvas")
        d3.select("#control-dash-wrapper").classed("off-canvas": !offCanvas, "on-canvas": offCanvas)
        d3.select("#control-dash-background").classed("off-canvas": !offCanvas, "on-canvas": offCanvas)
