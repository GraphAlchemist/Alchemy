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

    API::Get = (instance, api) ->
        a: instance
        api: api
        # returns one or more nodes as an array
        nodes: (id, ids...) ->
            nodeList = []
            if id?
                args = _.flatten arguments
                allIDs = _.map args, (arg) -> String(arg)
                a = @.a
                nodeList = do (a) ->
                    # All passed ids with artificially enforced type safety
                    _.filter a._nodes, (val, key)->
                        val if _.contains allIDs, key
            @api._elType = "node"
            @api._el = nodeList
            @api._makeChain nodeList, @

        # returns one or more edges as an array
        edges: (id, ids...) ->
            edgeList = []
            if id?
                allIDs = _.map arguments, (arg) -> String(arg)
                a = @.a
                edgeList = do (a) ->
                    # All passed ids with artificially enforced type safety
                    _.flatten _.filter a._edges, (val, key)->
                        val if _.contains allIDs, key
            @api._elType = "edge"
            @api._el = edgeList
            @api._makeChain edgeList, @

        all: ->
            a = @a
            elType = @api._elType
            @api._el = do (elType)->
                switch elType
                    when "node" then return a.elements.nodes.val
                    when "edge" then return a.elements.edges.flat
            @api._makeChain @api._el, @

        elState: (state) ->
            elList = _.filter @api._el, (e)-> e._state is state
            @api._el = elList
            @api._makeChain elList, @

        state: (key) -> if @a.state.key? then @a.state.key

        type: (type) ->
            elList = _.filter @api._el, (e) -> e._nodeType is type or e._edgeType is type
            @api._el = elList
            @api._makeChain elList, @

        activeNodes: () ->
            _.filter @a._nodes, (node) -> node if node._state is "active"

        activeEdges: ->
            _.filter @a.get.allEdges(), (edge) -> edge if edge._state is "active"
        
        state: (key) -> if @a.state.key? then @a.state.key

        clusters: ->
            clusterMap = @a.layout._clustering.clusterMap
            nodesByCluster = {}
            _.each clusterMap, (key, value) ->
                nodesByCluster[value] = _.select @a.get.allNodes(), (node) ->
                    node.getProperties()[@a.conf.clusterKey] is value
            nodesByCluster

        clusterColours: ->
            clusterMap = @a.layout._clustering.clusterMap
            clusterColoursObject = {}
            _.each clusterMap, (key, value) ->
               clusterColoursObject[value] = @a.conf.clusterColours[key % @a.conf.clusterColours.length]
            clusterColoursObject

        ###### ALL METHODS BELOW THIS POINT WILL BE DEPRECATED UPON 1.0 ######
        allEdges: -> @a.elements.nodes.flat

        allNodes: (type) ->
            if type?
                _.filter @a._nodes, (n) -> n if n._nodeType is type
            else
                @a.elements.nodes.val

        getNodes: (id, ids...)->
            a = @a
            ids.push(id)
            _.map ids, (id)-> a._nodes[id]

        getEdges: (id=null, target=null)->
            a = @a
            if id? and target?
                edge_id = "#{id}-#{target}"
                @a._edges[edge_id]
            else if id? and not target?
                @a._nodes[id]._adjacentEdges
