# algorithm to randomly shuffle an array
fisherYates = (arr) ->
    i = arr.length;
    if i == 0 then return false
 
    while --i
        j = Math.floor(Math.random() * (i+1))
        tempi = arr[i]
        tempj = arr[j]
        arr[i] = tempj
        arr[j] = tempi
    return arr

# establish configuration variables
window.alchemyConf = 
    dataSource: '/sample_data/ego_network.json'
        # if not alchemyConf.dataSource
        #     '/sample_data/charlize.json'
        # else
        #     alchemyConf.dataSource
    #graph filters
    nodeFilters: ['gender', 'type']
    edgeFilters: false
    filterAttribute: null
    tagsProperty: null
    nodeTypes: {} #the key/value by which to categorize node types for filtering
    #e.g. {'type': 'movie', 'type': 'actor'...}
    # nodeTypesProperty: 'type'
    edgeTypes: {} #the key/value by which to categorize edge types for filtering
    #e.g. {'type': ACTED_IN, 'type': PRODUCED...}

    #editor settings
    removeNodes: false # allow the removal of nodes with controls
    fixRootNodes: true # root nodes are not dragable by default
    
    # node style settings
    colours: fisherYates(["#DD79FF", "#FFFC00",
                         "#00FF30", "#5168FF",
                         "#00C0FF", "#FF004B",
                         "#00CDCD"])
    positions: false # not currently used - pre-calcuglated layout positions for nodes
    captionToggle: false # allow toggle of node captions
    edgesToggle: false # toggle edges on or off 
    cluster: true # assign ids to clusters of nodes e.g. communities in a social network
    locked: true # all non-root nodes are draggable by default
    nodeCat: []
    linkDistance: 2000 # default length of link
    rootNodeRadius: 45 # default size of root node
    # interactions
    nodeMouseOver: 'default'
    # default size of non-root nodes
    nodeRadius: 20# can be string for key that indicates node size, based on nodes mo
    nodeRadiusTest: 'degree'
    # integer, or function
    # string
    # nodeRadius: 'degree'
    # function
    #   nodeRadius: (n) ->
        #some function
    # nodeClick: (n) ->
    #                 $.get('/ga_graph/bio/' + n.id, (data) ->
    #                     $('aside').html(data);)
    # nodeDrag:   'default'
    
    #default
    # caption: 'caption'
    #string
    #caption: 'li_firstName'
    #function:
    caption: (n) ->
        "#{n.li_firstName} #{n.li_lastName}"
    #nodeStandOut: 'betweeness'
    initialScale: 0.3081060106225185
    initialTranslate:[462.646563149586,276.6962475525915]



# $('#search').autocomplete({
#     source: ((request, response) ->
#         $.getJSON '/live-search/' + request.term, response),
#     minLength: 2,
#     focus: ((event, ui) ->
#         $('#search').val ui.item.label
#         false),
#     select: (event, ui) ->
#         window.location = '/ga_graph/profile/' + ui.item.value
#         false
#     })
