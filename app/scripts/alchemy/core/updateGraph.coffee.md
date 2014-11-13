    Alchemy::updateGraph = (instance)->
        a = instance

        ()->
            a.generateLayout()
            
            d3Edges = _.flatten _.map(a._edges, (edgeArray) -> e._d3 for e in edgeArray)
            d3Nodes = _.map a._nodes, (n) -> n._d3

            a._drawEdges.createEdge d3Edges
            a._drawNodes.createNode d3Nodes

            a.layout.positionRootNodes()
            a.force.start()
            a.force.tick() while a.force.alpha() > 0.005
            a.force.on "tick", a.layout.tick
              .start()

            a.vis.selectAll 'g.node'
                .attr 'transform', (id, i) -> "translate(#{id.x}, #{id.y})"
