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
        nodes: (id, ids...) ->
                if not id
                    console.warn "Please specify a node id."
                    return
                # returns one or more nodes as an array
                if ids.length isnt 0
                    ids.push id
                    params = _.union ids
                    results = []
                    for p in params
                        results.push alchemy._nodes[p]
                    results
                else
                    [alchemy._nodes[id]]

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

        clusterColours: ->
            clusterMap = alchemy.layout._clustering.clusterMap
            clusterColoursObject = {}
            _.each clusterMap, (key, value) ->
               clusterColoursObject[value] = alchemy.conf.clusterColours[key%alchemy.conf.clusterColours.length]

            clusterColoursObject
               #  console.log alchemy.conf.clusterColours[key]




            # : alchemy.conf.clusterColours[value] for value of clusterMap

        allNodes: ->
            _.map alchemy._nodes, (n) -> n


        allEdges: ->
            _.flatten _.map(alchemy._edges, (edgeArray) -> e for e in edgeArray)
