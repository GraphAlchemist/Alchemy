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

class alchemy.Layout
    constructor: ->
        conf = alchemy.conf
        @k = Math.sqrt(_.size(alchemy._nodes) / (conf.graphWidth() * conf.graphHeight()))
        @_clustering = new alchemy.clustering
        
        if conf.cluster
            @_charge = () -> @_clustering.layout.charge
        else
            @_charge = () -> -10 / @k

        if conf.cluster
            @_linkDistancefn = (edge) -> @_clustering.linkDistancefn(edge)
        else if typeof conf.linkDistancefn is ('number' or 'string')
            @_linkDistancefn = (edge) -> conf.linkDistancefn
        else if typeof conf.linkDistancefn is 'function'
            conf.linkDistancefn(edge)

        if alchemy.conf.cluster
            @_linkStrength = (edge) -> @_clustering.layout.linkStrength(edge)
        else
            @_linkStrength = (edge) ->
                nodes = alchemy._nodes
                if nodes[edge.source.id].properties.root or nodes[edge.target.id].properties.root
                    0.5
                else
                    0.8

    gravity: () =>
        100 * @k

    linkStrength: (edge) =>
        @_linkStrength(edge)

    friction: () ->
        if alchemy.conf.cluster
            0.7
        else
            0.9

    collide: (node) =>
        node = node._d3
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

    tick: () =>
        if alchemy.conf.collisionDetection
            q = d3.geom.quadtree(_.map(alchemy._nodes, (node) -> node._d3))
            for node in _.values(alchemy._nodes)
                q.visit(@collide(node))

        # Isabella, use node generator?
        alchemy.node
            .attr("transform", (d) -> 
                # node_data = alchemy._nodes[d.id]._d3
                "translate(#{d.x},#{d.y})")

        drawEdge = new alchemy.drawing.DrawEdge
        drawEdge.styleText(alchemy.edge)
        drawEdge.styleLink(alchemy.edge)

    positionRootNodes: () ->
        conf = alchemy.conf
        container = 
            width: conf.graphWidth()
            height: conf.graphHeight()
        
        rootNodes = _.compact(_.map(alchemy._nodes, (node) -> if node.properties.root then node))
        
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
                alchemy._nodes[n.id]._d3.x = container.width / Math.sqrt((rootNodes.length * number))
                alchemy._nodes[n.id]._d3.y = container.height / 2
                alchemy._nodes[n.id]._d3.fixed = true

    chargeDistance: () ->
        500

    linkDistancefn: (edge) =>
        @_linkDistancefn(edge)

    charge: () ->
        @_charge()
            