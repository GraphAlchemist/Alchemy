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

alchemy.interactions =
    edgeClick: (d) ->
        vis = alchemy.vis
        vis.selectAll('.edge')
            .classed('highlight', false)
        d3.select("[source-target='#{d.id}']")
            .classed('highlight', true)
        d3.event.stopPropagation()
        if typeof alchemy.conf.edgeClick? is 'function'
            alchemy.conf.edgeClick()

    nodeMouseOver: (n) ->
        if alchemy.conf.nodeMouseOver?
            node = alchemy._nodes[n.id]
            if typeof alchemy.conf.nodeMouseOver == 'function'
                alchemy.conf.nodeMouseOver(node)
            else if typeof alchemy.conf.nodeMouseOver == ('number' or 'string')
                # the user provided an integer or string to be used
                # as a data lookup key on the node in the graph json
                return node.properties[alchemy.conf.nodeMouseOver]
        else
            null

    nodeMouseOut: (n) ->
        if alchemy.conf.nodeMouseOut? and typeof alchemy.conf.nodeMouseOut == 'function'
            alchemy.conf.nodeMouseOut(n)
        else
            null

    nodeMouseUp: (n) ->
        # console.log "mouseup from interactions"

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

        # alternate click event highlights neighboring nodes and outgoing edges
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

    nodeDragStarted: (d, i) ->
        d3.event.sourceEvent.stopPropagation()
        d3.select(this).classed("dragging", true)
        d.fixed = true

    nodeDragged: (d, i) ->
        d.x += d3.event.dx
        d.y += d3.event.dy
        d.px += d3.event.dx
        d.py += d3.event.dy

        alchemy.updateGraph false
        d3.select(this).attr("transform", "translate(#{d.x}, #{d.y})")

    nodeDragended: (d, i) ->
        d3.select(this).classed "dragging": false
        if !alchemy.conf.forceLocked  #alchemy.configuration for forceLocked
            alchemy.force.start() #restarts force on drag
