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
            d3.event.stopPropagation()
            edge = alchemy._edges[d.id][d.pos]

            if edge._state != "hidden"
                edge._state = do -> 
                    return "active" if edge._state is "selected"
                    "selected"
                edge.setStyles()
            if typeof alchemy.conf.edgeClick? is 'function'
                alchemy.conf.edgeClick()

        edgeMouseOver: (d) ->
            edge = alchemy._edges[d.id][d.pos]
            if edge._state != "hidden"
                if edge._state != "selected"
                    edge._state = "highlighted"
                edge.setStyles()

        edgeMouseOut: (d) ->
            edge = alchemy._edges[d.id][d.pos]
            if edge._state != "hidden"
                if edge._state != "selected"
                    edge._state = "active"
                edge.setStyles()

        nodeMouseOver: (n) ->
            node = alchemy._nodes[n.id]
            if node._state != "hidden"
                if node._state != "selected"
                    node._state = "highlighted"
                    node.setStyles()
                if typeof alchemy.conf.nodeMouseOver is 'function'
                    alchemy.conf.nodeMouseOver(node)
                else if typeof alchemy.conf.nodeMouseOver is ('number' or 'string')
                    # the user provided an integer or string to be used
                    # as a data lookup key on the node in the graph json
                    node.properties[alchemy.conf.nodeMouseOver]

        nodeMouseOut: (n) ->
            node = alchemy._nodes[n.id]
            if node._state != "hidden"
                if node._state != "selected"
                    node._state = "active"
                    node.setStyles()
                if alchemy.conf.nodeMouseOut? and typeof alchemy.conf.nodeMouseOut is 'function'
                    alchemy.conf.nodeMouseOut(n)

        nodeClick: (n) ->
            # Don't consider drag a click
            return if d3.event.defaultPrevented

            d3.event.stopPropagation()
            node = alchemy._nodes[n.id]

            if node._state != "hidden"
                node._state = do -> 
                    return "active" if node._state is "selected"
                    "selected"
                node.setStyles()
            if typeof alchemy.conf.nodeClick is 'function'
                alchemy.conf.nodeClick(n)

        zoom: (extent) ->
                    if not @._zoomBehavior?
                        @._zoomBehavior = d3.behavior.zoom()
                    @._zoomBehavior.scaleExtent extent
                                    .on "zoom", ->
                                        alchemy.vis.attr("transform", "translate(#{ d3.event.translate }) 
                                                                    scale(#{ d3.event.scale })" )
                                        
        clickZoom:  (direction) ->
                        [x, y, scale] = alchemy.vis
                                               .attr "transform"
                                               .match /(-*\d+\.*\d*)/g
                                               .map (a) -> parseFloat(a)

                        alchemy.vis
                            .attr "transform", ->
                                if direction is "in"
                                    scale += 0.2 if scale < alchemy.conf.scaleExtent[1]
                                    return "translate(#{x},#{y}) scale(#{ scale })"
                                else if direction is "out"
                                    scale -= 0.2 if scale > alchemy.conf.scaleExtent[0]
                                    return "translate(#{x},#{y}) scale(#{ scale })"
                                else if direction is "reset"
                                    return "translate(0,0) scale(1)"
                                else
                                    console.log 'error'
                        if not @._zoomBehavior?
                            @._zoomBehavior = d3.behavior.zoom()
                        @._zoomBehavior.scale(scale)
                                       .translate([x,y])

        toggleControlDash: () ->
            #toggle off-canvas class on click
            offCanvas = alchemy.dash.classed("off-canvas") or
                        alchemy.dash.classed("initial")
            alchemy.dash
                   .classed {
                        "off-canvas": !offCanvas,
                        "initial"   : false,
                        "on-canvas" : offCanvas
                    }

        nodeDragStarted: (d, i) ->
            d3.event.preventDefault
            d3.event.sourceEvent.stopPropagation()
            d3.select(@).classed "dragging", true
            d.fixed = true

        nodeDragged: (d, i) ->
            d.x += d3.event.dx
            d.y += d3.event.dy
            d.px += d3.event.dx
            d.py += d3.event.dy

            node = d3.select @
            node.attr "transform", "translate(#{d.x}, #{d.y})"
            edgeIDs = alchemy._nodes[d.id]._adjacentEdges
            for id in edgeIDs
                selection = alchemy.vis.select "#edge-#{id}"
                alchemy._drawEdges.updateEdge selection.data()[0]

        nodeDragended: (d, i) ->
            d3.select(@).classed "dragging": false
            if !alchemy.conf.forceLocked  #alchemy.configuration for forceLocked
                alchemy.force.start() #restarts force on drag

        deselectAll: () ->
            # this function is also fired at the end of a drag, do nothing if this
            if d3.event?.defaultPrevented then return
            if alchemy.conf.showEditor is true
                alchemy.modifyElements.nodeEditorClear()
            
            _.each alchemy._nodes, (n)->
                n._state = "active"
                n.setStyles()
            
            _.each alchemy._edges, (edge)->
                _.each edge, (e)->
                    e._state = "active"
                    e.setStyles()
            
            # call user-specified deselect function if specified
            if alchemy.conf.deselectAll and typeof(alchemy.conf.deselectAll is 'function')
                alchemy.conf.deselectAll()
