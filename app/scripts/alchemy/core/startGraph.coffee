startGraph = (data) ->
    # see if data is ok
    if not data
        # allow for user specified error
        # clean up search modal
        no_results = """
                    <div class="modal fade" id="no-results">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Sorry!</h4>
                                </div>
                                <div class="modal-body">
                                    <p>No data found, try searching for movies, actors or directors.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                   """
        $('body').append(no_results)
        $('#no-results').modal('show')
        $('#loading-spinner').hide()
        return

    # save nodes & edges
    alchemy.nodes = data.nodes
    alchemy.edges = data.edges

    # create nodes map and update links
    nodesMap = d3.map()
    alchemy.nodes.forEach (n) ->
        nodesMap.set(n.id, n)
    alchemy.edges.forEach (e) ->
        e.source = nodesMap.get(e.source)
        e.target = nodesMap.get(e.target)

    #get graph size
    # container =
    #     'width': $(window).width()
    #     'height': $(window).height()

    #API FIXME: allow alternative root node positioning?
    alchemy.layout.positionRootNodes()

    # TODO: fix this in the graph file generating view instead of here
    fixNodesTags(alchemy.nodes, alchemy.edges);

    #create SVG
    alchemy.vis = d3.select('.alchemy')
        .append("svg")
            .attr("xmlns", "http://www.w3.org/2000/svg")
            .attr("pointer-events", "all")
            .on("dblclick.zoom", null)
            .on('click', alchemy.utils.deselectAll)
            .call(alchemy.interactions.zoom)
            .append('g')
            # .attr("width", alchemy.container.width)
            # .attr("height", alchemy.container.height)

    #enter/exit nodes/edges
    alchemy.edge = alchemy.vis.selectAll("line")
               .data(alchemy.edges, (d) -> d.source.id + '-' + d.target.id)
    alchemy.node = alchemy.vis.selectAll("g.node")
              .data(alchemy.nodes, (d) -> d.id)

    # create layout
    alchemy.force = d3.layout.force()
        .charge(alchemy.layout.charge)
        .linkDistance(alchemy.layout.linkDistanceFn)
        .theta(1.0)
        .gravity(0.1)
        .linkStrength(alchemy.layout.linkStrength)
        .friction(alchemy.layout.friction())
        .chargeDistance(alchemy.layout.chargeDistance(500))
        .size([alchemy.container.width, alchemy.container.height])
        .nodes(data.nodes)
        .links(data.edges)

    alchemy.updateGraph()

    # configuration for forceLocked
    if !conf.forceLocked 
        alchemy.force
               .on("tick", alchemy.layout.tick)
               .start()


    # call user-specified functions after load function if specified
    # deprecate?
    if conf.afterLoad?
        if typeof conf.afterLoad is 'function'
            conf.afterLoad()
        else if typeof conf.afterLoad is 'string'
            alchemy[conf.afterLoad] = true
