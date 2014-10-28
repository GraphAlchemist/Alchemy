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


    # make js array method called ._state
    # alchemy.set.  nest set inside of get

    alchemy.get =
        _el: []

        _makeChain: (inp)->
            returnedGet = @
            returnedGet.__proto__ = [].__proto__
            returnedGet.pop() while returnedGet.length

            _.each inp, (e)-> returnedGet.push(e)
            returnedGet

        # returns one or more nodes as an array
        nodes: (id, ids...) ->
            allIDs = _.map arguments, (arg) -> String(arg)
            nodeList = do () ->
                if allIDs.length is 0
                    _.map alchemy._nodes, (n) -> n
                else
                    # All passed ids with artificially enforced type safety
                    _.filter alchemy._nodes, (val, key)->
                        val if _.contains allIDs, key

            @_el = nodeList
            @_makeChain nodeList

        state: (state) ->
            elList = _.filter @_el, (e)-> e._state is state
            @_el = elList
            @_makeChain elList

        type: (type) ->
            elList = _.filter @_el, (e) -> e._nodeType is type or e._edgeType is type
            @_el = elList
            @_makeChain elList

        # returns one or more edges as an array
        edges: (id, ids...) ->
            edgeList = do (id, ids) ->
                if id?
                    # All passed ids with artificially enforced type safety
                    allIDs = _.map arguments, (arg) -> String(arg)
                    _.flatten _.filter alchemy._edges, (val, key)->
                        val if _.contains allIDs, key
                else
                    _.flatten _.map alchemy._edges, (n) -> n

            @_el = edgeList
            @_makeChain edgeList

        # edges: (id=null, target=null) ->
        #     # edgeList = do (id, target) ->
        #         # returns one or more edges as an array
        #         if id? and target?
        #             edge_id = "#{id}-#{target}"
        #             edge = alchemy._edges[edge_id]
        #             [edge]
        #         else if id? and not target?
        #             if alchemy._edges[id]?
        #                 [_.flatten(alchemy._edges[id])]
        #             else
        #                 # edge does not exist, so return all edges with `id` as the
        #                 # `source OR `target` this method scans ALL edges....
        #                 results = _.map alchemy._edges, (edge) ->
        #                     if (edge.properties.source is id) or (edge.properties.target is id)
        #                         edge.properties
        #             _.compact results

            # @_el = edgeList
            # @_makeChain edgeList

        allNodes: (type) ->
            if type?
                _.filter alchemy._nodes, (n) -> n if n._nodeType is type
            else
                _.map alchemy._nodes, (n) -> n

        activeNodes: () ->
            _.filter alchemy._nodes, (node) -> node if node._state is "active"

        # allEdges: ->
        #     _.flatten _.map(alchemy._edges, (edgeArray) -> e for e in edgeArray)

        # state: (key) -> if alchemy.state.key? then alchemy.state.key

        # clusters: ->
        #     clusterMap = alchemy.layout._clustering.clusterMap
        #     nodesByCluster = {}
        #     _.each clusterMap, (key, value) ->
        #         nodesByCluster[value] = _.select alchemy.get.allNodes(), (node) ->
        #             node.getProperties()[alchemy.conf.clusterKey] is value
        #     nodesByCluster

        # clusterColours: ->
        #     clusterMap = alchemy.layout._clustering.clusterMap
        #     clusterColoursObject = {}
        #     _.each clusterMap, (key, value) ->
        #        clusterColoursObject[value] = alchemy.conf.clusterColours[key % alchemy.conf.clusterColours.length]
        #     clusterColoursObject

