#establish global variables
window.alchemyConf = 
    showFilters: true
    tagsProperty: 'genre'
    nodeTypes: ['movie', 'person', 'song', 'award', 'place']
    nodeTypesProperty: 'type'
    edgeTypes: ['acted in', 'directed']
    removeNodes: true
    fixRootNodes: true
    colours: [
        "#045E91", "#06799F", 
        "#69B1DA", "#9CC0D6", 
        "#9CCBD5", "#7AC5CD", 
        "#CDE5F3", "#3B8686", 
        "#408B94", "#4F868C", 
        "#11929E", "#00928C", 
        "#76BFB3", "#61B4CF", 
        "#AEEEEE", "#719DAE", 
        "#00CDCD", "#009B95", 
        "#A5D165", "#1272A8", 
        "#41A8B1", "#2A8AC7"
    ]
    positions: false
    labelsToggle: false
    linksToggle: false
    cluster: false
    locked: false
    nodeCat: []
    nodeClick: (n) ->
        $.get('/ga_graph/bio/' + n.id, (data) ->
            $('aside').html(data);
        )
    dataSource: ''#'/sample_data/charlize.json'
        # if not alchemyConf.dataSource
        #     '/sample_data/charlize.json'
        # else
        #     alchemyConf.dataSource


$('#search').autocomplete({
    source: ((request, response) ->
        $.getJSON '/live-search/' + request.term, response),
    minLength: 2,
    focus: ((event, ui) ->
        $('#search').val ui.item.label
        false),
    select: (event, ui) ->
        window.location = '/ga_graph/profile/' + ui.item.value
        false
    })
