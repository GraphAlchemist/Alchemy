# all interactions with Graph
# TODO: support touch
do interactions = ->

    nodeDragStarted = (d, i) ->
        d3.event.sourceEvent.stopPropagation()
        d3.select(this).classed("dragging", true)
        return

    nodeDragged = (d, i) ->
        d.x += d3.event.dx
        d.y += d3.event.dy
        d.px += d3.event.dx
        d.py += d3.event.dy
        d3.select(this).attr("transform", "translate(#{d.x}, #{d.y})")
        
        alchemy.edge.attr("x1", (d) -> d.source.x )
            .attr("y1", (d) -> d.source.y )
            .attr("x2", (d) -> d.target.x )
            .attr("y2", (d) -> d.target.y )
            .attr "cx", d.x = d3.event.x
            .attr "cy", d.y = d3.event.y
        return

    nodeDragended = (d, i) ->
        d3.select(this).classed "dragging", false
        return


    zooming = ->
        interactions.levels = 
                              'translate' : d3.event.translate
                              'scale' : d3.event.scale

    zoomend = ->
        d3.select(".alchemy svg g")
        .attr("transform",
              "translate(#{ interactions.levels.translate }) scale(#{ interactions.levels.scale })")

    interactions = {}

    interactions.edgeClick = (d) ->
        vis = alchemy.vis
        vis.selectAll('line')
            .classed('highlight', false)
        d3.select(this)
            .classed('highlight', true)
        d3.event.stopPropagation
        if typeof conf.edgeClick? is 'function'
            conf.edgeClick()

    interactions.nodeMouseOver = (n) ->
        #TODO: support user defined functions
        #if typeof conf.nodeMouseOver is 'function'
        if conf.nodeMouseOver?
            if typeof conf.nodeMouseOver == 'function'
                conf.nodeMouseOver(n)
            else if typeof conf.nodeMouseOver == ('number' or 'string')
                # the user provided an integer or string to be used
                # as a data lookup key on the node in the graph json
                return n[conf.nodeMouseOver]
        else
            null

    interactions.nodeMouseOut = (n) ->
        if conf.nodeMouseOut? and typeof conf.nodeMouseOut == 'function'
            conf.nodeMouseOut(n)
        else
            null


    interactions.nodeDoubleClick = (c) ->
        if not conf.extraDataSource or
            c.expanded or
            conf.unexpandable.indexOf c.type is not -1 then return

        $('<div id="loading-spi"></div>nner').show()
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
        d3.event.stopPropagation()
        alchemy.vis.selectAll('line')
            .classed('selected', (d) -> return c.id is d.source.id or c.id is d.target.id)
        # d3.select(this).classed({'selected':true})
        alchemy.vis.selectAll('.node')
            .classed('selected', (d) -> return c.id is d.id)
            # also select 1st degree connections
            .classed('selected', (d) ->
                 return d.id is c.id or alchemy.edges.some (e) ->
                     return (e.source.id is c.id and e.target.id is d.id) or (e.source.id is d.id and e.target.id is c.id))
        if typeof conf.nodeClick == 'function'
            conf.nodeClick(c)
            return

    interactions.drag = d3.behavior.drag()
                          .origin(Object)
                          .on("dragstart", nodeDragStarted)
                          .on("drag", nodeDragged)
                          .on("dragend", nodeDragended)
    
    interactions.zoom = d3.behavior.zoom()
                          # to do, allow UDF initial scale and zoom
                          # .translate conf.initialTranslate
                          # .scale conf.initialScale
                          .scaleExtent [0.28, 2] 
                          .on "zoom", ->
                            d3.select(".alchemy svg g")
                            .attr("transform","translate(#{ d3.event.translate}) scale(#{ d3.event.scale })")
                            return

    alchemy.interactions = interactions
