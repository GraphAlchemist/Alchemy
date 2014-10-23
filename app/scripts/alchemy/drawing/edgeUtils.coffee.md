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
            styles = alchemy.svgStyles.edge.update edge
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

The widht of the stroke places a large part in how the arrow lays out with larger edge widths.

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

        # Temporary drop in to reimplement curved directed edges.
        # Will be replaced once the math for the better alternative is worked out.
        curvedDirectedEdgeWalk: (edge, point)->
            conf = alchemy.conf

            # build a right triangle
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            # as in hypotenuse 
            hyp = Math.sqrt(height * height + width * width)

            newpoint = if point is 'middle'
                    distance = (hyp / 2)
                    x: edge.source.x + width * distance / hyp
                    y: edge.source.y + height * distance / hyp
                else if point is 'linkStart'
                    distance = edge.source.radius+ edge.source['stroke-width']
                    x: edge.source.x + width * distance / hyp
                    y: edge.source.y + height * distance / hyp
                else if point is 'linkEnd'
                    if conf.curvedEdges
                        distance = hyp
                    else
                        distance = hyp - (edge.target.radius + edge.target['stroke-width'])
                    if conf.directedEdges
                        distance = distance - conf.edgeArrowSize
                    x: edge.source.x + width * distance / hyp
                    y: edge.source.y + height * distance / hyp
            newpoint
        middleLine: (edge) -> @curvedDirectedEdgeWalk edge, 'middle'
        startLine: (edge) -> @curvedDirectedEdgeWalk edge, 'linkStart'
        endLine: (edge) -> @curvedDirectedEdgeWalk edge, 'linkEnd'
        
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
                
        # Temporary fill in for curved edges until math is completed for new path only edges
        middlePathCurve: (edge) ->
            pathNode = d3.select("#path-#{edge.id}").node()
            midPoint = pathNode.getPointAtLength(pathNode.getTotalLength()/2)

            x: midPoint.x
            y: midPoint.y