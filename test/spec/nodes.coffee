do ->
    beforeEach ->
        d3.json('sample_data/movies.json', (data) ->
            this.graphJSON = data
            alchemy.begin({'dataSource': data})
            return)
    
    afterEach ->
        d3.select(".alchemy").remove() 

    "use strict"
    describe "Test basic graph structure with nodes", ->
        it "DOM should match raw data", () ->
            expect(d3.selectAll('.node')[0]).to.have.length(graphJSON.nodes.length)
    
        return
    return