do ->
    "use strict"
    describe "Test basic graph structure with nodes", ->
        it "DOM should match raw data", () ->
            expect(d3.selectAll('.node')[0]).to.have.length(graphJSON.nodes.length)
            return
        return