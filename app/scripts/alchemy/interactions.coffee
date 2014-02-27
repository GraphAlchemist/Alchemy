# all interactions with Graph
# TODO: support touch
interactions.edgeClick = (d) ->
    vis = app.vis
    vis.selectAll('line')
        .classed('highlight', false)
    d3.select(this)
        .classed('highlight', true)
    d3.event.stopPropagation
    if typeof conf.edgeClick? is 'function'
        conf.edgeClick()

interactions.nodeMouseOver = (n) ->
    if typeof conf.nodeMouseOver? is 'function'
        conf.nodeMouseOver()
    else if conf.nodeMouseOver is 'default'
        #default interaction will likely be some popover
        return
        #console.log("default nodeMouseOver interaction on #{n.caption}")

interactions.nodeDoubleClick = (c) ->
    if not conf.extraDataSource or
        c.expanded or
        conf.unexpandable.indexOf c.type is not -1 then return

    $('#loading-spinner').show()
    console.log "loading more data for #{c.id}"
    c.expanded = true
    d3.json conf.extraDataSource + c.id, loadMoreNodes

    links = findAllEdges c
    for e of edges
        edges[e].distance *= 2

interactions.loadMoreNodes = (data) ->
    ###
    TRY:
      - fixing all nodes before laying out graph with added nodes, so only the new ones move
      - extending length of connection between requester node and root so there is some space around it for new nodes to display in
    ###
    console.log "loading more data for #{data.type} #{data.permalink}, #{data.nodes.length} nodes, #{data.links.length} edges"
    console.log "#{allNodes.length} nodes initially"
    console.log "#{allEdges.length} edges initially"
    requester = allNodes[findNode data.id]
    console.log "requester node index #{findNode data.id}"

    fixNodesTags data.nodes, data.links

    for i in data.nodes
        node = data.nodes[i]
        if findNode node.id is null
            console.log "adding node #{node.id}"

            min_radius = linkDistance * 3
            max_radius = linkDistance * 5
            radius = Math.random * (max_radius - min_radius) + min_radius
            angle = Math.random * 2 * Math.PI
            node_x = Math.cos angle * linkDistance
            node_y = Math.sin angle * linkDistance

            node.x = requester.x + node_x
            node.y = requester.y + node_y
            node.px = requester.x + node_x
            node.py = requester.y + node_y
            allNodes.push node

        if typeof conf.nodeAdded? is 'function'
            conf.nodeAdded(node)

    nodesMap = d3.map()
    allNodes.forEach (n) -> nodesMap.set n.id, n
    data.links.forEach (l) ->
        l.source = nodesMap.get(l.source)
        l.target = nodesMap.get(l.target)

    for i in data.links
        link = data.links[i]
        # see if link is already in dataset
        if findEdge link.source, link.target isnt null
            allEdges.push link

            if typeof conf.edgeAdded? is 'function'
                conf.edgeAdded(node)

            console.log "adding link #{link.source.id}-#{link.target.id}"
        else
            console.log "already have link #{link.source.id}-#{link.target.id} index #{findEdge link.source, link.target}"

    updateGraph()
    nodeClick requester

    requester.fixed = false
    setTimeout (-> requester.fixed = true), 1500

    if conf.showFilters then updateFilters
    $('#loading-spinner').hide
    console.log "#{allNodes.length} nodes afterwards"
    console.log "#{allEdges.length} edges afterwards"

    if typeof conf.nodeDoubleClick? is 'function'
        conf.nodeDoubleClick(requester)

interactions.nodeClick = (c) ->
    app.vis.selectAll('line')
        .classed('highlight', (d) -> return c.id is d.source.id or c.id is d.target.id)
    app.vis.selectAll('.node')
        .classed('selected', (d) -> return c.id is d.id)
        .classed('highlight', (d) ->
            return d.id is c.id or app.edges.some (e) ->
                return (e.source.id is c.id and e.target.id is d.id) or (e.source.id is d.id and e.target.id is c.id))
    #fix
    $('#graph').addClass 'highlight-active'

    if d3.event
        d3.event.stopPropagation()
        if conf.nodeClick? and typeof conf.nodeClick is 'function'
            conf.nodeClick c

interactions.dragstarted = (d, i) ->
    d3.event.sourceEvent.stopPropagation()
    d3.select(this).classed("dragging", true)
    return

interactions.dragged = (d, i) ->
    d.x += d3.event.dx
    d.y += d3.event.dy
    d.px += d3.event.dx
    d.py += d3.event.dy
    d3.select(this).attr("transform", "translate(#{d.x}, #{d.y})")
    
    app.edge.attr("x1", (d) -> d.source.x )
        .attr("y1", (d) -> d.source.y )
        .attr("x2", (d) -> d.target.x )
        .attr("y2", (d) -> d.target.y )
        .attr "cx", d.x = d3.event.x
        .attr "cy", d.y = d3.event.y
    return

interactions.dragended = (d, i) ->
    d3.select(this)
      .classed "dragging", false
    return

interactions.drag = d3.behavior.drag()
    .origin(Object)
    .on("dragstart", interactions.dragstarted)
    .on("drag", interactions.dragged)
    .on("dragend", interactions.dragended)
###
deprecated in version d3.js version 3
###
# interactions.node_drag = d3.behavior.drag()
#                 .on("dragstart", interactions.dragstart)
#                 .on("drag", interactions.dragmove)
#                 .on("dragend", interactions.dragend)

# interactions.dragstart = (d, i) ->
#     @parentNode.appendChild(this)

# interactions.dragmove = (d, interactions) ->
#     d.px += d3.event.dx
#     d.py += d3.event.dy
#     d.x += d3.event.dx
#     d.y += d3.event.dy

#     path.attr("x1", (d) -> d.source.x )
#       .attr("y1", (d) -> d.source.y )
#       .attr("x2", (d) -> d.target.x )
#       .attr("y2", (d) -> d.target.y )

#     node.attr("transform", (d) "translate(" + d.x + "," + d.y + ")" )

#     force.stop()

# interactions.dragend = (d, i) ->
#   force.stop()