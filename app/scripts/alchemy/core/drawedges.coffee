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

alchemy.drawing.drawedges = (edge) ->  
    if alchemy.conf.cluster
        edgeStyle = (d) ->
            if d.source.node_type is "root" or d.target.node_type is "root"
                index = (if d.source.node_type is "root" then d.target.cluster else d.source.cluster)
            else if d.source.cluster is d.target.cluster
                index = d.source.cluster
            else if d.source.cluster isnt d.target.cluster
                # use gradient between the two clusters' colours
                id = "#{d.source.cluster}-#{d.target.cluster}"
                gid = "cluster-gradient-#{id}"
                return "stroke: url(##{gid})"
            "stroke: #{alchemy.styles.getClusterColour(index)}"
    else if alchemy.conf.edgeColour and not alchemy.conf.cluster
        edgeStyle = (d) ->
            "stroke: #{alchemy.conf.edgeColour}"
    else
        edgeStyle = (d) -> 
            ""
    
    edge.enter()
        .insert("line", 'g.node')
        .attr("class", (d) -> 
            "edge #{d.caption} active #{if d.shortest then 'highlighted' else ''}")
        .attr('source-target', (d) -> d.source.id + '-' + d.target.id)
        .on('click', alchemy.interactions.edgeClick)
    edge.exit().remove()

    edge.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)
        .attr('shape-rendering', 'optimizeSpeed')
        .attr "style", (d) -> edgeStyle(d)

