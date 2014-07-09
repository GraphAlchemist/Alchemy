do ->
    describe "alchemy.updateGraph()", ->
        alchemy.begin({'dataSource': 'sample_data/movies.json'})
        
        describe "alchemy.edge", ->
            it "should be defined", (done) ->
                alchemy.edge.should.not.equal undefined
                done()

        describe "alchemy.node", ->
            it "should be defined", (done) ->
                alchemy.node.should.not.equal undefined
                done()
        return
    return