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
    colours: d3.shuffle(["#DD79FF", "#FFFC00",
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
    rootNodeRadius: 15 # default size of root node
    # interactions
    nodeMouseOver: null
    tipBody: null
    # default size of non-root nodes
    nodeRadius: 10# can be string for key that indicates node size, based on nodes mo
    nodeOverlap: 40# used in the collision detection function.  Defaults so that the nodes are roughly 100% apart from their radius.  A number less than the 2 x the radius would allow overlap.
    caption: 'caption'
    #nodeStandOut: 'betweeness'
    # initial graph elevation
    initialScale: 0
    initialTranslate: [0,0]
    warningMessage: "There be no data!  What's going on?"

conf = _.assign({}, defaults)
