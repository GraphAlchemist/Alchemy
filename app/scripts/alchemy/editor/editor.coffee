alchemy.editor =
    enableEditor: () ->
        alchemy.setState("interactions", "editor")
        dragLine = alchemy.vis
            .append("line")
            .attr("id", "dragline")

        d3.select("#node-editor")
            .attr("class", "enabled")
            .style("opacity", 1)

        @drawNodes.updateNode(alchemy.node)
        d3.selectAll(".node").classed("selected":false)

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


alchemy.editor.interactions = ->
    @mouseUpNode = null
    @sourceNode = null
    @targetNode = null
    @newEdge = null
    @click = null
    @drawNodes = new alchemy.drawing.DrawNodes
    @drawEdges = new alchemy.drawing.DrawEdges

    @nodeMouseOver = (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius*3)
        @

    @nodeMouseUp = (n) =>
        if @sourceNode != n
            @mouseUpNode = true
            @targetNode = n
            @click = false
        else 
            @click = true
        @

    @nodeMouseOut = (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius/3)
        @

    @nodeClick = (c) =>
        d3.event.stopPropagation()
        # select the correct nodes
        if !alchemy.vis.select("#node-#{c.id}").empty()
            selected = alchemy.vis.select("#node-#{c.id}").classed('selected')
            alchemy.vis.select("#node-#{c.id}").classed('selected', !selected)
        alchemy.modifyElements.nodeEditorClear()
        alchemy.modifyElements.nodeEditor(c)
        @

    @addNodeStart = (d, i) =>
        d3.event.sourceEvent.stopPropagation()
        @sourceNode = d
        d3.select('#dragline')
            .classed("hidden":false)
        @

    @addNodeDragging = (d, i) =>
        x2coord = d3.event.x
        y2coord = d3.event.y
        d3.select('#dragline')
            .attr "x1", @sourceNode.x
            .attr "y1", @sourceNode.y
            .attr "x2", x2coord
            .attr "y2", y2coord
            .attr "style", "stroke: #FFF"
        @


    @addNodeDragended = (d, i) =>
        #we moused up on an existing (different) node
        if !@click 
            if !@mouseUpNode
                dragline = d3.select("#dragline")
                targetX = dragline.attr("x2")
                targetY = dragline.attr("y2")

                @targetNode = {id: "#{_.uniqueId('addedNode_')}", x: parseFloat(targetX), y: parseFloat(targetY), caption: "node added"}

            @newEdge = {id: "#{@sourceNode.id}-#{@targetNode.id}", source: @sourceNode.id, target: @targetNode.id, caption: "edited"}   
            alchemy.editor.update(@targetNode, @newEdge)

        alchemy.editor.interactions().reset()
        @

    @deleteSelected = (d) =>
        switch d3.event.keyCode
            when 8, 46
                if !(d3.select(d3.event.target).node().tagName is ("INPUT" or "TEXTAREA"))
                    d3.event.preventDefault()
                    alchemy.editor.remove()

    @reset = =>
        # reset interaciton variables
        @mouseUpNode = null
        @sourceNode = null
        @targetNode = null
        @newEdge = null
        @click = null

        #reset dragline
        d3.select("#dragline")
            .classed "hidden":true
            .attr "x1", 0            
            .attr "y1", 0
            .attr "x2", 0
            .attr "y2", 0 
        @

    @
