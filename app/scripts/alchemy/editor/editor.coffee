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

class alchemy.editor.Editor
    constructor: ->
        @utils = new alchemy.editor.Utils

    # init: =>
    #     if alchemy.conf.showEditor is true
    #         @showOptions()
    #         @nodeEditorInit()
    #         @edgeEditorInit()
    
    editorContainerHTML:
            """
                <div id="editor-header" data-toggle="collapse" data-target="#editor #element-options">
                    <h3>Editor</h3><span class="fa fa-2x fa-caret-right"></span>
                </div>
                <div id="element-options" class="collapse">
                    <ul class="list-group"> 
                        <li class="list-group-item" id="remove">Remove Selected</li> 
                        <li class="list-group-item" id="editor-interactions">Editor mode enabled, click to disable editor interactions</li>
                    </ul>
                </div>
                """

    elementEditorHTML: (type) -> 
            """
                <h4>#{type} Editor</h4>
                <form id="add-property-form">
                    <div id="add-property">
                        <input class="form-control" id="add-prop-key" placeholder="New Property Name">
                        <input class="form-control" id="add-prop-value" placeholder="New Property Value">
                    </div>
                    <input id="add-prop-submit" type="submit" value="Add Property" placeholder="add a property to this node">
                </form>
                <form id="properties-list">
                    <input id="update-properties" type="submit" value="Update Properties">
                </form>
            """

    startEditor: =>
        divSelector = alchemy.conf.divSelector
        html = @editorContainerHTML
        editor = d3.select("#{divSelector} #control-dash")
            .append("div")
            .attr("id", "editor")
            .html(html)
        
        editor.select('#editor-header')
                .on('click', () ->
                    if d3.select('#element-options').classed("in")
                        d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-right")
                    else d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-down")
                )      

        editor_interactions = editor.select('#element-options ul #editor-interactions')
            .on('click', ->
                d3.select(@).attr("class", () ->
                    if alchemy.getState() is 'editor'
                        alchemy.setState('interactions', 'default')
                        return "inactive list-group-item"
                    else
                        alchemy.setState('interactions', 'editor')
                        return "active list-group-item")
                    .html( ->
                        if alchemy.getState() is 'editor'
                            return """Disable Editor Interactions"""
                        else 
                            return """Enable Editor Interactions""")
                )

        editor.select("#element-options ul #remove")
            .on("click", -> alchemy.editor.remove())

        utils = @utils
        
        editor_interactions.on "click", () -> 
                if !d3.select("#editor-interactions").classed("active")
                    utils.enableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": true, "inactive": false})
                        .html("""Editor mode enabled, click to disable editor interactions""")
                else 
                    utils.disableEditor()
                    d3.select("#editor-interactions")
                        .classed({"active": false, "inactive": true})
                        .html("""Editor mode disabled, click to enable editor interactions""")

    # nodeEditorInit: () ->
    #     addPropHTML = """
    #                     <div id="add-property">
    #                         <input class='form-control' id='node-add-prop-key' placeholder="Property Name"></input>
    #                         <input class='form-control' id='node-add-prop-value' placeholder="Property Value"></input>
    #                     </div>
    #                 """
    #     d3.select("#element-options")
    #         .append("div")
    #         .attr("id", "node-editor")
    #         .attr("class", () ->
    #             if d3.select("#editor-interactions").classed("active")
    #                 return "enabled"
    #             else return "hidden"
    #         )
    #         .html("""<h4>Node Editor</h4>""")

    #     # node editor form and add property form
    #     d3.select("#node-editor")
    #         .append("form")
    #         .attr("id", "node-add-property")
    #         .html(addPropHTML)

    #     d3.select("#node-add-property")
    #         .append("input")
    #         .attr("id", "node-add-prop-submit")
    #         .attr("type", "submit")
    #         .attr("value", "Add Property")

    #     # submission handler
    #     d3.select("#node-add-property")
    #         .on "submit" , ->
    #             event.preventDefault()
    #             if d3.select(".node.selected").empty()
    #                 d3.selectAll("#node-add-prop-value, #node-add-prop-key")
    #                     .attr("placeholder", "select a node first")
                            
    nodeEditor: (n) =>
        divSelector = alchemy.conf.divSelector        
        editor = d3.select("#{divSelector} #control-dash-wrapper #control-dash #editor")
        options = editor.select('#element-options')
        # options.html(html)
        html = @elementEditorHTML("Node")
        elementEditor = options.append('div')
                                .attr('id', 'node-editor')
                                .html(html)

        elementEditor.attr("class", () ->
                    if d3.select("#editor-interactions").classed("active")
                        return "enabled"
                    else return "hidden")
        
        add_property = editor.select("#node-editor form #add-property")
        add_property.select("#node-add-prop-key")
                    .attr("placeholder", "New Property Name")
                    .attr("value", null)
        add_property.select("#node-add-prop-value")
                    .attr("placeholder", "New Property Value")
                    .attr("value", null)

        d3.select("#add-property-form")
            .on "submit", ->
                event.preventDefault()
                key = d3.select('#add-prop-key').property('value')
                key = key.replace(/\s/g, "_")
                value = d3.select('#add-prop-value').property('value')
                updateProperty(key, value, true)
                d3.selectAll("#add-property .edited-property").classed("edited-property":false)
                @reset()

        nodeProperties = alchemy._nodes[n.id].getProperties()
        d3.select("#node-#{n.id}").classed("editing":true)

        property_list = editor.select("#node-editor #properties-list")

        for property, val of nodeProperties
            node_property = property_list.append("div")
                                            .attr("id", "node-#{property}")
                                            .attr("class", "property form-inline form-group")
            
            node_property.append("label")
                            .attr("for", "node-#{property}-input")
                            .attr("class","form-control property-name")
                            .text("#{property}")
            
            node_property.append("input")
                            .attr("id", "node-#{property}-input")
                            .attr("class", "form-control property-value")
                            .attr("value", "#{val}")

        d3.select("#properties-list")
            .on "submit", -> 
                event.preventDefault()
                properties = d3.selectAll(".edited-property")
                for property in properties[0]
                    selection = d3.select(property)
                    key = selection.select("label").text()
                    value = selection.select("input").attr('value')
                    updateProperty(key, value, false)

                d3.selectAll("#node-properties-list .edited-property").classed("edited-property":false)
                @.reset()

        d3.selectAll("#add-prop-key, #add-prop-value, .property")
            .on "keydown", ->
                if d3.event.keyCode is 13
                    event.preventDefault()
                d3.select(@).classed({"edited-property":true})

        updateProperty = (key, value, newProperty) ->
            nodeID = n.id
            if ((key!="") and (value != ""))
                alchemy._nodes[nodeID].setProperty("#{key}", "#{value}")
                drawNodes = new alchemy.drawing.DrawNodes
                drawNodes.updateNode(d3.select("#node-#{nodeID}"))
                if newProperty is true 
                    d3.select("#node-add-prop-key").attr("value", "property added/updated to key: #{key}")
                    d3.select("#node-add-prop-value").attr("value", "property at #{key} updated to: #{value}")
                else
                    d3.select("#node-#{key}-input").attr("value", "property at #{key} updated to: #{value}")

            else
                if newProperty is true 
                    d3.select("#node-add-prop-key").attr("value", "null or invalid input")
                    d3.select("#node-add-prop-value").attr("value", "null or invlid input")
                else
                    d3.select("#node-#{key}-input").attr("value", "null or invalid input")
            
    editorClear: () ->
        d3.selectAll(".node").classed("editing":false)
        d3.selectAll(".edge").classed("editing":false)
        d3.select("#node-editor").remove()
        d3.select("#edge-editor").remove()
        d3.select("#node-add-prop-submit")
            .attr("placeholder", ()->
                if d3.selectAll(".selected").empty()
                    return "select a node or edge to edit properties"
                else
                    return "add a property to this element"
                )   

    edgeEditor: (e) ->
        divSelector = alchemy.conf.divSelector        
        editor = d3.select("#{divSelector} #control-dash-wrapper #control-dash #editor")
        options = editor.select('#element-options')
        html = @elementEditorHTML("Edge")
        elementEditor = options.append('div')
                                .attr('id', 'edge-editor')
                                .html(html)

        elementEditor.attr("class", () ->
                    if d3.select("#editor-interactions").classed("active")
                        "enabled"
                    else 
                        "hidden")
        
        add_property = editor.select("#edge-editor form #add-property")
        add_property.select("#add-prop-key")
                    .attr("placeholder", "New Property Name")
                    .attr("value", null)
        add_property.select("#add-prop-value")
                    .attr("placeholder", "New Property Value")
                    .attr("value", null)
        
        edgeProperties = alchemy._edges[e.id].getProperties()
        d3.select("#edge-#{e.id}").classed("editing":true)

        property_list = editor.select("#edge-editor #properties-list")

        for property, val of edgeProperties
            edge_property = property_list.append("div")
                                            .attr("id", "edge-#{property}")
                                            .attr("class", "property form-inline form-group")
            
            edge_property.append("label")
                            .attr("for", "edge-#{property}-input")
                            .attr("class","form-control property-name")
                            .text("#{property}")
            
            edge_property.append("input")
                            .attr("id", "edge-#{property}-input")
                            .attr("class", "form-control property-value")
                            .attr("value", "#{val}")

        d3.selectAll("#add-prop-key, #add-prop-value, .property")
            .on "keydown", ->
                if d3.event.keyCode is 13
                    event.preventDefault()
                d3.select(@).classed({"edited-property":true})

        d3.select("#add-property-form")
            .on "submit", ->
                event.preventDefault()
                key = d3.select("#add-prop-key").property('value')
                key = key.replace(/\s/g, "_")
                value = d3.select("#add-prop-value").property('value')
                updateProperty(key, value, true)

                d3.selectAll("#add-property .edited-property").classed("edited-property":false)
                @reset()

        d3.select("#properties-list")
            .on "submit", -> 
                event.preventDefault()
                properties = d3.selectAll(".edited-property")
                for property in properties[0]
                    selection = d3.select(property)
                    key = selection.select("label").text()
                    value = selection.select("input").property('value')
                    updateProperty(key, value, false)

                d3.selectAll("#properties-list .edited-property").classed("edited-property":false)
                @reset()

        updateProperty = (key, value, newProperty) ->
            edgeID = e.id
            if ((key!="") and (value != ""))
                alchemy._edges[edgeID].setProperty("#{key}", "#{value}")
                edgeSelection = d3.select("#edge-#{edgeID}")
                drawEdges = new alchemy.drawing.DrawEdges
                drawEdges.updateEdge(d3.select("#edge-#{edgeID}"))
                if newProperty is true 
                    d3.select("#add-prop-key").attr("value", "property added/updated to key: #{key}")
                    d3.select("#add-prop-value").attr("value", "property at #{key} updated to: #{value}")
                else
                    d3.select("#edge-#{key}-input").attr("value", "property at #{key} updated to: #{value}")

            else
                if newProperty is true 
                    d3.select("#add-prop-key").attr("value", "null or invalid input")
                    d3.select("#add-prop-value").attr("value", "null or invlid input")
                else
                    d3.select("#edge-#{key}-input").attr("value", "null or invalid input")
        
