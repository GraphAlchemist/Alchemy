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
        interactions = alchemy.interactions
        conf = alchemy.conf
        nodes = alchemy._nodes
        interactions = alchemy.interactions
        @utils = new alchemy.drawing.NodeUtils
        utils = @utils

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
            node.selectAll('circle')
                .attr('r', (d) -> d.radius)
                .attr('shape-rendering', 'optimizeSpeed')
                .each (d) -> d3.select(@).style(utils.nodeStyle(d))

        @_setInteractions = (node) ->
            editorEnabled = alchemy.getState("interactions") is "editor"
            # editor = alchemy.editor.interactions()
            coreInteractions = alchemy.interactions

            # reset drag
            drag = d3.behavior.drag()
                .origin(Object)
                .on("dragstart", null)
                .on("drag", null)
                .on("dragend", null)

            if editorEnabled
                editorInteractions = new alchemy.editor.Interactions
                node.on('mouseup', editorInteractions.nodeMouseUp)
                    .on('mouseover', editorInteractions.nodeMouseOver)
                    .on('mouseout', editorInteractions.nodeMouseOut)
                    .on('dblclick', coreInteractions.nodeDoubleClick)
                    .on('click', editorInteractions.nodeClick)

                # drag = d3.behavior.drag()
                #     .origin(Object)
                #     .on("dragstart", editorInteractions.addNodeStart)
                #     .on("drag", editorInteractions.addNodeDragging)
                #     .on("dragend", editorInteractions.addNodeDragended)
                # node.call(drag)

            else 
                node.on('mouseup', null)
                    .on('mouseover', coreInteractions.nodeMouseOver)
                    .on('mouseout', coreInteractions.nodeMouseOut)
                    .on('dblclick', coreInteractions.nodeDoubleClick)
                    .on('click', coreInteractions.nodeClick)

                drag = d3.behavior.drag()
                        .origin(Object)
                        .on("dragstart", coreInteractions.nodeDragStarted)
                        .on("drag", coreInteractions.nodeDragged)
                        .on("dragend", coreInteractions.nodeDragended)

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