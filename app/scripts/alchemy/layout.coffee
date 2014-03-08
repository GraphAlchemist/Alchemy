###
force layout functions
###
layout.charge = (node) ->
    if conf.cluster
        -1600
    else
        -150

layout.strength = (edge) ->
    # debugger
    if (edge.source.node_type or edge.target.node_type) is 'root'
        .2
    else
        if conf.cluster
            edge.source.cluster is edge.target.cluster ? 0.011 : 0.01
        else
            1

layout.friction = () ->
    if conf.cluster
        0.7
    else
        0.9

layout.linkDistanceFn = (edge) ->
    #if typeof(edge.distance) isnt 'undefined' then edge.distance
    if conf.cluster
        # FIXME: parameterise this
        if (edge.source.node_type or edge.target.node_type) is 'root' then 300
        edge.source.cluster is edge.target.cluster ? 200 : 600
    else
        if typeof(edge.source.connectedNodes is 'undefined') then edge.source.connectedNodes = 0
        if typeof(edge.target.connectedNodes is 'undefined') then edge.target.connectedNodes = 0
        edge.source.connectedNodes++
        edge.target.connectedNodes++
        edge.distance = (Math.floor(Math.sqrt(edge.source.connectedNodes + edge.target.connectedNodes)) + 2) * 35
        edge.distance

layout.cluster = (alpha) ->
    centroids = {}
    app.nodes.forEach (d) ->
        if d.cluster == ''
            return
        if d.cluster not in centroids
            centroids[d.cluster] = {'x':0, 'y':0, 'c':0}
        centroids[d.cluster].x += d.x
        centroids[d.cluster].y += d.y
        centroids[d.cluster].c++
        
    for c in centroids
        c.x = c.x / c.c
        c.y = c.y / c.c

    (d) ->
        if d.cluster is '' then return
        c = centroids[d.cluster]
        x = d.x - c.x
        y = d.y - c.y
        l = Math.sqrt( x * x * y * y)
        if l > nodeRadius * 2 + 5
            l = (l - nodeRadius) / l * alpha
            d.x -= x * l
            d.y -= y * l

layout.collide = (node) ->
    # this is not working...
    r = utils.nodeSize(node) + 20
    nx1 = node.x - r
    nx2 = node.x + r
    ny1 = node.y - r
    ny2 = node.y + r
    (quad, x1, y1, x2, y2) ->
        if quad.point and (quad.point isnt node)
            x = node.x - quad.point.x
            y = node.y - quad.point.y
            l = Math.sqrt(x * x + y * y)
            r = nodeRadius + nodeRadius + 10
            if l < r
                l = (l - r) / l * .5
                node.x -= x *= l
                node.y -= y *= l
                quad.point.x += x
                quad.point.y += y
        x1 > nx2 or
        x2 < nx1 or
        y1 > ny2 or
        y2 < ny1

layout.final = ->
    q = d3.geom.quadtree(app.nodes)
    for n in app.nodes
        q.visit(layout.collide(n))

layout.tick = () ->
    # NOTE: allNodes should be changed to currentNodes when node hiding is introduced
    # q = d3.geom.quadtree(app.nodes)
    # if conf.cluster
    #     c = layout.cluster(10 * app.force.alpha() * app.force.alpha())
    # for n in app.nodes
    #     q.visit(layout.collide(n))
    # if conf.cluster then c(n)
    # if path?
    #     path.attr('x1', (d) -> d.source.x)
    #     path.attr('y1', (d) -> d.source.y)
    #     path.attr('x2', (d) -> d.target.x)
    #     path.attr('y2', (d) -> d.source.y)
    # if node?
    #     node.attr('transform', (d) ->
    #         "translate(#{ d.x }, #{ d.y })")

layout.positionRootNodes = () ->
    #fix or unfix root nodes
    fixRootNodes = conf.fixRootNodes
    #count root nodes
    rootNodes = Array()
    for n in app.nodes
        if (n.node_type == 'root') or (n.id == rootNodeId)
            n.node_type = 'root'
            rootNodes.push(n)

    #currently we center the graph on one or two root nodes
    if rootNodes.length == 1
        rootNodes[0].x = container.width / 2
        rootNodes[0].y = container.height / 2
        rootNodes[0].px = container.width / 2
        rootNodes[0].py = container.height / 2
        rootNodes[0].fixed = fixRootNodes
        rootNodes[0].r = rootNodeRadius
    else
        rootNodes[0].x = container.width * 0.25
        rootNodes[0].y = container.height / 2
        rootNodes[0].px = container.width * 0.25
        rootNodes[0].py = container.height / 2
        rootNodes[0].fixed = fixRootNodes
        rootNodes[0].r = rootNodeRadius
        rootNodes[1].x = container.width * 0.75
        rootNodes[1].y = container.height / 2
        rootNodes[1].px = container.width * 0.75
        rootNodes[1].py = container.height / 2
        rootNodes[1].fixed = fixRootNodes
        rootNodes[1].r = rootNodeRadius

#position the nodes
layout.positionNodes = (nodes, x, y) ->
    if typeof(x) is 'undefined'
        x = container.width / 2
        y = container.height / 2
    for n in nodes
        min_radius = linkDistance * 3
        max_radius = linkDistance * 5
        radius = Math.random() * (max_radius - min_radius) + min_radius
        angle = Math.random() * 2 * Math.PI
        node_x = Math.cos(angle) * linkDistance
        node_y = Math.sin(angle) * linkDistance
        n.x = x + node_x
        n.y = y + node_y
####

layout.chargeDistance = (distance) ->
     distance