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

    alchemy.startGraph = (data) =>
        conf = alchemy.conf

        if d3.select(conf.divSelector).empty()
            console.warn alchemy.utils.warnings.divWarning()

        # see if data is ok
        if not data
            alchemy.utils.warnings.dataWarning()

        # create nodes map and update links
        alchemy.create.nodes.apply @, data.nodes

        data.edges.forEach (e) ->
            alchemy.create.edges e

        # create SVG
        alchemy.vis = d3.select conf.divSelector
            .attr "style", "width:#{conf.graphWidth()}px; height:#{conf.graphHeight()}px; background:#{conf.backgroundColour}"
            .append "svg"
                .attr "xmlns", "http://www.w3.org/2000/svg"
                .attr "xlink", "http://www.w3.org/1999/xlink"
                .attr "pointer-events", "all"
                .on 'click', alchemy.interactions.deselectAll
                .call alchemy.interactions.zoom(conf.scaleExtent)
                .on "dblclick.zoom", null
                .append 'g'
                    .attr "transform","translate(#{conf.initialTranslate}) scale(#{conf.initialScale})"
        
        # Create zoom event handlers
        alchemy.interactions.zoom().scale conf.initialScale
        alchemy.interactions.zoom().translate conf.initialTranslate

        alchemy.generateLayout()
        alchemy.controlDash.init()

        #enter/exit nodes/edges
        d3Edges = _.flatten _.map(alchemy._edges, (edgeArray) -> e._d3 for e in edgeArray)
        d3Nodes = _.map alchemy._nodes, (n) -> n._d3

        # if start
        alchemy.layout.positionRootNodes()
        alchemy.force.start()
        while alchemy.force.alpha() > 0.005
            alchemy.force.tick()

        alchemy._drawEdges = alchemy.drawing.DrawEdges
        alchemy._drawEdges.createEdge d3Edges
        alchemy._drawNodes = alchemy.drawing.DrawNodes
        alchemy._drawNodes.createNode d3Nodes

        initialComputationDone = true
        console.log Date() + ' completed initial computation'

        nodes = alchemy.vis.selectAll 'g.node'
                        .attr 'transform', (id, i) -> "translate(#{id.x}, #{id.y})"

        # configuration for forceLocked
        if !conf.forceLocked
            alchemy.force
                    .on "tick", alchemy.layout.tick
                    .start()

        # call user-specified functions after load function if specified
        # deprecate?
        if conf.afterLoad?
            if typeof conf.afterLoad is 'function'
                conf.afterLoad()
            else if typeof conf.afterLoad is 'string'
                alchemy[conf.afterLoad] = true

        if conf.cluster or conf.directedEdges
            defs = d3.select("#{alchemy.conf.divSelector} svg").append "svg:defs"

        if conf.directedEdges
            arrowSize = conf.edgeArrowSize + (conf.edgeWidth() * 2)
            marker = defs.append "svg:marker"
                .attr "id", "arrow"
                .attr "viewBox", "0 -#{arrowSize * 0.4} #{arrowSize} #{arrowSize}"
                .attr 'markerUnits', 'userSpaceOnUse'
                .attr "markerWidth", arrowSize
                .attr "markerHeight", arrowSize
                .attr "orient", "auto"
            marker.append "svg:path"
                .attr "d", "M #{arrowSize},0 L 0,#{arrowSize * 0.4} L 0,-#{arrowSize * 0.4}"
            if conf.curvedEdges
                marker.attr "refX", arrowSize + 1
            else
                marker.attr 'refX', 1 

        if conf.nodeStats
            alchemy.stats.nodeStats()

        if conf.showEditor
            editor = new alchemy.editor.Editor
            editorInteractions = new alchemy.editor.Interactions
            d3.select "body"
                .on 'keydown', editorInteractions.deleteSelected

            editor.startEditor()
