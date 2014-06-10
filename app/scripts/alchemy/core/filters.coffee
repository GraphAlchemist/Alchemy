fixNodesTags = (nodes, edges) ->
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

    tags = Object.keys(allTags)
    tags.sort()
    $('#add-tag').autocomplete('option', 'source', tags)

    # shouldn't nodetypes be renamed to nodetags? since adding a tag is essentially adding a nodetype? and vice-versa?

alchemy.filters = 
    init: (nodes, edges) -> 
        #show the appropriate filters:
        if conf.showFilters then alchemy.filters.show()
        if conf.edgeFilters then alchemy.filters.showEdgeFilters()
        if conf.nodeFilters then alchemy.filters.showNodeFilters()

        #generate filter forms
        if conf.nodeTypes
            nodeKey = Object.keys(conf.nodeTypes)

            nodeTypes = ''
            for nodeType in conf.nodeTypes[nodeKey]
                # if not currentNodeTypes[t] then continue
                caption = nodeType.replace('_', ' ')
                nodeTypes += "<li class = 'nodeType' role = 'menuitem' id='li-#{nodeType}' name = #{caption}>#{caption}</li>"
            $('#node-dropdown').append(nodeTypes)
            # $('#node-dropdown li').click(alchemy.filters.update())

        if conf.edgeTypes
            for e in edges
                currentRelationshipTypes[[e].caption] = true

            edgeTypes = ''
            for edgeType in conf.edgeTypes
                if not edgeType then continue
                caption = edgeType.replace('_', ' ')
                edgeTypes += "<li class = 'edgeType' role = 'menuitem' id='li-#{edgeType}' name = #{caption}>#{caption}</li>"
            $('#rel-dropdown').append(edgeTypes)
            # $('#rel-dropdown li').click(alchemy.filters.update())
        
        alchemy.filters.update()

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

    ##refactor without checkboxes

    #update filters
    update: () ->
        vis = alchemy.vis
        graphElements = {
            "node" : vis.selectAll("g"),
            "edge" : vis.selectAll("line"),
        }
        tags = d3.selectAll(".nodeType, .edgeType")
        # relationshipTypeList = $('#filter-relationships :checked')

        reFilter = (boxName, state, checked, highlight) ->
            boxName = boxName.replace(/\s+/g, '_');
            console.log boxName + " " + state
            ["node", "edge"].forEach (t) ->
                graphElements[t].filter(".#{boxName}")
                    .attr("class", "#{t} #{boxName} #{state}")

            #remove spaces from state
            state = state.replace(/\s+/g, '.');
            console.log boxName + " " + state


            for node in graphElements["node"].filter(".#{state}")[0]
                graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                    .classed({"inactive": !checked, "active": checked, "highlight": highlight})
            console.log  "refiltered #{boxName} with state #{state} and checked #{checked} and highlight #{highlight}"

        # add label active / inactive classes
        for tag in tags[0]
            element = d3.select("##{tag.id}")
            name = element[0][0].innerText
            state = if element.classed("disabled") then "inactive" else "active"
            checked = !element.classed("disabled")
            element.classed({'active-label': checked,'disabled': !checked})
            reFilter(name, state, checked, false)

        # filter previews
        tags
            .on "mouseenter", () ->
                #get the element and state
                element = d3.select("##{this.id}")
                checked = !element.classed("disabled")
                name = element[0][0].innerText
                state = if checked then "active" else "inactive"

                highlight = true
                state += " highlight"
                reFilter(name, state, checked, highlight)

            .on "mouseleave", () ->
                #get the element and state
                console.log "mouseleave"
                element = d3.select("##{this.id}")
                checked = !element.classed("disabled")
                name = element[0][0].innerText
                state = if checked then "active" else "inactive"

                highlight = false
                reFilter(name, state, checked, highlight)

            .on "click", () ->
                #find the current state of the element
                element = d3.select("##{this.id}")
                checked = !element.classed("disabled")

                #toggle the checked property and add disabled class
                checked = !checked
                element.classed({'active-label': checked,'disabled': !checked})

                name = element[0][0].innerText
                console.log name + " click and checked" + checked
                state = if checked then "active" else "inactive"

                highlight = false
                reFilter(name, state, checked, highlight)
                                




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

