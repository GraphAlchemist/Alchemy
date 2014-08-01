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
            .attr("class", () ->
                if d3.select("#editor-interactions").classed("active")
                    return "enabled"
                else return "hidden"
            )
            .html("""<h4>Node Editor</h4>""")

        d3.select("#node-editor")
            .append("form")
            .attr("id", "node-add-property")
            .attr("class", "node-property form-inline")
            .append("input")
            .attr("type", "submit")
            .attr("value", " + ")
            .attr("class", "form-control property-name")
        d3.select("#node-add-property")
            .append("input")
            .attr("class", "form-control property-value")
            .attr("placeholder", ()->
                if d3.selectAll(".node.selected").empty()
                    return "select a node to edit properties"
                else
                    return "add a property to this node"
                )
        d3.select("#node-add-property")
            .on "submit" , ->
                event.preventDefault()
                d3.select("#node-add-property .property-value")
                    .attr("placeholder", "select a node first")
                @.reset()
                            
    nodeEditor: (n) ->
        d3.select("#node-editor")
            .append("div")
            .attr("id", "node-properties-list")
        nodeProperties = alchemy._nodes[n.id].getProperties()

        for property, val of nodeProperties
            d3.select("#node-properties-list")
                .append("form")
                .attr("id", "node-#{property}")
                .attr("class", "node-property form-inline")
                .append("input")
                .attr("type", "submit")
                .attr("class","form-control property-name")
                .attr("value","#{property}")
            d3.select("#node-#{property}")
                .append("input")
                .attr("class", "form-control property-value")
                .attr("placeholder", "#{val}")

        d3.selectAll(".node-property")
            .on "submit" , ->
                event.preventDefault()
                # grab original ID name and select node
                nodeEdited = d3.select("#node-editor #node-id .property-value").attr("placeholder")
                propertyName = d3.select(@).select(".property-name").attr("value")
                propertyVal = d3.select(@).select(".property-value")
                newVal = propertyVal[0][0].value 
                # two routes from here: create a clone node and replace the old node
                # with the new one
                # use a unique id for d3 and alchemy._nodes so key value pairs don't get messed up
                if propertyName is "id"
                    alchemy._nodes[nodeEdited].setD3Property(propertyName, newVal)
                    d3.select("#node-#{nodeEdited}")
                        .attr("id", "#node-#{newVal}")
                alchemy._nodes[nodeEdited].setProperty(propertyName, newVal)

                d3.select(@).select(".property-name").attr("value", propertyName)
                propertyVal.attr("placeholder", "#{newVal}")
                @.reset()

    nodeEditorClear: () ->
        d3.select("#node-properties-list").remove()
        d3.select("#node-add-property input")
            .attr("placeholder", ()->
                if d3.selectAll(".node.selected").empty()
                    return "select a node to edit properties"
                else
                    return "add a property to this node"
                )   

alchemy.editor =
    enableEditor: () ->
        alchemy.setState("interactions", "editor")
        dragLine = alchemy.vis
            .append("line")
            .attr("id", "dragline")

        d3.select("#node-editor")
            .attr("class", "enabled")
            .style("opacity", 1)

        d3.selectAll(".node circle")
            .style("stroke", "#E82C0C")

        alchemy.drawing.setNodeInteractions(alchemy.node)

    disableEditor: () ->
        alchemy.setState("interactions", "default")
        alchemy.vis.select("#dragline").remove()

        d3.select("#node-editor")
            .transition()
            .duration(300)
            .style("opacity", 0)
        d3.select("#node-editor")
            .transition()
            .delay(300)
            .attr("class", "hidden")

        d3.selectAll(".node circle")
            .style("stroke", "white")

        alchemy.drawing.setNodeInteractions(alchemy.node)

    remove: () ->
        console.log "remove called"
        selectedNodes = d3.selectAll(".selected.node")
        selectedEdges = d3.selectAll(".selected.edge")

        console.log selectedNodes
        console.log selectedEdges

        for node in selectedNodes[0]
            nodeID = d3.select(node).data()[0].id
            node_data = alchemy._nodes[nodeID]
            if node_data?   
                console.log node_data.edges
                alchemy._nodes = _.omit(alchemy._nodes, "#{nodeID}")
                alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3))
                for edge in node_data.edges
                    d3.select(edge)
                d3.select(node).remove()


        for edge in selectedEdges[0]
            edgeID = d3.select(edge).data()[0].id
            if alchemy._edges[edgeID]?
                console.log alchemy._edges[edgeID]
                alchemy.edges = _.omit(alchemy._edges, "#{edgeID}")  
                alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3))
                d3.select(edge).remove()
        alchemy.drawing.drawNodes(alchemy.node)
        # alchemy.drawing.drawEdges(alchemy.edge)     
        
        alchemy.force.friction(1)
        alchemy.updateGraph(false)
        
        alchemy.force.resume()
        alchemy.force.friction(0.9)         
        
        d3.selectAll(".selected").classed("selected", false)

    addNode: (node) ->
        newNode = alchemy._nodes[node.id] = new alchemy.models.Node({})
        newNode.setProperty("id", node.id)
        newNode.setProperty("caption", node.caption)
        newNode.setD3Property("id", node.id)
        newNode.setD3Property("x", node.x)
        newNode.setD3Property("y", node.y)
        alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3))

    addEdge: (edge) ->
        newEdge = alchemy._edges[edge.id] = new alchemy.models.Edge(edge)
        alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3))

    update: (node, edge) ->
        #only push the node if it didn't previously exist
        if !@mouseUpNode
            alchemy.editor.addNode(node)
            alchemy.drawing.drawNodes(alchemy.node)

        alchemy.editor.addEdge(edge)
        alchemy.drawing.drawEdges(alchemy.edge)
        alchemy.layout.tick()


alchemy.editor.interactions = ->
    @mouseUpNode = null
    @sourceNode = null
    @targetNode = null
    @newEdge = null
    @click = null

    @nodeMouseOver = (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius*3)
        @

    @nodeMouseUp = (n) =>
        if @sourceNode != n
            @mouseUpNode = true
            @targetNode = n
            @click = false
        else 
            @click = true
        @

    @nodeMouseOut = (n) ->
        if !d3.select(@).select("circle").empty()
            radius = d3.select(@).select("circle").attr("r")
            d3.select(@).select("circle")
                .attr("r", radius/3)
        @

    @nodeClick = (c) =>
        d3.event.stopPropagation()
        # select the correct nodes
        if !alchemy.vis.select("#node-#{c.id}").empty()
            selected = alchemy.vis.select("#node-#{c.id}").classed('selected')
            alchemy.vis.select("#node-#{c.id}").classed('selected', !selected)
        alchemy.modifyElements.nodeEditorClear()
        alchemy.modifyElements.nodeEditor(c)
        @

    @addNodeStart = (d, i) =>
        d3.event.sourceEvent.stopPropagation()
        @sourceNode = d
        d3.select('#dragline')
            .classed("hidden":false)
        @

    @addNodeDragging = (d, i) =>
        x2coord = d3.event.x
        y2coord = d3.event.y
        d3.select('#dragline')
            .attr "x1", @sourceNode.x
            .attr "y1", @sourceNode.y
            .attr "x2", x2coord
            .attr "y2", y2coord
            .attr "style", "stroke: #FFF"
        @


    @addNodeDragended = (d, i) =>
        #we moused up on an existing (different) node
        if !@click 
            if !@mouseUpNode
                dragline = d3.select("#dragline")
                targetX = dragline.attr("x2")
                targetY = dragline.attr("y2")

                @targetNode = {id: "#{_.uniqueId('addedNode_')}", "x": targetX, "y": targetY, caption: "node added"}

            @newEdge = {id: "#{@sourceNode.id}-#{@targetNode.id}", source: @sourceNode.id, target: @targetNode.id, caption: "edited"}   
            alchemy.editor.update(@targetNode, @newEdge)

        alchemy.editor.interactions().reset()
        @

    @reset = =>
        # reset interaciton variables
        @mouseUpNode = null
        @sourceNode = null
        @targetNode = null
        @newEdge = null
        @click = null

        #reset dragline
        d3.select("#dragline")
            .classed "hidden":true
            .attr "x1", 0            
            .attr "y1", 0
            .attr "x2", 0
            .attr "y2", 0 
        @

    @


