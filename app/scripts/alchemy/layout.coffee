###
force layout functions
###
node_drag = d3.behavior.drag()
            .on("dragstart", dragstart)
            .on("drag", dragmove)
            .on("dragend", dragend)

dragstart = (d, i) ->
    @parentNode.appendChild(this)

dragmove = (d, i) ->
    d.px += d3.event.dx
    d.py += d3.event.dy
    d.x += d3.event.dx
    d.y += d3.event.dy

    path.attr("x1", (d) -> d.source.x )
      .attr("y1", (d) -> d.source.y )
      .attr("x2", (d) -> d.target.x )
      .attr("y2", (d) -> d.target.y )

    node.attr("transform", (d) "translate(" + d.x + "," + d.y + ")" )

    force.stop()

dragend = (d, i) ->
  force.stop()

charge = (n) ->
    if conf.cluster
        n.node_type == 'root' ? -1600 : -400
    else
        -350

strength = (edge) ->
    if edge.source.node_type == 'root'
        .2
    else
        if conf.cluster
            edge.source.cluster == edge.target.cluster ? 0.5 : 0.01
        else
            1

friction = () ->
    if conf.cluster
        0.7
    else
        0.9

linkDistanceFn = (edge) ->
    if typeof(edge.distance) isnt 'undefined' then edge.distance
    if conf.cluster
        # FIXME: parameterise this
        if edge.source.node_type is 'root' then 100
        edge.source.cluster == edge.target.cluster ? 180 : 540
    else
        if typeof(edge.source.connectedNodes is 'undefined') then edge.source.connectedNodes = 0
        if typeof(edge.target.connectedNodes is 'undefined') then edge.target.connectedNodes = 0
        edge.source.connectedNodes++
        edge.target.connectedNodes++
        edge.distance = (Math.floor(Math.sqrt(edge.source.connectedNodes + edge.target.connectedNodes)) + 2) * 35
        edge.distance

tick = () ->
    # NOTE: allNodes should be changed to currentNodes when node hiding is introduced
    q = d3.geom.quadtree(allNodes)
    if conf.cluster
        c = cluster(10 * force.alpha() * force.alpha())
    for n in allNodes
        q.visit(collide(n))
        if conf.cluster then c[n]
    if path?
        path.attr('x1', (d) -> d.source.x)
        path.attr('y1', (d) -> d.source.y)
        path.attr('x2', (d) -> d.target.x)
        path.attr('y2', (d) -> d.source.y)
    if node?
        node.attr('transform', (d) ->
            'translate(#{ d.x }, #{ d.y })')

cluster = (alpha) ->
    centroids = {}
    allNodes.forEach (d) ->
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

collide = (node) ->
    r = nodeRadius + 16
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

positionRootNodes = () ->
    #fix or unfix root nodes
    fixRootNodes = conf.fixRootNodes
    #count root nodes
    rootNodes = Array()
    for n in allNodes
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
positionNodes = (nodes, x, y) ->
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