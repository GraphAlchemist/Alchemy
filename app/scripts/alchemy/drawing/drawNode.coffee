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

class alchemy.drawing.DrawNode
    constructor: ->
        utils = new alchemy.drawing.NodeUtils
        interactions = alchemy.interactions
        conf = alchemy.conf
        nodes = alchemy._nodes
        interactions = alchemy.interactions

        @_styleText = (node) ->
            node.selectAll("text")
                .attr('dy', (d) -> if nodes[d.id].properties.root then conf.rootNodeRadius / 2 else conf.nodeRadius * 2 - 5)
                .html((d) -> utils.nodeText(d))

        @_createNode = (node) ->
            node.append('circle')
                .attr('id', (d) -> "circle-#{d.id}")
            node.append('svg:text')
                .attr('id', (d) -> "text-#{d.id}")

        @_styleNode = (node) ->
            node.select('circle')
                .attr('r', (d) -> d.r)
                .attr('shape-rendering', 'optimizeSpeed')
                .attr('style', (d) -> utils.nodeStyle(d))

        @_setInteractions = (node) ->
            editorEnabled = alchemy.getState("interactions") is "editor"
            editor = alchemy.editor.interactions()
            interactions = alchemy.interactions

            # reset drag
            drag = d3.behavior.drag()
                .origin(Object)
                .on("dragstart", null)
                .on("drag", null)
                .on("dragend", null)

            if editorEnabled
            # set interactions
                node.on('mouseup', editor.nodeMouseUp)
                    .on('mouseover', editor.nodeMouseOver)
                    .on('mouseout', editor.nodeMouseOut)
                    .on('dblclick', interactions.nodeDoubleClick)
                    .on('click', editor.nodeClick)

                drag = d3.behavior.drag()
                    .origin(Object)
                    .on("dragstart", editor.addNodeStart)
                    .on("drag", editor.addNodeDragging)
                    .on("dragend", editor.addNodeDragended)
                node.call(drag)

            else 
                node
                    .on('mouseup', null)
                    .on('mouseover', interactions.nodeMouseOver)
                    .on('mouseout', interactions.nodeMouseOut)
                    .on('dblclick', interactions.nodeDoubleClick)
                    .on('click', interactions.nodeClick)

                drag = d3.behavior.drag()
                        .origin(Object)
                        .on("dragstart", interactions.nodeDragStarted)
                        .on("drag", interactions.nodeDragged)
                        .on("dragend", interactions.nodeDragended)

                if not conf.fixNodes
                    nonRootNodes = node.filter((d) -> return d.root != true)
                    nonRootNodes.call(drag)

                if not conf.fixRootNodes
                    rootNodes = node.filter((d) -> return d.root == true)
                    rootNodes.call(drag)

    styleText: (node) =>
        @_styleText(node)

    createNode: (node) =>
        @_createNode(node)

    setInteractions: (node) =>
        @_setInteractions(node)

    styleNode: (node) =>
        @_styleNode(node)


