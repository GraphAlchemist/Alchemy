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


class alchemy.drawing.DrawEdge
    constructor: ->
        # edge is a selection of a single edge or multiple edges
        utils = alchemy.drawing.drawingUtils.edgeUtils()
        conf = alchemy.conf
        nodes = alchemy._nodes
        interactions = alchemy.interactions
        if not conf.curvedEdges
            @_styleLink = (edge) -> 
                edge.select('line')
                    .attr("class", (d) -> 
                        # edge_data = alchemy._edges[d.id]
                        "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
                    .attr('x1', (d) -> nodes[d.source]._d3.x)
                    .attr('y1', (d) -> nodes[d.source]._d3.y)
                    .attr('x2', (d) -> nodes[d.target]._d3.x)
                    .attr('y2', (d) -> nodes[d.target]._d3.y)
                    .attr('shape-rendering', 'optimizeSpeed')
                    .attr("style", (d) -> utils.edgeStyle(d)) # depricate this
                    .attr("style", {'stroke-width': conf.edgeWidth})
                edge.select('rect')
                    .attr('x', 0)
                    .attr('y', -conf.edgeOverlayWidth/2)
                    .attr('height', conf.edgeOverlayWidth)
                    .attr('width', (d) -> utils.edgeLength(d)) 
                    .on('click', alchemy.interactions.edgeClick)
                    .attr('transform', (d) -> "translate(#{nodes[d.source]._d3.x}, #{nodes[d.source]._d3.y}) rotate(#{utils.edgeAngle(d)})")
        else
            @_styleLink = (edge) -> 
                edge.select('path')
                     .attr('d', (d) ->
                        # high school  trigonometry
                        sourceX = alchemy._nodes[d.source]._d3.x
                        sourceY = alchemy._nodes[d.source]._d3.y
                        targetX = alchemy._nodes[d.target]._d3.x
                        targetY = alchemy._nodes[d.target]._d3.y
                        dx = targetX - sourceX
                        dy = targetY - sourceY
                        hyp = Math.sqrt( dx * dx + dy * dy)
                        "M#{sourceX},#{sourceY}A#{hyp},#{hyp} 0 0,1 #{targetX},#{targetY}")
        if not alchemy.conf.curvedEdges
            @_createLink = (edge) ->
                edge.append('rect')
                    .attr('class', 'edge-handler')
                edge.append('line')
        else
            @_createLink = (edge) ->
                edge.append('path')
                    .attr('class', 'edge-handler')
                edge.append('path')
        @_styleText = (edge) ->
            # edge.select('text')
            #     .attr('dx', (d) -> utils.middleLine(d).x)
            #     .attr('dy', (d) -> utils.middleLine(d).y)
            #     .attr('transform', (d) -> "rotate(#{utils.edgeAngle(d)} #{utils.middleLine(d).x} #{utils.middleLine(d).y})")
            #     .text((d) -> utils.edgeCaption(d))
            # return
        @_setInteractions = (edge) ->
            if not conf.curvedEdges
                edge.select('rect')
                    .on('click', (d) -> interactions.edgeClick(d))

    createLink: (edge) =>
        @_createLink(edge)

    styleLink: (edge) =>
        @_styleLink(edge)

    styleText: (edge) =>
        @_styleText(edge)

    setInteractions: (edge) =>
        @_setInteractions(edge)
