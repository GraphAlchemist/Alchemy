#default configuration
class Animal
  @find: (name) ->

Animal.find("Parrot")

class Alchemy
    constructor: (@conf) ->   
        # app.drawing
        # app.nodes - holds all nodes in the application scope
        # app.edges - holds all edges in the application scope
        # app.node - the model for returning node instances in the app scope
        # app.edge - the model for returning edges in the app scope
        # app.force - the d3 force layout visualization
        # app.vis - the container for all visualization elements
        # app.startGraph - creates the svg container and calls the `app.updateGraph` function on the initial rendering
        # app.updateGraph - applies node and link elements to the graph visualization
        @layout = {}
        # Don't confuse with d3.layout
        # TODO
        @interactions = {}
        # all of the graph interactions
        # app.drag...
        #TODO
        @utils = {}
        # all of the helpers
        @visControls = {}
        # all of the visual controls
        @styles = {}
        @drawing = {}

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
