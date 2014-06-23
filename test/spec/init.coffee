do ->
    d3.json('sample_data/movies.json', (data) ->
        this.graphJSON = data
        alchemy.begin({'dataSource': data})
        return)
    return
