test = {}

test.mouseOut = (d) ->
    test.PopUp.transition()
                .delay(500)
                .remove()

testConf = _.assign {},

    caption: (n) ->
        "#{n.caption}"

    dataSource: '/sample_data/charlize.json'
    # nodeMouseOver: (n) ->
    #    $("#node-#{n.id}")[0].popover({title: "title", container: 'body'})
    # nodeClick: (d) ->
    #     test.nodeClick(d, window.alchemyConf.bio_url)

    nodeRadius: 7
    rootNodeRadius: 10

    nodeTypes: {"node_type":["movie", "award", "person"]}
    edgeTypes: ["ACTED_IN", "NOMINATED", "RECEIVED", "PARENT_OF", "PARTNER_OF", "BORN_AT", "PRODUCED"]

    #show control dash, zoom controls, all filters, and all stats.
    showControlDash: true

    showStats: true
    nodeStats: true
    edgeStats: true

    showFilters: true
    nodeFilters: true
    edgeFilters: true
    zoomControls: true
    
alchemy.conf = _.assign(alchemy.conf, testConf)