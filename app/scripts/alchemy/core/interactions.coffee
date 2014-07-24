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
    if alchemy.conf.editorInteractions is true
        sourceNode = d
        data = {source: sourceNode}
        dragLine = alchemy.vis
            .datum(data)
            .append("line")
            .attr "id", "dragline"
            .attr "x1", 0
            .attr "y1", 0
            .attr "x2", 0
            .attr "y2", 0
        d3.select("#dragline").classed("hidden":false)
    else
        d3.select(this).classed("dragging", true)
    return

nodeDragged = (d, i) ->
    if alchemy.conf.editorInteractions is true
        x2coord = d3.event.x
        y2coord = d3.event.y
        sourceNode = d
        d3.select('#dragline')
            .attr "x1", sourceNode.x
            .attr "y1", sourceNode.y
            .attr "x2", x2coord
            .attr "y2", y2coord
            .attr "style", "stroke: #FFF"
    else
        d.x += d3.event.dx
        d.y += d3.event.dy
        d.px += d3.event.dx
        d.py += d3.event.dy
        d3.select(this).attr("transform", "translate(#{d.x}, #{d.y})")
        if !alchemy.conf.forceLocked  #alchemy.configuration for forceLocked
            alchemy.force.start() #restarts force on drag

        alchemy.edge
            .attr("x1", (d) -> d.source.x )
            .attr("y1", (d) -> d.source.y )
            .attr("x2", (d) -> d.target.x )
            .attr("y2", (d) -> d.target.y )
            .attr "cx", d.x = d3.event.x
            .attr "cy", d.y = d3.event.y
    return

nodeDragended = (d, i) ->
    if alchemy.conf.editorInteractions is true
        if (alchemy.interactions.nodeMouseUp() is false) and (!d3.select("#dragline").empty())
            dragline = d3.select("#dragline")
            targetX = dragline.attr("x2")
            targetY = dragline.attr("y2")

            # coordinates relative to source node
            sourceNode = d

            targetNode = {id: alchemy.nodes.length, x: targetX, y: targetY, caption: "editedNode"}    
            newLink = {source: sourceNode, target: targetNode, caption: "edited"}

            # add to alchemy data
            alchemy.nodes.push(targetNode)
            alchemy.edges.push(newLink)


            alchemy.node = alchemy.node.data(alchemy.nodes)
            alchemy.edge = alchemy.edge.data(alchemy.edges)
            
            alchemy.drawing.drawedges(alchemy.edge)
            alchemy.drawing.drawnodes(alchemy.node)
            alchemy.layout.tick()

            dragline.remove()
    else
        d3.select(this).classed "dragging", false
    return

alchemy.interactions =
    enableEditor: () ->
        alchemy.nodes

    edgeClick: (d) ->
        vis = alchemy.vis
        vis.selectAll('line')
            .classed('highlight', false)
        d3.select(this)
            .classed('highlight', true)
        d3.event.stopPropagation()
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
        if alchemy.conf.editorInteractions is true
            if !d3.select(@).select("circle").empty()
                radius = d3.select(@).select("circle").attr("r")
                d3.select(@).select("circle")
                    .attr("r", radius*3)
        else
            null

    nodeMouseUp: (n) ->
        # we are dragging
        # to do: insert lines uniquely
        if alchemy.conf.editorInteractions is true
            if !d3.select(n).empty() and !d3.select("#dragline").empty()
                dragline = d3.select("#dragline")
                sourceNode = dragline.data()[0].source
                targetNode = n
                if sourceNode != targetNode
                    console.log "different"
                    newLink = {source: sourceNode, target: targetNode, caption: "edited"}

                    alchemy.edges.push(newLink)
                    alchemy.edge = alchemy.edge.data(alchemy.edges)
                    alchemy.drawing.drawedges(alchemy.edge)
                dragline.datum()
                dragline.remove()
                return true
            else return false

        else return false

    nodeMouseOut: (n) ->
        if alchemy.conf.nodeMouseOut? and typeof alchemy.conf.nodeMouseOut == 'function'
            alchemy.conf.nodeMouseOut(n)
        if alchemy.conf.editorInteractions is true
            if !d3.select(@).select("circle").empty()
                radius = d3.select(@).select("circle").attr("r")
                d3.select(@).select("circle")
                    .attr("r", radius/3)
        else
            null

    #not currently implemented
    nodeDoubleClick: (c) ->
        d3.event.stopPropagation()
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
        # select the correct nodes
        if !alchemy.vis.select("#node-#{c.id}").empty()
            selected = alchemy.vis.select("#node-#{c.id}").classed('selected')
            alchemy.vis.select("#node-#{c.id}").classed('selected', !selected)

        # alchemy.vis.selectAll(".node").classed('selected', (d) ->
        #     if d.id is c.id
        #         return !selected
        #     else 
        #         connections = alchemy.edges.some (e) -> 
        #             ((e.source.id is c.id and e.target.id is d.id) or 
        #             (e.source.id is d.id and e.target.id is c.id))
        #             # and d3.select(".edge[source-target*='#{d.id}']").classed("active")
        #         return connections
        #     )

        # selectedEdges = alchemy.vis.selectAll(".edge[source-target*='#{c.id}']")
        # selectedEdges.classed("selected", !selected)
        # if alchemy.conf.nodeClick?
        if typeof alchemy.conf.nodeClick == 'function'
            alchemy.conf.nodeClick(c)
            return

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





