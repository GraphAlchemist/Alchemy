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
            square = (num) ->
                return num * num
            padding = 6
            arrowWidth = 1.2
            shaftRadius = arrowWidth / 2
            headRadius = shaftRadius * 2
            headLength = headRadius * 2
            xDist = edge.source.x - edge.target.x
            yDist = edge.source.y - edge.target.y
            distance = Math.sqrt(square(xDist) + square(yDist))

            # start = { x: 0, y: 0, r: edge.source.radius }
            startX = 0
            startY = 0
            startR = edge.source.radius

            # end = { x: distance, y: 0, r: edge.target.radius }
            endX = distance
            endY = 0
            endR = edge.target.radius

            d = endX - startX

            radiusRatio = (startR + padding) / (endR + headLength + padding)
            homotheticCenter = -d * radiusRatio / (1 - radiusRatio)

            angle = 3 * headRadius * 2 / startR 

            startAttachX = Math.cos(angle) * (startR + padding)
            startAttachY = Math.sin(angle) * (startR + padding)

            gradient = startAttachY / (startAttachX - homotheticCenter)
            hc = startAttachY - gradient * startAttachX
            p = endX

            a = 1 + square(gradient)
            b = 2 * (gradient * hc - p)
            c = square(hc) + square(p) - square(endR + headLength + padding)

            endAttachX = (-(b) - Math.sqrt(square(b) - 4 * a * c)) / (2 * a)
            endAttachY = (endAttachX - homotheticCenter) * gradient

            g1 = -startAttachX / startAttachY
            c1 = startAttachY + (square(startAttachX) / startAttachY)
            g2 = -(endAttachX - endX) / endAttachY
            c2 = endAttachY + (endAttachX - endX) * endAttachX / endAttachY

            cx = (c1 - c2) / (g2 - g1)
            cy = g1 * cx + c1

            arcRadius = Math.sqrt(square(cx - startAttachX) + square(cy - startAttachY))

            startTangent = (dr) ->
                if dr < 0
                    num = -1
                else 
                    num = 1
                dx = num * Math.sqrt(square(dr) / (1 + square(g1)))
                dy = g1 * dx
                return "#{startAttachX + dx}, #{startAttachY + dy}"

            endTangent = (dr) ->
                if dr < 0
                    num = -1
                else 
                    num = 1
                dx = num * Math.sqrt(square(dr) / (1 + square(g2)))
                dy = g2 * dx
                return "#{endAttachX + dx}, #{endAttachY + dy}"

            endNormal = (dc) ->
                if dc < 0
                    num = -1
                else 
                    num = 1
                dx = num * Math.sqrt(square(dc) / (1 + square((1 / g2))))
                dy = dx / g2
                return "#{endAttachX + dx}, #{endAttachY - dy}"
            
            return "
                M #{startTangent(-shaftRadius)}
                L #{startTangent(shaftRadius)}
                A #{arcRadius - shaftRadius}, #{arcRadius - shaftRadius} 0 0 0 #{endTangent(-shaftRadius)}
                L #{endTangent(-headRadius)}
                L #{endNormal(headLength)}
                L #{endTangent(headRadius)}
                L #{endTangent(shaftRadius)}
                A #{arcRadius + shaftRadius}, #{arcRadius + shaftRadius} 0 0 1 #{startTangent(-shaftRadius)}
                Z"
            # straight.  works perfect(?)
            # xDist = Math.abs(edge.source.x - edge.target.x)
            # yDist = Math.abs(edge.source.y - edge.target.y)
            # distance = Math.sqrt(square(xDist) + square(yDist)) - padding
            # return "M #{padding} 0 L #{distance} 0 stroke='white'"


            #curved looks good, but is wrong
            # x = Math.cos(1) * 15
            # y = Math.sin(1) * 15
            # mid = distance / 2
            # return "M #{x} #{y} Q #{mid} 100 #{distance} #{y *2}"
            # return "M 0 0 Q #{mid} 100 #{distance} 0 stroke='white'"

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