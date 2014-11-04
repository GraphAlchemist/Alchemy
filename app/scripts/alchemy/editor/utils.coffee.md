    class EditorUtils
        constructor: () ->
            @drawNodes = alchemy._drawNodes
            @drawEdges = alchemy._drawEdges

        enableEditor: () =>
            alchemy.set.state "interactions", "editor"
            dragLine = alchemy.vis
                .append "line"
                .attr "id", "dragline"

            @drawNodes.updateNode alchemy.node
            @drawEdges.updateEdge alchemy.edge
            selectedElements = alchemy.vis.selectAll ".selected"
            editor = new alchemy.editor.Editor
            if (not selectedElements.empty()) and (selectedElements.length is 1)
                if selectedElements.classed 'node'
                    editor.nodeEditor selectedElements.datum()
                    alchemy.dash
                        .select "#node-editor"
                        .attr "class", "enabled"
                        .style "opacity", 1
                else if selectedElements.classed 'edge'
                    editor.edgeEditor selectedElements.datum()
                    alchemy.dash
                        .select "#edge-editor"
                        .attr "class", "enabled"
                        .style "opacity", 1
            else
                selectedElements.classed "selected":false

        disableEditor: () ->
            alchemy.setState "interactions", "default"
            alchemy.vis
                   .select "#dragline"
                   .remove()

            alchemy.dash
                   .select "#node-editor"
                   .transition()
                   .duration 300
                   .style "opacity", 0
            alchemy.dash
                   .select "#node-editor"
                   .transition()
                   .delay 300
                   .attr "class", "hidden"

            @drawNodes.updateNode alchemy.node
            alchemy.vis
                   .selectAll ".node"
                   .classed "selected":false

        remove: () ->
            selectedNodes = alchemy.vis.selectAll ".selected.node"
            for node in selectedNodes[0]
                nodeID = alchemy.vis
                                .select node
                                .data()[0]
                                .id

                node_data = alchemy._nodes[nodeID]
                if node_data?
                    for edge in node_data.adjacentEdges
                        alchemy._edges = _.omit alchemy._edges, "#{edge.id}-#{edge._index}"
                        alchemy.edge = alchemy.edge.data _.map(alchemy._edges, (e) -> e._d3), (e)->e.id
                        alchemy.vis
                               .select "#edge-#{edge.id}-#{edge._index}"
                               .remove()
                    alchemy._nodes = _.omit alchemy._nodes, "#{nodeID}"
                    alchemy.node = alchemy.node.data _.map(alchemy._nodes, (n) -> n._d3), (n)->n.id
                    alchemy.vis
                           .select node
                           .remove()
                    if alchemy.get.state("interactions") is "editor"
                        alchemy.modifyElements.nodeEditorClear()

        addNode: (node) ->
            newNode = alchemy._nodes[node.id] = new alchemy.models.Node {id:"#{node.id}"}
            newNode.setProperty "caption", node.caption
            newNode.setD3Property "x", node.x
            newNode.setD3Property "y", node.y
            alchemy.node = alchemy.node.data _.map(alchemy._nodes, (n) -> n._d3), (n)->n.id

        addEdge: (edge) ->
            newEdge = alchemy._edges[edge.id] = new alchemy.models.Edge edge
            alchemy.edge = alchemy.edge.data _.map(alchemy._edges, (e) -> e._d3), (e)->e.id

        update: (node, edge) ->
            #only push the node if it didn't previously exist
            if !@mouseUpNode
                alchemy.editor.addNode node
                alchemy.editor.addEdge edge
                @drawEdges.createEdge alchemy.edge
                @drawNodes.createNode alchemy.node

            else
                alchemy.editor.addEdge edge
                @drawEdges.createEdge alchemy.edge

            alchemy.layout.tick()
