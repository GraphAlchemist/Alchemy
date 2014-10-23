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

    alchemy.create =
        nodes: (nodeMap, nodeMaps...) ->
                registerNode = (node) ->
                    # check if the node already exists
                    if not alchemy._nodes[node.id]
                        alchemyNode = new alchemy.models.Node(node)
                        alchemy._nodes[node.id] = alchemyNode
                        [alchemyNode]
                    else
                        # if the node already exists, suggest that the user uses a 
                        # different method for creating/updating the node
                        console.warn("""
                                    A node with the id #{node.id} already exists.
                                    Consider using the alchemy.get.nodes() method to 
                                    retrieve the node and then using the Node methods.
                                    """)
                if nodeMaps.length isnt 0
                    nodeMaps.push nodeMap
                    # create the results set
                    results = []
                    for n in nodeMaps
                        # check if the node already exists
                        registerNode n
                    results
                else
                    registerNode nodeMap

        edges: (edgeMap, edgeMaps...) ->
            registerEdge = (edge) ->
                # data provided a unique id and that edge does not yet exist
                if edge.id and not alchemy._edges[edge.id]
                    alchemyEdge = new alchemy.models.Edge(edge)
                    alchemy._edges[edge.id] = [alchemyEdge]
                    [alchemyEdge]
                # data provided a unique id and that edge already exists
                else if edge.id and alchemy._edges[edge.id]
                    console.warn """
                        An edge with that id #{someEdgeMap.id} already exists.
                        Consider using the alchemy.get.edge() method to 
                        retrieve the edge and then using the Edge methods.
                        Note: id's are not required for edges.  Alchemy will create
                        an unlimited number of edges for the same source and target node.
                        Simply omit 'id' when creating the edge.
                        """
                # data did not provide a unique id and so alchemy uses source-target
                else
                    edgeArray = alchemy._edges["#{edge.source}-#{edge.target}"]
                    if edgeArray
                        # edges already exist with this source target, append a new edge object
                        alchemyEdge = new alchemy.models.Edge(edge, edgeArray.length)
                        edgeArray.push alchemyEdge
                        [alchemyEdge]
                    else
                        # edge array does not exist - create the array and give the edge
                        # an id of 'source-target-0' for the first position in the array
                        alchemyEdge = new alchemy.models.Edge(edge, 0)
                        alchemy._edges["#{edge.source}-#{edge.target}"] = [alchemyEdge]
                        [alchemyEdge]
                        
            if edgeMaps.length isnt 0
                console.warn "Make sure this function supports multiple arguments"
            else
                registerEdge edgeMap
