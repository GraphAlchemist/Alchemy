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

alchemy.modifyElements = 
    init: () ->
        if alchemy.conf.showEditor is true
            alchemy.modifyElements.showOptions()
            alchemy.modifyElements.nodeEditorInit()

    
    showOptions: () ->
        optionsHTML = """<ul class="list-group"> 
                        <li class="list-group-item" id="remove">Remove Selected</li> 
                        </ul>"""
        
        d3.select('#editor')
            .append("div")
            .attr("id","element-options")
            .attr("class", "collapse")
            .html(optionsHTML)

        d3.select('#element-options ul')
            .append("li")
            .attr("class", ()->
                if alchemy.conf.editorInteractions is true
                    return "active list-group-item"
                else
                    return "inactive list-group-item"
                )
            .attr("id","editor-interactions")
            .html(()->
                if alchemy.conf.editorInteractions is true
                    return """Disable Editor Interactions"""
                else 
                    return """Enable Editor Interactions"""
                )

        d3.select("#remove")
            .on "click", ()-> alchemy.editor.remove()
        d3.select("#editor-interactions")
            .on "click", () -> 
                if !d3.select("#editor-interactions").classed("active")
                    alchemy.editor.enableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": true, "inactive": false})
                        .html("""Editor mode enabled, click to disable editor interactions""")
                else 
                    alchemy.editor.disableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": false, "inactive": true})
                        .html("""Editor mode disabled, click to enable editor interactions""")

    nodeEditorInit: () ->
        d3.select("#element-options")
            .append("div")
            .attr("id", "node-editor")
            .html("""<h4>Node Editor</h4>""")

        d3.select("#node-editor")
            .append("div")
            .attr("id", "node-add-property")
            .attr("class", "node-property input-group")
            .append("span")
            .attr("class", "input-group-addon")
            .text("+")
        d3.select("#node-add-property")
            .append("input")
            .attr("class", "form-control")
            .attr("placeholder", ()->
                if d3.selectAll(".node.selected").empty()
                    return "select a node to edit properties"
                else
                    return "add a property to this node"
                )
                            
    nodeEditor: (n) ->
        d3.select("#node-editor")
            .append("div")
            .attr("id", "node-properties-list")
        nodeProperties = Object.keys(n)

        for property in nodeProperties
            d3.select("#node-properties-list")
                .append("div")
                .attr("id", "node-#{property}")
                .attr("class", "node-property input-group")
                .append("span")
                .attr("class","input-group-addon")
                .html("#{property}")
            d3.select("#node-#{property}")
                .append("input")
                .attr("class", "form-control")
                .attr("placeholder", "#{n[property]}")

    nodeEditorClear: () ->
        d3.select("#node-properties-list").remove()
        d3.select("#node-add-property input")
            .attr("placeholder", ()->
                if d3.selectAll(".node.selected").empty()
                    return "select a node to edit properties"
                else
                    return "add a property to this node"
                )

addNodeStart = (d, i) ->
    d3.event.sourceEvent.stopPropagation()
    sourceNode = d
    d3.select('#dragline')
        .datum({source: sourceNode})
        .classed("hidden":false)

addNodeDragging = (d, i) ->
    x2coord = d3.event.x
    y2coord = d3.event.y
    sourceNode = d
    d3.select('#dragline')
        .attr "x1", sourceNode.x
        .attr "y1", sourceNode.y
        .attr "x2", x2coord
        .attr "y2", y2coord
        .attr "style", "stroke: #FFF"


addNodeDragended = (d, i) ->
    if (alchemy.editor.interactions.nodeMouseUp() is false) and d3.select("#dragline").datum()?
        dragline = d3.select("#dragline")
        targetX = dragline.attr("x2")
        targetY = dragline.attr("y2")
        sourceNode = d

        targetNode = {id: alchemy.nodes.length, x: targetX, y: targetY, caption: "editedNode"}    
        newLink = {source: sourceNode, target: targetNode, caption: "edited"}

        # add to alchemy data and draw nodes / links
        alchemy.editor.update(targetNode, newLink)

    # reset dragline
    d3.select("#dragline")
        .classed "hidden":true
        .attr "x1", 0            
        .attr "y1", 0
        .attr "x2", 0
        .attr "y2", 0    


alchemy.editor = 
    enableEditor: () ->
        dragLine = alchemy.vis
            .append("line")
            .attr "id", "dragline"
        alchemy.conf.editorInteractions = true
        alchemy.drawing.setNodeInteractions(alchemy.node)
        d3.selectAll(".node circle")
            .style("stroke", "#E82C0C")

    disableEditor: () ->
        alchemy.vis.select("#dragline").remove()
        alchemy.conf.editorInteractions = false
        alchemy.drawing.setNodeInteractions(alchemy.node)
        d3.selectAll(".node circle")
            .style("stroke", "white")

    remove: () ->
        selectedNodes = d3.selectAll(".selected.node").data()
        selectedEdges = d3.selectAll(".selected.edge").data()         
        
        alchemy.edges = _.difference(alchemy.edges, selectedEdges)
        alchemy.nodes = _.difference(alchemy.nodes, selectedNodes)
        
        alchemy.force.friction(1)
        alchemy.updateGraph(false)
        
        alchemy.force.resume()
        alchemy.force.friction(0.9)         
        
        d3.selectAll(".selected").classed("selected", false)

    addNode: (node) ->
        alchemy.nodes.push(node)
        alchemy.node = alchemy.node.data(alchemy.nodes)

    addEdge: (edge) ->
        alchemy.edges.push(edge)
        alchemy.edge = alchemy.edge.data(alchemy.edges)

    update: (node, edge) ->
        alchemy.editor.addEdge(edge)
        alchemy.drawing.drawedges(alchemy.edge)

        if node?
            alchemy.editor.addNode(node)
            alchemy.drawing.drawnodes(alchemy.node)
        alchemy.layout.tick()
        d3.select("#dragline").datum(null)

alchemy.editor.interactions =
    nodeMouseOver: (n) ->
        if alchemy.conf.editorInteractions is true
            if !d3.select(@).select("circle").empty()
                radius = d3.select(@).select("circle").attr("r")
                d3.select(@).select("circle")
                    .attr("r", radius*3)

    nodeMouseUp: (n) ->
        # to do: insert lines uniquely
        if !d3.select(n).empty() and !d3.select("#dragline").empty()
            dragline = d3.select("#dragline")
            sourceNode = dragline.data()[0].source
            targetNode = n
            if sourceNode != targetNode
                newLink = {source: sourceNode, target: targetNode, caption: "edited"}
                alchemy.editor.update(null, newLink)
            # do nothing (we've registered a click; just reset dragline data)
            dragline.datum(null)
            return true
        else return false

    nodeMouseOut: (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius/3)

    nodeClick: (c) ->
        d3.event.stopPropagation()
        # select the correct nodes
        if !alchemy.vis.select("#node-#{c.id}").empty()
            selected = alchemy.vis.select("#node-#{c.id}").classed('selected')
            alchemy.vis.select("#node-#{c.id}").classed('selected', !selected)
        alchemy.modifyElements.nodeEditorClear()
        alchemy.modifyElements.nodeEditor(c)


