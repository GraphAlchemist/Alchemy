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
    alchemy.edge = alchemy.vis.selectAll("line")
               .data(alchemy.edges)
    alchemy.node = alchemy.vis.selectAll("g.node")
              .data(alchemy.nodes, (d) -> d.id)
              
    if start then @force.start()
    if not initialComputationDone
        while @force.alpha() > 0.005
            alchemy.force.tick()
        initialComputationDone = true
        console.log(Date() + ' completed initial computation')
        if(alchemy.conf.locked) then alchemy.force.stop()

    for node in alchemy.nodes
        alchemy.layout.collide(node)
        alchemy.layout.tick()

    alchemy.styles.edgeGradient(alchemy.edges)

    #draw node and edge objects with all of their interactions
    alchemy.drawing.drawedges(alchemy.edge)
    alchemy.drawing.drawnodes(alchemy.node)

    alchemy.vis.selectAll('g.node')
           .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")

    alchemy.vis.selectAll('.node text')
        .text((d) => @utils.nodeText(d))

    alchemy.node
           .exit()
           .remove()
