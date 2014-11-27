# Karma configuration
# Generated on Fri Oct 31 2014 11:20:38 GMT-0700 (PDT)
module.exports = (config) ->

  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: "../"
    
    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ["mocha", "chai", "fixture"]
    
    # list of files / patterns to load in the browser
    files: [
      # "node_modules/chai/chai.js"
      "app/bower_components/jquery/dist/jquery.js"
      "app/bower_components/bootstrap/dist/js/bootstrap.js"
      "app/bower_components/lodash/dist/lodash.compat.js"
      "app/bower_components/d3/d3.min.js"
      ".tmp/scripts/alchemy.js"
      "test/spec/configurationTests.coffee"
      "test/spec/core/startGraph.coffee"
      "test/spec/models/node.coffee"
      "test/spec/models/edge.coffee"
      "test/spec/api/get.coffee"
      "test/spec/api/remove.coffee"
      "test/spec/plugins/plugins.coffee"
      "test/spec/uiTests.coffee"
      "app/sample_data/contrib.json"
    ]
    
    # list of files to exclude
    exclude: []
    
    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: 
      # we should probably have a real "html" fixture, instead of 
      # creating things dynamically, for example in spec/configurationTests.coffee
      # with the <div id="alchemy">
      # 'test/index.html' : ['html2js'],
      "app/sample_data/contrib.json": ['html2js']
      "test/contrib.json": ['html2js']
      'test/spec/**/*.coffee': ['coffee']

    
    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ["progress"]
    
    # web server port
    port: 9876
    
    # enable / disable colors in the output (reporters and logs)
    colors: true
    
    # level of logging
    # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_ERROR
    
    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true
    
    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    # defined in grunt files
    # browsers: [
      # "Chrome"
      # "Firefox"
      # "Safari"
      # "IE"
    # ]
    
    # Defined in Gruntfile
    # # Continuous Integration mode
    # # if true, Karma captures browsers, runs the tests and exits
    # singleRun: false

  return