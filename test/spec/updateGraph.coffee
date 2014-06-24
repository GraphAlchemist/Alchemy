do ->
    afterEach ->
        d3.select(".alchemy").remove() 
    
    describe "alchemy.updateGraph()", ->

        describe "alchemy.edge", ->
            alchemy.begin({'dataSource': 'sample_data/movies.json'})
            
            it "should be defined", ->
                alchemy.edge.should.not.equal undefined

            it "should contain one DOM object for each edge in dataset", (done)->
                expect(alchemy.edge[0].length).to.equal 83
                done()

        describe "alchemy.node", ->
            alchemy.begin({'dataSource': 'sample_data/movies.json'})

            it "should be defined", ->
                alchemy.node.should.not.equal undefined

            it "should contain one DOM object for each node in dataset", (done)->
                expect(alchemy.node[0].length).to.equal 69
                done()

        return
    return