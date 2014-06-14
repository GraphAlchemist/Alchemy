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

alchemy.filters = 
    init: () -> 
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
                nodeTypes += "<li class = 'list-group-item nodeType' role = 'menuitem' id='li-#{nodeType}' name = #{caption}>#{caption}</li>"
            $('#node-dropdown').append(nodeTypes)
            # $('#node-dropdown li').click(alchemy.filters.update())

        if conf.edgeTypes
            for e in d3.selectAll(".edge")[0]
                currentRelationshipTypes[[e].caption] = true

            edgeTypes = ''
            for edgeType in conf.edgeTypes
                if not edgeType then continue
                caption = edgeType.replace('_', ' ')
                edgeTypes += "<li class = 'list-group-item edgeType' role = 'menuitem' id='li-#{edgeType}' name = #{caption}>#{caption}</li>"
            $('#rel-dropdown').append(edgeTypes)
            # $('#rel-dropdown li').click(alchemy.filters.update())
        
        alchemy.filters.update()

    # NOT IMPLEMENTED: 
    # # not working, deprecate?
    # updateTagsAutocomplete: () ->
    #     # if no tags have been selected, use entire list
    #     # otherwise, only use tags that match one or more nodes that match all tags that have been selected
    #     tags = Object.keys(allTags)
    #     selected = (tag.textContent.trim() for tag in $('#tags-list').children())
    #     if selected
    #         newTags = {}
    #         for node in allNodes
    #             ok = true
    #             for tag in selected
    #                 if node._tags.indexOf(tag) is -1
    #                     ok = false
    #                     break
    #             if ok
    #                 # this node matches all tags, add all of its tags to new autocomplete list
    #                 # exclude tags that have already been selected though
    #                 for tag in node._tags
    #                     if selected.indexOf(tag) is -1
    #                         newTags[tag] = true

    #         tags = Object.keys(newTags)

    #     tags.sort()
    #     $('#add-tag').autocomplete('option', 'source', tags)

    # #add a tag NEEDS TESTING
    # addTag: (event, ui) ->
    #     tag = ui.item.value
    #     list = $('#tags-list')
    #     #check if tag is already present
    #     if list.children().filter(() -> @textContent is tag).length is 0

    #         li = $("""<li>
    #                     <span>#{ tag }<i class="icon-remove-sign"></i></span>
    #                   </li>
    #                """)
    #         li.find('i').click(() ->
    #             $(this).parents('li').remove()
    #             updateTagsAutocomplete()
    #             updateFilters()
    #         )
    #         list.append(li)
    #         li.after(' ')

    #     @value = '';
    #     @blur()
    #     updateTagsAutocomplete()
    #     alchemy.filters.update
    #     event.preventDefault()

    show: () ->
        filter_html = """
                        <h3 data-toggle="collapse" data-target="#filters form">
                            Filters
                            <span class = "fa fa-caret-right"></span>
                        </h3>
                        <form class="form-inline collapse">
                        </form>
                      """
        d3.select('#control-dash #filters').html(filter_html)
        # d3.select('#filters>h3')
        #     .on('hide.bs.collapse', () -> d3.select('#filters>h3').html('<span class="fa fa-caret-right"></span>Show Filters'))
        #     .on('show.bs.collapse', () -> d3.select('#filters>h3').html('<span class="fa fa-caret-down"></span>Hide Filters'))

        $('#filters form').submit(false)

    #create relationship filters
    showEdgeFilters: () ->
        rel_filter_html = """
                           <div id="filter-relationships" class="btn-group">
                                <button type="button" data-target = "#rel-dropdown" class="btn btn-default" data-toggle="collapse">
                                    Edge Types<span class="fa fa-caret-down"></span>
                                </button>
                                <ul id="rel-dropdown" class="collapse list-group" role="menu">
                                </ul>
                           </div>

                           """
        $('#filters form').append(rel_filter_html)

    #create node filters
    showNodeFilters: () ->
        node_filter_html = """
                           <div id="filter-nodes" class="btn-group">
                                <button type="button" data-target="#node-dropdown" class="btn btn-default" data-toggle="collapse">
                                    Node Types<span class="fa fa-caret-down"></span>
                                </button>
                                <ul id="node-dropdown" class="collapse list-group" role="menu">
                                </ul>
                           </div>

                           """
        $('#filters form').append(node_filter_html)

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
            ["node", "edge"].forEach (t) ->
                graphElements[t].filter(".#{boxName}")
                    .attr("class", "#{t} #{boxName} #{state}")

            #remove spaces from state
            state = state.replace(/\s+/g, '.');
            for node in graphElements["node"].filter(".#{state}")[0]
                # console.log "nodes with state: #{state}"
                # console.log graphElements["node"].filter(".#{state}")[0]
                # console.log "edge with node as one end: "
                # console.log graphElements["edge"].filter("[id*='#{node.id[7..13]}']")[0][0]
                graphElements["edge"].filter("[id*='#{node.id[7..13]}']")
                    .classed({"inactive": !checked, "active": checked, "highlight": highlight})

            alchemy.stats.update()

        # add label active / inactive classes
        for tag in tags[0]
            element = d3.select("##{tag.id}")
            name = element[0][0].innerText
            checked = !element.classed("disabled")
            state = if checked then "active" else "inactive"
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

