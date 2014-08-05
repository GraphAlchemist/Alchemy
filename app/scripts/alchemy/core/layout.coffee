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
# class alchemy.layout.force
#     constructor: 
#         @gravity
#         @charge
#         @linkStrength
#         @linkDistancefn
#         @friction
#         @collide

alchemy.layout =
    gravity: (k) ->
        8 * k

    charge: (k) ->
        if alchemy.conf.cluster
            -500
        else
            -10 / k

    linkStrength: (edge) ->
        sourceNode = alchemy._nodes[edge.source.id]
        targetNode = alchemy._nodes[edge.target.id]
        if alchemy.conf.cluster
            if sourceNode.properties.cluster is targetNode.properties.cluster then 1 else 0.1
        else
            if sourceNode.properties.root or targetNode.properties.root
                0.9
            else
                1

    friction: () ->
        if alchemy.conf.cluster
            0.7
        else
            0.9

    # cluster: (alpha) ->
    #     centroids = {}
    #     alchemy.nodes.forEach (d) ->
    #         if d.cluster == ''
    #             return
    #         if d.cluster not in centroids
    #             centroids[d.cluster] = {'x':0, 'y':0, 'c':0}
    #         centroids[d.cluster].x += d.x
    #         centroids[d.cluster].y += d.y
    #         centroids[d.cluster].c++

    #     for c in centroids
    #         c.x = c.x / c.c
    #         c.y = c.y / c.c

    #     (d) ->
    #         if d.cluster is '' then return
    #         c = centroids[d.cluster]
    #         x = d.x - c.x
    #         y = d.y - c.y
    #         l = Math.sqrt( x * x * y * y)
    #         if l > nodeRadius * 2 + 5
    #             l = (l - nodeRadius) / l * alpha
    #             d.x -= x * l
    #             d.y -= y * l


    collide: (node) ->
        r = 2.2 * alchemy.utils.nodeSize(node) + alchemy.conf.nodeOverlap
        nx1 = node.x - r
        nx2 = node.x + r
        ny1 = node.y - r
        ny2 = node.y + r
        return (quad, x1, y1, x2, y2) ->
            if quad.point and (quad.point isnt node)
                x = node.x - Math.abs(quad.point.x)
                y = node.y - quad.point.y
                l = Math.sqrt(x * x + y * y)
                r = r
                if l < r
                    l = (l - r) / l * alchemy.conf.alpha
                    node.x -= x *= l
                    node.y -= y *= l
                    quad.point.x += x
                    quad.point.y += y
            x1 > nx2 or
            x2 < nx1 or
            y1 > ny2 or
            y2 < ny1

    tick: () ->
        if alchemy.conf.collisionDetection
            q = d3.geom.quadtree(_.keys(alchemy._nodes))
            for node in _.values(alchemy._nodes)
                q.visit(alchemy.layout.collide(node))

        alchemy.node
            .attr("transform", (d) -> "translate(#{d.x},#{d.y})")

        drawEdge = new alchemy.drawing.DrawEdge
        drawEdge.styleText(alchemy.edge)
        drawEdge.styleLink(alchemy.edge)

    positionRootNodes: () ->
        container = 
            width: alchemy.conf.graphWidth()
            height: alchemy.conf.graphHeight()
        rootNodes = Array()
        for id, d in alchemy._nodes
            if not d[alchemy.conf.rootNodes] then continue
            else
                # n.i = i
                rootNodes.push(n)
        # if there is one root node, position it in the center
        if rootNodes.length == 1
            n = rootNodes[0]
            node_data = alchemy._nodes[n.id]
            node_data._d3.x = container.width / 2
            node_data._d3.y = container.height / 2
            node_data._d3.px = container.width / 2
            node_data._d3.py = container.height / 2
            # fix root nodes until force layout is complete
            node_data._d3.fixed = true
            return
        # position nodes towards center of graph
        else
            number = 0
            for n in rootNodes
                number++
                alchemy._nodes[n.id]._d3.x = container.width / Math.sqrt((rootNodes.length * number))#container.width / (rootNodes.length / ( number * 2 ))
                alchemy._nodes[n.id]._d3.y = container.height / 2 #container.height / (rootNodes.length / number)
                alchemy._nodes[n.id]._d3.fixed = true

    chargeDistance: () ->
         distance = 500
         distance

    linkDistancefn: (edge, k) ->
        if alchemy.conf.cluster
            if edge.source.root or edge.target.root then 300
            if edge.source.cluster is edge.target.cluster then 10 else 600
        else
            10 / (k * 5)
            
