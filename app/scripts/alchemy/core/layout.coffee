alchemy.layout =
    gravity: (k) ->
        8 * k

    charge: (k) ->
        if conf.cluster
            -500
        else
            -10 / k

    linkStrength: (edge) ->
        if conf.cluster
            if edge.source.cluster is edge.target.cluster then 1 else 0.1
        else
            if edge.source.root or edge.target.root
                0.9
            else
                1

    friction: () ->
        if conf.cluster
            0.7
        else
            0.9

    linkDistanceFn: (edge, k) ->
        if conf.cluster
            # FIXME: parameterise this
            if (edge.source.node_type or edge.target.node_type) is 'root' then 300
            if edge.source.cluster is edge.target.cluster then 10 else 600
        else
            10 / (k * 5)

    # cluster: (alpha) ->
    #     centroids = {}
    #     alchemy.nodes.forEach (d) ->
    #         if d.cluster == ''
    #             return
    #         if d.cluster not in centroids
    #             centroids[d.cluster] = {'x':0, 'y':0, 'c':0}
    #         centroids[d.cluster].x += d.x
    #         centroids[d.cluster].y += d.y
    #         centroids[d.cluster].c++

    #     for c in centroids
    #         c.x = c.x / c.c
    #         c.y = c.y / c.c

    #     (d) ->
    #         if d.cluster is '' then return
    #         c = centroids[d.cluster]
    #         x = d.x - c.x
    #         y = d.y - c.y
    #         l = Math.sqrt( x * x * y * y)
    #         if l > nodeRadius * 2 + 5
    #             l = (l - nodeRadius) / l * alpha
    #             d.x -= x * l
    #             d.y -= y * l


    collide: (node) ->
        r = 2.2 * alchemy.utils.nodeSize(node) + conf.nodeOverlap
        nx1 = node.x - r
        nx2 = node.x + r
        ny1 = node.y - r
        ny2 = node.y + r
        return (quad, x1, y1, x2, y2) ->
            if quad.point and (quad.point isnt node)
                x = node.x - Math.abs(quad.point.x)
                y = node.y - quad.point.y
                l = Math.sqrt(x * x + y * y)
                r = r
                if l < r
                    l = (l - r) / l * conf.alpha
                    node.x -= x *= l
                    node.y -= y *= l
                    quad.point.x += x
                    quad.point.y += y
            x1 > nx2 or
            x2 < nx1 or
            y1 > ny2 or
            y2 < ny1

    tick: () ->
        if conf.collisionDetection
            q = d3.geom.quadtree(alchemy.nodes)
            for node in alchemy.nodes
                q.visit(alchemy.layout.collide(node))
        alchemy.edge.attr("x1", (d) -> d.source.x )
              .attr("y1", (d) -> d.source.y )
              .attr("x2", (d) -> d.target.x )
              .attr("y2", (d) -> d.target.y )
        alchemy.node
               .attr("transform", (d) -> "translate(#{d.x},#{d.y})")


    positionRootNodes: () ->
        container = 
            width: conf.graphWidth
            height: conf.graphHeight
        rootNodes = Array()
        for n, i in alchemy.nodes
            if not n.root then continue
            else
                n.i = i
                rootNodes.push(n)
        # if there is one root node, position it in the center
        if rootNodes.length == 1
            n = rootNodes[0]
            alchemy.nodes[n.i].x = container.width / 2
            alchemy.nodes[n.i].y = container.height / 2
            alchemy.nodes[n.i].px = container.width / 2
            alchemy.nodes[n.i].py = container.height / 2
            alchemy.nodes[n.i].fixed = conf.fixRootNodes
            return
        # position nodes towards center of graph
        else
            number = 0
            for n in rootNodes
                number++
                alchemy.nodes[n.i].x = container.width / Math.sqrt((rootNodes.length * number))#container.width / (rootNodes.length / ( number * 2 ))
                alchemy.nodes[n.i].y = container.height / 2 #container.height / (rootNodes.length / number)
                alchemy.nodes[n.i].fixed = true

    # #position the nodes
    # positionNodes: (nodes, x, y) ->
    #     if typeof(x) is 'undefined'
    #         x = container.width / 2
    #         y = container.height / 2
    #     for n in nodes
    #         min_radius = linkDistance * 3
    #         max_radius = linkDistance * 5
    #         radius = Math.random() * (max_radius - min_radius) + min_radius
    #         angle = Math.random() * 2 * Math.PI
    #         node_x = Math.cos(angle) * linkDistance
    #         node_y = Math.sin(angle) * linkDistance
    #         n.x = x + node_x
    #         n.y = y + node_y

    chargeDistance: () ->
         distance = 500
         distance
