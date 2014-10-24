# the testing strategy needs to invoke 1 instance of alchemy!
# or, properly scope the different instances...

do ->

    before (done) ->
        alchemy.begin({'dataSource': 'sample_data/contrib.json', 'nodeTypes': {'role': ['maintainer', 'project']}})
        setTimeout(done, 1000)

    describe "alchemy.models.Node", ->

        before ->
           window.testNode = alchemy._nodes[0]

        describe "@constructor", ->
            describe '@_d3', ->
                it "should initialize as an object", ->       
                    _d3Type = typeof testNode._d3
                    typeof _d3Type.should.equal typeof {}
                
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
                    edgesType = typeof testNode._adjacentEdges
                    arrayType = typeof []
                    edgesType.should.equal arrayType

        describe "_setNodeType", ->
            it "should set nodeType of @, if any", ->
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

        describe "removeProperty", ->
            it "should accept parameter [property] and remove said property/properties if exist", ->
                testNode.removeProperty("caption")
                testNode._properties.should.not.include.keys "caption"

        describe "getStyles", ->
            it "should accept optional parameter [key] and return style object or value", ->
                testNode.getStyles().should.include.keys "radius"
                testNode.getStyles("captionSize").should.equal 12

        describe "setStyles", -> 
            it "should accept [key, value] and update or create the property, and draw the resultant state", ->
                testNode.setStyles("radius", 20)
                testNode.getStyles("radius").should.equal 20
                testNode.setStyles("foo", "bar")
                testNode.getStyles("foo").should.equal "bar"

        describe "toggleHidden", ->
            it "should toggle the _state of the node (and its _adjacentEdges) between 'active' and 'hidden'", ->
                testNode.toggleHidden()
                testNode._state.should.equal "hidden"







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