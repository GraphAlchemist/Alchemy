do ->
    
    afterEach ->
        d3.select(".alchemy").remove() 
    
    describe "alchemy.updateGraph()", ->

        describe "alchemy.edge", ->
            alchemy.begin({'dataSource': 'sample_data/movies.json'})
            it "should be defined", ->
                console.log(alchemy.edge)
                alchemy.edge.should.not.equal undefined

            it "should contain one DOM object for each edge in dataset", ->
                console.log(alchemy.edge[0].length)
                expect(alchemy.edge[0].length).to.equal 83

        return
    return