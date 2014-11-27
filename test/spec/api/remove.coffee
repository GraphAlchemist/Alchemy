# the testing strategy needs to invoke 1 instance of alchemy!
# or, properly scope the different instances...

do ->

    describe "alchemy.remove", ->

        before ->
            window.testNodes = alchemy._nodes
            window.testNode1 = alchemy._nodes[1]
            window.testNode2 = alchemy._nodes[2]
            window.testNode3 = alchemy._nodes[3]
            window.testEdges = _.flatten _.values alchemy._edges
            window.testEdge1 = alchemy._edges["1-0"]
            window.testEdge2 = alchemy._edges["2-0"]
            window.testEdge3 = alchemy._edges["3-0"]

        describe "edges", ->
            it "should remove array of single edge when passed one edge", ->
                console.log _.flatten _.values alchemy._edges
                alchemy.get.edges([testEdge1]).remove()
                expect(_.flatten _.values alchemy._edges).to.not.deep.include.members([testEdge1])
            it "should remove array of edges when passed multiple edges", ->
                alchemy.get.edges([testEdge2, testEdge3]).remove()
                expect(_.flatten _.values alchemy._edges).to.not.deep.include.members([testEdge2, testEdge3])
            it "should remove array of all edges when passed 'alledges'", ->
                alchemy.get.edges().all().remove()
                expect(_.flatten _.values alchemy._edges).to.deep.eq []

        describe "nodes", ->
            it "should remove array of single node when passed one node", ->
                alchemy.get.nodes(testNode1.id).remove()
                expect(_.values alchemy._nodes).to.not.deep.include.members([testNode1])
            it "should remove array of nodes when passed multiple nodes", ->
                alchemy.get.nodes([testNode2.id, testNode3.id]).remove()
                expect(_.values alchemy._nodes).to.not.deep.include.members([testNode2, testNode3])
            it "should remove array of all nodes when passed 'allnodes'", ->
                alchemy.get.nodes().all().remove()
                expect(_.values alchemy._nodes).to.deep.eq []

    return
