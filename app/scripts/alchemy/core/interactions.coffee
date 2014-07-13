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

    nodeMouseDown: (n) ->
        if alchemy.conf.editorInteractions is true
            console.log "node mousedown, true"
            drag_line = alchemy.vis.append("line")
            alchemy.edges.push(drag_line)
            alchemy.interactions.nodeMouseOver(n, drag_line)
        else
            console.log "mousedown, no"
            n.fixed = true

    nodeMouseMove: (n, drag_line) ->
        if alchemy.conf.editorInteractions is true
            drag_line.source = n
            drag_line.target = d3.svg.mouse(this)
            alchemy.drawing.drawedges(drag_line)
            # drag_line
            #     .attr("x1", mousedown_node.x)
            #     .attr("y1", mousedown_node.y)
            #     .attr("x2", d3.svg.mouse(this)[0])
            #     .attr("y2", d3.svg.mouse(this)[1])
            #     .attr "style", (d) -> edgeStyle(d)
            console.log "node mousemove, true"
        else
            console.log "mousemove, no."
            n.fixed = true

    nodeMouseUp: (n) ->
        if alchemy.conf.editorInteractions is true
            point = d3.mouse(this)
            length = alchemy.nodes.length
            node = {x: point[0], y: point[1], id: length}
            n = alchemy.nodes.push(node)
            alchemy.updateGraph()

            selected_node = node
            selected_link = null

            # alchemy.edges.push({source: mousedown_node, target: node})
            alchemy.drawing.drawnodes(node)
            console.log "node mouseup, true"
        else
            console.log "mousedown, no."
            n.fixed = true

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
        if alchemy.editorInteractions is false
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
                                d3.select(".edge[source-target*='#{d.id}']").classed("active"))

            if typeof alchemy.conf.nodeClick == 'function'
                alchemy.conf.nodeClick(c)
                return
        else 
            console.log "node click, editorInteractions is true"

    drag: d3.behavior.drag()
                          .origin(Object)
                          .on("dragstart", nodeDragStarted)
                          .on("drag", nodeDragged)
                          .on("dragend", nodeDragended)

    zoom: (extent) ->
                if not @._zoomBehavior?
                    @._zoomBehavior = d3.behavior.zoom()
                @._zoomBehavior.scaleExtent extent
                                .on "zoom", ->
                                    alchemy.vis.attr("transform", "translate(#{ d3.event.translate }) 
                                                                scale(#{ d3.event.scale })" )
                                    
                            

    clickZoom:  (direction) ->
                    startTransform = alchemy.vis
                                            .attr("transform")
                                            .match(/(-*\d+\.*\d*)/g)
                                            .map( (a) -> return parseFloat(a) )
                    endTransform = startTransform
                    alchemy.vis
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
                    if not @._zoomBehavior?
                        @._zoomBehavior = d3.behavior.zoom()
                    @._zoomBehavior.scale(endTransform[2])
                                   .translate(endTransform[0..1])

    toggleControlDash: () ->
        #toggle off-canvas class on click
        offCanvas = d3.select("#control-dash-wrapper").classed("off-canvas") or d3.select("#control-dash-wrapper").classed("initial")
        d3.select("#control-dash-wrapper").classed("off-canvas": !offCanvas, "initial": false, "on-canvas": offCanvas)





