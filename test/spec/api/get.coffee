# the testing strategy needs to invoke 1 instance of alchemy!
# or, properly scope the different instances...

do ->

    describe "alchemy.get", ->

        before ->
            window.testNodes = alchemy._nodes
            window.testNode1 = alchemy._nodes[0]
            window.testNode2 = alchemy._nodes[1]
            window.testEdges = _.flatten _.values alchemy._edges
            window.testEdge1 = alchemy._edges["1-0"]
            window.testEdge2 = alchemy._edges["2-0"]

        describe "nodes", ->
            it "should return array of all nodes when chained with .all()'", ->
                containedNodes = _.map alchemy.get.nodes().all(), (n)-> n
                expect(containedNodes).to.deep.include.members(_.values testNodes);
            it "should return array of single node when passed one node id", ->
                containedNode = _.map alchemy.get.nodes(0), (n)-> n
                expect(containedNode).to.deep.include.members([testNode1]);
            it "should return array of nodes when passed multiple node ids", ->
                containedNodes = _.map alchemy.get.nodes(0, 1), (n)-> n
                expect(containedNodes).to.deep.include.members([testNode1, testNode2]);

        describe "edges", ->
            it "should return array of all edges when chained with .all()", ->
                containedEdges = _.map alchemy.get.edges().all(), (e)-> e
                expect(containedEdges).to.deep.include.members(_.values testEdges);
            it "should return array of single edge when passed one edge id", ->
                containedEdge = _.map alchemy.get.edges("1-0"), (e)-> e
                expect(containedEdge).to.deep.include.members(testEdge1);
            it "should return array of edges when passed multiple edge ids", ->
                containedEdges = _.map alchemy.get.edges("1-0", "2-0"), (e)-> e
                expect(containedEdges).to.deep.include.members(testEdge1, testEdge2);

        describe "elState", ->
            it "should return array subset of node(s) of passed state", ->
                containedNodes = _.map alchemy.get.nodes(0, 1).elState("active"), (n)-> n
                expect(containedNodes).to.deep.include.members([testNode2]);
            it "should return array subset of edge(s) of passed state", ->
                containedEdges = _.map alchemy.get.edges("1-0", "2-0").elState("active"), (e)-> e
                testEdge1Active = _.compact _.map testEdge1, (e) -> e if e._state is "active"
                testEdge2Active = _.compact _.map testEdge2, (e) -> e if e._state is "active"
                expect(containedEdges).to.deep.include.members(testEdge1Active, testEdge2Active);

        describe "type", ->
            it "should return array subset of node(s) of passed type", ->
                containedNodes = _.map alchemy.get.nodes(0, 1).type("project"), (n)-> n
                expect(containedNodes).to.deep.include.members([testNode1]);
            it "should return array subset of edge(s) of passed type", ->
                containedEdges = _.map alchemy.get.edges("1-0", "2-0").type("all"), (e)-> e
                testEdge1Active = _.compact _.map testEdge1, (e) -> e if e._type is "all"
                testEdge2Active = _.compact _.map testEdge2, (e) -> e if e._type is "all"
                expect(containedEdges).to.deep.include.members(testEdge1Active, testEdge2Active);
    return
