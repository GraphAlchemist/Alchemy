# the testing strategy needs to invoke 1 instance of alchemy!
# or, properly scope the different instances...

do ->
    describe "alchemy.models.Node", ->

        before (done)->
            alchemy.begin({'dataSource': 'sample_data/contrib.json'})
            setTimeout(done, 1000)

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    testNode = alchemy._nodes[0]
                    _d3Type = typeof testNode._d3
                    objType = typeof {}

                    typeof _d3Type.should.equal objType
                
                it "should contain properties from d3 calculations", ->
                    testNode = alchemy._nodes[0]
                    _d3Keys = _.keys testNode._d3
                    d3Properties = ['x', 'y', 'px', 'py', 'weight']

                    overlap = _.intersection _d3Keys, d3Properties

                    overlap.length.should.equal d3Properties.length
                
                it "should contain a copy of the node id", ->
                    testNode = alchemy._nodes[0]
                    testNode._d3.id.should.equal testNode.id

        describe "@_adjacentEdges", ->
            it "should be an array", ->
                testNode = alchemy._nodes[0]
                edgesType = typeof testNode._adjacentEdges
                arrayType = typeof []

                edgesType.should.equal arrayType


            # it "should contain ids of all connected edges", ->
            #     testNode = alchemy._nodes[0]
            #     edges = testNode._adjacentEdges
            #     edgeIDsFromData = ["1-0", "2-0", "3-0", "4-0", "5-0"]

            #     edges.should.eql edgeIDsFromData

        # describe "outDegree()", ->
        #     it "should return number of connections to node", ->
        #         testNode = alchemy._nodes[0]
        #         testNode.outDegree().should.equal 5

    return