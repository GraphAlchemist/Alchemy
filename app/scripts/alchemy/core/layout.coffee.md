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
            nodes = alchemy._nodes
            @k = Math.sqrt Math.log(_.size(alchemy._nodes)) / (conf.graphWidth() * conf.graphHeight())
            @_clustering = new alchemy.clustering
            @d3NodeInternals = _.map alchemy._nodes, (v,k)-> v._d3

            if conf.cluster
                @_charge = () -> @_clustering.layout.charge
                @_linkStrength = (edge) -> @_clustering.layout.linkStrength(edge)
            else
                @_charge = () -> -10 / @k
                @_linkStrength = (edge) ->
                    if nodes[edge.source.id].getProperties('root') or nodes[edge.target.id].getProperties('root')
                        1
                    else
                        0.9

            if conf.cluster
                @_linkDistancefn = (edge) -> @_clustering.layout.linkDistancefn(edge)
            else if conf.linkDistancefn is 'default'
                @_linkDistancefn = (edge) ->
                    1 / (@k * 50)
            else if typeof conf.linkDistancefn is 'number'
                @_linkDistancefn = (edge) -> conf.linkDistancefn
            else if typeof conf.linkDistancefn is 'function'
                @_linkDistancefn = (edge) -> conf.linkDistancefn(edge)

            

        gravity: () =>
            if alchemy.conf.cluster
                @_clustering.layout.gravity @k
            else
                50 * @k

        linkStrength: (edge) =>
            @_linkStrength edge

        friction: () -> 0.9

        collide: (node) ->
            conf = alchemy.conf
            r = 2 * (node.radius + node['stroke-width']) + conf.nodeOverlap
            nx1 = node.x - r
            nx2 = node.x + r
            ny1 = node.y - r
            ny2 = node.y + r
            return (quad, x1, y1, x2, y2) ->
                if quad.point and (quad.point isnt node)
                    x = node.x - Math.abs quad.point.x
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
            if alchemy.conf.collisionDetectionls
                q = d3.geom.quadtree @d3NodeInternals
                for node in @d3NodeInternals
                    q.visit @collide(node)

            # alchemy.node
            alchemy.vis
                .selectAll "g.node"
                .attr "transform", (d) -> "translate(#{d.x},#{d.y})"

            edges = alchemy.vis.selectAll "g.edge"
            @drawEdge = alchemy.drawing.DrawEdge
            @drawEdge.styleText edges
            @drawEdge.styleLink edges

        positionRootNodes: () ->
            conf = alchemy.conf
            container =
                width: conf.graphWidth()
                height: conf.graphHeight()

            rootNodes = _.filter alchemy.get.allNodes(), (node) -> node.getProperties('root')
            # if there is one root node, position it in the center
            if rootNodes.length is 1
                n = rootNodes[0]
                [n._d3.x, n._d3.px] = [container.width / 2, container.width / 2]
                [n._d3.y, n._d3.py] = [container.height/ 2, container.height/ 2]
                # fix root nodes until force layout is complete
                n._d3.fixed = true
                return
            # position nodes towards center of graph
            else
                for n, i in rootNodes
                    n._d3.x = container.width / Math.sqrt(rootNodes.length * (i+1))
                    n._d3.y = container.height / 2
                    n._d3.fixed = true

        chargeDistance: () ->
            500

        linkDistancefn: (edge) =>
            @_linkDistancefn edge

        charge: () ->
            @_charge()

    alchemy.generateLayout = (start=false)->
        conf = alchemy.conf

        alchemy.layout = new alchemy.Layout
        alchemy.force = d3.layout.force()
            .size [conf.graphWidth(), conf.graphHeight()]
            .nodes _.map(alchemy._nodes, (node) -> node._d3)
            .links _.flatten(_.map(alchemy._edges, (edgeArray) -> e._d3 for e in edgeArray))

        alchemy.force
            .charge alchemy.layout.charge()
            .linkDistance (link) -> alchemy.layout.linkDistancefn(link)
            .theta 1.0
            .gravity alchemy.layout.gravity()
            .linkStrength (link) -> alchemy.layout.linkStrength(link)
            .friction alchemy.layout.friction()
            .chargeDistance alchemy.layout.chargeDistance()
