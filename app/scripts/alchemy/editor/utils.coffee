class alchemy.editor.Utils
    constructor: () ->
        @drawNodes = new alchemy.drawing.DrawNodes
        @drawEdges = new alchemy.drawing.DrawEdges

    enableEditor: () =>
        alchemy.setState("interactions", "editor")
        dragLine = alchemy.vis
            .append("line")
            .attr("id", "dragline")

        @drawNodes.updateNode(alchemy.node)
        @drawEdges.updateEdge(alchemy.edge)
        selectedElements = d3.selectAll(".selected")
        editor = new alchemy.editor.Editor
        debugger
        if (not selectedElements.empty()) and (selectedElements.length is 1)
            if selectedElements.classed('node')
                editor.nodeEditor(selectedElements.datum())
                d3.select("#node-editor")
                    .attr("class", "enabled")
                    .style("opacity", 1)
            else if selectedElements.classed('edge')
                editor.edgeEditor(selectedElements.datum())
                d3.select("#edge-editor")
                    .attr("class", "enabled")
                    .style("opacity", 1)
        else
            selectedElements.classed("selected":false)

    disableEditor: () ->
        alchemy.setState("interactions", "default")
        alchemy.vis.select("#dragline").remove()

        d3.select("#node-editor")
            .transition()
            .duration(300)
            .style("opacity", 0)
        d3.select("#node-editor")
            .transition()
            .delay(300)
            .attr("class", "hidden")

        @drawNodes.updateNode(alchemy.node)
        d3.selectAll(".node").classed("selected":false)

    remove: () ->
        selectedNodes = d3.selectAll(".selected.node")
        for node in selectedNodes[0]
            nodeID = d3.select(node).data()[0].id

            node_data = alchemy._nodes[nodeID]
            if node_data?  
                for edge in node_data.adjacentEdges
                    alchemy._edges = _.omit(alchemy._edges, "#{edge}")
                    alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3), (e)->e.id)
                    d3.select("#edge-#{edge}").remove()
                alchemy._nodes = _.omit(alchemy._nodes, "#{nodeID}")
                alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3), (n)->n.id)
                d3.select(node).remove()
                if alchemy.getState("interactions") is "editor"
                    alchemy.modifyElements.nodeEditorClear()

    addNode: (node) ->
        newNode = alchemy._nodes[node.id] = new alchemy.models.Node({id:"#{node.id}"})
        newNode.setProperty("caption", node.caption)
        newNode.setD3Property("x", node.x)
        newNode.setD3Property("y", node.y)
        alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3), (n)->n.id)

    addEdge: (edge) ->
        newEdge = alchemy._edges[edge.id] = new alchemy.models.Edge(edge)
        alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3), (e)->e.id)

    update: (node, edge) ->
        #only push the node if it didn't previously exist
        if !@mouseUpNode
            alchemy.editor.addNode(node)
            alchemy.editor.addEdge(edge)
            @drawEdges.createEdge(alchemy.edge)
            @drawNodes.createNode(alchemy.node)

        else
            alchemy.editor.addEdge(edge)
            @drawEdges.createEdge(alchemy.edge)

        # force = new alchemy.layout.force
        alchemy.layout.tick()
