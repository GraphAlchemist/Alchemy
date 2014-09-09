class Neo4jBackend
    constructor: ->
        @txUrl = "http://localhost:7474/db/data/transaction/commit"

    execute: (query, params, cb) =>
        $.ajax @txUrl,
          type: "POST"
          data: JSON.stringify(statements: [
            statement: query
            parameters: params or {}
            resultDataContents: [
              "row"
              "graph"
            ]
          ])
          contentType: "application/json"
          error: (err) ->
            cb(err)
            return

          success: (res) ->
            if res.errors.length > 0
              cb res.errors
            else
              cols = res.results[0].columns
              rows = res.results[0].data.map((row) ->
                r = {}
                cols.forEach (col, index) ->
                  r[col] = row.row[index]
                  return

                r
              )
              nodes = []
              rels = []
              labels = []
              res.results[0].data.forEach (row) ->
                row.graph.nodes.forEach (n) ->
                  found = nodes.filter((m) ->
                    m.id is n.id
                  ).length > 0
                  unless found
                    node = n.properties or {}
                    node.id = n.id
                    node.type = n.labels[0]
                    nodes.push node
                    labels.push node.type  if labels.indexOf(node.type) is -1
                  return

                rels = rels.concat(row.graph.relationships.map((r) ->
                  source: r.startNode
                  target: r.endNode
                  caption: r.type
                ))
                return

              cb null,
                table: rows
                graph:
                  nodes: nodes
                  edges: rels

                labels: labels

            return

        return
