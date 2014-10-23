do ->
    describe "alchemy.models.Edge", ->

        before (done)->
            alchemy.begin({'dataSource': 'sample_data/contrib.json'})
            setTimeout(done, 1000)

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    testEdge = alchemy._edges["1-0"][0]
                    _d3Type = typeof testEdge._d3
                    objType = typeof {}

                    typeof _d3Type.should.equal objType

                it "should contain properties from d3 calculations", ->
                    testEdge = alchemy._edges["1-0"][0]
                    _d3Keys = _.keys testEdge._d3
                    d3Properties = ['id', 'source', 'target']

                    overlap = _.intersection _d3Keys, d3Properties

                    overlap.length.should.equal d3Properties.length

                it "should contain a copy of the edge id", ->
                    testEdge = alchemy._edges["1-0"][0]
                    testEdge._d3.id.should.equal testEdge.id

            it "should inform source and target nodes that it is connected", ->
                positionInEdgeArray = 0
                testEdge = alchemy._edges["1-0"][positionInEdgeArray]
                source = alchemy._nodes[testEdge._d3.source.id]
                target = alchemy._nodes[testEdge._d3.target.id]

                fullEdgeId = "#{testEdge.id}-#{positionInEdgeArray}"

                sourceKnowsEdge = _.contains source._adjacentEdges, fullEdgeId
                targetKnowsEdge = _.contains target._adjacentEdges, fullEdgeId

                sourceKnowsEdge.should.equal true
                targetKnowsEdge.should.equal true

        describe "Property accessor/modifier methods", ->
            describe "setProperties()", ->
                it "should change specificed property", ->
                    testEdge = alchemy._edges["1-0"][0]
                    # Initial caption is "Maintains"
                    initialCaption = testEdge.getProperties('caption')

                    testEdge.setProperties "caption", "newCaption"
                    newCaption = testEdge.getProperties('caption')

                    initialCaption.should.not.equal newCaption and
                    newCaption.should.not.equal "Maintains"

            describe "setProperties(source/target)", ->
                it "should change specified _d3 property", ->
                    testEdge = alchemy._edges["1-0"][0]
                    # Initial source is 1
                    initialSource = testEdge._d3.source
                    newSource = 4
                    testEdge.setProperties "source", 4
                    newSource = testEdge._d3.source

                    initialSource.should.not.equal newSource &&
                    newSource.should.not.equal 1

                    # Resetting for future tests without reload
                    testEdge.setProperties "source", 1

    return