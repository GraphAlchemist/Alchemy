do ->
    describe "alchemy.conf.plugins", ->
        before (done) ->
            # Test plugin
            Alchemy::plugins.foo = (instance) ->
                a: instance
                conf: instance.conf.plugins["foo"]
                init: ->
                  window.pluginFooHasBeenCalled = true
                  window.pluginConf = @conf

            window.instance = new Alchemy
                dataSource : contrib_json
                plugins:
                  "foo":{}
        
            setTimeout done, 1000

        it "should have plugin 'foo' in instance.plugins", () ->
            expect(_.keys instance.plugins).to.include "foo"

        it "should initialize defined plugins automatically", () ->
            expect(pluginFooHasBeenCalled).to.be.true

        it "should consider 'conf' the plugin config", ()->
            expect(pluginConf).to.eql instance.plugins["foo"].conf
    return
