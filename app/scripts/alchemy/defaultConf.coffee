# Alchemy.js is a graph drawing application for the web.
# Copyright (C) 2014  GraphAlchemist, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

alchemy.defaults =
    # Helpers
    afterLoad: 'drawingComplete'
    dataSource: null

    # Layout
    graphWidth: d3.select(".alchemy").node().parentElement.clientWidth
    graphHeight: do () ->
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
    captionToggle: false
    edgesToggle: false
    nodesToggle: false
    toggleRootNodes: true
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
    edgeFilters: false
    nodeFilters: false

    # Controls
    zoomControls: false

    # Nodes
    nodeCaption: 'caption' #changed key
    nodeColour: null
    nodeMouseOver: 'caption' # partially implemented
    nodeOverlap: 25
    nodeRadius: 10 # partially implemented
    nodeTypes: null
    rootNodeRadius: 15

    # Edges
    edgeCaption: 'caption' # not implemented
    edgeColour: null
    edgeTypes: null

    # Init
    initialScale: 1
    initialTranslate: [0,0]
    scaleExtent: [0.01, 5] # not yet implemented
    warningMessage: "There be no data!  What's going on?" #not yet implemented