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

    # Layout
    graphWidth: ->
        d3.select(@divSelector).node().parentElement.clientWidth
    graphHeight: ->
        if d3.select(@divSelector).node().parentElement.nodeName == "BODY"
            return window.innerHeight
        else 
            return d3.select(@divSelector).node().parentElement.clientHeight
    alpha: .5
    cluster: false
    clusterColours: d3.shuffle(["#DD79FF", "#FFFC00",
                                "#00FF30", "#5168FF",
                                "#00C0FF", "#FF004B",
                                "#00CDCD", "#f83f00",
                                "#f800df", "#ff8d8f",
                                "#ffcd00", "#184fff",
                                "#ff7e00"])
    collisionDetection: true
    fixNodes: false
    fixRootNodes: false
    forceLocked: true
    linkDistancefn: 'default'
    nodePositions: null # not currently implemented

    # Editing
    showEditor: false
    captionToggle: false
    toggleRootNodes: false
    removeElement: false

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
    edgesToggle: false
    nodesToggle: false

    # Controls
    zoomControls: false

    # Nodes
    nodeCaption: 'caption'
    nodeStyle: {}
    nodeColour: null
    nodeMouseOver: 'caption' # partially implemented
    nodeOverlap: 25
    nodeRadius: 10 # partially implemented
    nodeTypes: null
    rootNodes: 'root'
    rootNodeRadius: 15

    # Edges
    edgeCaption: 'caption' # in progress
    edgeClick: 'default' # user can provide function, needs documentation
    edgeStyle: (d) -> # why is this a function?
        null
    edgeTypes: null
    curvedEdges: false
    edgeWidth: 4
    edgeOverlayWidth: 20

    # Search
    search: true
    searchMethod: "contains"

    # Misc
    afterLoad: 'afterLoad'
    divSelector: '#alchemy'
    dataSource: null
    initialScale: 1
    initialTranslate: [0,0]
    scaleExtent: [0.5, 2.4]
    dataWarning: "default"
    warningMessage: "There be no data!  What's going on?"
