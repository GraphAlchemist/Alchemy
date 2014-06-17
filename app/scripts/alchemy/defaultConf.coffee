defaults =
    # Helpers
    afterLoad: 'drawingComplete'
    dataSource: null

    # Layout
    graphWidth: d3.select(".alchemy").node().parentElement.clientWidth
    graphHeight: () ->
        if d3.select(".alchemy").node().parentElement.nodeName == "BODY"
            return window.innerHeight
        else 
            return d3.select(".alchemy").node().parentElement.clientHeight
    alpha: .5
    cluster: false
    clusterColours: d3.shuffle(["#DD79FF", "#FFFC00",
                         "#00FF30", "#5168FF",
                         "#00C0FF", "#FF004B",
                         "#00CDCD", "#f83f00",
                         "#f800df", "#ff8d8f",
                         "#ffcd00", "#184fff",
                         "#ff7e00"])
    fixNodes: false
    fixRootNodes: false
    forceLocked: true
    linkDistance: 2000
    nodePositions: null # not currently implemented

    # Editing
    captionToggle: false # not currently implemented
    edgesToggle: false # not currently implemented
    nodesToggle: false # not currently implemented
    removeNodes: false # not currently implemented
    removeEdges: false # not currently implemented
    addNodes: false # not currently implemented
    addEdges: false # not currently implemented

    #Control Dash
    showControlDash: false 

    #Stats
    showStats: false
    nodeStats: false
    edgeStats: false

    # Filtering
    showFilters: false
    edgeFilters: false # not currently implemented
    nodeFilters: false

    # Controls
    # controlOrientation: 'vertical' no longer implemented or used
    zoomControls: false

    # Nodes
    nodeCaption: 'caption' #changed key
    nodeColour: null
    nodeMouseOver: 'caption' # partially implemented
    nodeOverlap: 20
    nodeRadius: 10 # partially implemented
    nodeTypes: null
    rootNodeRadius: 15

    # Edges
    edgeCaption: 'caption' # not implemented
    edgeColour: null
    edgeTypes: null

    # Init
    initialScale: 0 #not yet implemented
    initialTranslate: [0,0] #not yet implemented
    warningMessage: "There be no data!  What's going on?" #not yet implemented

conf = _.assign({}, defaults)
