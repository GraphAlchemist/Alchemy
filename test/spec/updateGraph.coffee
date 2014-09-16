do ->
    describe "alchemy.updateGraph()", ->
        alchemy.begin({'dataSource': 'sample_data/contrib.json'})
        
        describe "alchemy._edges", ->
            it "should be defined", (done) ->
                alchemy._edges.should.not.equal undefined
                done()

        describe "alchemy._nodes", ->
            it "should be defined", (done) ->
                alchemy._nodes.should.not.equal undefined
                done()
        return
    return