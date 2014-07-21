alchemy.modifyElements = 
    init: () ->
        if alchemy.conf.removeElement then alchemy.modifyElements.showRemove()
    
    showRemove: () ->
        removeElement_html = """
                            <div id="element-options" class="collapse">
                                <ul class = "list-group" id="remove">Remove Selected</ul>
                            </div>
                             """
        d3.selectAll('#editor-header')
            .append("div")
            .html(removeElement_html)
            .on('click', () ->
                if d3.select('#element-options').classed("in")
                    d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-right")
                else d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-down")
            )           
        d3.select("#remove")
            .on("click", ()-> alchemy.modifyElements.remove())

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
