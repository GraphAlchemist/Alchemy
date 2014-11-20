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

    Alchemy::startGraph = (instance) ->
        a = instance

        (data) ->
            conf = a.conf

            if d3.select(conf.divSelector).empty()
                console.warn a.utils.warnings.divWarning()

            # Verify passed in data
            if not data
                data =
                  nodes:[]
                  edges:[]
                a.utils.warnings.dataWarning()
            if not data.edges? then data.edges = []

            # create nodes map and update links
            a.create.nodes data.nodes

            data.edges.forEach (e) -> a.create.edges e

            # create SVG
            a.vis = d3.select conf.divSelector
                .attr "style", "width:#{conf.graphWidth()}px; height:#{conf.graphHeight()}px; background:#{conf.backgroundColour};"
                .append "svg"
                    .attr "xmlns", "http://www.w3.org/2000/svg"
                    .attr "xlink", "http://www.w3.org/1999/xlink"
                    .attr "pointer-events", "all"
                    .attr "style", "background:#{conf.backgroundColour};"
                    .attr "alchInst", (Alchemy::instances.length - 1)
                    .on 'click', a.interactions.deselectAll
                    .call a.interactions.zoom(conf.scaleExtent)
                    .on "dblclick.zoom", null
                    .append 'g'
                        .attr "transform","translate(#{conf.initialTranslate}) scale(#{conf.initialScale})"
            
            # Create zoom event handlers
            a.interactions.zoom().scale conf.initialScale
            a.interactions.zoom().translate conf.initialTranslate

            a.index = Alchemy::Index a

            a.generateLayout()
            a.controlDash.init()

            #enter/exit nodes/edges
            d3Edges = a.elements.edges.d3
            d3Nodes = a.elements.nodes.d3

            # if start
            a.layout.positionRootNodes()
            a.force.start()
            if conf.forceLocked
                while a.force.alpha() > 0.005
                    a.force.tick()

            a._drawEdges = a.drawing.DrawEdges
            a._drawNodes = a.drawing.DrawNodes

            a._drawEdges.createEdge d3Edges
            a._drawNodes.createNode d3Nodes 

            a.index()

            a.elements.nodes.svg
             .attr "transform", (id,i)-> "translate(#{id.x}, #{id.y})"

            console.log Date() + ' completed initial computation'
            
            if !conf.forceLocked
                a.force.on "tick", a.layout.tick
                 .start()

            # call user-specified functions after load function if specified
            # deprecate?
            if conf.afterLoad?
                if typeof conf.afterLoad is 'function'
                    conf.afterLoad()
                else if typeof conf.afterLoad is 'string'
                    a[conf.afterLoad] = true

            if conf.cluster
                defs = d3.select("#{a.conf.divSelector} svg").append "svg:defs"

            if conf.nodeStats
                a.stats.nodeStats()

            if conf.showEditor
                editor = new a.editor.Editor
                editorInteractions = new a.editor.Interactions
                d3.select "body"
                    .on 'keydown', editorInteractions.deleteSelected

                editor.startEditor()

            a.initial = true
