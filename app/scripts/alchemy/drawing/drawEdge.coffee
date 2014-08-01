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
        if not alchemy.conf.curvedEdges
            @_styleLink = (edge) -> 
                edge.select('line')
                    .attr("class", (d) -> 
                        # edge_data = alchemy._edges[d.id]
                        "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
                    .on('click', alchemy.interactions.edgeClick)
                    .attr('x1', (d) -> alchemy._nodes[d.source]._d3.x)
                    .attr('y1', (d) -> alchemy._nodes[d.source]._d3.y)
                    .attr('x2', (d) -> alchemy._nodes[d.target]._d3.x)
                    .attr('y2', (d) -> alchemy._nodes[d.target]._d3.y)
                    .attr('shape-rendering', 'optimizeSpeed')
                    .attr "style", (d) -> utils.edgeStyle(d)
                    return
        else
            @_styleLink = (edge) -> 
                edge.select('path')
                     .attr('d', (d) ->
                        # high school  trigonometry
                        dx = d.target.x - d.source.x
                        dy = d.target.y - d.source.y
                        hyp = Math.sqrt( dx * dx + dy * dy)
                        "M#{d.source.x},#{d.source.y}A#{hyp},#{hyp} 0 0,1 #{d.target.x},#{d.target.y}")
        if not alchemy.conf.curvedEdges
            @_createLink = (edge) ->
                edge.append('line')
        else
            @_createLink = (edge) ->
                edge.append('path')
        @_styleText = (edge) ->
            # edge.select('text')
            #     .attr('dx', (d) -> utils.middleLine(d).x)
            #     .attr('dy', (d) -> utils.middleLine(d).y)
            #     .attr('transform', (d) -> "rotate(#{utils.angle(d)} #{utils.middleLine(d).x} #{utils.middleLine(d).y})")
            #     .text((d) -> utils.edgeCaption(d))
            # return
    
    createLink: (edge) =>
        @_createLink(edge)

    styleLink: (edge) =>
        @_styleLink(edge)

    styleText: (edge) =>
        @_styleText(edge)
