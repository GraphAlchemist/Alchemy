do ->

    describe "alchemy.models.Edge", ->

        before ->
           window.testEdge = alchemy._edges["1-0"][0] 

        describe "@constructor", ->

           describe '@_d3', ->
                it "should initialize as an object", ->
                    (typeof testEdge._d3).should.equal typeof {}

                it "should contain properties from d3 calculations", ->
                    _d3Keys = _.keys testEdge._d3
                    d3Properties = ['id', 'source', 'target', 'pos', 'edgeType']
                    overlap = _.intersection _d3Keys, d3Properties
                    overlap.length.should.equal d3Properties.length

                it "should contain a copy of the edge id", ->
                    testEdge._d3.id.should.equal testEdge.id

            it "should inform source and target nodes that it is connected", ->
                source = alchemy._nodes[testEdge._d3.source.id]
                target = alchemy._nodes[testEdge._d3.target.id]

                fullEdgeId = "#{testEdge.id}-0"

                sourceKnowsEdge = _.contains source._adjacentEdges, fullEdgeId
                targetKnowsEdge = _.contains target._adjacentEdges, fullEdgeId

                sourceKnowsEdge.should.equal true
                targetKnowsEdge.should.equal true

        describe "_setID(edge)", ->
            it "should construct an edge id if not already provided in conf", ->
                testEdge.id.should.equal "1-0"

        describe "_setCaption(edge, conf)", ->
            it "should set @_d3.caption to the edgeCaption provided in conf", ->
                testEdge._d3.caption.should.equal "Maintains"


        describe "_setEdgeType()", ->
            it "should set @_d3.edgeType to value from conf-- if none provided, default to 'all'", ->
                testEdge._d3.edgeType.should.equal "all"
                alchemy.setConf({"edgeTypes": "murp"})
                alchemy.setConf({"edgeTypes": null})

        describe "setProperties(property, value)", ->
            it "should set @_properties[property] to value", ->
                # Initial caption is "Maintains"
                initialCaption = testEdge.getProperties('caption')

                testEdge.setProperties "caption", "newCaption"
                newCaption = testEdge.getProperties('caption')

                initialCaption.should.not.equal newCaption and
                newCaption.should.not.equal "Maintains"

            it "should change specified @_d3 property, including source/target", ->
                # Initial source is 1
                initialSource = testEdge._d3.source
                testEdge.setProperties "source", 4
                newSource = testEdge._d3.source

                initialSource.should.not.equal newSource and
                newSource.should.not.equal 1

                # Resetting for future tests without reload
                testEdge.setProperties "source", 1

            it "should also accept and assign arbitrary properties", ->
                testEdge.setProperties "Indiana", "Jones"
                testEdge._properties["Indiana"].should.equal "Jones"

    return