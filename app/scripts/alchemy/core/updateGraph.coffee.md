    Alchemy::updateGraph = (instance)->
        a = instance

        ()->
            a.generateLayout()
            
            a._drawEdges.createEdge a.elements.edges.d3
            a._drawNodes.createNode a.elements.nodes.d3

            a.index()

            a.layout.positionRootNodes()
            a.force.start()
            a.force.tick() while a.force.alpha() > 0.005
            a.force.on "tick", a.layout.tick
              .start()

            a.elements.nodes.svg
                .attr 'transform', (id, i) -> "translate(#{id.x}, #{id.y})"
