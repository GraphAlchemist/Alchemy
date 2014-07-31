do ->
    describe "alchemy.startGraph()", ->
        alchemy.begin({'dataSource': 'sample_data/contrib.json'})
        it "should append svg to #alchemy div", (done) ->
            expect(d3.select('#alchemy').select("svg")).to.have.length(1)
            done()
        
        describe "alchemy.nodes", ->
            it "should define alchemy.nodes", (done) ->
                alchemy._nodes.should.not.equal undefined
                done()

        describe "alchemy.edges", ->
            it "should define alchemy.edges", (done) ->
                alchemy._edges.should.not.equal undefined
                done()
            return

        it "should define alchemy.force", (done) ->
            alchemy.force.should.not.equal(undefined)
            done()
        return
    return