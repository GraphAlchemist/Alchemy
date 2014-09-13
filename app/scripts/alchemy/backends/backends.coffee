alchemy.backend = ->
    if alchemy.conf.backend is 'neo4j'
        new Neo4jBackend
        