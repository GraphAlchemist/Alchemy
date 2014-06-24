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
        
        describe "dataSource", ->
            it "can find non-default datasets", ->
                runWithConf({dataSource:"sample_data/ego1.json"})

                # Make sure dataSource was changed from default (null)
                alchemy.conf.dataSource.should.equal "sample_data/ego1.json"
                
                # Make sure it can use the dataset to create elements
                console.log(alchemy.nodes)
                alchemy.nodes.length.should.not.equal 0

        return
    return