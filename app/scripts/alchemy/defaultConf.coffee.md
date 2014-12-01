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

    Alchemy::defaults =

        plugins: null
        # Renderer
        renderer: "svg"

        # Layout
        graphWidth: ->
            d3.select(@divSelector).node().parentElement.clientWidth
        graphHeight: ->
            if d3.select(@divSelector).node().parentElement.nodeName is "BODY"
                window.innerHeight
            else 
                d3.select(@divSelector).node().parentElement.clientHeight
        alpha: 0.5
        collisionDetection: true
        nodeOverlap: 25
        fixNodes: false
        fixRootNodes: false
        forceLocked: true
        linkDistancefn: 'default'
        nodePositions: null # not currently implemented

        # Editing
        showEditor: false # should change to nodeEditor and edgeEditor
        captionToggle: false
        toggleRootNodes: false
        removeElement: false

        #Clustering
        cluster: false
        clusterKey: "cluster"
        clusterColours: d3.shuffle ["#DD79FF", "#FFFC00",
                                    "#00FF30", "#5168FF",
                                    "#00C0FF", "#FF004B",
                                    "#00CDCD", "#f83f00",
                                    "#f800df", "#ff8d8f",
                                    "#ffcd00", "#184fff",
                                    "#ff7e00"]
        clusterControl: false

        #Stats
        nodeStats: false
        edgeStats: false

        # Filtering
        edgeFilters: false
        nodeFilters: false
        edgesToggle: false
        nodesToggle: false

        # Controls
        zoomControls: false

        # Nodes
        nodeCaption: 'caption'
        nodeCaptionsOnByDefault: false
        nodeStyle:
            "all":
                "radius": 10
                "color"  : "#68B9FE"
                "borderColor": "#127DC1"
                "borderWidth": (d, radius) -> radius / 3
                "captionColor": "#FFFFFF"
                "captionBackground": null
                "captionSize": 12
                "selected":
                    "color" : "#FFFFFF"
                    "borderColor": "#349FE3"
                "highlighted":
                    "color" : "#EEEEFF"
                "hidden":
                    "color": "none" 
                    "borderColor": "none"

        nodeColour: null # WILL BE DEPRECATED IN 1.0
        nodeMouseOver: 'caption'
        nodeRadius: 10 # WILL BE DEPRECATED IN 1.0
        nodeTypes: null
        rootNodes: 'root'
        rootNodeRadius: 15
        nodeClick: null
        nodePadding: 0

        # Edges
        edgeCaption: 'caption'
        edgeCaptionsOnByDefault: false
        edgeStyle:
            "all":
                "width": 4
                "color": "#CCC"
                "opacity": 0.2
                "directed": true
                "curved": true
                "selected":
                    "opacity": 1
                "highlighted":
                    "opacity": 1
                "hidden":
                    "opacity": 0
        edgeTypes: null
        curvedEdges: false
        edgeWidth: -> 4
        edgeOverlayWidth: 20
        directedEdges: false
        edgeArrowSize: 5
        edgeClick: null

        # Search
        search: false
        searchMethod: "contains"

        # Misc
        backgroundColour: "#000000"
        theme: null
        afterLoad: 'afterLoad'
        divSelector: '#alchemy'
        dataSource: null
        initialScale: 1
        initialTranslate: [0,0]
        scaleExtent: [0.5, 2.4]
        exportSVG: false
        dataWarning: "default"
        warningMessage: "There be no data!  What's going on?"