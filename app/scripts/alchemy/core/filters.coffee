fixNodesTags = (nodes, edges) ->
    #show the appropriate filters:
    if conf.showFilters then alchemy.filters.show()
    if conf.edgeFilters then alchemy.filters.showEdgeFilters()
    if conf.nodeFilters then alchemy.filters.showNodeFilters()

    for n in nodes
        allCaptions[n.label] = n.id
        n._tags = []
        if conf.nodeTypesProperty then currentNodeTypes[n[conf.nodeTypesProperty]] = true
        if typeof(n[conf.tagsProperty]) == 'undefined' then continue
        for t in n[conf.tagsProperty]
            tag = t.trim().toLowerCase()
            allTags[tag] = true
            n._tags.push(tag)

    updateCaptions()
    
    if conf.nodeTypes
        nodeKey = Object.keys(conf.nodeTypes)

        checkboxes = ''
        for t in conf.nodeTypes[nodeKey]
            # if not currentNodeTypes[t] then continue
            l = t.replace('_', ' ')
            checkboxes += "<li id='li-#{t}'><label><input type='checkbox' name='#{t}' checked>#{l}</label></li>"
        $('#node-dropdown').append(checkboxes)
        $('#node-dropdown input').click(alchemy.filters.update)

    if conf.edgeTypes
        for e in edges
            currentRelationshipTypes[[e].caption] = true

        checkboxes = ''
        for t in conf.edgeTypes
            if not t then continue
            caption = t.replace('_', ' ')
            checkboxes += "<li id='li-#{t}'><label><input type='checkbox' name='#{t}' checked>#{caption}</label></li>"
        $('#rel-dropdown').append(checkboxes)
        $('#rel-dropdown input').click(alchemy.filters.update)

    tags = Object.keys(allTags)
    tags.sort()
    $('#add-tag').autocomplete('option', 'source', tags)

alchemy.filters = 
    # not working, deprecate?
    updateTagsAutocomplete: () ->
        # if no tags have been selected, use entire list
        # otherwise, only use tags that match one or more nodes that match all tags that have been selected
        tags = Object.keys(allTags)
        selected = (tag.textContent.trim() for tag in $('#tags-list').children())
        if selected
            newTags = {}
            for node in allNodes
                ok = true
                for tag in selected
                    if node._tags.indexOf(tag) is -1
                        ok = false
                        break
                if ok
                    # this node matches all tags, add all of its tags to new autocomplete list
                    # exclude tags that have already been selected though
                    for tag in node._tags
                        if selected.indexOf(tag) is -1
                            newTags[tag] = true

            tags = Object.keys(newTags)

        tags.sort()
        $('#add-tag').autocomplete('option', 'source', tags)

    #add a tag NEEDS TESTING
    addTag: (event, ui) ->
        tag = ui.item.value
        list = $('#tags-list')
        #check if tag is already present
        if list.children().filter(() -> @textContent is tag).length is 0

            li = $("""<li>
                        <span>#{ tag }<i class="icon-remove-sign"></i></span>
                      </li>
                   """)
            li.find('i').click(() ->
                $(this).parents('li').remove()
                updateTagsAutocomplete()
                updateFilters()
            )
            list.append(li)
            li.after(' ')

        @value = '';
        @blur()
        updateTagsAutocomplete()
        alchemy.filters.update
        event.preventDefault()

    show: () ->
        # #old
        filter_html = """
                        <div id="filters">
                            <h4 data-toggle="collapse" data-target="#filters form">
                                <i class="icon-caret-right"></i> 
                                Show Filters
                            </h4>
                            <form class="form-inline collapse">
                            </form>
                        </div>
                      """
        d3.select('#controls-container').html(filter_html)
        d3.select('#filters form')
            .on('hide.bs.collapse', () -> d3.select('#filters>h4').html('<i class="icon-caret-right"></i> Show Filters'))
            .on('show.bs.collapse', () -> d3.select('#filters>h4').html('<i class="icon-caret-down"></i> Hide Filters'))

        $('#filters form').submit(false)

    #create relationship filters
    showEdgeFilters: () ->
        rel_filter_html = """
                           <div id="filter-relationships" class="btn-group">
                                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                    Edges<span class="caret"></span>
                                </button>
                                <ul id="rel-dropdown" class="dropdown-menu" role="menu">
                                </ul>
                           </div>

                           """
        $('#filters form').append(rel_filter_html)

    #create node filters
    showNodeFilters: () ->
        node_filter_html = """
                           <div id="filter-nodes" class="btn-group">
                                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                    Nodes<span class="caret"></span>
                                </button>
                                <ul id="node-dropdown" class="dropdown-menu" role="menu">
                                </ul>
                           </div>

                           """
        $('#filters form').append(node_filter_html)

    #update filters
    updateBoxStatus: () ->
        vis = alchemy.vis
        # tagList = $('#tags-list')
        checkboxes = $("[type='checkbox']")
        relationshipTypeList = $('#filter-relationships :checked')
        graphElements = {
            "node" : vis.selectAll('g'),
            "edge" : vis.selectAll('line'),
        } 

        console.log "called mini update"
        for box in checkboxes
            state = if box.checked then "active" else "inactive"
            console.log box.name + " " + box.checked + " " + state

            d3.select("#li-#{box.name}")
                .classed({'active-label': box.checked,'inactive-label': !box.checked})
                .on "click", () ->
                    console.log state
                    state = !state
                    console.log state

            ["node", "edge"].forEach (t) ->
                graphElements[t].filter(".#{box.name}")
                .attr("class", "#{t} #{box.name} #{state}")

        for node in graphElements["node"].filter(".inactive")[0]
            graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                .classed({"inactive":false, "active": false})

            #reset the state
            state = null

    update: () ->
        vis = alchemy.vis
        # tagList = $('#tags-list')
        checkboxes = $("[type='checkbox']")
        relationshipTypeList = $('#filter-relationships :checked')
        graphElements = {
            "node" : vis.selectAll('g'),
            "edge" : vis.selectAll('line'),
        }
        # alchemy.filters.updateBoxStatus()

        for box in checkboxes
            state = if box.checked then "active" else "inactive"
            console.log box.name + " " + box.checked + " " + state

            d3.select("#li-#{box.name}")
                .classed({'active-label': box.checked,'inactive-label': !box.checked})

            # # filter out the correct nodes and edges
            # ["node", "edge"].forEach (t) ->
            #     graphElements[t].filter(".#{box.name}")
            #     .attr("class", "#{t} #{box.name} #{state}")

            # for node in graphElements["node"].filter(".inactive")[0]
            #     graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
            #         .classed({"inactive":false, "active": false})
 
        checked = null
        hoverState = null
        d3.selectAll(".inactive-label")
            .on "mouseenter", () ->
                if !checked
                    boxName = this.outerText
                    console.log boxName
                    hoverState = true
                    console.log "mousenter #{boxName} " + state
                    state = "inactive-hover"
                    # filter out the right nodes
                    ["node", "edge"].forEach (t) ->
                        graphElements[t].filter(".#{boxName}")
                            .attr("class", "#{t} #{boxName} #{state}")
                    for node in graphElements["node"].filter(".#{state}")[0]
                        graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                            .classed({"inactive":false, "active": false, "inactive-hover": hoverState})

            .on "mouseleave", () ->
                # console.log d3.select(this)
                console.log "mouseleave #{boxName} " + state +  " " + checked +  " " + hoverState
                boxName = this.outerText
                if hoverState and !checked
                    hoverState = false
                    state = "inactive"
                    console.log "mouseleave #{boxName} " + state
                    ["node", "edge"].forEach (t) ->
                        graphElements[t].filter(".#{boxName}")
                            .attr("class", "#{t} #{boxName} #{state}")
                    for node in graphElements["node"].filter(".#{state}")[0]
                        graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                            .classed({"inactive":true, "active": false, "inactive-hover":hoverState})

            .on "click", () ->
                boxName = this.outerText
                console.log "click"
                #get checked property and toggle it
                checked = d3.select("#li-#{boxName} input").property("checked")
                console.log checked + " " + state
                state = if checked then "active" else "inactive"

                ["node", "edge"].forEach (t) ->
                    graphElements[t].filter(".#{boxName}")
                        .attr("class", "#{t} #{boxName} #{state}")
                console.log state
                for node in graphElements["node"].filter(".#{state}")[0]
                    graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                        .classed({"inactive": !checked, "active": checked, "inactive-hover":false})
                                
                
                # d3.select("#li-#{boxName} input").property("checked", !checked)




        # edges.classed('search-match', (d) ->
        #     if relationshipTypeList.filter('[name="' + d.label + '"]').length
        #         $('#node-' + d.source.id)[0].classList.add('search-match')
        #         $('#node-' + d.target.id)[0].classList.add('search-match')
        #         return true
        #     else
        #         return false
        # )
        # matched = false
        # relationshipTypeList.each( (d) ->
        #     if d.caption is $(this).attr('name')
        #         matched = true
        # matched
        # )

#create tag box and tags

# if conf.tagsProperty
#     tag_html = """
#                     <input type="text" id="add-tag" class="form-control" placeholder="search for tags" data-toggle="tooltip" title="tags">
#                """
#     $('#filters form').append(tag_html)
#     $('#add-tag').autocomplete({select: addTag, minLength: 0})
#     $('#add-tag').focus ->
#         $(this).autocomplete('search')


        # if tagList.children().length + nodeTypeList.length + relationshipTypeList.length > 0
        #     active = true
        # else
        #     nodes.classed('search-match', false)
        #     edges.classed('search-match', false)
        #     return
        # nodes.classed('search-match', (d) ->
        #     if tagList.children().length + nodeTypeList.length is 0
        #         return false
        #     match = true
        #     for tag in tagList.children()
        #         if d._tags.indexOf(tag.textContent.trim()) is -1
        #             match = false

        #     if match and nodeTypeList.length > 0
        #         match = nodeTypeList.filter('[name="' + d.type + '"]').length > 0

        #     match
        # )    


# $('#filters form').append('<div class="clear"></div>')

# toggle_button = $('#filters form').find('button.toggle')
# toggle_button.click ->
#     #if all boxes are unchecked, check them all
#     #otherwise uncheck all
#     #todo not sure if @ is used correctly here for "this"
#     checkboxes = $(@).parents('fieldset').find('input')
#     checked = $(@).parents('fieldset').find('input:checked').length
#     checkboxes.prop('checked', (checked == 0))
#     alchemy.filters.update


# #label toggle
# if conf.captionsToggle
#     #todo, change every instance of 'label' to 'caption' to disambiguate with Graph property model
#     $('#labels-toggle').click = () ->
#         currentClasses = ($('svg').attr(class) or '').split(' ')
#         if (currentClasses.indexOf('hidetext') > -1)
#             currentClasses.splice(currentClasses.indexOf('hidetext'), 1)
#         else
#             currentClasses.push('hidetext')
#         $('svg').attr('class', currentClasses.join(' '))

# #links toggle
# if conf.linksToggle
#     $('#links-toggle').click = () ->
#         currentClasses = ($('svg').attr('class') or '').split(' ')
#         if(currentClasses.indexOf('hidelinks') > -1)
#             currentClasses.splice(currentClasses.indexOf('hidelinks'), 1)
#         else
#             currentClasses.push('hidelinks')
#         $('svg').attr('class', currentClasses.join(' '))

