do ->
    describe "alchemy.models.Node", ->
        alchemy.begin({'dataSource': 'sample_data/contrib.json'})
        testNode = alchemy._nodes[0]

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    typeof testNode._d3.should.equal Object
                    done()
                
                it "should contain properties from d3 calculations", ->
                    _d3Keys = _.keys testNode._d3
                    d3Properties = ['x', 'y', 'px', 'py', 'weight']

                    overlap = _.intersection _d3Keys, d3Properties

                    overlap.length.should.equal d3Properties.length
                    done()
                
                it "should contain a copy of the node id", ->
                    testNode._d3.id.should.equal testNode.id
                    done()

        describe "@edges", ->
            it "should be an array", ->
                typeof testNode.edges.should.equal Array
                done()

            it "should contain ids of all connected edges", ->
                edges = testNode.edges
                edgeIDsFromData = ["1-0", "2-0", "3-0", "4-0", "5-0"]

                edges.should.equal edgeIDsFromData

        describe "outDegree()", ->
            it "should return number of connections to node", ->
                testNode.outDegree.should.equal 5

    return