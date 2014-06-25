do ->
    afterEach ->
        d3.select(".alchemy").remove() 

    describe "alchemy.updateGraph()", ->

        describe "alchemy.edge", ->
            alchemy.begin({'dataSource': 'sample_data/movies.json'})
            
            it "should be defined", ->
                alchemy.edge.should.not.equal undefined

        describe "alchemy.node", ->
            alchemy.begin({'dataSource': 'sample_data/movies.json'})

            it "should be defined", ->
                alchemy.node.should.not.equal undefined
        return
    return