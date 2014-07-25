alchemy.modifyElements = 
    init: () ->
        if alchemy.conf.showEditor is true
            alchemy.modifyElements.showOptions()

    
    showOptions: () ->
        optionsHTML = """<ul class="list-group"> 
                        <li class="list-group-item" id="remove">Remove Selected</li> 
                        </ul>"""
        
        d3.select('#editor')
            .append("div")
            .attr("id","element-options")
            .attr("class", "collapse")
            .html(optionsHTML)

        d3.select('#element-options ul')
            .append("li")
            .attr("class", ()->
                if alchemy.conf.editorInteractions is true
                    return "active list-group-item"
                else
                    return "inactive list-group-item"
                )
            .attr("id","editor-interactions")
            .html(()->
                if alchemy.conf.editorInteractions is true
                    return """Disable Editor Interactions"""
                else 
                    return """Enable Editor Interactions"""
                )

        nodeEditorHTML = """
                        NodeEditor
                        """
        d3.select("#element-options")
            .append("div")
            .attr("id", "node-editor")
            .html(nodeEditorHTML)

        d3.select("#remove")
            .on "click", ()-> alchemy.editor.remove()
        d3.select("#editor-interactions")
            .on "click", () -> 
                if !d3.select("#editor-interactions").classed("active")
                    alchemy.editor.enableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": true, "inactive": false})
                        .html("""Editor mode enabled, click to disable editor interactions""")
                else 
                    alchemy.editor.disableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": false, "inactive": true})
                        .html("""Editor mode disabled, click to enable editor interactions""")


    nodeEditor: (n) ->
        console.log n
        console.log d3.select(n)
        d3.select("#node-editor")
            .append("p")
            .attr("class", "node-edit")
            .text("nodeeeee!")
            console.log "a thing"

        nodeProperties = Object.keys(n)
        console.log nodeProperties
        for property in nodeProperties
            console.log property
            console.log n[property]



addNodeStart = (d, i) ->
    d3.event.sourceEvent.stopPropagation()
    sourceNode = d
    d3.select('#dragline')
        .datum({source: sourceNode})
        .classed("hidden":false)

addNodeDragging = (d, i) ->
    x2coord = d3.event.x
    y2coord = d3.event.y
    sourceNode = d
    d3.select('#dragline')
        .attr "x1", sourceNode.x
        .attr "y1", sourceNode.y
        .attr "x2", x2coord
        .attr "y2", y2coord
        .attr "style", "stroke: #FFF"


addNodeDragended = (d, i) ->
    if (alchemy.editor.interactions.nodeMouseUp() is false) and d3.select("#dragline").datum()?
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

        dragline.datum(null)


    # reset dragline
    d3.select("#dragline")
        .classed "hidden":true
        .attr "x1", 0            
        .attr "y1", 0
        .attr "x2", 0
        .attr "y2", 0    


alchemy.editor = 
    enableEditor: () ->
        dragLine = alchemy.vis
            .append("line")
            .attr "id", "dragline"
        alchemy.conf.editorInteractions = true
        alchemy.drawing.setNodeInteractions(alchemy.node)

    disableEditor: () ->
        alchemy.vis.select("#dragline").remove()
        alchemy.conf.editorInteractions = false
        alchemy.drawing.setNodeInteractions(alchemy.node)

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

    nodeMouseUp: (n) ->
        # we are dragging
        # to do: insert lines uniquely
        if !d3.select(n).empty() and !d3.select("#dragline").empty()
            dragline = d3.select("#dragline")
            sourceNode = dragline.data()[0].source
            targetNode = n
            if sourceNode != targetNode
                newLink = {source: sourceNode, target: targetNode, caption: "edited"}
                alchemy.edges.push(newLink)
                alchemy.edge = alchemy.edge.data(alchemy.edges)
                alchemy.drawing.drawedges(alchemy.edge)
            dragline.datum(null)
            return true
        else return false

    nodeMouseOut: (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius/3)

    nodeClick: (c) ->
        d3.event.stopPropagation()
        # select the correct nodes
        alchemy.modifyElements.nodeEditor(c)
        if !alchemy.vis.select("#node-#{c.id}").empty()
            selected = alchemy.vis.select("#node-#{c.id}").classed('selected')
            alchemy.vis.select("#node-#{c.id}").classed('selected', !selected)


