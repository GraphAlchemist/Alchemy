do ->
    # Define default configuration for easy testing
    defaultConf = alchemy.defaults

    describe "Configuration testing", ->
        runWithConf = (conf) ->
            alchemy.begin(conf)

        #Helpers
        describe "afterLoad", ->
            "placeholder"

        describe "dataSource", ->
            it "can find non-default datasets", (done) ->
                runWithConf({dataSource:"sample_data/contrib.json"})
                # Make sure dataSource was changed from default (null)
                alchemy.conf.dataSource.should.equal("sample_data/contrib.json") and Object.keys(alchemy._nodes).length.should.equal 6
                done()

        #Layout
        describe "graphWidth", ->
            it "should reassign default configuration", (done) ->
                runWithConf({dataSource:"sample_data/contrib.json", graphWidth:200 })
                alchemy.conf.graphWidth.should.equal(200)
                done()

        describe "graphHeight", ->
            it "should reassign default configuration", (done) ->
                runWithConf({dataSource:"sample_data/contrib.json", graphHeight: () -> 200 })
                alchemy.conf.graphHeight().should.equal(200)
                done()

        describe "alpha", ->
            it "should reassign default configuration", (done) ->
                runWithConf({dataSource:"sample_data/contrib.json", alpha:0.23})
                alchemy.conf.alpha.should.equal(0.23)
                done()

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
