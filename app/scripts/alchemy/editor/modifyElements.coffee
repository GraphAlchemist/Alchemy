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

        d3.selectAll("#node-add-prop-key, #node-add-prop-value, .node-property")
            .on "keydown", ->
                if d3.event.keyCode is 13
                    event.preventDefault()
                d3.select(@).classed({"edited-property":true})

        d3.select("#node-add-property")
            .on "submit", ->
                event.preventDefault()

                key = d3.select("#node-add-prop-key")[0][0].value
                key = key.replace(/\s/g, "_")
                value = d3.select("#node-add-prop-value")[0][0].value
                updateProperty(key, value, true)

                d3.selectAll("#add-property .edited-property").classed("edited-property":false)
                @.reset()

        d3.select("#node-properties-list")
            .on "submit", -> 
                event.preventDefault()

                properties = d3.selectAll(".edited-property")
                for property in properties[0]
                    console.log property
                    key = d3.select(property).select("label").text()
                    value = d3.select(property).select("input")[0][0].value
                    updateProperty(key, value, false)

                d3.selectAll("#node-properties-list .edited-property").classed("edited-property":false)
                @.reset()

        updateProperty = (key, value, newProperty) ->
            nodeID = n.id
            if ((key!="") and (value != ""))
                alchemy._nodes[nodeID].setProperty("#{key}", "#{value}")
                drawNodes = new alchemy.drawing.DrawNodes
                drawNodes.updateNode(d3.select("#node-#{nodeID}"))
                if newProperty is true 
                    d3.select("#node-add-prop-key").attr("placeholder", "property added/updated to key: #{key}")
                    d3.select("#node-add-prop-value").attr("placeholder", "property at #{key} updated to: #{value}")
                else
                    d3.select("#node-#{key}-input").attr("placeholder", "property at #{key} updated to: #{value}")

            else
                if newProperty is true 
                    d3.select("#node-add-prop-key").attr("placeholder", "null or invalid input")
                    d3.select("#node-add-prop-value").attr("placeholder", "null or invlid input")
                else
                    d3.select("#node-#{key}-input").attr("placeholder", "null or invalid input")
            


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
