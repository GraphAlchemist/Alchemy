alchemy.layout =
    charge: (node) ->
        # debugger
        if conf.cluster
            # value = Math.floor(Math.sqrt(node.connectedNodes * 2)) * 35
            # -value
            -500
        else
            -150
            # if typeof(node.connectedNodes is 'undefined') then node.connectedNodes = 0
            # node.connectedNodes++
            # value = Math.floor(Math.sqrt(node.connectedNodes * 2)) * 35
            # -value
            # # -30

    linkStrength: (edge) ->
        if conf.cluster
             if edge.source.cluster is edge.target.cluster then 1 else 0.1
        else
             if edge.source.root or edge.target.root
                 1
             else
                 .5
        
    

    friction: () ->
        if conf.cluster
            0.7
        else
            0.9

    linkDistanceFn: (edge) ->
        if conf.cluster
            if edge.source.root or edge.target.root
                500
            else if edge.source.cluster is edge.target.cluster 
                50
            else
                300
        else
            20
        #     # if edge.source.cluster is edge.target.cluster then false
        # else 
        #     if edge.source.root and edge.target.root then 500
        #     else if edge.source.root or edge.target.root then 700
        #     else 800
        # 20

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
        r = alchemy.utils.nodeSize(node) + conf.nodeOverlap
        nx1 = node.x - r
        nx2 = node.x + r
        ny1 = node.y - r
        ny2 = node.y + r
        return (quad, x1, y1, x2, y2) ->
            if quad.point and (quad.point isnt node)
                x = node.x - Math.abs(quad.point.x)
                y = node.y - quad.point.y
                l = Math.sqrt(x * x + y * y)
                r = conf.nodeOverlap
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
                if not node.root
                    q.visit(alchemy.layout.collide(node))
        alchemy.edge.attr("x1", (d) -> d.source.x )
              .attr("y1", (d) -> d.source.y )
              .attr("x2", (d) -> d.target.x )
              .attr("y2", (d) -> d.target.y )
        alchemy.node
               .attr("transform", (d) -> 
                if d.root then debugger
                "translate(#{d.x},#{d.y})")


    positionRootNodes: () ->
        container = 
            width: conf.graphWidth
            height: conf.graphHeight
        rootNodes = Array()
        for n in alchemy.nodes
            if not n.root then continue
            else
        #currently we center the graph on one or two root nodes
                n.x = container.width / 2
                n.y = container.height / 2
                n.px = container.width / 2
                n.py = container.height / 2
                # n.fixed = conf.fixRootNodes
                n.fixed = true
                n.r = conf.rootNodeRadius
                return
                # if rootNodes.length == 1
                #     rootNodes[0].x = container.width / 2
                #     rootNodes[0].y = container.height / 2
                #     rootNodes[0].px = container.width / 2
                #     rootNodes[0].py = container.height / 2
                #     rootNodes[0].fixed = conf.fixRootNodes
                #     rootNodes[0].r = conf.rootNodeRadius
                #     return
                # else
                #     rootNodes[0].x = container.width * 0.25
                #     rootNodes[0].y = container.height / 2
                #     rootNodes[0].px = container.width * 0.25
                #     rootNodes[0].py = container.height / 2
                #     rootNodes[0].fixed = conf.fixRootNodes
                #     rootNodes[0].r = conf.rootNodeRadius
                #     rootNodes[1].x = container.width * 0.75
                #     rootNodes[1].y = container.height / 2
                #     rootNodes[1].px = container.width * 0.75
                #     rootNodes[1].py = container.height / 2
                #     rootNodes[1].fixed = conf.fixRootNodes
                #     rootNodes[1].r = conf.rootNodeRadius
                #     return

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

    chargeDistance: (distance) ->
         distance
