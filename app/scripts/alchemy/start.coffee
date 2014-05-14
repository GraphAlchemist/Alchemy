class Alchemy
    constructor: (@conf) ->   
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @drawing = {}

#this is establishing local variables for things that have been configured... 
#This may be redundant
debugger
linkDistance = conf.linkDistance
rootNodeRadius = conf.rootNodeRadius
nodeRadius = conf.nodeRadius
initialComputationDone = false

graph_elem = $('#graph')
igraph_search = $('#igraph-search')

allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
rootNodeId = null

window.alchemy = new Alchemy(conf)

alchemy.container =
    'width': parseInt(d3.select('.alchemy').style('width'))
    'height': parseInt(d3.select('.alchemy').style('height'))
