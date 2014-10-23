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

    alchemy.drawing.DrawEdges =
        createEdge: (d3Edges) ->
            drawEdge = alchemy.drawing.DrawEdge
            edge = alchemy.vis.selectAll "g.edge"
                            .data d3Edges
            edge.enter().append 'g'
                        .attr "id", (d) -> "edge-#{d.id}-#{d.pos}"
                        .attr 'class', (d)->
                            "edge #{d.edgeType}"
                        .attr 'source-target', (d) -> "#{d.source.id}-#{d.target.id}"    
            drawEdge.createLink edge
            drawEdge.classEdge edge
            drawEdge.styleLink edge
            drawEdge.styleText edge
            drawEdge.setInteractions edge
            edge.exit().remove()

            if alchemy.conf.directedEdges and alchemy.conf.curvedEdges
                edge.select('.edge-line')
                    .attr('marker-end', 'url(#arrow)')

        updateEdge: (d3Edge) ->
            drawEdge = alchemy.drawing.DrawEdge
            edge = alchemy.vis.select "#edge-#{d3Edge.id}-#{d3Edge.pos}"
            drawEdge.classEdge edge
            drawEdge.styleLink edge
            drawEdge.styleText edge
            drawEdge.setInteractions edge
