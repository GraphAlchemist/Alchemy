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

    DrawNode = (instance)->
        a: instance
        styleText: (node) ->
            conf = @a.conf
            utils = @a.drawing.NodeUtils
            nodes = @a._nodes
            node.selectAll "text"
                .attr 'dy', (d) ->
                    if nodes[d.id].getProperties().root
                        conf.rootNodeRadius / 2
                    else
                        conf.nodeRadius * 2 - 5
                .attr 'visibility', (d) ->
                    if nodes[d.id]._state is "hidden"
                        "hidden"
                    else
                        "visible"
                .text (d) -> utils.nodeText(d)
                .style "display", (d)->
                    return "block" if conf.nodeCaptionsOnByDefault

        createNode: (node) ->
            node = _.difference node, node.select("circle").data()
            node.__proto__ = d3.select().__proto__
            node.append 'circle'
                .attr 'id', (d) -> "circle-#{d.id}"
            node.append 'svg:text'
                .attr 'id', (d) -> "text-#{d.id}"

        styleNode: (node) ->
            utils = @a.drawing.NodeUtils

            node.selectAll 'circle'
                .attr 'r', (d) ->
                    if typeof d.radius is "function"
                        d.radius()
                    else
                        d.radius
                .each (d) -> d3.select(@).style utils.nodeStyle d


        setInteractions: (node) ->
            conf = @a.conf
            coreInteractions = @a.interactions
            editorEnabled = @a.get.state("interactions") is "editor"

            # reset drag
            drag = d3.behavior.drag()
                .origin Object
                .on "dragstart", null
                .on "drag", null
                .on "dragend", null

            if editorEnabled
                editorInteractions = new @a.editor.Interactions
                node.on 'mouseup',(d)->  editorInteractions.nodeMouseUp(d)
                    .on 'mouseover', (d)-> editorInteractions.nodeMouseOver(d)
                    .on 'mouseout', (d)-> editorInteractions.nodeMouseOut(d)
                    .on 'dblclick', (d)-> coreInteractions.nodeDoubleClick(d)
                    .on 'click', (d)-> editorInteractions.nodeClick(d)

            else
                node.on 'mouseup', null
                    .on 'mouseover', (d)-> coreInteractions.nodeMouseOver(d)
                    .on 'mouseout', (d)-> coreInteractions.nodeMouseOut(d)
                    .on 'dblclick', (d)-> coreInteractions.nodeDoubleClick(d)
                    .on 'click', (d)-> coreInteractions.nodeClick(d)

                drag = d3.behavior.drag()
                        .origin(Object)
                        .on "dragstart", coreInteractions.nodeDragStarted
                        .on "drag", coreInteractions.nodeDragged
                        .on "dragend", coreInteractions.nodeDragended

                if not conf.fixNodes
                    nonRootNodes = node.filter (d) -> d.root isnt true
                    nonRootNodes.call drag

                if not conf.fixRootNodes
                    rootNodes = node.filter (d) -> d.root is true
                    rootNodes.call drag
