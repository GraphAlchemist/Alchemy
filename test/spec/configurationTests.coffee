do ->
    afterEach ->
        d3.select(".alchemy").remove() 

    # Define default configuration for easy testing
    defaultConf = alchemy.defaults

    describe "Configuration testing", ->
        runWithConf = (conf) ->
            alchemy.begin(conf)

        it "should use default configuration if one is not specified", ->
            runWithConf()
            alchemy.conf.should.deep.equal defaultConf
        
        #Helpers
        describe "afterLoad", ->
            "placeholder"

        describe "dataSource", ->
            it "can find non-default datasets", ->
                runWithConf({dataSource:"sample_data/ego1.json"})
                # Make sure dataSource was changed from default (null)
                alchemy.conf.dataSource.should.equal("sample_data/ego1.json") and                
                # Make sure it can use the dataset to create elements
                alchemy.nodes.length.should.not.equal 0

        #Layout
        describe "graphWidth", ->
            it "should reassign default configuration", ->
                runWithConf({dataSource:"sample_data/movies.json", graphWidth:200 })
                alchemy.conf.graphWidth.should.equal(200)

            it "should fill parent div by default", ->
                d3.select(".alchemy").remove()
                parentDiv = d3.select("body")
                              .append("div")
                              .attr("id", "parentDiv")
                parentDiv.append("div")
                         .classed("alchemy", true)

                runWithConf({dataSource:"sample_data/movies.json"})
                d3.select(".alchemy").style("width").should.equal parentDiv.style("width")

        describe "graphHeight", ->
            it "should reassign default configuration", ->
                runWithConf({dataSource:"sample_data/movies.json", graphHeight:200 })
                alchemy.conf.graphHeight.should.equal(200)

        describe "alpha", ->
            it "should reassign default configuration", ->
                runWithConf({dataSource:"sample_data/movies.json", alpha:0.23})
                alchemy.conf.alpha.should.equal(0.23)

        describe "cluster", ->
            "placeholder"
            
        describe "clusterColours", ->
            "placeholder"       

        describe "fixNodes", ->
            "placeholder" 

        describe "fixRootNodes", ->
            "placeholder"

        describe "forceLocked", ->
            "placeholder"

        describe "linkDistance", ->
            "placeholder"

        describe "nodePositions", ->
            # not yet implemented
            "placeholder"    

        #Editing
        describe "captionToggle", ->
            "placeholder"

        describe "edgesToggle", ->
            "placeholder"

        describe "nodesToggle", ->
            "placeholder"

        describe "toggleRootNodes", ->
            "placeholder"

        describe "removeNodes", ->
            # not yet implemented
            "placeholder"

        describe "removeEdges", ->
            # not yet implemented
            "placeholder"

        describe "addNodes", ->
            # not yet implemented
            "placeholder"

        describe "addEdges", ->
            # not yet implemented
            "placeholder"

        #Control Dash
        describe "showControlDash", ->
            "placeholder"

        #Stats
        describe "showStats", ->
            "placeholder"

        describe "nodeStats", ->
            "placeholder"

        describe "edgeStats", ->
            "placeholder"

        #Filtering
        describe "showFilters", ->
            "placeholder"

        describe "edgeFilters", ->
            "placeholder"

        describe "nodeFilters", ->
            "placeholder"

        #Controls
        describe "zoomControls", ->
            "placeholder"

        #Nodes
        describe "nodeCaption", ->
            "placeholder"

        describe "nodeColour", ->
            "placeholder"
        
        describe "nodeMouseOver", ->
            "placeholder"

        describe "nodeOverlap", ->
            "placeholder"

        describe "nodeRadius", ->
            "placeholder"

        describe "nodeTypes", ->
            "placeholder"

        describe "rootNoteRadius", ->
            "placeholder"

        #Edges
        describe "edgeCaption", ->
            # not yet implemented
            "placeholder"

        describe "edgeColour", ->
            "placeholder"

        describe "edgeTypes", ->
            "placeholder"

        #Init
        describe "initialScale", ->
            "placeholder"

        describe "initialTranslate", ->
            "placeholder"

        describe "scaleExtent", ->
            # not yet implemented
            "placeholder"

        describe "warningMessage", ->
            "placeholder"        

        return
    return