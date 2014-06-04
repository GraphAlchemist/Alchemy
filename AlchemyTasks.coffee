exports.CoffeeTask = ->
        dist:
            options:
                bare: false
                sourceMap: true
            files:
                # all of the files used in testing and development - configuration, etc.
                ".tmp/scripts/else.js": [".tmp/scripts/*.coffee", "!.tmp/scripts/alchemy.src.coffee"]
                # all of the core, alchemy.js files
                ".tmp/scripts/alchemy.js": [".tmp/scripts/alchemy/defaultConf.coffee"
                                          ".tmp/scripts/alchemy/start.coffee"
                                          ".tmp/scripts/alchemy/*/*.{coffee,litcoffee,coffee.md}"
                                          ".tmp/scripts/alchemy/end.coffee"]