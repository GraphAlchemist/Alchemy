# Generated on 2014-09-11 using generator-angular 0.9.8
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt 
  # the package file from the alchemy directory
  pkg = grunt.file.readJSON('./package.json')
  AlchemyPkg = grunt.file.readJSON('../package.json')
  appConfig =
    app: require("./bower.json").appPath or "app"
    dist: "dist"

  grunt.initConfig
    
    yeoman: appConfig
    
    jekyll:
      dev:
        options:
          config: "_config.yml"
          dest: ".tmp/docs"

      dist:
        options:
          config: "_config.yml"
          dest: "<%= yeoman.dist %>/docs"

    'string-replace':
      version:
        files:
          '<%= yeoman.dist %>/views/home.html': '<%= yeoman.dist %>/views/home.html'
          '<%= yeoman.dist %>/views/nav.html': '<%= yeoman.dist %>/views/nav.html'
        options:
          replacements: [
            pattern: /#VERSION#/ig
            replacement: AlchemyPkg.version
          ]
    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      jekyll:
        files: ["<%= yeoman.app %>/docs/{,*/,*/*/}*{.scss,.coffee,.html,.md}"]
        tasks: [
          "jekyll:dev"
          "compass:docs"
          "coffee:dist"
        ]

      bower:
        files: ["bower.json"]
        tasks: ["wiredep"]

      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: [
          "newer:coffee:test"
          "karma"
        ]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"
                "<%= yeoman.app %>/docs/styles/scss/{,*/}*.{scss,sass}"
              ]
        
        tasks: [
          "compass"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.coffee"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "<%= yeoman.app %>/{,*/}*.html"
          ".tmp/styles/{,*/}*.css"
          ".tmp/scripts/{,*/}*.js"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    "gh-pages":
      options:
        base: "dist"
      src: ["**"]
    
    # The actual grunt server settings
    connect:
      options:
        port: 9002
        
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
        livereload: 35729

      livereload:
        options:
          open: true
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(appConfig.app)
            ]

      test:
        options:
          port: 9001
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect.static("test")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(appConfig.app)
            ]

      dist:
        options:
          open: true
          base: "<%= yeoman.dist %>"
    
    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all:
        src: ["Gruntfile.js"]

    
    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/{,*/}*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]

      server: ".tmp"

    
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

    
    # Automatically inject Bower components into the app
    wiredep:
      app:
        src: ["<%= yeoman.app %>/index.html"]
        ignorePath: /\.\.\//

      sass:
        src: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        ignorePath: /(\.\.\/){1,2}bower_components\//
    
    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          {  
            expand: true
            cwd: "<%= yeoman.app %>/scripts"
            src: "{,*/}*.coffee"
            dest: ".tmp/scripts"
            ext: ".js"
          }
          {
            expand: true
            cwd: "<%= yeoman.app %>/docs/js/coffee"
            src: "*.coffee"
            dest: ".tmp/docs/scripts/"
            ext: ".js"
          }
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    
    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      app:
        options:
          relativeAssets: false
          assetCacheBuster: false
          raw: "Sass::Script::Number.precision = 10\n"
          sassDir: "<%= yeoman.app %>/styles"
          cssDir: ".tmp/styles"
          generatedImagesDir: ".tmp/images/generated"
          imagesDir: "<%= yeoman.app %>/images"
          javascriptsDir: "<%= yeoman.app %>/scripts"
          fontsDir: "<%= yeoman.app %>/styles/fonts"
          importPath: "./bower_components"
          httpImagesPath: "/images"
          httpGeneratedImagesPath: "/images/generated"
          httpFontsPath: "/styles/fonts"
          # generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      docs:
        options:
          assetCacheBuster: false
          raw: "Sass::Script::Number.precision = 10\n"
          debugInfo: true
          sassDir: "<%= yeoman.app %>/docs/styles/scss"
          cssDir: ".tmp/docs/styles"

      # Old tasks from grunt sass
      # dist:
      #   files: [
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/styles"
      #       src: ["*.scss"]
      #       dest: ".tmp/styles"
      #       ext: ".css"
      #     }
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/docs/styles/scss"
      #       src: ["*.scss"]
      #       dest: ".tmp/docs/styles"
      #       ext: ".css"
      #     }
      #   ]
      # server:
      #   files: [
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/styles"
      #       src: ["*.scss"]
      #       dest: ".tmp/styles"
      #       ext: ".css"
      #     }
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/docs/styles/scss"
      #       src: ["*.scss"]
      #       dest: ".tmp/docs/styles"
      #       ext: ".css"
      #     }
      #   ]

    
    # Renames files for browser caching purposes
    filerev:
      dist:
        src: [
          "<%= yeoman.dist %>/scripts/{,*/}*.js"
          "<%= yeoman.dist %>/styles/{,*/}*.css"
          # "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
          # "<%= yeoman.dist %>/styles/fonts/*"
        ]

    
    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: 
        src: "<%= yeoman.app %>/index.html"
        options:
          dest: "<%= yeoman.dist %>"
          flow:
            html:
              steps:
                js: [
                  "concat"
                  "uglifyjs"
                ]
                css: ["cssmin"]

              post: {}
        
      docs:
        src: "<%= yeoman.dist %>/docs/index.html"
        options:
          dest: "<%= yeoman.dist %>/docs"
          root: ".tmp/docs"

    
    # Performs rewrites based on filerev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/{,*/,*/*/}*.html"]
      css: ["<%= yeoman.dist %>/{,*/,*/*/}*.css"]
      options:
        assetsDirs: [
          "<%= yeoman.dist %>"
          "<%= yeoman.dist %>/images"
          "<%= yeoman.dist %>/docs"
        ]

    
    # The following *-min tasks will produce minified files in the dist folder
    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/styles/main.css': [
    #         '.tmp/styles/{,*/}*.css'
    #       ]
    #     }
    #   }
    # },
    # uglify: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/scripts/scripts.js': [
    #         '<%= yeoman.dist %>/scripts/scripts.js'
    #       ]
    #     }
    #   }
    # },
    # concat: {
    #   dist: {}
    # },
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
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
          collapseWhitespace: true
          conservativeCollapse: true
          collapseBooleanAttributes: true
          removeCommentsFromCDATA: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: [
            "*.html"
            "views/{,*/}*.html"
          ]
          dest: "<%= yeoman.dist %>"
        ]

    
    # ng-annotate tries to make the code safe for minification automatically
    # by using the Angular long form for dependency injection.
    ngAnnotate:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: [
            "*.js"
            "!oldieshim.js"
          ]
          dest: ".tmp/concat/scripts"
        ]

    
    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]

    
    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "*.html"
              "views/{,*/}*.html"
              "images/{,*/}*.{webp}"
              "styles/fonts/*"
              "!docs/**"
            ]
          }
          {
            # hack to get around doubled up font-awesome dependency!!
            # fix in alchemy build and here
            expand: true
            dot: true
            cwd: "./bower_components/font-awesome/"
            dest: "<%= yeoman.dist %>"
            src: [ "fonts/**"] 
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: ["generated/*"]
          }
          {
            expand: true
            cwd: "."
            src: "bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*"
            dest: "<%= yeoman.dist %>"
          }
          {
            expand: true
            dot: true
            cwd: ".tmp/docs"
            src: "**"
            dest: "<%= yeoman.dist %>/docs/"
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"
      
      data:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          src: "data/**"
          dest: "<%= yeoman.dist %>"
        ]

    
    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee:dist"
        "compass"
      ]
      test: [
        "coffee"
        "compass"
      ]
      dist: [
        "coffee"
        "compass"
        "imagemin"
        "svgmin"
        "copy:data"
      ]

    
    # Test settings
    karma:
      unit:
        configFile: "test/karma.conf.coffee"
        singleRun: true

  grunt.loadNpmTasks('grunt-string-replace')
  grunt.registerTask "serve", "Compile then start a connect web server", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "jekyll:dev"
      "wiredep"
      "concurrent:server"
      "autoprefixer"
      "connect:livereload"
      "watch"
    ]
    return

  grunt.registerTask "server", "DEPRECATED TASK. Use the \"serve\" task instead", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve:" + target]
    return

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"
    "autoprefixer"
    "connect:test"
    "karma"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "jekyll:dist"
    "wiredep"
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngAnnotate"
    "cdnify"
    "cssmin"
    "uglify"
    "copy:dist"
    "string-replace:version"
    "filerev"
    "usemin"
    "htmlmin"
  ]
  grunt.registerTask "default", [
    # "newer:jshint"
    # "test"
    "build"
    "gh-pages"
  ]
  return