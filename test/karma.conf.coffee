# Karma configuration
# Generated on Fri Oct 31 2014 11:20:38 GMT-0700 (PDT)
module.exports = (config) ->
  config.set
    
    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: "../"
    
    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ["mocha"]
    
    # list of files / patterns to load in the browser
    files: [
      "node_modules/chai/chai.js"
      "app/bower_components/jquery/dist/jquery.js"
      "app/bower_components/bootstrap/dist/js/bootstrap.js"
      "app/bower_components/lodash/dist/lodash.compat.js"
      "app/bower_components/d3/d3.min.js"
      # ".tmp/scripts/alchemy.js"
      ".tmp/spec/configurationTests.js"
      ".tmp/spec/core/startGraph.js"
      ".tmp/spec/models/node.js"
      ".tmp/spec/models/edge.js"
      ".tmp/spec/api/get.js"
    ]
    
    # list of files to exclude
    exclude: []
    
    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {}
    
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
    browsers: [
      "Chrome"
      # "Firefox"
      # "Safari"
      # "IE"
    ]
    
    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

  return