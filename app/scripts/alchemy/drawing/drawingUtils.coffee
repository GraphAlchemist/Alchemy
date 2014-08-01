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

alchemy.drawing.drawingUtils = 
    edgeUtils: () ->
        nodes = alchemy._nodes
        # edge styles based on clustering
        if alchemy.conf.cluster
            edgeStyle = (d) ->
                if d.source.root or d.target.root
                    index = (if d.source.root then d.target.cluster else d.source.cluster)
                else if d.source.cluster is d.target.cluster
                    index = d.source.cluster
                else if d.source.cluster isnt d.target.cluster
                    # use gradient between the two clusters' colours
                    id = "#{d.source.cluster}-#{d.target.cluster}"
                    gid = "cluster-gradient-#{id}"
                    return "stroke: url(##{gid})"
                "stroke: #{alchemy.styles.getClusterColour(index)}"
        else if alchemy.conf.edgeStyle and not alchemy.conf.cluster
            edgeStyle = (d) ->
                "#{alchemy.conf.edgeStyle(d)}"
        else
            edgeStyle = (d) -> 
                ""

        square = (n) -> n * n
        edgeWalk = (edge, point) ->
            # build a right triangle
            width  = nodes[edge.target]._d3.x - nodes[edge.source]._d3.x
            height = nodes[edge.target]._d3.y - nodes[edge.source]._d3.y
            # as in hypotenuse 
            hyp = Math.sqrt(height * height + width * width)
            distance = (hyp / 2) if point is "middle"
            return {
                x: edge.source.x + width * distance / hyp
                y: edge.source.y + height * distance / hyp
            }
        edgeAngle = (edge) ->
            width  = nodes[edge.target]._d3.x - nodes[edge.source]._d3.x
            height = nodes[edge.target]._d3.y - nodes[edge.source]._d3.y
            Math.atan2(height, width) / Math.PI * 180
        
        caption = alchemy.conf.edgeCaption
        if typeof caption is ('string' or 'number')
            edgeCaption = (d) -> d[caption]
        else if typeof caption is 'function'
            edgeCaption = (d) -> caption(d)


        middleLine: (edge) -> edgeWalk(edge, 'middle')
        middlePath: (edge) -> 
            # edgeWalk places text as if the line were straight
            # offset the text to lie on the mid point of the path 
        edgeLength: (edge) ->
            # build a right triangle
            width  = nodes[edge.target]._d3.x - nodes[edge.source]._d3.x
            height = nodes[edge.target]._d3.y - nodes[edge.source]._d3.y
            # as in hypotenuse 
            hyp = Math.sqrt(height * height + width * width)
        edgeAngle: (edge) -> edgeAngle(edge)
        edgeStyle: (d) -> edgeStyle(d)
        captionAngle: (edge) -> 
            angle = edgeAngle(edge)
            if angle < -90 or angle > 90
                angle += 180
            else
                angle
        edgeCaption: (d) -> edgeCaption(d)
