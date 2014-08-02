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
                    .attr('x1', (d) -> nodes[d.source]._d3.x)
                    .attr('y1', (d) -> nodes[d.source]._d3.y)
                    .attr('x2', (d) -> nodes[d.target]._d3.x)
                    .attr('y2', (d) -> nodes[d.target]._d3.y)
                    .attr('shape-rendering', 'optimizeSpeed')
                    .attr("style", (d) -> utils.edgeStyle(d))
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
                edge.selectAll('path')
                     .attr('d', (d) ->
                        # high school  trigonometry
                        sourceX = alchemy._nodes[d.source]._d3.x
                        sourceY = alchemy._nodes[d.source]._d3.y
                        targetX = alchemy._nodes[d.target]._d3.x
                        targetY = alchemy._nodes[d.target]._d3.y
                        dx = targetX - sourceX
                        dy = targetY - sourceY
                        hyp = Math.sqrt( dx * dx + dy * dy)
                        "M #{sourceX},#{sourceY} A #{hyp}, #{hyp} #{utils.captionAngle(d)} 0, 1 #{targetX}, #{targetY}")
        if not conf.curvedEdges
            @_createLink = (edge) ->
                edge.append('rect')
                    .attr('class', 'edge-handler')
                edge.append('line')
                edge.append('text')
        else
            @_createLink = (edge) ->
                edge.append('path')
                    .attr('class', 'edge-handler')
                    .style('stroke-width', "#{conf.edgeOverlayWidth}")
                edge.append('path')
                    .attr('class', 'edge-line')
                    .attr('id', (d) -> "path-#{d.id}")
                edge.append('text')
                    .append('textPath')
                    .attr('class', 'textpath') # this is a workaround for a bug in webkit
        if not conf.curvedEdges
            @_styleText = (edge) ->
                edge.select('text')
                    .attr('dx', (d) -> utils.middleLine(d).x)
                    .attr('dy', (d) -> utils.middleLine(d).y)
                    .attr('transform', (d) -> "rotate(#{utils.captionAngle(d)} #{utils.middleLine(d).x} #{utils.middleLine(d).y})")
                    .text((d) -> utils.edgeCaption(d))
        else
            @_styleText = (edge) ->
                edge.select('text')
                    .attr('dx', (d) -> utils.middlePath(d).x)
                    .attr('dy', (d) -> utils.middlePath(d).y + 20)
                    .attr('transform', (d) -> "rotate(#{utils.captionAngle(d)} #{utils.middlePath(d).x} #{utils.middlePath(d).y})")
                    .text((d) -> utils.edgeCaption(d))
        @_setInteractions = (edge) ->
            edge.select('.edge-handler')
                .on('click', (d) -> interactions.edgeClick(d))
        @_classLink = (edge) ->
            edge.classed('active', true)

    createLink: (edge) =>
        @_createLink(edge)

    styleLink: (edge) =>
        @_styleLink(edge)

    classLink: (edge) =>
        @_classLink(edge)

    styleText: (edge) =>
        @_styleText(edge)

    setInteractions: (edge) =>
        @_setInteractions(edge)
