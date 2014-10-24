# do ->
# 	describe "alchemy.get", ->


#         describe "alchemy.get.allNodes()", ->
# 	        it "should return an array of all nodes", () ->
# 	            expect(alchemy.get.allNodes()).to.have.length(6)

# 	    describe "alchemy.get.activeNodes()", ->
# 	    	it "should return an array of all active nodes", () ->
# 	    		stateArray = _.map alchemy.get.activeNodes(), (n) -> n._state
# 	    		expect(_.unique(stateArray)).to.have.length(1)
# 	    		expect(_.unique(stateArray)[0]).to.equal("active")
     
#      #  this test currently passes no matter what you assert	
#      #  describe "alchemy.get.nodes()", ->
#      #    	it "should, given an id set, return an array of matching node(s)", () ->
#      #    	    node0 = alchemy._nodes[0]
#      #    	    node1 = alchemy._nodes[1]
#      #    	    node5 = alchemy._nodes[4]
#      #    		expect(alchemy.get.nodes(0)).to.equal(node5)

#     return
