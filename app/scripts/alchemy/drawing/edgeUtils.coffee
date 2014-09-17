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
        edge = alchemy._edges[d.id]
        styles = edge[d.pos]._style
        nodes = alchemy._nodes

        # edge styles based on clustering
        if alchemy.conf.cluster
            clustering = alchemy.layout._clustering
            edgeColour = (d) ->
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
        else
            edgeColour = -> ''

        if edgeColour(d) is not ''
            styles.fill = @nodeColours d

        styles

    edgeWalk: (edge, point) ->
        conf = alchemy.conf

        # build a right triangle
        width  = edge.target.x - edge.source.x
        height = edge.target.y - edge.source.y
        # as in hypotenuse 
        hyp = Math.sqrt height * height + width * width
        switch point
            when 'middle' then distance = hyp / 2
            when 'linkStart' then distance = edge.source.radius + edge.source['stroke-width']
            when 'linkEnd'
                if conf.curvedEdges
                    distance = hyp
                else
                    distance = hyp - (edge.target.radius + edge.target['stroke-width'])
                if conf.directedEdges
                    distance = distance - conf.edgeArrowSize

        x: edge.source.x + width  * distance / hyp
        y: edge.source.y + height * distance / hyp

    middleLine: (edge) -> @edgeWalk edge, 'middle'
    startLine: (edge) -> @edgeWalk edge, 'linkStart'
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
            pathNode = d3.select("#path-#{edge.id}").node()
            midPoint = pathNode.getPointAtLength pathNode.getTotalLength()/2
 
            x: midPoint.x
            y: midPoint.y