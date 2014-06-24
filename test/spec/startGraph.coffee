do ->
    describe "alchemy.startGraph()", ->
        it "should append svg to .alchemy div", () ->
            expect(d3.select('.alchemy').select("svg")).to.have.length(1)
            return
        return

        it "should define alchemy.force", ->
            alchemy.force.should.equal(undefined)
            return
        return