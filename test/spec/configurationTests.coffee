do ->

    before (done) ->
        # There must be an easier way to do this
        # https://github.com/billtrik/karma-fixture
        # we are accessing the 'fixture' plugin's internals here:
        contrib_string = window.__html__['app/sample_data/contrib.json']
        window.contrib_json = JSON.parse(contrib_string)
        # again, not the correct way to create a 'fixture',
        # and should be fixed in favor of a more robust implementation
        d3.select('body').append('div').attr('id', 'alchemy')
        
        alchemy = new Alchemy
            dataSource : contrib_json
            graphWidth : () -> 200
            graphHeight: () -> 200
            alpha      : 0.23
            nodeTypes  : {"role": ["maintainer", "project"]}

        setTimeout done, 1000

    describe "Configuration testing", ->
        #General
        beforeEach -> window.alchemy = Alchemy::instances[0]

        describe "renderer", ->
            it "should be svg", ->
                alchemy.conf.renderer.should.equal "svg"

        describe "dataSource", ->
            it "should specify a dataset, default null, only required user input", ->
                alchemy.conf.dataSource.should.deep.equal contrib_json

        describe "divSelector", ->
            it "should specify a div on page for each instance, default '#alchemy'", ->
                alchemy.conf.divSelector.should.equal "#alchemy"
                # Test for new instances, when implemented 
                # chemistry = new Alchemy({"divSelector": "#chemistry"})
                # chemistry.conf.divSelector.should.equal "#chemsitry"

        describe "graphWidth", ->
            it "should accept value or calulate by div selector", ->
                alchemy.conf.graphWidth().should.equal(200)

        describe "graphHeight", ->
            it "should accept value or calculate by div delector", ->
                alchemy.conf.graphHeight().should.equal(200)

        describe "backgroundColour", ->
            it "should set the background color, black by default", ->
                alchemy.conf.backgroundColour.should.equal "#000000"
                alchemy.setConf({"backgroundColor": "#FFFFFF"})
                alchemy.conf.backgroundColour.should.equal "#FFFFFF"

        describe "theme", ->
            it "should reference name by string of an alchemy provided theme, default null", ->
                assert.isNull alchemy.conf.theme
                alchemy.setConf({"theme": "white"})
                alchemy.conf.theme.should.equal "white"

        describe "alpha", ->
            it "should hold and reassign current alpha value", ->
                alchemy.conf.alpha.should.equal(0.5)

        describe "cluster", ->
            it "should be a boolean, default false", ->
                alchemy.conf.cluster.should.equal false
                alchemy.setConf({"cluster": true})
                alchemy.conf.cluster.should.equal true 

        describe "clusterKey", ->
            it "should be a string used to determine initial clustering", ->
                alchemy.conf.clusterKey.should.equal "cluster"
                alchemy.setConf({"clusterKey": "role"})
                alchemy.conf.clusterKey.should.equal "role"
            
        describe "clusterColours", ->
            it "should be an array of color hex-codes, customizable", ->
                alchemy.conf.clusterColours.length.should.equal 13
                alchemy.conf.clusterColours.push "#BA2D00"
                alchemy.conf.clusterColours.length.should.equal 14
                alchemy.conf.clusterColours.should.include "#BA2D00"

        describe "fixNodes", ->
            it "should be a boolean, default false", ->
                alchemy.conf.fixNodes.should.equal false
                alchemy.setConf({"fixNodes": true})
                alchemy.conf.fixNodes.should.equal true

        describe "fixRootNodes", ->
            it "should be a boolean, default false", ->
                alchemy.conf.fixRootNodes.should.equal false
                alchemy.setConf({"fixRootNodes": true})
                alchemy.conf.fixRootNodes.should.equal true

        describe "forceLocked", ->
            it "should be a boolean, default true", ->
                alchemy.conf.forceLocked.should.equal true
                alchemy.setConf({"forceLocked": false})
                alchemy.conf.forceLocked.should.equal false


        #Nodes
        describe "nodeCaption", ->
            it "should be a string, can be set to any node property, defaults to 'caption'", ->
                alchemy.conf.nodeCaption.should.equal 'caption'
                alchemy.setConf({"nodeCaption": 'role'})
                alchemy.conf.nodeCaption.should.equal 'role'
        
        describe "nodeMouseOver", ->
            it "should be a string, referencing a node property to display on mouseover", ->
                alchemy.conf.nodeMouseOver.should.equal 'caption'
                alchemy.setConf({"nodeMouseOver": 'role'})
                alchemy.conf.nodeMouseOver.should.equal 'role'

        describe "nodeOverlap", ->
            it "should be an integer, indicating allowed node overlap, 25 by default", ->
                alchemy.conf.nodeOverlap.should.equal 25
                alchemy.setConf({"nodeOverlap": 20})
                alchemy.conf.nodeOverlap.should.equal 20

        describe "nodeRadius", ->
            it "should be an integer, setting default node radius, 10 by default", ->
                alchemy.conf.nodeRadius.should.equal 10
                alchemy.setConf({"nodeRadius": 20})
                alchemy.conf.nodeRadius.should.equal 20

        describe "rootNoteRadius", ->
            it "should be an integer, setting default root node radius, 10 by default", ->
                alchemy.conf.rootNodeRadius.should.equal 15
                alchemy.setConf({"rootNodeRadius": 20})
                alchemy.conf.rootNodeRadius.should.equal 20

        describe "nodeTypes", ->
            it "should be an object, declaring nodeTypes for further config, null by default", ->
                assert.isNull alchemy.conf.nodeTypes
                alchemy.setConf({nodeTypes:{"role":["contributer", "maintainer", "project"]}})
                alchemy.conf.nodeTypes.should.deep.equal {"role":["contributer", "maintainer", "project"]}

        describe "nodeStyle", ->
            it "should contain an object of programmatic styles", ->
                Object.keys(alchemy.conf.nodeStyle.all).length.should.equal 10
                Object.keys(alchemy.conf.nodeStyle.all).should.include "radius"

        #Edges
        describe "edgeCaption", ->
            it "should be a string, can be set to any edge property, defaults to 'caption'", ->
                alchemy.conf.edgeCaption.should.equal 'caption'
                alchemy.setConf({"edgeCaption": 'source'})
                alchemy.conf.edgeCaption.should.equal 'source'

        describe "curvedEdges", ->
            it "should be a boolean, default false", ->
                alchemy.conf.curvedEdges.should.equal false
                alchemy.setConf({"curvedEdges": true})
                alchemy.conf.curvedEdges.should.equal true

        describe "directedEdges", ->
            it "should be a boolean, default false", ->
                alchemy.conf.directedEdges.should.equal false
                alchemy.setConf({"directedEdges": true})
                alchemy.conf.directedEdges.should.equal true

        describe "edgeCaptionsOnByDefault", ->
            it "should be a boolean, default false", ->
                alchemy.conf.edgeCaptionsOnByDefault.should.equal false
                alchemy.setConf({"edgeCaptionsOnByDefault": true})
                alchemy.conf.edgeCaptionsOnByDefault.should.equal true

        describe "edgeTypes", ->
            it "should be an object, declaring edgeTypes for further config, null by default", ->
                assert.isNull alchemy.conf.edgeTypes
                alchemy.setConf("edgeTypes": {"caption": ["Maintains", "Often_breaks", "contributes"]})
                assert.deepEqual alchemy.conf.edgeTypes, {"caption": ["Maintains", "Often_breaks", "contributes"]}

        describe "edgeStyle", ->
            it "should contain an object of programmatic styles", ->
                Object.keys(alchemy.conf.edgeStyle.all).length.should.equal 8
                Object.keys(alchemy.conf.edgeStyle.all).should.include "width" and "color"


        #Editing
        describe "captionToggle", ->
            it "should be a boolean, default false", ->
                alchemy.conf.captionToggle.should.equal false
                alchemy.setConf({"captionToggle": true})
                alchemy.conf.captionToggle.should.equal true

        describe "toggleRootNodes", ->
            it "should be a boolean, default false", ->
                alchemy.conf.toggleRootNodes.should.equal false
                alchemy.setConf({"toggleRootNodes": true})
                alchemy.conf.toggleRootNodes.should.equal true


        #Stats
        describe "nodeStats", ->
            it "should be a boolean, default false", ->
                alchemy.conf.nodeStats.should.equal false
                alchemy.setConf({"nodeStats": true})
                alchemy.conf.nodeStats.should.equal true

        describe "edgeStats", ->
            it "should be a boolean, default false", ->
                alchemy.conf.edgeStats.should.equal false
                alchemy.setConf({"edgeStats": true})
                alchemy.conf.edgeStats.should.equal true


        #Filtering
        describe "edgeFilters", ->
            it "should be a boolean, default false", ->
                alchemy.conf.edgeFilters.should.equal false
                alchemy.setConf({"edgeFilters": true})
                alchemy.conf.edgeFilters.should.equal true

        describe "nodeFilters", ->
            it "should be a boolean, default false", ->
                alchemy.conf.nodeFilters.should.equal false
                alchemy.setConf({"nodeFilters": true})
                alchemy.conf.nodeFilters.should.equal true

        describe "nodesToggle", ->
            it "should be a boolean, default false", ->
                alchemy.conf.nodesToggle.should.equal false
                alchemy.setConf({"nodesToggle": true})
                alchemy.conf.nodesToggle.should.equal true

        describe "edgesToggle", ->
            it "should be a boolean, default false", ->
                alchemy.conf.edgesToggle.should.equal false
                alchemy.setConf({"edgesToggle": true})
                alchemy.conf.edgesToggle.should.equal true


        #Controls
        describe "zoomControls", ->
            it "should be a boolean, default false", ->
                alchemy.conf.zoomControls.should.equal false
                alchemy.setConf({"zoomControls": true})
                alchemy.conf.zoomControls.should.equal true


        #Init
        describe "initialScale", ->
            it "should be a real number, setting default d3 scale, 1 by default", ->
                alchemy.conf.initialScale.should.equal 1
                alchemy.setConf({"initialScale": 1.5})
                alchemy.conf.initialScale.should.equal 1.5

        describe "initialTranslate", ->
            it "should be an array of reals, setting intial d3 translation, [0,0] by default", ->
                assert.deepEqual alchemy.conf.initialTranslate, [0, 0]

        describe "scaleExtent", ->
            it "should be an array of reals, setting limits on d3 scale values, [0.5,2.4] by default", ->
                assert.deepEqual alchemy.conf.scaleExtent, [0.5, 2.4]
                alchemy.setConf({"scaleExtent": [0.6, 2.2]})
                assert.deepEqual alchemy.conf.scaleExtent, [0.6, 2.2]

        describe "afterLoad", ->
            it "should return 'afterload' by default", ->
                alchemy.conf.afterLoad.should.equal "afterLoad"

        describe "warningMessage", ->
            it "should be a default string", ->
                alchemy.conf.warningMessage.should.equal "There be no data!  What's going on?"

         return
    return
