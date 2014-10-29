do ->

    describe "alchemy.startGraph()", ->

        it "should append svg to #alchemy div", () ->
            expect(d3.select('#alchemy').select("svg")).to.have.length(1)
        
        describe "alchemy._nodes", ->
            it "should define alchemy._nodes", () ->
                alchemy._nodes.should.not.equal undefined
            it "should have ids as keys", () ->
                keys = _.keys(alchemy._nodes)
                
                keysThatAreNotIDs = 0
                for key in keys
                    keysThatAreNotIDs += 1 if !alchemy._nodes[key]?

        describe "alchemy._edges", ->
            it "should define alchemy._edges", () ->
                alchemy._edges.should.not.equal undefined
            return

        it "should define alchemy.force", () ->
            alchemy.force.should.not.equal(undefined)
        return
    return