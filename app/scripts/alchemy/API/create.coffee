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

apiCreateMethods = 
    create:    
        nodes: (nodeMap, nodeMaps...) ->
            if nodeMaps.length isnt 0
                rawNodes = nodeMaps.push(nodeMap)
                # create the results set
                results = []
                for n in rawNodes
                    # check if the node already exists
                    if not alchemy._nodes[n.id]
                        node = new alchemy.models.Node(n)
                        alchemy._nodes[n.id] = node
                        results.push(node)
                    else
                        # if the node already exists, suggest that the user uses a 
                        # different method for creating/updating the node
                        console.warn("""
                                    A node with the id #{n.id} already exists.
                                    Consider using the alchemy.get.nodes() method to 
                                    retrieve the node and then using the Node methods.
                                    """)
                results
                
            else
                # check if the node already exists
                if not alchemy._nodes[nodeMap.id]
                    node = new alchemy.models.Node(nodeMap)
                    alchemy._nodes[nodeMap.id] = node
                    [node]
                else
                    # if the node already exists, suggest that the user uses a 
                    # different method for creating/updating the node
                    console.warn("""
                                A node with the id #{n.id} already exists.
                                Consider using the alchemy.get.nodes() method to 
                                retrieve the node and then using the Node methods.
                                """)

        edges: (edgeMap) ->
