do ->
    describe "alchemy.models.Edge", ->

        before (done)->
            alchemy.begin({'dataSource': 'sample_data/contrib.json'})
            setTimeout(done, 1000)

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    testEdge = alchemy._edges["1-0"]
                    _d3Type = typeof testEdge._d3
                    objType = typeof {}

                    typeof _d3Type.should.equal objType

                it "should contain properties from d3 calculations", ->
                    testEdge = alchemy._edges["1-0"]
                    _d3Keys = _.keys testEdge._d3
                    d3Properties = ['id', 'source', 'target']

                    overlap = _.intersection _d3Keys, d3Properties

                    overlap.length.should.equal d3Properties.length

                it "should contain a copy of the edge id", ->
                    testEdge = alchemy._edges["1-0"]
                    testEdge._d3.id.should.equal testEdge.id

            it "should inform source and target nodes that it is connected", ->
                testEdge = alchemy._edges["1-0"]
                source = alchemy._nodes[testEdge._d3.source.id]
                target = alchemy._nodes[testEdge._d3.target.id]

                sourceKnowsEdge = _.contains source.adjacentEdges, testEdge.id
                targetKnowsEdge = _.contains target.adjacentEdges, testEdge.id

                sourceKnowsEdge.should.equal true
                targetKnowsEdge.should.equal true

        describe "Property accessor/modifier methods", ->
            describe "setProperty()", ->
                it "should change specificed property", ->
                    testEdge = alchemy._edges["1-0"]
                    # Initial caption is "Maintains"
                    initialCaption = testEdge._rawEdge.caption

                    testEdge.setProperty "caption", "newCaption"
                    newCaption = testEdge._rawEdge.caption

                    initialCaption.should.not.equal newCaption &&
                    newCaption.should.not.equal "Maintains"

            describe "setD3Property()", ->
                it "should change specified _d3 property", ->
                    testEdge = alchemy._edges["1-0"]
                    # Initial source is 1
                    initialSource = testEdge._d3.source

                    testEdge.setD3Property "source", "newSource"
                    newSource = testEdge._d3.source

                    initialSource.should.not.equal newSource &&
                    newSource.should.not.equal 1

                    # Resetting for future tests without reload
                    testEdge.setD3Property "source", 1

    return