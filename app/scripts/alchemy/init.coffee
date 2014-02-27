#default configuration
conf = window.alchemyConf

###
application scopes
###
window.app = {}
# app.nodes - all nodes in the application scope
# app.edges - all edges in the application scope
# app.node - the model for returning node instances in the app scope
# app.edge - the model for returning edges in the app scope
# app.force - the d3 force layout visualization
# app.vis - the container for all visualization elements
# app.startGraph - creates the svg container and calls the `app.updateGraph` function on the initial rendering
# app.updateGraph - applies node and link elements to the graph visualization
window.layout = {}
# Don't confuse with d3.layout
# TODO
window.interactions = {}
# all of the graph interactions
# app.drag...
#TODO
window.utils = {}
# all of the helpers
window.visControls = {}
# all of the visual controls
window.styles = {}

linkDistance = conf.linkDistance
rootNodeRadius = conf.rootNodeRadius
nodeRadius = conf.nodeRadius
initialComputationDone = false

graph_elem = $('#graph')
igraph_search = $('#igraph-search')

# allNodes = []
# allEdges = []
allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
# force = null
# vis = null
rootNodeId = null
# zoom = null
