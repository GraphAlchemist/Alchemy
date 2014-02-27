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
    removeNodes: false #allow the removal of nodes with controls
    fixRootNodes: true #root nodes are not dragable by default
    
    #style settings
    # colours: {
    #     'default':"#06799F" 
    #             }

    colours: fisherYates([ "#045E91", "#06799F", 
            "#69B1DA", "#9CC0D6", 
            "#9CCBD5", "#7AC5CD", 
            "#CDE5F3", "#3B8686", 
            "#408B94", "#4F868C", 
            "#11929E", "#00928C", 
            "#76BFB3", "#61B4CF", 
            "#AEEEEE", "#719DAE", 
            "#00CDCD", "#009B95", 
            "#A5D165", "#1272A8", 
            "#41A8B1", "#2A8AC7"])

    positions: false #not currently used - pre-calcuglated layout positions for nodes
    captionToggle: false #allow toggle of node captions
    #to do - change every instance of 'links' to 'edges'
    linksToggle: false #toggle edges on or off 
    cluster: true #assign ids to clusters of nodes e.g. communities in a social network
    locked: false #all non-root nodes are draggable by default
    nodeCat: []
    linkDistance: 2000 #default length of link
    rootNodeRadius: 45 #default size of root node
    #interactions
    nodeMouseOver: 'default'
    nodeRadius: 20 #default size of non-root nodes
    # nodeClick: (n) ->
    #                 $.get('/ga_graph/bio/' + n.id, (data) ->
    #                     $('aside').html(data);)
    # nodeDrag:   'default'

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
