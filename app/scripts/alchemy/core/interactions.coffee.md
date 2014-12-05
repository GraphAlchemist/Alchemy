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

    Alchemy::interactions = (instance)->
        a = instance

        edgeClick: (d) ->
            # Don't consider drag a click
            return if d3.event.defaultPrevented
            # Don't tell alchemy about the click
            d3.event.stopPropagation()

            # Convert d3.edge to alchemy.edge
            edge = d.self

            if typeof a.conf.edgeClick is 'function'
                a.conf.edgeClick(edge)

            if edge._state != "hidden"
                edge._state = 
                    if edge._state is "highlighted" then "selected" else "active"
                edge.setStyles()

        edgeMouseOver: (d) ->
            edge = d.self
            if edge._state != "hidden"
                if edge._state != "selected"
                    edge._state = "highlighted"
                edge.setStyles()

        edgeMouseOut: (d) ->
            edge = d.self
            if edge._state != "hidden"
                if edge._state != "selected"
                    edge._state = "active"
                edge.setStyles()

        nodeMouseOver: (n) ->
            node = n.self
            if node._state != "hidden"
                if node._state != "selected"
                    node._state = "highlighted"
                    node.setStyles()
                if typeof a.conf.nodeMouseOver is 'function'
                    a.conf.nodeMouseOver(node)
                else if typeof a.conf.nodeMouseOver is ('number' or 'string')
                    # the user provided an integer or string to be used
                    # as a data lookup key on the node in the graph json
                    node.properties[a.conf.nodeMouseOver]

        nodeMouseOut: (n) ->
            node = n.self
            a = node.a
            if node._state != "hidden"
                if node._state != "selected"
                    node._state = "active"
                    node.setStyles()
                if a.conf.nodeMouseOut? and typeof a.conf.nodeMouseOut is 'function'
                    a.conf.nodeMouseOut(n)

        nodeClick: (n) ->
            # Don't consider drag a click
            return if d3.event.defaultPrevented
            # Don't tell alchemy about the click
            d3.event.stopPropagation()
            # Convert d3.node to alchemy.node
            node = n.self

            if typeof a.conf.nodeClick is 'function'
                a.conf.nodeClick(node)

            if node._state != "hidden"
                node._state = do ->
                    return "active" if node._state is "selected"
                    "selected"
                node.setStyles()

        zoom: (extent) ->
                    if not @_zoomBehavior?
                        @_zoomBehavior = d3.behavior.zoom()
                    @_zoomBehavior.scaleExtent extent
                                  .on "zoom", (d) ->
                                    a = Alchemy::getInst this
                                    a.vis.attr("transform", "translate(#{ d3.event.translate }) 
                                                              scale(#{ d3.event.scale })" )
        clickZoom:  (direction) ->
                        [x, y, scale] = a.vis
                                          .attr "transform"
                                          .match /(-*\d+\.*\d*)/g
                                          .map (a) -> parseFloat(a)

                        a.vis
                            .attr "transform", ->
                                if direction is "in"
                                    scale += 0.2 if scale < a.conf.scaleExtent[1]
                                    return "translate(#{x},#{y}) scale(#{ scale })"
                                else if direction is "out"
                                    scale -= 0.2 if scale > a.conf.scaleExtent[0]
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
            offCanvas = a.dash.classed("off-canvas") or
                        a.dash.classed("initial")
            a.dash
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
            a = d.self.a

            d.x  += d3.event.dx
            d.y  += d3.event.dy
            d.px += d3.event.dx
            d.py += d3.event.dy

            node = d3.select @
            node.attr "transform", "translate(#{d.x}, #{d.y})"
            edges = d.self._adjacentEdges
            _.each edges, (edge) ->
                selection = a.vis.select "#edge-#{edge.id}-#{edge._index}"
                a._drawEdges.updateEdge selection.data()[0]

        nodeDragended: (d, i) ->
            a = d.self.a
            d3.select(@).classed "dragging": false
            if !a.conf.forceLocked  #a.configuration for forceLocked
                a.force.start() #restarts force on drag

        nodeDoubleClick: (d)-> null

        deselectAll: () ->
            a = Alchemy::getInst @

            # this function is also fired at the end of a drag, do nothing if this
            if d3.event?.defaultPrevented then return
            if a.conf.showEditor is true
                a.modifyElements.nodeEditorClear()

            _.each a._nodes, (n)->
                n._state = "active"
                n.setStyles()

            _.each a._edges, (edge)->
                _.each edge, (e)->
                    e._state = "active"
                    e.setStyles()

            # call user-specified deselect function if specified
            if a.conf.deselectAll and typeof(a.conf.deselectAll is 'function')
                a.conf.deselectAll()
