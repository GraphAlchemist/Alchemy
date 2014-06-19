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

        selection = d3.selectAll(".selected:not(.root)").data()

        for i in selection
            alchemy.edges = _.without(alchemy.edges, i)
            alchemy.nodes = _.without(alchemy.nodes, i)
        alchemy.updateGraph()
        alchemy.force.start()