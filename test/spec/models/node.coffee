# the testing strategy needs to invoke 1 instance of alchemy!
# or, properly scope the different instances...

# currently, these tests all pass in the browser ("grunt test:keepalive")
# but some fail in terminal ("grust test")

do ->

    describe "Node Testing", ->

        before -> window.testNode = alchemy._nodes[0]

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->
                    (typeof testNode._d3).should.equal typeof {}

                it "should contain properties from d3 calculations", ->
                    _d3Keys = _.keys testNode._d3
                    d3Properties = ['x', 'y', 'px', 'py', 'weight']
                    overlap = _.intersection _d3Keys, d3Properties
                    overlap.length.should.equal d3Properties.length

                it "should contain a copy of the node id", ->
                    testNode = alchemy._nodes[0]
                    testNode._d3.id.should.equal testNode.id

            describe "@_adjacentEdges", ->
                it "should be an array", ->
                    (typeof testNode._adjacentEdges).should.equal typeof []

                it "should contain all and only edges with a relationship to @", ->
                    assert.deepEqual testNode._adjacentEdges, _.flatten _.values testNode.a._edges

        describe "_setNodeType", ->
            it "should set nodeType of @, if any", ->
                testNode.a.conf.nodeTypes = {"role":["project", "Maintainer", "Contributor"]}
                testNode._setNodeType().should.equal "project"

        describe "_addEdge", ->
            it "should return an array of _adjacentEdges, including an edge passed in", ->
                testNode._addEdge("5-5-5")
                testNode._adjacentEdges.should.include("5-5-5")

        describe "getProperties", ->
            it "should return a list of the current node properties", ->
                testNode.getProperties().should.equal testNode._properties
                testNode.getProperties("caption").should.equal "AlchemyJS"

        describe "setProperty", ->
            it "should accept parameters [property, value], and set @'s property to that value", ->
                testNode.setProperty("caption", "ChemistryPy")
                testNode.getProperties("caption").should.equal "ChemistryPy"
            it "should accept parameters {property1: value1, property2: value2}, and set multiple properties", ->
                testNode.setProperty({"foo": "bar", "this": "that"})
                testNode.getProperties("foo").should.equal "bar"
                testNode.getProperties("this").should.equal "that"

        describe "removeProperty", ->
            it "should accept parameter [property] and remove said property/properties if exist", ->
                testNode.removeProperty("caption")
                testNode._properties.should.not.include.keys "caption"

        describe "removeProperty", ->
            it "should also accept multiple properties", ->
                testNode.removeProperty("role", "id", "root")
                testNode._properties.should.not.include.keys "root"

        describe "getStyles", ->
            it "should accept optional parameter [key] and return style object or value", ->
                testNode.getStyles().should.include.keys "radius"
                testNode.getStyles("captionSize").should.eql [12]

            it "should return a value for each key passed in", ->
                testNode.getStyles("captionSize", "color").should.eql [12, "#68B9FE"]

        describe "setStyles", ->
            it "should accept [key, value] and update or create the property, and draw the resultant state", ->
                testNode.setStyles("radius", 20)
                testNode.getStyles("radius")[0].should.equal 20
                testNode.setStyles("foo", "bar")
                testNode.getStyles("foo")[0].should.equal "bar"

        describe "toggleHidden", ->
            it "should toggle the _state of the node (and its _adjacentEdges) between 'active' and 'hidden'", ->
                testNode._adjacentEdges.pop()
                testNode.toggleHidden()
                testNode._state.should.equal "hidden"
                testNode._adjacentEdges.should.not.contain "hidden"

        describe "outDegree", ->
            it "should return the number of adjacentEdges", ->
                testNode.outDegree().should.equal 6

    return
