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
        addPropHTML = """
                        <div id="add-property">
                            <input class='form-control' id='node-add-prop-key' placeholder="Property Name"></input>
                            <input class='form-control' id='node-add-prop-value' placeholder="Property Value"></input>
                        </div>
                    """
        d3.select("#element-options")
            .append("div")
            .attr("id", "node-editor")
            .attr("class", () ->
                if d3.select("#editor-interactions").classed("active")
                    return "enabled"
                else return "hidden"
            )
            .html("""<h4>Node Editor</h4>""")

        # node editor form and add property form
        d3.select("#node-editor")
            .append("form")
            .attr("id", "node-add-property")
            .html(addPropHTML)

        d3.select("#node-add-property")
            .append("input")
            .attr("id", "node-add-prop-submit")
            .attr("type", "submit")
            .attr("value", "Add Property")

        # submission handler
        d3.select("#node-add-property")
            .on "submit" , ->
                event.preventDefault()
                if d3.select(".node.selected").empty()
                    d3.selectAll("#node-add-prop-value, #node-add-prop-key")
                        .attr("placeholder", "select a node first")
                            
    nodeEditor: (n) ->
        d3.select("#node-editor")
            .append("form")
            .attr("id", "node-properties-list")
        d3.selectAll("#node-add-prop-key")
            .attr("placeholder", "New Property Name")
            .attr("value", null)
        d3.selectAll("#node-add-prop-value")
            .attr("placeholder", "New Property Value")
            .attr("value", null)
        nodeProperties = alchemy._nodes[n.id].getProperties()
        d3.select("#node-#{n.id}").classed("editing":true)

        for property, val of nodeProperties
            d3.select("#node-properties-list")
                .append("div")
                .attr("id", "node-#{property}")
                .attr("class", "node-property form-inline form-group")
                .append("label")
                .attr("for", "node-#{property}-input")
                .attr("class","form-control property-name")
                .text("#{property}")
            d3.select("#node-#{property}")
                .append("input")
                .attr("id", "node-#{property}-input")
                .attr("class", "form-control property-value")
                .attr("placeholder", "#{val}")

        d3.select("#node-properties-list")
            .append("input")
            .attr("id", "update-properties")
            .attr("type", "submit")
            .attr("value", "Update Properties")

        # d3.selectAll(".node-property")
        #     .on "submit" , ->
        #         event.preventDefault()
        #         # grab original ID name and select node
        #         nodeID = n.id
        #         propertyName = d3.select(@).select(".property-name").attr("value")
        #         propertyVal = d3.select(@).select(".property-value")
        #         newVal = propertyVal[0][0].value 
                
        #         alchemy._nodes[nodeID].setProperty(propertyName, newVal)
        #         d3.select(@).select(".property-name").attr("value", propertyName)
        #         propertyVal.attr("placeholder", "property updated to: #{newVal}")
                
        #         # update node
        #         drawNodes = new alchemy.drawing.DrawNodes
        #         drawNodes.updateNode(d3.select("#node-#{nodeID}"))
        #         @.reset()

        d3.selectAll("#node-add-prop-key, #node-add-prop-value, .node-property")
            .on "keydown", ->
                if d3.event.keyCode is 13
                    event.preventDefault()
                d3.select(@).classed("edited-property":true)

        d3.select("#node-add-property")
            .on "submit", ->
                event.preventDefault()
                console.log 'adding new property'
                nodeID = n.id
                propertyName = d3.select("#node-add-prop-key")
                propertyVal = d3.select("#node-add-prop-value")
                if propertyVal[0][0].value? and propertyName[0][0].value?
                    key = propertyName[0][0].value
                    val = propertyVal[0][0].value
                    alchemy._nodes[nodeID].setProperty("#{key}", "#{val}")
                    propertyName.attr("placeholder", "property added/updated to key: #{key}")
                    propertyVal.attr("placeholder", "property at #{key} updated to: #{val}")
                    drawNodes = new alchemy.drawing.DrawNodes
                    drawNodes.updateNode(d3.select("#node-#{nodeID}"))
                else 
                    propertyName.attr("placeholder", "null or invalid input")
                    propertyVal.attr("placeholder", "null or invlid input")
                @.reset()

        d3.select("#node-properties-list")
            .on "submit", -> 
                event.preventDefault()
                console.log 'updating properties'
                nodeID = n.id
                properties = d3.selectAll(".edited-property")
                for editedProperty in properties[0]
                    console.log editedProperty
                    updateProperty(editedProperty)
                    # propertyName = d3.select("#node-add-prop-key")
                    # propertyVal = d3.select("#node-add-prop-value")
                    # if propertyVal[0][0].value? and propertyName[0][0].value?
                    #     key = propertyName[0][0].value
                    #     val = propertyVal[0][0].value
                    #     alchemy._nodes[nodeID].setProperty("#{key}", "#{val}")
                    #     propertyName.attr("placeholder", "property added/updated to key: #{key}")
                    #     propertyVal.attr("placeholder", "property at #{key} updated to: #{val}")
                    #     drawNodes = new alchemy.drawing.DrawNodes
                    #     drawNodes.updateNode(d3.select("#node-#{nodeID}"))
                    # else 
                    #     propertyName.attr("placeholder", "null or invalid input")
                    #     propertyVal.attr("placeholder", "null or invlid input")
                @.reset()
        updateProperty: (property) ->
            nodeID = n.id
            property.select("input")
            


    nodeEditorClear: () ->
        d3.selectAll(".node").classed("editing":false)
        d3.select("#node-properties-list").remove()
        d3.select("#node-add-prop-submit")
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

        @drawNodes.updateNode(alchemy.node)

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

        @drawNodes.updateNode(alchemy.node)

    remove: () ->
        selectedNodes = d3.selectAll(".selected.node")
        for node in selectedNodes[0]
            nodeID = d3.select(node).data()[0].id

            node_data = alchemy._nodes[nodeID]
            if node_data?  
                for edge in node_data.adjacentEdges
                    alchemy._edges = _.omit(alchemy._edges, "#{edge}")
                    alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3), (e)->e.id)
                    d3.select("#edge-#{edge}").remove()
                alchemy._nodes = _.omit(alchemy._nodes, "#{nodeID}")
                alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3), (n)->n.id)
                d3.select(node).remove()
                if alchemy.getState("interactions") is "editor"
                    alchemy.modifyElements.nodeEditorClear()

    addNode: (node) ->
        newNode = alchemy._nodes[node.id] = new alchemy.models.Node({id:"#{node.id}"})
        newNode.setProperty("caption", node.caption)
        newNode.setD3Property("x", node.x)
        newNode.setD3Property("y", node.y)
        alchemy.node = alchemy.node.data(_.map(alchemy._nodes, (n) -> n._d3), (n)->n.id)

    addEdge: (edge) ->
        newEdge = alchemy._edges[edge.id] = new alchemy.models.Edge(edge)
        alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, (e) -> e._d3), (e)->e.id)

    update: (node, edge) ->
        #only push the node if it didn't previously exist
        if !@mouseUpNode
            alchemy.editor.addNode(node)
            alchemy.editor.addEdge(edge)
            @drawEdges.createEdge(alchemy.edge)
            @drawNodes.createNode(alchemy.node)

        else
            alchemy.editor.addEdge(edge)
            @drawEdges.createEdge(alchemy.edge)

        # force = new alchemy.layout.force
        alchemy.layout.tick()


alchemy.editor.interactions = ->
    @mouseUpNode = null
    @sourceNode = null
    @targetNode = null
    @newEdge = null
    @click = null
    @drawNodes = new alchemy.drawing.DrawNodes
    @drawEdges = new alchemy.drawing.DrawEdges

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

                @targetNode = {id: "#{_.uniqueId('addedNode_')}", x: parseFloat(targetX), y: parseFloat(targetY), caption: "node added"}

            @newEdge = {id: "#{@sourceNode.id}-#{@targetNode.id}", source: @sourceNode.id, target: @targetNode.id, caption: "edited"}   
            alchemy.editor.update(@targetNode, @newEdge)

        alchemy.editor.interactions().reset()
        @

    @deleteSelected = (d) =>
        switch d3.event.keyCode
            when 8, 46
                if !(d3.select(d3.event.target).node().tagName is ("INPUT" or "TEXTAREA"))
                    d3.event.preventDefault()
                    alchemy.editor.remove()

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


