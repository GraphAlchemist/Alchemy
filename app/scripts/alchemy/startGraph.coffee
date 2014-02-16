app.startGraph = (data) ->
    
    # see if data is ok
    if not data
        # allow for user specified error
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
    allNodes = data.nodes
    allEdges = data.edges

    #see if root node id has been specified
    if 'id' of data
        rootNodeId = data.id

    # create nodes map and update links
    nodesMap = d3.map()
    data.nodes.forEach (n) ->
        nodesMap.set(n.id, n)
    data.edges.forEach (e) ->
        e.source = nodesMap.get(e.source)
        e.target = nodesMap.get(e.target)

    #get graph size
    container =
        'width': $(window).width()
        'height': $(window).height()

    #API FIXME: allow alternative root node positioning?
    layout.positionRootNodes();

    #API FIXME: allow custom styling
    #colours is spelled like whoever originally wrote this is from Scotland
    # as it should be ;)
    colours = conf.colours
    if Array.isArray colours
        colours.sort(() -> 0.5 - Math.random())

    #position nodes initially
    # API FIXME: allow specified positions for nodes?
    layout.positionNodes(data.nodes)

    # TODO: fix this in the graph file generating view instead of here
    fixNodesTags(allNodes, allEdges);

    # create layout
    layout.force = d3.layout.force()
        .charge(layout.charge)
        .linkDistance(layout.linkDistanceFn)
        .theta(1.0)
        .gravity(0)
        .linkStrength(layout.strength)
        .friction(layout.friction())
        .size([container.width, container.height])
        .on("tick", layout.tick)

    layout.force.nodes(allNodes)
         .links(allEdges)
         .start()

    zoom = d3.behavior.zoom()
        .scaleExtent([0.1, 2])

    #create SVG
    app.vis = d3.select('.alchemy')
        .append("svg:svg")
            .attr("width", container.width)
            .attr("height", container.height)
            .attr("xmlns", "http://www.w3.org/2000/svg")
            .attr("pointer-events", "all")
            .call(zoom.on("zoom", redraw))
            .on("dblclick.zoom", null)
            .on('click', utils.deselectAll)
            .append('svg:g')

    app.updateGraph()

    window.onresize = utils.resize

    # call user-specified functions after load function if specified
    user_spec = conf.afterLoad
    if user_spec and typeof(user_spec is 'function') then user_spec()
