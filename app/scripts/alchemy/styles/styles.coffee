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

alchemy.styles =
    getClusterColour: (index) ->
        if alchemy.conf.clusterColours[index]?
            alchemy.conf.clusterColours[index]
        else
            '#EBECE4'

    edgeGradient: (edges) ->
        defs = d3.select(".alchemy svg").append("svg:defs")
        Q = {}
        for edge in edges
            # skip root
            continue if edge.source.node_type is "root" or edge.target.node_type is "root"
            # skip nodes from the same cluster
            continue if edge.source.cluster is edge.target.cluster
            if edge.target.cluster isnt edge.source.cluster
                id = edge.source.cluster + "-" + edge.target.cluster
                if id of Q
                    continue
                else if id not of Q
                    startColour = @getClusterColour(edge.target.cluster)
                    endColour = @getClusterColour(edge.source.cluster)
                    Q[id] = {'startColour': startColour,'endColour': endColour}
        for ids of Q
            gradient_id = "cluster-gradient-" + ids
            gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
            gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
            gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']
    