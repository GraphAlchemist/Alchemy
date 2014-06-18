class Alchemy
    constructor: (@conf) ->   
        @version = "0.1.0"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @drawing = {}
        @log = {}

graph_elem = $('#graph')
igraph_search = $('#igraph-search')

allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
rootNodeId = null

window.alchemy = new Alchemy(conf)

# alchemy.container =
#     'width': parseInt(d3.select('.alchemy').style('width'))
#     'height': parseInt(d3.select('.alchemy').style('height'))
