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


alchemy.drawing.drawEdge = () ->
   
    # edge is a selection of a single edge or multiple edges
    utils = alchemy.drawing.drawingUtils.edgeUtils()

    if not alchemy.conf.curvedEdges
        @styleLink = (edge) -> 
            edge.select('line')
                .attr("class", (d) -> 
                    "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
                .on('click', alchemy.interactions.edgeClick)
                .attr('x1', (d) -> d.source.x)
                .attr('y1', (d) -> d.source.y)
                .attr('x2', (d) -> d.target.x)
                .attr('y2', (d) -> d.target.y)
                .attr('shape-rendering', 'optimizeSpeed')
                .attr "style", (d) -> utils.edgeStyle(d)
                return
    else
        @styleLink= (edge) ->
            edge.datum((d) ->
                def = d3.select("#{alchemy.conf.divSelector} svg defs path[source-target='#{d.source.id}-#{d.target.id}'")
                        .select('path')
                        .attr('d', () -> 
                                # high school  trigonometry
                                dx = d.target.x - d.source.x
                                dy = d.target.y - d.source.y
                                hyp = Math.sqrt( dx * dx + dy * dy)
                                "M#{d.source.x},#{d.source.y}A#{hyp},#{hyp} 0 0,1 #{d.target.x},#{d.target.y}")
                )

    if not alchemy.conf.curvedEdges
        @styleText = (edge) -> 
            edge.select('text')
                .attr('dx', (d) -> utils.middleLine(d).x)
                .attr('dy', (d) -> utils.middleLine(d).y)
                .attr('transform', (d) -> "rotate(#{utils.angle(d)} #{utils.middleLine(d).x} #{utils.middleLine(d).y})")
                .text((d) -> utils.edgeCaption(d))
                return
    else
        @styleText = (edge) -> 
            debugger
            edge.select('text')
                .data((d)->
                    debugger)
                .append('textPath')
                .attr("xlink:href", (d) -> 
                    debugger
                    "[source-target='#{d.source.id}-#{d.target.id}']")
                # .attr('dx', (d) -> 
                #     debugger
                #     utils.middlePath(d).x)
                # .attr('dy', (d) -> utils.middlePath(d).y)
                .attr('transform', (d) -> "rotate(#{utils.angle(d)} #{utils.middle(d).x} #{utils.middle(d).y})")
                .text((d) -> utils.edgeCaption(d))
                return

    @