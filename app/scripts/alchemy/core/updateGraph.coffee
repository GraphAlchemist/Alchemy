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
    alchemy.layout.positionRootNodes()
    #enter/exit nodes/edges

    nodeIDs = Object.keys(alchemy._nodes)

    alchemy.edge = alchemy.vis.selectAll("line")
               .data(alchemy._edges)
    alchemy.node = alchemy.vis.selectAll("g.node")
                .data(_.map(nodeIDs, (n) -> 
                    alchemy._nodes[n]._d3.id = "#{n}"
                    alchemy._nodes[n]._d3))

    # alchemy.node = alchemy.vis.selectAll("g.node")
    #                     .data(nodeIDs, (d) ->
    #                         console.log alchemy._nodes[d]
    #                         console.log alchemy._nodes[d].d3_internal 
    #                         alchemy._nodes[d].d3_internal)
              
    if start then @force.start()
    if not initialComputationDone
        while @force.alpha() > 0.005
            alchemy.force.tick()
        initialComputationDone = true
        console.log(Date() + ' completed initial computation')
        if(alchemy.conf.locked) then alchemy.force.stop()


    alchemy.layout.tick()

    alchemy.styles.edgeGradient(alchemy._edges)

    # draw nodes and edges
    alchemy.drawing.drawedges(alchemy.edge)
    alchemy.drawing.drawnodes(alchemy.node)

    alchemy.vis.selectAll('g.node')
           .attr('transform', (id, i) -> "translate(#{id.x}, #{id.y})")

    alchemy.vis.selectAll('.node text')
        .html((d) => @utils.nodeText(d))

    alchemy.node
           .exit()
           .remove()
