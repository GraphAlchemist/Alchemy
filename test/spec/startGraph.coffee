do ->
    describe "alchemy.startGraph()", ->
        before (done) ->
            alchemy.begin({'dataSource': 'sample_data/contrib.json'})
            setTimeout(done, 1000)

        it "should append svg to #alchemy div", (done) ->
            expect(d3.select('#alchemy').select("svg")).to.have.length(1)
            done()
        
        describe "alchemy._nodes", ->
            it "should define alchemy._nodes", (done) ->
                alchemy._nodes.should.not.equal undefined
                done()
            it "should have ids as keys", (done) ->
                keys = _.keys(alchemy._nodes)
                
                keysThatAreNotIDs = 0
                for key in keys
                    keysThatAreNotIDs += 1 if !alchemy._nodes[key]?
                done()

        describe "alchemy._edges", ->
            it "should define alchemy._edges", (done) ->
                alchemy._edges.should.not.equal undefined
                done()
            return

        it "should define alchemy.force", (done) ->
            alchemy.force.should.not.equal(undefined)
            done()
        return
    return