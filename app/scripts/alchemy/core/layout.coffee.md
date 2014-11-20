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

    class Layout
        constructor: (instance)->
            @a = a = instance

            conf = @a.conf
            nodes = @a._nodes

            @k = Math.sqrt Math.log(_.size(@a._nodes)) / (conf.graphWidth() * conf.graphHeight())
            @_clustering = new @a.clustering @a
            @d3NodeInternals = a.elements.nodes.d3

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
            if @a.conf.cluster
                @_clustering.layout.gravity @k
            else
                50 * @k

        linkStrength: (edge) =>
            @_linkStrength edge

        friction: () -> 0.9

        collide: (node) ->
            conf = @a.conf
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
                        l = (l - r) / l * conf.alpha
                        node.x -= x *= l
                        node.y -= y *= l
                        quad.point.x += x
                        quad.point.y += y
                x1 > nx2 or
                x2 < nx1 or
                y1 > ny2 or
                y2 < ny1

        tick: (draw) =>
            a     = @a
            nodes = a.elements.nodes.svg
            edges = a.elements.edges.svg

            if a.conf.collisionDetection
                q = d3.geom.quadtree @d3NodeInternals
                for node in @d3NodeInternals
                    q.visit @collide(node)

            nodes.attr "transform", (d) -> "translate(#{d.x},#{d.y})"

            @drawEdge = a.drawing.DrawEdge
            @drawEdge.styleText edges
            @drawEdge.styleLink edges

        positionRootNodes: () ->
            conf = @a.conf
            container =
                width: conf.graphWidth()
                height: conf.graphHeight()

            rootNodes = _.filter @a.elements.nodes.val, (node) -> node.getProperties('root')
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

        chargeDistance: () -> 500

        linkDistancefn: (edge) -> @_linkDistancefn edge

        charge: () -> @_charge()

    Alchemy::generateLayout = (instance)->
        a = instance
        (start=false)->
            conf = a.conf
            a.layout = new Layout a
            a.force = d3.layout.force()
                .size [conf.graphWidth(), conf.graphHeight()]
                .theta 1.0
                .gravity a.layout.gravity()
                .friction a.layout.friction()

                .nodes a.elements.nodes.d3
                .links a.elements.edges.d3
                .linkDistance (link) -> a.layout.linkDistancefn link
                .linkStrength (link) -> a.layout.linkStrength link
                
                .charge a.layout.charge()
                .chargeDistance a.layout.chargeDistance()            