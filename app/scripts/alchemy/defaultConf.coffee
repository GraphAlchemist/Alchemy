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
    
if not window.alchemyConf
    window.alchemyConf = {}

defaults =  
    afterLoad: 'drawingComplete'
    alpha: .5
    dataSource: null
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
                         "#00CDCD", "#f83f00",
                         "#f800df", "#ff8d8f",
                         "#ffcd00", "#184fff",
                         "#ff7e00"])
    positions: false # not currently used - pre-calcuglated layout positions for nodes
    captionToggle: false # allow toggle of node captions
    edgesToggle: false # toggle edges on or off 
    cluster: true # assign ids to clusters of nodes e.g. communities in a social network
    locked: true # all non-root nodes are draggable by default
    nodeCat: []
    linkDistance: 2000 # default length of link
    rootNodeRadius: 45 # default size of root node
    # interactions
    nodeMouseOver: null
    tipBody: null
    # default size of non-root nodes
    nodeRadius: 20# can be string for key that indicates node size, based on nodes mo
    caption: 'caption'
    #nodeStandOut: 'betweeness'
    # initial graph elevation
    initialScale: 0
    initialTranslate: [0,0]
    warningMessage: "There be no data!  What's going on?"

# more elegant way to do this?
window.alchemyConf = $.extend({}, defaults, window.alchemyConf  )
# userDefined = d3.map(window.alchemyConf)
# if userDefined? and not userDefined.empty()
#     defaultsMap = d3.map(defaults)
#     for k of defaults
#         if not userDefined.has(k)
#             window.alchemyConf[k] = defaults[k]
# else
#     window.alchemyConf = defaults


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
