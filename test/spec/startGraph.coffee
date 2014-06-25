do ->
    beforeEach ->
        alchemy.begin({'dataSource': 'sample_data/movies.json'})
    
    afterEach ->
        d3.select(".alchemy").remove()

    describe "alchemy.startGraph()", ->
    
        it "should append svg to .alchemy div", () ->
            expect(d3.select('.alchemy').select("svg")).to.have.length(1)
        
        describe "alchemy.nodes", ->
            it "should define alchemy.nodes", ->
                alchemy.nodes.should.not.equal undefined

        describe "alchemy.edges", ->
            it "should define alchemy.edges", ->
                alchemy.edges.should.not.equal undefined

        it "should define alchemy.force", ->
            alchemy.force.should.not.equal(undefined)
    
        return
    return