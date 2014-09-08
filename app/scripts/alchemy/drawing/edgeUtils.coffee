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

class alchemy.drawing.EdgeUtils
    constructor: ->
        conf = alchemy.conf
        nodes = alchemy._nodes
        edges = alchemy._edges

        # edge styles based on clustering
        if alchemy.conf.cluster
            clustering = alchemy.layout._clustering
            @edgeColour = (d) ->
                clusterKey = alchemy.conf.clusterKey
                if nodes[d.source.id].properties.root or nodes[d.target.id].properties.root
                    index = (if nodes[d.source.id].properties.root then nodes[d.target.id].properties[clusterKey] else nodes[d.source.id].properties[clusterKey])
                    "#{clustering.getClusterColour(index)}"
                else if nodes[d.source.id].properties[clusterKey] is nodes[d.target.id].properties[clusterKey]
                    index = nodes[d.source.id].properties[clusterKey]
                    "#{clustering.getClusterColour(index)}"
                else if nodes[d.source.id].properties[clusterKey] isnt nodes[d.target.id].properties[clusterKey]
                    # use gradient between the two clusters' colours
                    id = "#{nodes[d.source.id].properties[clusterKey]}-#{nodes[d.target.id].properties[clusterKey]}"
                    gid = "cluster-gradient-#{id}"
                    "url(##{gid})"
        else
            @edgeColour = -> ''

        square = (n) -> n * n
        hyp = (edge) ->
            # build a right triangle
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            # as in hypotenuse
            Math.sqrt(height * height + width * width)

        @_edgeWalk = (edge, point) ->
            # build a right triangle
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            # as in hypotenuse 
            hyp = Math.sqrt(height * height + width * width)
            switch point
                when 'middle' then distance = hyp / 2
                when 'linkStart' then distance = edge.source.r + edge.source['stroke-width']
                when 'linkEnd'
                    if conf.curvedEdges
                        distance = hyp
                    else
                        distance = hyp - (edge.target.r + edge.target['stroke-width'])
                    if conf.directedEdges
                        distance = distance - conf.edgeArrowSize

            x: edge.source.x + width  * distance / hyp
            y: edge.source.y + height * distance / hyp

        caption = alchemy.conf.edgeCaption
        if typeof caption is ('string' or 'number')
            @edgeCaption = (d) -> edges[d.id].properties[caption]
        else if typeof caption is 'function'
            @edgeCaption = (d) -> caption(edges[d.id])

    edgeStyle: (d) ->
        edge = alchemy._edges[d.id]
        styles = edge[0].style
        console.log styles
        if @edgeColour(d) is not ''
            styles.fill = @nodeColours d

        styles

    middleLine: (edge) -> @_edgeWalk(edge, 'middle')
    startLine: (edge) ->  @_edgeWalk(edge, 'linkStart')
    endLine: (edge) -> @_edgeWalk(edge, 'linkEnd')
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
    
    captionAngle: (edge) =>
        angle = @edgeAngle(edge)
        if angle < -90 or angle > 90
            angle += 180
        else
            angle
    hyp: (edge) -> hyp(edge)
    middlePath: (edge) ->
            pathNode = d3.select("#path-#{edge.id}").node()
            midPoint = pathNode.getPointAtLength(pathNode.getTotalLength()/2)
 
            x: midPoint.x
            y: midPoint.y