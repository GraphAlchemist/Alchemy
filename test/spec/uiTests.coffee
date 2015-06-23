do ->  

    describe "UI testing", ->
        before -> 
       		alchemy.vis = d3.select('svg')

        describe "alchemy d3", ->
            it "should present to the browser all info necessary to render data", ->
                d3.select('g.node').text().should.equal "AlchemyJS"
                d3.select('g.edge').text().should.equal "Maintains"
                alchemy.vis.attr('alchInst').should.equal "0"

    return
