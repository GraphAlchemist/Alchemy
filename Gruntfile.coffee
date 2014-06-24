"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  grunt.initConfig
    
    # Project settings
    yeoman:
      
      # Configurable paths
      app: "app"
      dist: "dist"
      django_path: "/Users/huston/Dropbox/Projects/ga-mainsite/apps/social_login/static/social_login"

    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      coffee:
        files: ["app/scripts/{,*/,*/*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["copy:coffee", "coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["coffee:test", "test:watch"]

      gruntfile:
        files: ["Gruntfile.js"]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
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

      server: ".tmp"

    
    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/spec/{,*/}*.js"]

    
    # Mocha testing framework configuration options
    mocha:
      all:
        options:
          run: true
          urls: ["http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html"]

    
    # Compiles CoffeeScript to JavaScript
    coffee:
      dist:
        options:
            bare: false
            sourceMap: true
        files:
            # all of the core, alchemy.js files
            ".tmp/scripts/alchemy.js": [".tmp/scripts/alchemy/start.coffee"
                                        ".tmp/scripts/alchemy/{,*/}*.{coffee,litcoffee,coffee.md}"
                                        ".tmp/scripts/alchemy/end.coffee"]
      dev:
        options:
            bare: false
            sourceMap: true
        files:
            # all of the files used in testing and development - configuration, etc.
            ".tmp/scripts/else.js": [".tmp/scripts/*.coffee", "!.tmp/scripts/alchemy.src.coffee"]

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
        ]

    # Copies remaining files to places other tasks can use
    copy:
      coffee:
        files: [
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>/scripts',
          dest: '.tmp/scripts',
          src: '**/{,*/}*.coffee'
        ]

      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,png,txt}", "images/{,*/}*.webp", "{,*/}*.html", "styles/fonts/{,*/}*.*", "sample_data/{,*/}*.json"]
        ]

      styles:
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"

      django:
        files:
          "<%= yeoman.django_path %>/js/alchemy/main.js":"dist/scripts/main.js"
          "<%= yeoman.django_path %>/js/alchemy/vendor.js":"dist/scripts/vendor.js"
          "<%= yeoman.django_path %>/css/alchemy/main.css":"dist/styles/main.css"

    concurrent:
      # Run some tasks in parallel to speed up build process
      server: ["compass:server", "coffee",  "copy:styles"]
      test: ["coffee:test", "coffee:dist", "copy:styles"]
      dist: ["coffee", "compass", "copy:styles", "imagemin", "svgmin"]
      buildAlchemy: ["coffee:dist", "coffee:test", "compass", "copy:styles"]

  grunt.loadNpmTasks('grunt-mocha');

  grunt.registerTask "serve", (target) ->
    return grunt.task.run(["build", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:server", "autoprefixer", "connect:livereload", "watch"]

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]

  grunt.registerTask "test", (target) ->
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:test", "autoprefixer"]  if target isnt "watch"
    if target is "keepalive"
      grunt.task.run ["connect:test:keepalive", "mocha"]
    else
      grunt.task.run ["connect:test", "mocha"]

  grunt.registerTask "build", ["clean:dist", "useminPrepare", 
                               "copy:coffee", "concurrent:dist", 
                               "autoprefixer", "concat:dist", 
                               "concat:generated", "cssmin", 
                               "uglify:dist", "copy:dist", 
                               "rev", "usemin", 
                               "htmlmin"]

  #same as `build` but builds Alchemy for distribution
  grunt.registerTask 'buildAlchemy', ["clean:dist", "useminPrepare", 
                                      "copy:coffee", "concurrent:buildAlchemy", 
                                      "autoprefixer", "concat:buildAlchemy", 
                                      "concat:generated", "cssmin:buildAlchemy", 
                                      "uglify:buildAlchemy"]

  grunt.registerTask "default", ["newer:jshint", "test", "buildAlchemy"]
