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

    DrawNodes = (instance)->
        a: instance
        createNode: (d3Nodes) ->
            drawNode = @a.drawing.DrawNode

            # alchemyNode is an array of one or more alchemyNode._d3 packets
            node = @a.vis.selectAll "g.node"
                     .data d3Nodes, (n) -> n.id

            node.enter().append "g"
                .attr "class", (d) ->
                    nodeType = d.self._nodeType
                    "node #{nodeType} active"
                .attr 'id', (d) -> "node-#{d.id}"
                .classed 'root', (d) -> d.root
            
            drawNode.createNode node
            drawNode.styleNode node
            drawNode.styleText node
            drawNode.setInteractions node
            node.exit().remove()

        updateNode: (alchemyNode) ->
            # alchemyNode is an array of one or more alchemyNode._d3 packets
            drawNode = @a.drawing.DrawNode
            node = @a.vis.select "#node-#{alchemyNode.id}"
            drawNode.styleNode node
            drawNode.styleText node
            drawNode.setInteractions node
