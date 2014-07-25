alchemy.modifyElements = 
    init: () ->
        if alchemy.conf.showEditor then alchemy.modifyElements.showOptions()
    
    showOptions: () ->
        removeElement_html = """
                                <li class="list-group-item" id="remove">Remove Selected</li>
                             """

        editorHTML = """
                            <li class="list-group-item" id="editor-interactions">Enable Editor Interactions</li>
                    """

        optionsHTML = """<ul class="list-group"> 
                        <li class="list-group-item" id="remove">Remove Selected</li>
                        <li class="list-group-item" id="editor-interactions">Enable Editor Interactions</li> 
                        </ul>"""
        
        d3.select('#editor')
            .append("div")
            .attr("id","element-options")
            .attr("class", "collapse")
            .html(optionsHTML)

        d3.select("#remove")
            .on "click", ()-> alchemy.editor.remove()
        d3.select("#editor-interactions")
            .on "click", () -> alchemy.editor.enableEditor()


addNodeStart = (d, i) ->
    d3.event.sourceEvent.stopPropagation()
    sourceNode = d
    data = {source: sourceNode}
    dragLine = alchemy.vis
        .datum(data)
        .append("line")
        .attr "id", "dragline"
        .attr "x1", 0
        .attr "y1", 0
        .attr "x2", 0
        .attr "y2", 0
    d3.select("#dragline").classed("hidden":false)

addNodeDragging = (d, i) ->
    x2coord = d3.event.x
    y2coord = d3.event.y
    sourceNode = d
    d3.select('#dragline')
        .datum({source: sourceNode})
        .attr "x1", sourceNode.x
        .attr "y1", sourceNode.y
        .attr "x2", x2coord
        .attr "y2", y2coord
        .attr "style", "stroke: #FFF"


addNodeDragended = (d, i) ->
    if (alchemy.interactions.nodeMouseUp() is false) and (!d3.select("#dragline").empty())
        dragline = d3.select("#dragline")
        targetX = dragline.attr("x2")
        targetY = dragline.attr("y2")

        # coordinates relative to source node
        sourceNode = d

        targetNode = {id: alchemy.nodes.length, x: targetX, y: targetY, caption: "editedNode"}    
        newLink = {source: sourceNode, target: targetNode, caption: "edited"}

        # add to alchemy data
        alchemy.nodes.push(targetNode)
        alchemy.edges.push(newLink)


        alchemy.node = alchemy.node.data(alchemy.nodes)
        alchemy.edge = alchemy.edge.data(alchemy.edges)
        
        alchemy.drawing.drawedges(alchemy.edge)
        alchemy.drawing.drawnodes(alchemy.node)
        alchemy.layout.tick()

        dragline.remove()


alchemy.editor = 
    enableEditor: () ->
        editor = true
        dragLine = alchemy.vis
            .append("line")
            .attr "id", "dragline"
            # alchemy.drawing.drawnodes(alchemy.node).update(editor)

    disableEditor: () ->
        editor = false
        alchemy.vis.select("#dragline")
            .exit().remove()
        # alchemy.drawing.drawnodes(alchemy.node).update(editor)

    remove: () ->
        selectedNodes = d3.selectAll(".selected.node").data()
        selectedEdges = d3.selectAll(".selected.edge").data()         
        
        alchemy.edges = _.difference(alchemy.edges, selectedEdges)
        alchemy.nodes = _.difference(alchemy.nodes, selectedNodes)
        
        alchemy.force.friction(1)
        alchemy.updateGraph(false)
        
        alchemy.force.resume()
        alchemy.force.friction(0.9)         
        
        d3.selectAll(".selected").classed("selected", false)

alchemy.editor.interactions =
    nodeMouseOver: (n) ->
        if alchemy.conf.editorInteractions is true
            if !d3.select(@).select("circle").empty()
                radius = d3.select(@).select("circle").attr("r")
                d3.select(@).select("circle")
                    .attr("r", radius*3)
        else console.log "editor not enabled"

    nodeMouseUp: (n) ->
        # we are dragging
        # to do: insert lines uniquely
        if alchemy.conf.editorInteractions is true
            if !d3.select(n).empty() and !d3.select("#dragline").empty()
                dragline = d3.select("#dragline")
                sourceNode = dragline.data()[0].source
                targetNode = n
                if sourceNode != targetNode
                    console.log "different"
                    newLink = {source: sourceNode, target: targetNode, caption: "edited"}

                    alchemy.edges.push(newLink)
                    alchemy.edge = alchemy.edge.data(alchemy.edges)
                    alchemy.drawing.drawedges(alchemy.edge)
                dragline.datum()
                # dragline.remove()
                return true
            else return false

        else return false

    drag: d3.behavior.drag()
                      .origin(Object)
                      .on("dragstart", addNodeStart)
                      .on("drag", addNodeDragging)
                      .on("dragend", addNodeDragended)

