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

alchemy.drawing.drawnodes = (node) ->

    nodeEnter = node.enter().append("g")
                    .attr("class", (d) ->
                        if alchemy.conf.nodeTypes
                            nodeType = d[Object.keys(alchemy.conf.nodeTypes)]
                            "node #{nodeType} active"
                        else
                            "node")
                    .attr('id', (d) -> "node-#{d.id}")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', alchemy.interactions.nodeMouseOver)
                    .on('mouseout', alchemy.interactions.nodeMouseOut)
                    .on('dblclick', alchemy.interactions.nodeDoubleClick)
                    .on('click', alchemy.interactions.nodeClick)

    if not alchemy.conf.fixNodes
        nonRootNodes = nodeEnter.filter((d) -> return d.node_type != "root")
        nonRootNodes.call(alchemy.interactions.drag)

    if not alchemy.conf.fixRootNodes
        rootNodes = nodeEnter.filter((d) -> return d.node_type == "root")
        rootNodes.call(alchemy.interactions.drag)

    nodeColours = (d) ->
        if alchemy.conf.cluster
            if (isNaN parseInt d.cluster) or (d.cluster > alchemy.conf.clusterColours.length)
                colour = alchemy.conf.clusterColours[alchemy.conf.clusterColours.length - 1]
            else
                colour = alchemy.conf.clusterColours[d.cluster]
            "fill: #{colour}; stroke: #{colour};"
        else
            if alchemy.conf.nodeColour
                colour = alchemy.conf.nodeColour
            else
                ''

    nodeEnter
        .append('circle')
        .attr('class', (d) -> "#{d.node_type} active")
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) -> alchemy.utils.nodeSize(d))
        .attr('shape-rendering', 'optimizeSpeed')
        .attr('target-id', (d) -> d.id)
        .attr('style', (d) ->
           "#{nodeColours(d)}; stroke-width: #{if d.node_type == 'root' then alchemy.conf.rootNodeRadius/3 else alchemy.conf.nodeRadius/3}")

    #append caption to the node
    nodeEnter
        .append('svg:text')
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if d.node_type is 'root' then alchemy.conf.rootNodeRadius / 2 else alchemy.conf.nodeRadius * 2 - 5)
        .text((d) -> alchemy.utils.nodeText(d))
