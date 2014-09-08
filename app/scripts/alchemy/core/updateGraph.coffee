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

alchemy.updateGraph = (start=true) ->

    #enter/exit nodes/edges
    alchemy.edge = alchemy.vis.selectAll("g.edge")
                        .data -> alchemy.flatEdges
    # alchemy.edge = alchemy.vis.selectAll("g.edge")
    #              .data(_.map(alchemy._edges, (e) -> e._d3), (e)-> e.id) 
    alchemy.node = alchemy.vis.selectAll("g.node")
                .data(_.map(alchemy._nodes, (n) -> n._d3), (n)-> n.id)

    if start
        alchemy.layout.positionRootNodes()
        @force.start()
        while @force.alpha() > 0.005
            alchemy.force.tick()

        drawEdges = new alchemy.drawing.DrawEdges
        drawEdges.createEdge(alchemy.edge)
        drawNodes = new alchemy.drawing.DrawNodes
        drawNodes.createNode(alchemy.node)

        initialComputationDone = true
        console.log(Date() + ' completed initial computation')

    alchemy.vis.selectAll('g.node')
           .attr('transform', (id, i) -> "translate(#{id.x}, #{id.y})")

    alchemy.node
           .exit()
           .remove()
