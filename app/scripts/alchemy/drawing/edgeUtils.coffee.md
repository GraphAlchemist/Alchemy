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

    alchemy.drawing.EdgeUtils =
        edgeStyle: (d) ->
            edge = alchemy._edges[d.id][d.pos]
            styles = alchemy.svgStyles.edge.populate edge
            nodes = alchemy._nodes

            # edge styles based on clustering
            if alchemy.conf.cluster
                clustering = alchemy.layout._clustering
                styles.stroke = do (d) ->
                    nodes = alchemy._nodes
                    clusterKey = alchemy.conf.clusterKey
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

        triangle: (edge) ->
            width = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y

            width: width
            height: height
            hyp: Math.sqrt height * height + width * width

This is the primary function used to draw the svg paths between
two nodes for directed or undirected noncurved edges. 

        edgeWalk: (edge) ->
            arrowSize = alchemy.conf.edgeArrowSize
            arrowScale = 0.3
            
Build a right triangle.

            triangle = @triangle(edge)
            width  = triangle.width
            height = triangle.height
            hyp = triangle.hyp

The width of the stroke places a large part in how the arrow lays out with larger edge widths.

            edgeWidth = edge['stroke-width']

After all of our calculations, we offset the edge by 2 pixels to account for the curve of the node.
This typically is only noticable with opaque styles.

            curveOffset = 2

We start the edge at the very *edge* of the node, taking into account distances created by the stroke-width of the node
and edge itself.  The length of startPathX is then accounted for in the edgeLength.

            startPathX = 0 + edge.source.radius + edge.source['stroke-width'] - (edgeWidth / 2) + curveOffset
            edgeLength = hyp - startPathX - curveOffset * 1.5


The absolute angle of the edge used for caption rendering and
path rendering.

            edgeAngle: Math.atan2(height, width) / Math.PI * 180

The start of the edge in absolute coordinates.  The start of the edge and end
of the edge are simply the center of the source and target nodes.

            startEdgeX: edge.source.x
            startEdgeY: edge.source.y

            #endEdgeX: edge.target.x + (width * edge.target.radius + edge.target['stroke-width']) / hyp
            #endEdgeY: edge.target.y + (height * edge.target.radius + edge.target['stroke-width']) / hyp

The middle point of the edge, where the caption will be anchored.

            midLineX: edge.source.x + width / 2
            midLineY: edge.source.x + height / 2
            endLineX: edge.source.x + width / hyp
            endLineY: edge.source.x + height / hyp
            
Here we offset the start of the path to the very edge of the node by adding the stroke-width and the radius.
Additionally, we account for the 'stroke-width' of the edge itself, and then offeset that by one pixel to account
for the curve of the node.

            startPathX: startPathX
            startPathBottomY: edgeWidth / 2
            
            arrowBendX: edgeLength - arrowSize
            arrowBendBottomY: edgeWidth / 2
            
            arrowTipBottomY: edgeWidth / 2 + (arrowSize * arrowScale)
            
            arrowEndX: edgeLength
            arrowEndY: 0
            
            arrowTipTopY: -(arrowSize * arrowScale + edgeWidth / 2)
            
            arrowBendTopY: - edgeWidth / 2

            startPathTopY: - edgeWidth / 2

            edgeLength: edgeLength

        
        curvedEdgeWalk: (edge) ->
            arrowSize = alchemy.conf.edgeArrowSize
            arrowScale = 0.3
            arrowLength = arrowSize
            arrowWidth = arrowSize * arrowScale
            
            arrowAngle = -45

Pixel spacing ("padding") between node and edge
            
            padding = 0

            triangle = @triangle(edge)
            width  = triangle.width
            height = triangle.height
            hyp = triangle.hyp

            if height < 0 then arrowAngle = -arrowAngle

            edgeWidth = edge['stroke-width']

            startRadius = edge.source.radius + edge.source['stroke-width']
            endRadius = edge.target.radius + edge.target['stroke-width']
            
            radiusRatio = (startRadius + padding ) / (endRadius + arrowSize + padding)

            square = (n) -> n * n

Yes, the [homotheticCenter](http://en.wikipedia.org/wiki/Homothetic_center)
            
            homotheticCenter = -width * radiusRatio / (1 - radiusRatio)

            # rename
            intersectWithOtherCircle = (fixedPointX, fixedPointY, radius, xCenter, polarity) ->

Some context for gradient, `tan(gradient) =  "opposite" / "adjacent" 
                
                gradient = fixedPointY / (fixedPointX - homotheticCenter)

The internal homotheticCenter = "opposite" - tan(theta) * "adjacent"
A is sec2(theta) = 1 + square(tan(theta))
B is 
     
                internalHC = fixedPointY - gradient * fixedPointX
                A = 1 + square(gradient)
                B = 2 * (gradient * internalHC - xCenter)
                C = square(internalHC) + square(xCenter) - square(radius)
                intersection = {x: (-B + polarity * Math.sqrt(Math.abs(square(B) - 4 * A * C))) / (2 * A)}
                intersection.y = (intersection.x - homotheticCenter) * gradient
                intersection

            
            #if edge.target.radius + arrowSize > edge.source.radius
            #offsetAngle = minOffset / edge.source.radius
            offsetAngle = (arrowAngle * Math.PI) / (180 * startRadius)
            pathStartX = Math.cos( offsetAngle ) * ( startRadius + padding )
            pathStartY = Math.sin( offsetAngle ) * ( startRadius + padding )
            intersection = intersectWithOtherCircle(pathStartX, pathStartY, endRadius + arrowLength, hyp, -1)
            pathEndX = intersection.x
            pathEndY = intersection.y
            
            #else
            #    offsetAngle = minOffset / endRadius;
            #    endAttach = {
            #        x: endCentre - Math.cos( offsetAngle ) * (endRadius + headLength),
            #        y: Math.sin( offsetAngle ) * (endRadius + headLength)
            #    }
            #    startAttach = intersectWithOtherCircle( endAttach, startRadius, 0, 1 )

            g1 = - pathStartX / pathEndY
            c1 = pathStartY + (pathStartX * pathStartX) / pathStartY
            g2 = -( pathEndX - hyp ) / pathEndY
            c2 = pathEndY + (pathEndX - hyp) * pathEndX / pathEndY

            cx = (c1 - c2) / (g2 - g1)
            cy = g1 * cx + c1

            arcRadius = Math.sqrt( square(cx - pathStartX) + square(cy - pathStartY) )

            # change name?
            startTangent = (dr) ->
                dx = (if dr < 0 then -1 else 1) * Math.sqrt(dr * dr / (1 + g1 * g1))
                dy = g1 * dx
                "#{pathStartX + dx}, #{pathStartY + dy}"

            endTangent = (dr) ->
                dx = (if dr < 0 then -1 else 1) * Math.sqrt( dr * dr / (1 + g2 * g2) )
                dy = g2 * dx
                "#{pathEndX + dx}, #{pathEndY + dy}"

            endNormal = (dc) ->
                dx = (if dc < 0 then -1 else 1) * Math.sqrt( dc * dc / (1 + (1 / g2) * (1 / g2)) )
                dy = dx / g2
                "#{pathEndX + dx}, #{pathEndY - dy}"
            
            # STTest = (dr) ->
            #     dx = (if dr < 0 then -1 else 1) * Math.sqrt(dr * dr / (1 + g1 * g1))
            #     dy = g1 * dx
                
            #     x: pathStartX + dx
            #     y: pathStartY + dy

            # ETTest = (dr) ->
            #     dx = (if dr < 0 then -1 else 1) * Math.sqrt( dr * dr / (1 + g2 * g2) )
            #     dy = g2 * dx
                
            #     x: pathEndX + dx
            #     y: pathEndY + dy

            # ENTest = (dc) ->
            #     dx = (if dc < 0 then -1 else 1) * Math.sqrt( dc * dc / (1 + (1 / g2) * (1 / g2)) )
            #     dy = dx / g2
                
            #     x: pathEndX + dx
            #     y: pathEndY - dy

            # edgeEl = d3.select("#edge-"+ edge.id + "-" + edge.pos)

            # test = STTest(-edgeWidth)
            
            # edgeEl.append('circle')
            #      .attr('r', 1)
            #      .attr('cx', test.x)
            #      .attr('cy', test.y)
            #      .attr('style', 'stroke: red !important;')

            # test = STTest(edgeWidth)
            # edgeEl.append('circle')
            #      .attr('r', 1)
            #      .attr('cx', test.x)
            #      .attr('cy', test.y)
            #      .attr('style', 'stroke: blue !important;')

            # test = ETTest(-edgeWidth)
            # edgeEl.append('circle')
            #      .attr('r', 1)
            #      .attr('cx', test.x)
            #      .attr('cy', test.y)
            #      .attr('style', 'stroke: orange !important;')

            # test = ETTest(edgeWidth)
            # edgeEl.append('circle')
            #      .attr('r', 1)
            #      .attr('cx', test.x)
            #      .attr('cy', test.y)
            #      .attr('style', 'stroke: #ff00de !important;')
            
            #              0, 0, #{if minOffset > 0 then 0 else 1},
            """
            M #{startTangent(-edgeWidth)},
            L #{startTangent(edgeWidth)},
            A #{arcRadius - edgeWidth}, #{arcRadius - edgeWidth},
               0, 0, 1,
              #{endTangent(-edgeWidth)},
            L #{endTangent(-arrowWidth)},
            L #{endNormal(arrowLength)},
            L #{endTangent(arrowWidth)},
            L #{endTangent(edgeWidth)},
            A #{arcRadius +  edgeWidth}, #{arcRadius + edgeWidth},
              0, 0, 0,
              #{startTangent(-edgeWidth)},
            """           
            # First arc is on bottom of path, bending up...

        # middleLine: (edge) -> @edgeWalk edge, 'middle'
        # startLine: (edge) -> @edgeWalk edge, 'linkStart'
        endLine: (edge) -> @edgeWalk edge, 'linkEnd'
        
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
        middlePath: (edge) ->
                pathNode = alchemy.vis
                                  .select "#path-#{edge.id}"
                                  .node()
                midPoint = pathNode.getPointAtLength pathNode.getTotalLength()/2
     
                x: midPoint.x
                y: midPoint.y