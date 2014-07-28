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


    @styleLine = (edge) -> 
        edge.select('line')
            .attr("class", (d) -> 
                "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
            .attr('source-target', (d) -> d.source.id + '-' + d.target.id)
            .on('click', alchemy.interactions.edgeClick)
            .attr('x1', (d) -> d.source.x)
            .attr('y1', (d) -> d.source.y)
            .attr('x2', (d) -> d.target.x)
            .attr('y2', (d) -> d.target.y)
            .attr('shape-rendering', 'optimizeSpeed')
            .attr "style", (d) -> utils.edgeStyle(d)
            return

    @styleText = (edge) -> 
        edge.select('text')
            .attr('dx', (d) -> utils.middle(d).x)
            .attr('dy', (d) -> utils.middle(d).y)
            .attr('transform', (d) -> "rotate(#{utils.angle(d)} #{utils.middle(d).x} #{utils.middle(d).y})")
            .text('YAYYYYY!')
            return

    @