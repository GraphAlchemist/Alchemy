alchemy.modifyElements =
    init: () ->
        alchemy.modifyElements.show()

    show: () ->
        modifyElements_html = """
                                <h3 data-toggle="collapse" data-target="#update-elements #element-options">
                                    Elements
                                    <span class = "fa fa-caret-right"></span>
                                </h3>
                                <div id="element-options" class="collapse">
                                    <ul class = "list-group" id="remove">Remove Selected</ul>
                                </div>
                              """
        d3.select("#update-elements").html(modifyElements_html)
          
        d3.select("#remove")
          .on("click", ()-> alchemy.modifyElements.remove())

    remove: () ->

        selectedNodes = d3.selectAll(".selected.node").data()
        selectedEdges = d3.selectAll(".selected.edge").data()
        
        alchemy.edges = _.difference(alchemy.edges, selectedEdges)
        alchemy.nodes = _.difference(alchemy.nodes, selectedNodes)

        alchemy.updateGraph(false)
        alchemy.force.resume()
