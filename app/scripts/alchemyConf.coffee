#establish global variables
window.alchemyConf = 
    nodeFilters: ['gender', 'type']
    edgeFilters: false
    filterAttribute: 
    tagsProperty: ''    
    nodeTypes: [] #the key/value by which to categorize node types for filtering
    nodeTypesProperty: 'type'
    edgeTypes: [] #the key/value by which to categorize edge types for filtering
    removeNodes: true #?
    fixRootNodes: true #root nodes are not dragable by default
    colours: {
        'default':"#06799F", 
       'clusters':[ "#045E91", "#06799F", 
                    "#69B1DA", "#9CC0D6", 
                    "#9CCBD5", "#7AC5CD", 
                    "#CDE5F3", "#3B8686", 
                    "#408B94", "#4F868C", 
                    "#11929E", "#00928C", 
                    "#76BFB3", "#61B4CF", 
                    "#AEEEEE", "#719DAE", 
                    "#00CDCD", "#009B95", 
                    "#A5D165", "#1272A8", 
                    "#41A8B1", "#2A8AC7"]
                }
    positions: false #?
    captionToggle: false #allow toggle of node captions
    #to do - change every instance of 'links' to 'edges'
    linksToggle: false #toggle edges on or off 
    cluster: false #assign ids to clusters of nodes e.g. communities in a social network
    locked: false #all non-root nodes are draggable by default
    nodeCat: []
    linkDistance: 2000 #default length of link
    rootNodeRadius: 45 #default size of root node
    nodeRadius: 20 #default size of non-root nodes
    nodeClick: null # A function to get data for the node 
            # (n) ->
            #   $.get('/ga_graph/bio/' + n.id, (data) ->
            #         $('aside').html(data);)
    dataSource: '/sample_data/charlize.json'
        # if not alchemyConf.dataSource
        #     '/sample_data/charlize.json'
        # else
        #     alchemyConf.dataSource


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
