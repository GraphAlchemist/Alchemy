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

    Alchemy::EdgeUtils = (instance)->
        a: instance
        edgeStyle: (d) ->
            conf = @a.conf
            edge = @a._edges[d.id][d.pos]
            styles = @a.svgStyles.edge.update edge
            nodes = @a._nodes

            # edge styles based on clustering
            if @a.conf.cluster
                clustering = @a.layout._clustering
                styles.stroke = do (d) ->
                    clusterKey = conf.clusterKey
                    source = nodes[d.source.id]._properties
                    target = nodes[d.target.id]._properties
                    if source.root or target.root
                        index = if source.root then target[clusterKey] else source[clusterKey]
                        "#{clustering.getClusterColour(index)}"
                    else if source[clusterKey] is target[clusterKey]
                        index = source[clusterKey]
                        "#{clustering.getClusterColour(index)}"
                    else if source[clusterKey] isnt target[clusterKey]
                        # use gradient between the two clusters' colours
                        id = "#{source[clusterKey]}-#{target[clusterKey]}"
                        gid = "cluster-gradient-#{id}"
                        "url(##{gid})"

            styles

This is the primary function used to draw the svg paths between
two nodes for directed or undirected noncurved edges. 

        edgeWalk: (edge) ->
            a = @a
            conf = a.conf

            distance = Math.abs(edge.source.x - edge.target.x)
            padding = 1
            shaftRadius = edge["stroke-width"]
            arrowWidth = shaftRadius * 2
            headRadius = shaftRadius * 2
            headLength = headRadius * 2

            start = { x: edge.source.x, y: edge.source.y, r: edge.source.radius }
            end = { x: edge.target.x, y: edge.target.y, r: edge.target.radius }

            d = end.x - start.x

            radiusRatio = (start.r + padding) / (end.r + headLength + padding)
            homotheticCenter = -d * radiusRatio / (1 - radiusRatio)

            offsets = [-3, -2, -1, 1, 2, 3]

            curves = _.map offsets, (offset) ->
                square = (num) ->
                    return num * num

                angle = offset * headRadius * 2 / start.r

                startAttach = { x: Math.cos( angle ) * (start.r + padding), y: Math.sin( angle ) * (start.r + padding) }
                gradient = startAttach.y / (startAttach.x - homotheticCenter)
                hc = startAttach.y - gradient * startAttach.x
                p = end.x

                A = 1 + square(gradient)
                B = 2 * (gradient * hc - p)
                C = square(hc) + square(p) - square(end.r + headLength + padding)

                endAttach = { x: (-B - Math.sqrt( square( B*2 ) - 4 * A * C )) / (2 * A) }
                endAttach.y = (endAttach.x - homotheticCenter) * gradient

                g1 = -startAttach.x / startAttach.y
                c1 = startAttach.y + (square( startAttach.x ) / startAttach.y)
                g2 = -(endAttach.x - end.x) / endAttach.y
                c2 = endAttach.y + (endAttach.x - end.x) * endAttach.x / endAttach.y

                cx = ( c1 - c2 ) / (g2 - g1)
                cy = g1 * cx + c1

                arcRadius = 5 # Math.sqrt(square(cx - startAttach.x) + square(cy - startAttach.y))
                startTangent = (dr) ->
                    dx = (dr < 0 ? -1 : 1) * Math.sqrt(square(dr) / (1 + square(g1)))
                    dy = g1 * dx
                    return [
                        startAttach.x + dx + start.x,
                        startAttach.y + dy + start.y
                    ].join(",")

                endTangent = (dr) ->
                    dx = (dr < 0 ? -1 : 1) * Math.sqrt(square(dr) / (1 + square(g2)))
                    dy = g2 * dx
                    return [
                        end.x,  
                        end.y
                    ].join(",")

                endNormal = (dc) ->
                    dx = (dc < 0 ? -1 : 1) * Math.sqrt(square(dc) / (1 + square(1 / g2)))
                    dy = dx / g2
                    return [
                        end.x + dx,
                        end.y - dy
                    ].join(",")

                return path: [
                        "M", startTangent(-shaftRadius),
                        "L", startTangent(shaftRadius),
                        "A", arcRadius - shaftRadius, arcRadius - shaftRadius, 0, 0, (if offset > 0 then 0 else 1), endTangent(-shaftRadius),
                        "L", endTangent(-headRadius),
                        "L", endNormal(headLength),
                        "L", endTangent(headRadius),
                        "L", endTangent(shaftRadius),
                        "A", arcRadius + shaftRadius, arcRadius + shaftRadius, 0, 0, (if offset < 0 then 0 else 1), startTangent(-shaftRadius)
                    ].join( " " )
            
            console.log curves
            return curves[3].path

        triangle: (edge) ->
            width = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            hyp = Math.sqrt height * height + width * width
            [width, height, hyp]

        edgeData: (edge) ->
            [width, height, hyp] = @triangle edge

            edgeWidth = edge['stroke-width']

            curveOffset = 2

            startPathX = edge.source.radius + edge.source['stroke-width'] - (edgeWidth / 2) + curveOffset
            edgeLength = hyp - startPathX - curveOffset * 1.5

            edgeAngle: Math.atan2(height, width) / Math.PI * 180
            edgeLength: edgeLength

        edgeLength: (edge) ->
            # build a right triangle
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            # as in hypotenuse 
            hyp = Math.sqrt(height * height + width * width)
        edgeAngle: (edge) ->
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            Math.atan2(height, width) / Math.PI * 180
        
        captionAngle: (angle) ->
            if angle < -90 or angle > 90
                180
            else
                0