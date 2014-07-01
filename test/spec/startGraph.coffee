do ->
    beforeEach (done) ->
        alchemy.begin({'dataSource': 'sample_data/movies.json'})
        done()
        return
    
    afterEach(done) ->
        d3.select("#alchemy").remove()
        done()
        return

    describe "alchemy.startGraph()", ->

        it "should append svg to #alchemy div", () ->
            expect(d3.select('#alchemy').select("svg")).to.have.length(1)
            return
        
        describe "alchemy.nodes", ->
            it "should define alchemy.nodes", ->
                alchemy.nodes.should.not.equal undefined
                return
            return

        describe "alchemy.edges", ->
            it "should define alchemy.edges", ->
                alchemy.edges.should.not.equal undefined
                return
            return

        it "should define alchemy.force", ->
            alchemy.force.should.not.equal(undefined)
            return
    
        return
    return