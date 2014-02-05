# all interactions with Graph
# TODO: support touch
deselectAll = () ->
    # this function is also fired at the end of a drag, do nothing if this happens
    if d3.event?.defaultPrevented then return
    vis.selectAll('.node, line')
        .classed('selected highlight', false)
    $('#graph').removeClass('highlight-active')

    # vis.selectAll('line.edge')
    #     .classed('highlighted connected unconnected', false)
    # vis.selectAll('g.node,circle,text')
    #     .classed('selected unselected neighbor unconnected connecting', false)
    #call user-specified deselect function if specified
    if conf.deselectAll and typeof(conf.deselectAll == 'function')
        conf.deselectAll()

edgeClick = (d) ->
    vis.selectAll('line')
        .classed('highlight', false)
    d3.select(this)
        .classed('highlight', true)
    d3.event.stopPropagation
    if typeof conf.edgeClick? is 'function'
        conf.edgeClick()

nodeMouseOver = (n) ->
    if typeof conf.nodeMouseOver? is 'function'
        conf.nodeMouseOver()
    else if conf.nodeMouseOver is 'default'
        console.log("default nodeMouseOver interaction on #{n.caption}")

nodeDoubleClick = (c) ->
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

loadMoreNodes = (data) ->
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

nodeClick = (c) ->
    vis.selectAll('line')
        .classed('highlight', (d) -> return c.id is d.source.id or c.id is d.target.id)
    vis.selectAll('.node')
        .classed('selected', (d) -> return c.id is d.id)
        .classed('highlight', (d) ->
            return d.id is c.id or allEdges.some (e) ->
                return (e.source.id is c.id and e.target.id is d.id) or (e.source.id is d.id and e.target.id is c.id))

    $('#graph').addClass 'highlight-active'

    if d3.event
        d3.event.stopPropagation()
        if conf.nodeClick? and typeof conf.nodeClick is 'function'
            conf.nodeClick c