do ->

    before (done) ->
        alchemy.begin({
            'dataSource': 'sample_data/contrib.json',
            graphWidth: () -> 200,
            graphHeight: () -> 200,
            alpha: 0.23,
            'nodeTypes': {'role': ['maintainer', 'project']}
        })
        setTimeout(done, 1000)
    
     describe "Configuration testing", ->

         #Helpers
         describe "afterLoad", ->
             "placeholder"

         describe "dataSource", ->
             it "can find non-default datasets", ->
                 # Make sure dataSource was changed from default (null)
                 alchemy.conf.dataSource.should.equal("sample_data/contrib.json") and Object.keys(alchemy._nodes).length.should.equal 6

         #Layout
         describe "graphWidth", ->
             it "should reassign default configuration", ->
                 alchemy.conf.graphWidth().should.equal(200)

         describe "graphHeight", ->
             it "should reassign default configuration", ->
                 alchemy.conf.graphHeight().should.equal(200)

         describe "alpha", ->
             it "should reassign default configuration", ->
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
             "placeholder"

         describe "warningMessage", ->
             "placeholder"

         return
    return
