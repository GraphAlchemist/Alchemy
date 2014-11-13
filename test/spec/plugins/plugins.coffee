do ->
    describe "alchemy.conf.plugins", ->
        before (done) ->
            # extend Alchemy with fake plugin callables
            Alchemy::plugins.foobar = ->
                window.pluginFoobarHasBeenCalled = true
            Alchemy::plugins.testplugin = ->
                window.pluginTestpluginHasBeenCalled = true
            debugger
            window.pluginInstance = new Alchemy 
                dataSource : contrib_json
                plugins: ["foobar", "testplugin"]
        
            setTimeout done, 1000

        it "should have plugin 'foobar' and 'testplugin' defined for testing", () ->
                expect(pluginInstance.conf.plugins).to.include("foobar", "testplugin")

        it "should initialize defined plugins automatically", () ->
            expect(pluginFoobarHasBeenCalled).to.be.true
            expect(pluginTestpluginHasBeenCalled).to.be.true

    return