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
            .on("click", ()-> alchemy.modifyElements.remove())
        d3.select("#editor-interactions")
            .on "click", () -> alchemy.interactions.enableEditor()

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

