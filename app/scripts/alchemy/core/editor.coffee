if conf.removeNodes
    node_filter_html = """
                        <fieldset id="remove-nodes">
                            <legend>Remove Nodes
                                <button>Remove</button>
                            </legend>
                        </fieldset>
                       """
    $('#filters form').append(node_filter_html)

    $('#filters #remove-nodes button').click ->
        # remove all nodes and associated tags and captions with class selected or search-match
        ids = []
        $('.node.selected, .node.search-match').each((i, n) ->
            ids.push n.__data__.id
            delete allCaptions[n.__data__.label]
        )
        allNodes = allNodes.filter((n) ->
            ids.indexOf(n.id) is -1
        )
        allEdges = allEdges.filter((e) ->
            ids.indexOf(e.source.id) is -1 and ids.indexOf(e.target.id) is -1
        )
        updateCaptions()
        updateGraph(false)
        # clear all filters
        $('#tags-list').html('')
        $('#filters input:checked').parent().remove()
        updateFilters()
        deselectAll()