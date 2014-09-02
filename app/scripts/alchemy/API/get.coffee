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

###
API get methods
###

_.extend alchemy,
    getNodes: (id, ids...) ->
        # returns one or more nodes as an array
        if ids
            ids.push(id)
            params = _.union(ids)
            results = []
            for p in params
                results.push(alchemy._nodes[p].properties)
            results
        else
            debugger
            [@_nodes[id].properties]

    getEdges: (id=null, target=null) ->
        # returns one or more edges as an array
        if id? and target?
            edge_id = "#{id}-#{target}"
            edge = @_edges[edge_id]
            [edge.properties]
        else if id? and not target?
            results = _.map(@_edges, (edge) -> 
                        if (edge.properties.source is id) or (edge.properties.target is id)
                            edge.properties)
            _.compact(results) # best way to do this?

    allNodes: ->
        # deprecate in v1.0 in favor of getAllNodes()
        _.map(@_nodes, (n) -> n.properties)

    getAllNodes: ->
        _.map(@_nodes, (n) -> n.properties)

    allEdges: ->
        # deprecate in v1.0 in favor of getAllEdges()
        _.map(@_edges, (e) -> e.properties)

    getAllEdges: ->
        _.map(@_edges, (e) -> e.properties)
