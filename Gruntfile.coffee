# Generated on 2014-01-30 using generator-webapp 0.4.7
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  
  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt
  
  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt
  
  # Define the configuration for all the tasks
  grunt.initConfig
    
    # Project settings
    yeoman:
      
      # Configurable paths
      app: "app"
      dist: "dist"

    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
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
          bare: true
          sourceMap: true
        files: ".tmp/scripts/alchemy.js": [  ".tmp/scripts/alchemy/defaultConf.coffee",
                                             ".tmp/scripts/alchemy/init.coffee",
                                             ".tmp/scripts/alchemy/errors.coffee",
                                             ".tmp/scripts/alchemy/startGraph.coffee",
                                             ".tmp/scripts/alchemy/update.coffee",
                                             ".tmp/scripts/alchemy/{,*/}*.{coffee,litcoffee,coffee.md}"]
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
    # cssmin: {
    #     dist: {
    #         files: {
    #             '<%= yeoman.dist %>/styles/main.css': [
    #                 '.tmp/styles/{,*/}*.css',
    #                 '<%= yeoman.app %>/styles/{,*/}*.css'
    #             ]
    #         }
    #     }
    # },
    # uglify: {
    #     dist: {
    #         files: {
    #             '<%= yeoman.dist %>/scripts/scripts.js': [
    #                 '<%= yeoman.dist %>/scripts/scripts.js'
    #             ]
    #         }
    #     }
    # },
    # concat: {
    #     dist: {}
    # },
    
    # Copies remaining files to places other tasks can use
    copy:
      coffee:
        files: [
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>/scripts',
          dest: '.tmp/scripts',
          src: '**/*.coffee'
        ]

      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,png,txt}", ".htaccess", "images/{,*/}*.webp", "{,*/}*.html", "styles/fonts/{,*/}*.*"]
        ]

      styles:
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"

    
    # Run some tasks in parallel to speed up build process
    concurrent:
      server: ["compass:server", "coffee:dist", "copy:styles"]
      test: ["coffee", "copy:styles"]
      dist: ["coffee", "compass", "copy:styles", "imagemin", "svgmin"]

  grunt.registerTask "serve", (target) ->
    return grunt.task.run(["build", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:server", "autoprefixer", "connect:livereload", "watch"]

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]

  grunt.registerTask "test", (target) ->
    grunt.task.run ["clean:server", "copy:coffee", "concurrent:test", "autoprefixer"]  if target isnt "watch"
    grunt.task.run ["connect:test", "mocha"]

  grunt.registerTask "build", ["clean:dist", "useminPrepare", "copy:coffee", "concurrent:dist", "autoprefixer", "concat", "cssmin", "uglify", "copy:dist", "rev", "usemin", "htmlmin"]
  grunt.registerTask "default", ["newer:jshint", "test", "build"]