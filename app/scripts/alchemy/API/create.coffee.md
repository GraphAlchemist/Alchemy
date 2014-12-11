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

    API::Create = (instance, api)->
        a    : instance
        api  : api
        nodes: (nodeMap, nodeMaps...) ->
            a = this.a
            registerNode = (node) ->
                # if the node does not yet exist, create and register it
                if not a._nodes[node.id]
                    aNode = new a.models.Node(node)
                    a._nodes[node.id] = aNode
                    [aNode]
                else
                    # if the node already exists, suggest that the user uses a 
                    # different method for creating/updating the node
                    console.warn("""
                                A node with the id #{node.id} already exists.
                                Consider using the @a.get.nodes() method to 
                                retrieve the node and then using the Node methods.
                                """)

            nodeMaps = _.uniq _.flatten arguments
            # create the results set
            for n in nodeMaps
                registerNode n

            if @a.initial
                @a.index = Alchemy::Index @a 
                @a.updateGraph()

        edges: (edgeMap, edgeMaps...) ->
            a = this.a
            registerEdge = (edge) ->
                # data provided a unique id and that edge does not yet exist
                if edge.id and not a._edges[edge.id]
                    aEdge = new a.models.Edge(edge)
                    a._edges[edge.id] = [aEdge]
                    [aEdge]
                # data provided a unique id and that edge already exists
                else if edge.id and a._edges[edge.id]
                    console.warn """
                        An edge with that id #{someEdgeMap.id} already exists.
                        Consider using the @a.get.edge() method to 
                        retrieve the edge and then using the Edge methods.
                        Note: id's are not required for edges.  Alchemy will create
                        an unlimited number of edges for the same source and target node.
                        Simply omit 'id' when creating the edge.
                        """
                # data did not provide a unique id and so @a uses source-target
                else
                    edgeArray = a._edges["#{edge.source}-#{edge.target}"]
                    if edgeArray
                        # edges already exist with this source target, append a new edge object
                        aEdge = new a.models.Edge(edge, edgeArray.length)
                        edgeArray.push aEdge
                        [aEdge]
                    else
                        # edge array does not exist - create the array and give the edge
                        # an id of 'source-target-0' for the first position in the array
                        aEdge = new a.models.Edge(edge, 0)
                        a._edges["#{edge.source}-#{edge.target}"] = [aEdge]
                        [aEdge]

             allEdges = _.uniq _.flatten arguments

             _.each allEdges, (e)-> registerEdge e
             if @a.initial
                @a.index = Alchemy::Index @a 
                @a.updateGraph()
