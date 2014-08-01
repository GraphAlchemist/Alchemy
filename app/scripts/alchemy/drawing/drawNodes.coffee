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
alchemy.drawing.setNodeInteractions = (node) ->
    resetDrag = () ->
        drag = d3.behavior.drag()
            .origin(Object)
            .on("dragstart", null)
            .on("drag", null)
            .on("dragend", null)
        node.call(drag)

    editorEnabled = alchemy.getState("interactions") is "editor"
    editor = alchemy.editor.interactions()
    resetDrag()

    if editorEnabled
    # set interactions
        node
            .on('mouseup', editor.nodeMouseUp)
            .on('mouseover', editor.nodeMouseOver)
            .on('mouseout', editor.nodeMouseOut)
            .on('dblclick', alchemy.interactions.nodeDoubleClick)
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
            .on('mouseover', alchemy.interactions.nodeMouseOver)
            .on('mouseout', alchemy.interactions.nodeMouseOut)
            .on('dblclick', alchemy.interactions.nodeDoubleClick)
            .on('click', alchemy.interactions.nodeClick)

        drag = d3.behavior.drag()
                .origin(Object)
                .on("dragstart", alchemy.interactions.nodeDragStarted)
                .on("drag", alchemy.interactions.nodeDragged)
                .on("dragend", alchemy.interactions.nodeDragended)

        if not alchemy.conf.fixNodes
            nonRootNodes = node.filter((d) -> return d.root != true)
            nonRootNodes.call(drag)

        if not alchemy.conf.fixRootNodes
            rootNodes = node.filter((d) -> return d.root == true)
            rootNodes.call(drag)

alchemy.drawing.drawNodes = (node) ->
    nodeEnter = node.enter().append("g")
                    .attr("class", (d) ->
                        node_data = alchemy._nodes[d.id].getProperties()
                        rootKey = alchemy.conf.rootNodes
                        if alchemy.conf.nodeTypes
                            nodeType = node_data[Object.keys(alchemy.conf.nodeTypes)]
                            if node_data[rootKey]? and node_data[rootKey] then "node root #{nodeType} active"
                            else "node #{nodeType} active"
                        else
                            if node_data[rootKey]? and node_data[rootKey] then "node root active"
                            else "node active"
                        )
                    .attr('id', (d) -> "node-#{d.id}")

    alchemy.drawing.setNodeInteractions(node)

    nodeColours = (d) ->
        node_data = alchemy._nodes[d.id].getProperties()
        if alchemy.conf.cluster
            if (isNaN parseInt node_data.cluster) or (node_data.cluster > alchemy.conf.clusterColours.length)
                colour = alchemy.conf.clusterColours[alchemy.conf.clusterColours.length - 1]
            else
                colour = alchemy.conf.clusterColours[node_data.cluster]
            "fill: #{colour}; stroke: #{colour};"
        else
            if alchemy.conf.nodeColour
                colour = alchemy.conf.nodeColour
            else
                ''

    nodeEnter
        .append('circle')
        .attr('class', (d) -> 
            node_data = alchemy._nodes[d.id].getProperties()
            rootKey = alchemy.conf.rootNodes
            if alchemy.conf.nodeTypes
                nodeType = node_data[Object.keys(alchemy.conf.nodeTypes)]
                if node_data[rootKey]? and node_data[rootKey] then "root #{nodeType} active"
                else "#{nodeType} active"
            else 
                if node_data[rootKey]? and node_data[rootKey] then "root"
                else "node"
           	)
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) -> 
            node_data = alchemy._nodes[d.id].getProperties()
            alchemy.utils.nodeSize(node_data)
            )
        .attr('shape-rendering', 'optimizeSpeed')
        .attr('target-id', (d) -> d.id)
        .attr('style', (d) ->
           radius = d3.select(this).attr('r')
           "#{nodeColours(d)}; stroke-width: #{ radius / 3 }")
        .style('stroke', () -> 
            if alchemy.getState("interactions") is "editor"
                return "#E82C0C"
            )

    #append caption to the node
    nodeEnter
        .append('svg:text')
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if alchemy._nodes[d.id].properties.root then alchemy.conf.rootNodeRadius / 2 else alchemy.conf.nodeRadius * 2 - 5)
        .html((d) -> alchemy.utils.nodeText(d))
