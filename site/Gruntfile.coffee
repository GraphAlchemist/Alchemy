# Generated on 2014-06-24 using generator-webapp 0.4.9
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

  pkg = grunt.file.readJSON('../package.json')

  # Configurable paths
  config =
    app: "app"
    dist: "dist"


  # Define the configuration for all the tasks
  grunt.initConfig
    jekyll:
      dev:
        options:
          config: "_config.yml"
          dest: ".tmp/docs"

      dist:
        options:
          config: "_config.yml"
          dest: "<%= config.dist %>/docs"


    # Project settings
    config: config

    'string-replace':
      version:
        files:
          '<%= config.dist %>/views/home.html'
        options:
          replacements: [
            pattern: "#VERSION#"
            replacement: pkg.version
          ]


    # Watches files for changes and runs tasks based on the changed files
    watch:
      jekyll:
        files: ["<%= config.app %>/docs/{,*/,*/*/}*{.scss,.coffee,.html,.md}"]
        tasks: [
          "jekyll:dev"
          "sass:server"
          "coffee:dist"
        ]

      bower:
        files: ["bower.json"]
        tasks: ["bowerInstall"]

      coffee:
        files: ["<%= config.app %>/scripts/{,*/,*/*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: [
          "coffee:test"
          "test:watch"
        ]

      gruntfile:
        files: ["Gruntfile.coffee"]

      sass:
        files: [
          "<%= config.app %>/styles/{,*/}*.{scss,sass}"
          "<%= config.app %>/docs/styles/scss/{,*/}*.{scss,sass}"
        ]
        tasks: [
          "sass:server"
          "autoprefixer"
        ]

      styles:
        files: ["<%= config.app %>/styles/{,*/}*.css"]
        tasks: [
          "newer:copy:styles"
          "autoprefixer"
        ]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "<%= config.app %>/{,*/}*.html"
          ".tmp/styles/{,*/}*.css"
          ".tmp/scripts/{,*/}*.js"
          ".tmp/docs/{,*/}*.html"
          ".tmp/docs/styles/*.css"
          "<%= config.app %>/images/{,*/}*"
          "<%= config.app %>/{,*/}*.html"
        ]

    "gh-pages":
      options:
        base: "dist"

      src: ["**"]


    # The actual grunt server settings
    connect:
      options:
        port: 9002
        open: true
        livereload: 35730

        # Change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(config.app)
            ]

      test:
        options:
          open: false
          port: 9003
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect.static("test")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(config.app)
            ]

      dist:
        options:
          base: "<%= config.dist %>"
          livereload: false


    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= config.dist %>/*"
            "!<%= config.dist %>/.git*"
          ]
        ]

      server: ".tmp"


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "Gruntfile.js"

        # '<%= config.app %>/scripts/{,*/}*.js',
        "!<%= config.app %>/scripts/vendor/*"
        "test/spec/{,*/}*.js"
      ]


    # Mocha testing framework configuration options
    mocha:
      all:
        options:
          run: true
          urls: ["http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html"]


    # Compiles CoffeeScript to JavaScript
    coffee:
      dist:
        files: [
          {
            expand: true
            cwd: "<%= config.app %>/scripts"
            src: "{,*/}*.{coffee,litcoffee,coffee.md}"
            dest: ".tmp/scripts"
            ext: ".js"
          }
          {
            expand: true
            cwd: "<%= config.app %>/docs/js/coffee"
            src: "*.coffee"
            dest: ".tmp/docs/scripts/"
            ext: ".js"
          }
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
    sass:
      options:
        includePaths: ["bower_components"]

      dist:
        files: [
          {
            expand: true
            cwd: "<%= config.app %>/styles"
            src: ["*.scss"]
            dest: ".tmp/styles"
            ext: ".css"
          }
          {
            expand: true
            cwd: "<%= config.app %>/docs/styles/scss"
            src: ["*.scss"]
            dest: ".tmp/docs/styles"
            ext: ".css"
          }
        ]

      server:
        files: [
          {
            expand: true
            cwd: "<%= config.app %>/styles"
            src: ["*.scss"]
            dest: ".tmp/styles"
            ext: ".css"
          }
          {
            expand: true
            cwd: "<%= config.app %>/docs/styles/scss"
            src: ["*.scss"]
            dest: ".tmp/docs/styles"
            ext: ".css"
          }
        ]

    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: "*.js"
          dest: ".tmp/concat/scripts"
        ]


    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          {
            expand: true
            cwd: ".tmp/styles/"
            src: "{,*/}*.css"
            dest: ".tmp/styles/"
          }
          {
            expand: true
            cwd: ".tmp/docs/styles/"
            src: "{,*/}*.css"
            dest: ".tmp/docs/styles/"
          }
        ]


    # Automatically inject Bower components into the HTML file
    bowerInstall:
      app:
        src: ["<%= config.app %>/index.html"]
        exclude: ["bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap.js"]

      sass:
        src: ["<%= config.app %>/styles/{,*/}*.{scss,sass}"]


    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= config.dist %>/scripts/{,*/}*.js"
            "<%= config.dist %>/styles/{,*/}*.css"
            "<%= config.dist %>/docs/scripts/{,*/}*.js"
            "<%= config.dist %>/docs/styles/{,*/}*.css"
            # rev will not rewrite paths in bootstrap Sass
            # "<%= config.dist %>/images/{,*/}*.*",
            # "<%= config.dist %>/styles/fonts/{,*/}*.*",
            "<%= config.dist %>/*.{ico,png}"
          ]


    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html:
        src: "<%= config.app %>/index.html"
        dest: "<%= config.dist %>"

      docs:
        src: "<%= config.dist %>/docs/index.html"
        options:
          dest: "<%= config.dist %>/docs"
          root: ".tmp/docs"
          # staging: '.tmp/docs'

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      options:
        assetsDirs: [
          "<%= config.dist %>"
          "<%= config.dist %>/images"
          "<%= config.dist %>/docs"
        ]

      html: ["<%= config.dist %>/{,*/,*/*/}*.html"]
      css: ["<%= config.dist %>/{,*/,*/*/}*.css"]


    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= config.app %>/images"
          src: "{,*/}*.{gif,jpeg,jpg,png}"
          dest: "<%= config.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= config.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= config.dist %>/images"
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
          cwd: "<%= config.dist %>"
          src: "{,*/,*/*/}*.html"
          dest: "<%= config.dist %>"
        ]


    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #     dist: {
    #         files: {
    #             '<%= config.dist %>/styles/main.css': [
    #                 '.tmp/styles/{,*/}*.css',
    #                 '<%= config.app %>/styles/{,*/}*.css'
    #             ]
    #         }
    #     }
    # },
    # uglify: {
    #     dist: {
    #         files: {
    #             '<%= config.dist %>/scripts/scripts.js': [
    #                 '<%= config.dist %>/scripts/scripts.js'
    #             ]
    #         }
    #     }
    # },
    # concat: {
    #     dist: {}
    # },

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
            expand: true
            dot: true
            cwd: "<%= config.app %>"
            dest: "<%= config.dist %>"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "images/{,*/}*.webp"
              "{,*/,*/*/}*.html"
              "styles/fonts/{,*/}*.*"
              "!docs/**"
              "!bower_components/**"
            ]
          ,
            expand: true
            dot: true
            cwd: "."
            src: ["bower_components/bootstrap-sass-official/vendor/assets/fonts/bootstrap/*.*"]
            dest: "<%= config.dist %>"
          ,
            expand: true
            dot: true
            cwd: ".tmp/docs/"
            src: "**"
            dest: "dist/docs/"
        ]

      # styles:
      #   files: [
      #     {
      #       expand: true
      #       dot: true
      #       cwd: "<%= config.app %>/styles"
      #       dest: ".tmp/styles/"
      #       src: "{,*/}*.css"
      #     }
      #     {
      #       expand: true
      #       dot: true
      #       cwd: "<%= config.app %>/docs/styles/scss"
      #       dest: ".tmp/docs/styles/css/"
      #       src: "{,*/}*.css"
      #     }
      #   ]

      # docs:
      #   files: [
      #     expand: true
      #     dot: true
      #     cwd: ".tmp/docs/"
      #     src: "**"
      #     dest: "dist/docs/"
      #   ]

      data:
        files: [
          expand: true
          dot: true
          cwd: "<%= config.app %>"
          src: "data/**"
          dest: "<%= config.dist %>"
        ]


    # Generates a custom Modernizr build that includes only the tests you
    # reference in your app
    modernizr:
      dist:
        devFile: "<%= config.app %>/bower_components/modernizr/modernizr.js"
        outputFile: "<%= config.dist %>/scripts/vendor/modernizr.js"
        files:
          src: [
            "<%= config.dist %>/scripts/{,*/}*.js"
            "<%= config.dist %>/styles/{,*/}*.css"
            "!<%= config.dist %>/scripts/vendor/*"
          ]

        uglify: true


    # Run some tasks in parallel to speed up build process
    concurrent:
      server: [
        "coffee:dist"
        # "copy:styles"
      ]
      test: [
        "coffee"
        # "copy:styles"
      ]
      dist: [
        "coffee"
        "sass:dist"
        # "copy:styles"
        "copy:data"
        "imagemin"
        "svgmin"
      ]

  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-gh-pages"
  grunt.loadNpmTasks "grunt-ngmin"
  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "jekyll:dev"
      "sass:server"
      "concurrent:server"
      "autoprefixer"
      "connect:livereload"
      "watch"
    ]
    return

  grunt.registerTask "server", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run [(if target then ("serve:" + target) else "serve")]
    return

  grunt.registerTask "test", (target) ->
    if target isnt "watch"
      grunt.task.run [
        "clean:server"
        "concurrent:test"
        "autoprefixer"
      ]
    grunt.task.run [
      "connect:test"
      "mocha"
    ]
    return

  grunt.registerTask "build", [
    "clean:dist"
    "jekyll:dist"
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngmin"
    "cssmin"
    "uglify"
    "copy:dist"
    "modernizr"
    "rev"
    "usemin"
    "htmlmin"
  ]
  grunt.registerTask "default", [

    # 'newer:jshint',
    "test"
    "build"
    "gh-pages"
  ]
  return
