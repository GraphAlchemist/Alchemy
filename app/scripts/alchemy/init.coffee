conf = window.alchemyConf

#configure the graph
linkDistance = conf.linkDistance
rootNodeRadius = conf.rootNodeRadius
nodeRadius = conf.nodeRadius
initialComputationDone = false

graph_elem = $('#graph')
igraph_search = $('#igraph-search')

allNodes = []
allEdges = []
allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
force = null
vis = null
rootNodeId = null
zoom = null