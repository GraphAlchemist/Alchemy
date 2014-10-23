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

    alchemy.get = 
        # returns one or more nodes as an array
        nodes: (id, ids...) ->
                if id?
                    # All passed ids with artificially enforced type safety
                    allIDs = _.map arguments, (arg) -> String(arg)
                    _.filter alchemy._nodes, (val, key)->
                        val if _.contains allIDs, key
                else
                    console.warn "Please specify a node id."

        edges: (id=null, target=null) ->
            # returns one or more edges as an array
            if id? and target?
                edge_id = "#{id}-#{target}"
                edge = alchemy._edges[edge_id]
                [edge]
            else if id? and not target?
                if alchemy._edges[id]?
                    [_.flatten(alchemy._edges[id])]
                else
                    # edge does not exist, so return all edges with `id` as the 
                    # `source OR `target` this method scans ALL edges....
                    results = _.map alchemy._edges, (edge) ->
                        if (edge.properties.source is id) or (edge.properties.target is id)
                            edge.properties
                _.compact results

        allNodes: (type) ->
            if type?
                _.filter alchemy._nodes, (n) -> n if n._nodeType is type
            else
                _.map alchemy._nodes, (n) -> n

        activeNodes: () ->
            _.filter alchemy._nodes, (node) -> node if node._state is "active"

        allEdges: ->
            _.flatten _.map(alchemy._edges, (edgeArray) -> e for e in edgeArray)
        
        state: (key) -> if alchemy.state.key? then alchemy.state.key

        clusters: ->
            clusterMap = alchemy.layout._clustering.clusterMap
            nodesByCluster = {}
            _.each clusterMap, (key, value) ->
                nodesByCluster[value] = _.select alchemy.get.allNodes(), (node) ->
                    node.getProperties()[alchemy.conf.clusterKey] is value
            nodesByCluster

        clusterColours: ->
            clusterMap = alchemy.layout._clustering.clusterMap
            clusterColoursObject = {}
            _.each clusterMap, (key, value) ->
               clusterColoursObject[value] = alchemy.conf.clusterColours[key % alchemy.conf.clusterColours.length]
            clusterColoursObject

