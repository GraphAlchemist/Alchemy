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

alchemy.drawing.drawEdges = (edge) ->  
    
    edge.enter().append('g')
                .attr('class', 'edge')
                .attr('source-target', (d) -> d.source.id + '-' + d.target.id)
    
    if not alchemy.conf.curvedEdges
        edge.append('line')
    else
        edge.append('path')
    
    # notes on proper appending of caption to curved edges
    # edge.append('use')
    #     .attr('xlink:href', (d) ->
    #         d3.select("#{alchemy.conf.divSelector} svg defs")
    #             .append('path')
    #             .attr('source-target', "#{d.source.id}-#{d.target.id}")
    #         "#{d.source.id}-#{d.target.id}")


    edge.append('text')

    drawEdge = @drawEdge()
    
    drawEdge.styleLink(edge)
    drawEdge.styleText(edge)

    # alchemy.drawing.drawEdge(edge)
    edge.exit().remove()
