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

    edgeWalk: (edge) ->
        arrowSize = alchemy.conf.edgeArrowSize
        triangle = @triangle(edge)
        # build a right triangle
        width  = triangle.width
        height = triangle.height
        # as in hypotenuse 
        hyp = triangle.hyp
        edgeWidth = edge.style['stroke-width']
        debugger
        
        edgeAngle: Math.atan2(height, width) / Math.PI * 180

        # start and end are in the middle of the node
        startLineX: edge.source.x + width / hyp
        startLineY: edge.source.y + height / hyp
        midLineX: edge.source.x + width / 2
        midLineY: edge.source.x + height / 2
        endLineX: edge.source.x + width / hyp
        endLineY: edge.source.x + height / hyp
        
        # path x and y are relative to the <g> parent element
        startPathX: 0
        startPathY: edgeWidth

        L1X: hyp
        L1Y: edgeWidth

        L2X: hyp
        L2Y: edgeWidth + arrowSize

        L3X: hyp + arrowSize
        L3Y: 0

        L4X: hyp
        L4Y: -arrowSize

        L5X: 0
        L5Y: -arrowSize

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
    
    captionAngle: (edge) ->
        angle = @edgeAngle(edge)
        if angle < -90 or angle > 90
            angle += 180
        else
            angle
    middlePath: (edge) ->
            pathNode = alchemy.vis
                              .select "#path-#{edge.id}"
                              .node()
            midPoint = pathNode.getPointAtLength pathNode.getTotalLength()/2
 
            x: midPoint.x
            y: midPoint.y