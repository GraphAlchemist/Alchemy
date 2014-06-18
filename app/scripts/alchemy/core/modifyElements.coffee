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

    remove: () ->
        alchemy.nodes.splice(1,30)
        alchemy.updateGraph()
        #update statistics