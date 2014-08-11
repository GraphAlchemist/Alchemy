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
        conf = alchemy.conf
        @curved = conf.curvedEdges
        @directed = conf.directedEdges

    createLink: (edge) =>
        utils = new alchemy.drawing.EdgeUtils
        conf = alchemy.conf
        interactions = alchemy.interactions

        if @curved
            edge.append('path')
                .attr('class', 'edge-line')
                .attr('id', (d) -> "path-#{d.id}")
            edge.append('path')
                .attr('class', 'edge-handler')
                .style('stroke-width', "#{conf.edgeOverlayWidth}")
                .on('click', alchemy.interactions.edgeClick)

            edge.filter((d,i) -> alchemy._edges[d.id].properties.caption?)
                .append('text')
        else
            edge.append('line')
                .attr('class', 'edge-line')
                .attr('shape-rendering', 'optimizeSpeed')
                .style('stroke', (d) -> utils.edgeStyle(d))
                .style('stroke-width', conf.edgeWidth)
            edge.append('rect')
                .attr('class', 'edge-handler')
                .on('click', alchemy.interactions.edgeClick)

            edge.filter((d,i) -> alchemy._edges[d.id].properties.caption?)
                .append('text')

    styleLink: (edge) =>
        utils = new alchemy.drawing.EdgeUtils
        conf = alchemy.conf

        if @curved
            edge.selectAll('path')
                 .attr('d', (d) ->
                    # high school trigonometry
                    # sourceX = d.source.x
                    # sourceY = d.source.y
                    # targetX = d.target.x
                    # targetY = d.target.y
                    startLine = utils.startLine(d)
                    endLine = utils.endLine(d)
                    sourceX = startLine.x
                    sourceY = startLine.y
                    targetX = endLine.x
                    targetY = endLine.y
                    dx = targetX - sourceX
                    dy = targetY - sourceY
                    hyp = Math.sqrt( dx * dx + dy * dy)
                    # "M #{startLine.x},#{startLine.y} A #{hyp}, #{hyp} #{utils.captionAngle(d)} 0, 1 #{endLine.x}, #{endLine.y}")
                    "M #{sourceX},#{sourceY} A #{hyp}, #{hyp} #{utils.captionAngle(d)} 0, 1 #{targetX}, #{targetY}")
            edge.select('path.edge-line')
                .style('stroke', (d) -> utils.edgeStyle(d))
    
        else
            edge.select('.edge-line')
                .each( (d) ->
                    startLine = utils.startLine(d)
                    endLine = utils.endLine(d)
                    d3.select(@).attr(
                        'x1': startLine.x
                        'y1': startLine.y
                        'x2': endLine.x
                        'y2': endLine.y
                        )
                    )

            edge.select('.edge-handler')
                .attr('x', 0)
                .attr('y', -conf.edgeOverlayWidth/2)
                .attr('height', conf.edgeOverlayWidth)
                .attr('width', (d) -> utils.edgeLength(d))
                .attr('transform', (d) -> "translate(#{d.source.x}, #{d.source.y}) rotate(#{utils.edgeAngle(d)})")

        if @directed
            edge.select('.edge-line')
                .attr('marker-end', 'url(#arrow)')

    classEdge: (edge) =>
        edge.classed('active', true)

    styleText: (edge) =>
        utils = new alchemy.drawing.EdgeUtils

        if @curved
            edge.select('text')
                .attr('dx', (d) -> utils.middlePath(d).x)
                .attr('dy', (d) -> utils.middlePath(d).y + 20)
                .attr('transform', (d) -> "rotate(#{utils.captionAngle(d)} #{utils.middlePath(d).x} #{utils.middlePath(d).y})")
                .text((d) -> utils.edgeCaption(d))
        else
            edge.select('text')
                .attr('dx', (d) -> utils.middleLine(d).x)
                .attr('dy', (d) -> utils.middleLine(d).y - 5)
                .attr('transform', (d) -> "rotate(#{utils.captionAngle(d)} #{utils.middleLine(d).x} #{utils.middleLine(d).y})")
                .text((d) -> utils.edgeCaption(d))
