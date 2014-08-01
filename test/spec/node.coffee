do ->
    describe "alchemy.models.Node", ->

        before (done)->
            alchemy.begin({'dataSource': 'sample_data/contrib.json'})
            setTimeout(done, 1000)

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    testNode = alchemy._nodes[0]
                    typeof testNode._d3.should.equal typeof Object()
                
                it "should contain properties from d3 calculations", ->
                    testNode = alchemy._nodes[0]
                    _d3Keys = _.keys testNode._d3
                    d3Properties = ['x', 'y', 'px', 'py', 'weight']

                    overlap = _.intersection _d3Keys, d3Properties

                    overlap.length.should.equal d3Properties.length
                
                it "should contain a copy of the node id", ->
                    testNode = alchemy._nodes[0]
                    testNode._d3.id.should.equal testNode.id

        describe "@edges", ->
            it "should be an array", ->
                testNode = alchemy._nodes[0]
                typeof testNode.edges.should.equal typeof Array()

            # Not currently supported by edge constructor
            it "should contain ids of all connected edges", ->
                # testNode = alchemy._nodes[0]
                # edges = testNode.edges
                # edgeIDsFromData = ["1-0", "2-0", "3-0", "4-0", "5-0"]

                # edges.should.equal edgeIDsFromData

        describe "outDegree()", ->
            # Not currently supported by edge constructor
            it "should return number of connections to node", ->
                # testNode = alchemy._nodes[0]
                # testNode.outDegree().should.equal 5

    return