#default configuration
conf = window.alchemyConf

#application scopes
window.app = {}
window.layout = {}
window.interactions = {}
window.utils = {}
window.visControls = {}

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
# force = null
# vis = null
rootNodeId = null
# zoom = null
