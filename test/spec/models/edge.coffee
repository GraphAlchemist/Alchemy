do ->

    describe "Edge testing", ->

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

                sourceKnowsEdge = _.contains source._adjacentEdges, testEdge
                targetKnowsEdge = _.contains target._adjacentEdges, testEdge

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

        describe "getProperties(key[s]...)", ->
            it "should return the current value for @ of property at given key[s], no key returns all", ->
                testEdge.getProperties("caption").should.equal "Maintains"
                assert.deepEqual (Object.keys testEdge.getProperties("source", "target")), ["source", "target"]
                (Object.keys testEdge.getProperties()).length.should.equal 3

        describe "setProperties(property, value)", ->
            it "should set @_properties[property] to value", ->
                initialCaption = testEdge.getProperties('caption')
                testEdge.setProperties "caption", "newCaption"
                newCaption = testEdge.getProperties('caption')

                initialCaption.should.not.equal newCaption and
                newCaption.should.not.equal "Maintains"
                testEdge.setProperties "caption", "Maintains"

            it "should change specified @_d3 property, including source/target", ->
                initialSource = testEdge._d3.source
                testEdge.setProperties "source", 4
                newSource = testEdge._d3.source

                initialSource.should.not.equal newSource and
                newSource.should.not.equal 1
                testEdge.setProperties "source", 1

            it "should also accept and assign arbitrary properties", ->
                testEdge.setProperties "Indiana", "Jones"
                testEdge._properties["Indiana"].should.equal "Jones"

        describe "getStyles(key[s]...)", ->
            it "should return current styles for @ at given key[s], no keys returns all", ->
                testEdge.getStyles("color").should.eql ["#CCC"]
                assert.deepEqual testEdge.getStyles("opacity", "curved"), [0.2, true]
                (Object.keys testEdge.getStyles()).length.should.equal 8

            it "should return the styles for all keys passed in", ->
                testEdge.getStyles("color", "width").should.eql(["#CCC", 4])

        describe "setStyles(key..., value...)", ->
            it "should appeal to alchemy.svgStyles if called bare", ->
                initialStyles = testEdge.getStyles()
                assert.deepEqual (testEdge.setStyles().getStyles()), initialStyles

            it "should update an edge style, if given a key and value", ->
                testEdge.setStyles({"width": 6})
                testEdge.getStyles("width")[0].should.equal 6

            it "should update multiple styles too", ->
                testEdge.setStyles {"width": 4, "color": "#FFFFFF", "opacity": 1}
                assert.deepEqual testEdge.getStyles("width", "color", "opacity"), [4, "#FFFFFF", 1]

            it "should allow for addition of arbitrary novel styles", ->
                testEdge.setStyles({"noshadow": "noshadow"})
                testEdge.getStyles("noshadow")[0].should.equal "noshadow"

        describe "toggleHidden", ->
            it "should toggle @_state, between 'active' and 'hidden'", ->
                testEdge._state.should.equal "hidden"
                testEdge.toggleHidden()
                testEdge._state.should.equal "active"

        describe "allNodesActive", ->
            it "should return a boolean, true if @._source and target are both currently active", ->
                alchemy.get.nodes(testEdge._properties.target)[0]._state = "active"
                testEdge.allNodesActive().should.equal true
                alchemy.get.nodes(testEdge._properties.target)[0]._state = "hidden"
                testEdge.allNodesActive().should.equal false

    return

