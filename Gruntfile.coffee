"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt
  pkg = grunt.file.readJSON('./package.json')

  # set up sauce labs credentials 
  if grunt.file.isFile('./sauce.yml')
    s3Config = grunt.file.readYAML('./sauce.yml')
    sauce_user_name = s3Config.SAUCE_USERNAME
    sauce_access_key = s3Config.SAUCE_ACCESS_KEY
  else
    sauce_user_name = ''
    sauce_access_key = ''

  # set up s3 credentials
  if grunt.file.isFile('./s3.yml')
    s3Config = grunt.file.readYAML('./s3.yml')
    key_id = s3Config.AWS_ACCESS_KEY_ID
    secret = s3Config.AWS_SECRET_ACCESS_KEY
  else
    key_id = ''
    secret = ''

  grunt.initConfig
    # Project settings
    yeoman:

      # Configurable paths
      app: "app"
      dist: "dist"

    # Upload to CDN.
    s3:
      options:
        #Accesses environment variables
        key: key_id
        secret: secret
        access: 'public-read'
      production:
        bucket: "cdn.graphalchemist.com"
        upload:[
            # upload the files without version to  CDN
            src: ".tmp/s3/**"
            dest: "/"
        ]

    'string-replace':
      version:
        files:
          './bower.json': './bower.json'
          '<%= yeoman.dist %>/alchemy.js':'<%= yeoman.dist %>/alchemy.js'
          '<%= yeoman.dist %>/alchemy.min.js':'<%= yeoman.dist %>/alchemy.min.js'
        options:
          replacements: [
            pattern: /#VERSION#/ig
            replacement: pkg.version
          ]

    release:
      options:
        file: 'package.json'
        bump: false
        commit: false
        npm: false # never automatically publish to npm

    # shell tasks
    shell:
      commitBuild:
        command: "git add -A && git commit -am 'commit dist files for #{pkg.version}'"

    # Watches files for changes and runs tasks based on the changed files
    watch:
      coffee:
        files: ["app/scripts/{,*/,*/*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["copy:coffee", "coffee:dist", "coffee:dev"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["coffee:test", "test:watch"], 

      gruntfile:
        files: ["Gruntfile.coffee"]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/,*/*/}*.{scss,sass}"]
        tasks: ["compass:server", "autoprefixer"]

      styles:
        files: ["<%= yeoman.app %>/styles/{,*/}*.css"]
        tasks: ["newer:copy:styles", "autoprefixer"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: ["<%= yeoman.app %>/{,*/}*.html", ".tmp/styles/{,*/}*.css", ".tmp/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{gif,jpeg,jpg,png,svg,webp}"]

    # The actual grunt server settings
    connect:
      options:
        port: 9000
        livereload: 35729

        # Change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          open: true
          base: [".tmp", "<%= yeoman.app %>"]

      test:
        options:
          port: 9001
          base: [".tmp", "test", "<%= yeoman.app %>"]

      dist:
        options:
          open: true
          base: "<%= yeoman.dist %>"
          livereload: false


    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: 
        files: [
          dot: true
          src: ".tmp"
        ]


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: ["Gruntfile.coffee", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/spec/{,*/}*.js"]


    # Mocha testing framework configuration options
    # mocha:
    #   all:
    #     options:
    #       run: true
    #       urls: ["http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html"]

    # Test settings
    karma:
      options:
        configFile: "test/karma.conf.coffee"
        sauceLabs:
          startConnect: true
        reporters: ['saucelabs']
        customLaunchers:
          sl_safari_mac:
            base: 'SauceLabs'
            browserName: 'safari'
          sl_chrome_mac:
            base: 'SauceLabs'
            browserName: 'chrome'
          sl_ie_windows:
            base: 'SauceLabs'
            browserName: 'internet explorer'
          sl_firefox:
            base: 'SauceLabs'
            browserName: 'firefox'
      travis:
        singleRun: true
        browsers: ['PhantomJS', 'sl_safari_mac', 'sl_chrome_mac', 'sl_firefox']#, 'sl_ie_windows']
      sauce:
        singleRun: true
        browsers: ['PhantomJS', 'sl_safari_mac', 'sl_chrome_mac', 'sl_firefox']#'sl_ie_windows']
      local:
        singleRun: false
        browsers: ['PhantomJS', 'Chrome', 'Firefox', 'Safari', 'sl_ie_windows']
      pullRequest:
        singleRun: true
        browsers: ['PhantomJS', 'Firefox']
        # sauceLabs: []
        # customLaunchers: []
        # reporters: []

    # Compiles CoffeeScript to JavaScript
    coffee:
      dist:
        options:
            bare: false
            sourceMap: true
            joinExt: 'src.coffee.md'
        files:
            # all of the core, alchemy.js files
            ".tmp/scripts/alchemy.js": [".tmp/scripts/alchemy/Alchemy.{coffee,litcoffee,coffee.md}"
                                        ".tmp/scripts/alchemy/{,*/}*.{coffee,litcoffee,coffee.md}"]
      dev:              
        options:
            bare: false
            sourceMap: true
            joinExt: 'src.coffee.md'
        files:
          # all of the core, alchemy.js files
          ".tmp/scripts/alchemy.js": [".tmp/scripts/alchemy/Alchemy.{coffee,litcoffee,coffee.md}"
                                      ".tmp/scripts/alchemy/{,*/}*.{coffee,litcoffee,coffee.md}"
                                      ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.{coffee,litcoffee,coffee.md}"
          dest: ".tmp/spec"
          ext: ".js"
        ]


    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        generatedImagesDir: ".tmp/images/generated"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: "<%= yeoman.app %>/bower_components"
        httpImagesPath: "/images"
        httpGeneratedImagesPath: "/images/generated"
        httpFontsPath: "/styles/fonts"
        relativeAssets: false
        assetCacheBuster: false

      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"
          outputStyle: "compressed"
      server:
        options:
          debugInfo: true


    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "{,*/}*.css"
          dest: ".tmp/styles/"
        ]


    # Automatically inject Bower components into the HTML file
    "bower-install":
      app:
        html: "<%= yeoman.app %>/index.html"
        ignorePath: "<%= yeoman.app %>/"


    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{gif,jpeg,jpg,png,webp}", "<%= yeoman.dist %>/styles/fonts/{,*/}*.*"]


    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      options:
        dest: "<%= yeoman.dist %>"

      html: "<%= yeoman.app %>/index.html"


    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      options:
        assetsDirs: ["<%= yeoman.dist %>"]

      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]


    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{gif,jpeg,jpg,png}"
          dest: "<%= yeoman.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        options:
          collapseBooleanAttributes: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeCommentsFromCDATA: true
          removeEmptyAttributes: true
          removeOptionalTags: true
          removeRedundantAttributes: true
          useShortDoctype: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: "{,*/}*.html"
          dest: "<%= yeoman.dist %>"
        ]

    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    cssmin:
      buildAlchemy:
        files: [
          '<%= yeoman.dist %>/alchemy.min.css': '.tmp/concat/styles/alchemy.min.css'
          '<%= yeoman.dist %>/styles/vendor.css': '.tmp/concat/styles/vendor.css'
              ]

    uglify:
      dist:
        files: [
          {
            dest: '<%= yeoman.dist %>/scripts/alchemy.min.js'
            src: '.tmp/concat/scripts/alchemy.js'
          }
          {
            dest: '<%= yeoman.dist %>/scripts/vendor.js'
            src: '.tmp/concat/scripts/vendor.js'
          }
        ]
      buildAlchemy:
        files: [
          {
            dest: '<%= yeoman.dist %>/alchemy.min.js'
            src: '.tmp/concat/scripts/alchemy.js'
          }
          {
            dest: '<%= yeoman.dist %>/scripts/vendor.js'
            src: '.tmp/concat/scripts/vendor.js'
          }
        ]

    concat:
      dist:
        files: [
          {
            dest: ".tmp/concat/scripts/alchemy.js"
            src: "{app,.tmp}/scripts/alchemy.js"
          }
          {
            dest: '<%= yeoman.dist %>/scripts/alchemy.js'
            src: "{app,.tmp}/scripts/alchemy.js"
          }
          {
            dest: '<%= yeoman.dist %>/styles/alchemy.css'
            src: '.tmp/styles/alchemy.css'
          }
          {
            dest: '<%= yeoman.dist %>/styles/alchemy-white.css'
            src: '.tmp/styles/alchemy-white.css'
          }
        ]
      s3:
        files: [
            dest: '.tmp/s3/alchemy.min.js'
            src: ['<%= yeoman.dist %>/scripts/vendor.js'
                  '<%= yeoman.dist %>/alchemy.min.js']
          , 
            dest: '.tmp/s3/alchemy.js'
            src: ['<%= yeoman.dist %>/scripts/vendor.js'
                  '<%= yeoman.dist %>/alchemy.js']
          ,
            dest: '.tmp/s3/alchemy.min.css'
            src: ['<%= yeoman.dist %>/styles/vendor.css'
                  '<%= yeoman.dist %>/alchemy.min.css']
          ,
            dest: '.tmp/s3/alchemy.css'
            src: ['<%= yeoman.dist %>/styles/vendor.css'
                  '<%= yeoman.dist %>/alchemy.css']
            ]
      s3Version:
        files: [
            expand: true
            cwd: ".tmp/s3/"
            src:  "alchemy{,*}.*"
            dest: ".tmp/s3/"
            rename: (dest, src) ->
              name = src.substring(0, src.indexOf('.'))
              ext = src.substring(src.indexOf('.'), src.length)
              versioned = "#{name}.#{pkg.version}#{ext}"
              dest + versioned
            ]
      buildAlchemy:
        files: [
          {
            dest: ".tmp/concat/scripts/alchemy.js"
            src: "{app,.tmp}/scripts/alchemy.js"
          }
          {
            dest: '<%= yeoman.dist %>/alchemy.js'
            src: "{app,.tmp}/scripts/alchemy.js"
          }
          {
            dest: '<%= yeoman.dist %>/alchemy.css'
            src: '.tmp/styles/alchemy.css'
          }
          {
            dest: '<%= yeoman.dist %>/alchemy-white.css'
            src: '.tmp/styles/alchemy-white.css'
          }
        ]

    # Copies remaining files to places other tasks can use
    copy:
      coffee:
        files: [
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>/scripts',
          dest: '.tmp/scripts',
          src: '**/{,*/}*.{litcoffee,coffee,coffee.md}'
        ]

      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,png,txt}", "images/{,*/}*.webp", "{,*/}*.html", "styles/fonts/{,*/}*.*", "sample_data/{,*/}*.json"]
          ]
      
      s3:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/styles"
          dest: ".tmp/s3/"
          src: ["fonts/*", "images/*"]
          ]

      styles:
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>/"
        dest: ".tmp/"
        src: "styles/**"

      fonts:
        expand: true
        dot: true
        cwd: ".tmp/styles"
        dest: "<%= yeoman.dist %>/styles"
        src: 'fonts/**'

      images:
        expand: true
        dot: true
        cwd: ".tmp/styles"
        dest: "<%= yeoman.dist %>/styles"
        src: "images/**"

      archive:
        expand: true
        dot: true
        dest: "archive/#{pkg.version}"
        cwd: "<%= yeoman.dist %>"
        src: "**"

    concurrent:
      # Run some tasks in parallel to speed up build process
      server: ["compass:server", "coffee:dev",  "copy:styles"]
      test: ["coffee:test", "coffee:dist", "copy:styles"]
      dist: ["coffee", "compass", "copy:styles", "imagemin", "svgmin"]
      buildAlchemy: ["coffee:dist", "coffee:test", "compass", "copy:styles"]

  grunt.loadNpmTasks('grunt-mocha')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-release')
  grunt.loadNpmTasks('grunt-string-replace')
  # grunt.loadNpmTasks('grunt-s3') # yeoman already includes

  grunt.registerTask 'bumpBower', ->
      bower = grunt.file.readJSON('./bower.json')
      bower['version'] = pkg.version
      grunt.file.write('./bower.json', JSON.stringify(bower, null, 2) + '\n')

  grunt.registerTask 'archiveDist', ->
      path = "./archive/#{pkg.version}"
      grunt.file.mkdir(path)
      grunt.task.run 'copy:archive'

  grunt.registerTask "serve", (target) ->
    return grunt.task.run(["build", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:server", "autoprefixer", "connect:livereload", "watch"]

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]

  grunt.registerTask "test", (target) ->
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:test", "autoprefixer"]  if target isnt "watch"
    if not target then target = "keepalive"
    switch target
      # for debugging tasks locally
      when "keepalive"
        grunt.task.run ["connect:test", "karma:local"]
      when "dist"
        grunt.task.run ["connect:test", "karma:sauce"]
      when "pr"
        grunt.task.run ["connect:test", "karma:pullRequest"]
      when "travis"
        grunt.task.run ["connect:test", "karma:travis"]

  grunt.registerTask 'build', ["clean:dist", "useminPrepare",
                               "copy:coffee", "concurrent:buildAlchemy",
                               "copy:fonts", "copy:images",
                               "autoprefixer", "concat:buildAlchemy",
                               "concat:generated", "cssmin:buildAlchemy",
                               "uglify:buildAlchemy"]

  releaseFlag = grunt.option('release')
  pullRequest = grunt.option('pr') 
  travis = grunt.option('travis')                         
  grunt.registerTask "default",
    # release alchemy
    if releaseFlag
      [
       "build",
       "string-replace", # apply version to alchemy.js
       "bumpBower", # bump bower version
       "shell:commitBuild", # commit dist files
       "release", # create tag and version
       "archiveDist", # create archive of files to zip for github release
       "concat:s3", # squash vendor and alchemy files for cdn
       "concat:s3Version", # apply version numbers for cdn
       "s3:production" # publish files to s3 for cdn
      ]
    # Travis-ci on a commit to the main repo branches
    else if travis
      ["test:travis",
       "build"]
    # Travis-ci on a pull request
    else if pullRequest
      ["test:pr",
       "build"]
    # test with sauce and build scripts
    else
      ["test:dist",
       "build"]
