###
***********************************
Notes:
gaConf is defined in ga_base.coffee and custom.js
***********************************
###

gaConf = window.alchemyConf

#some helpers
graph_elem = $('#graph')
igraph_search = $('#igraph-search')

allNodes = []
allEdges = []
allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
force = null
vis = null
rootNodeId = null
zoom = null
#path 
#node
#colours 
#rootNodeId

#// API FIXME: allow different values for layout/appearance
linkDistance = 2000
rootNodeRadius = 45
nodeRadius = 20
initialComputationDone = false

###
Graph initiation
###
#check if the graph exists
if not gaConf.hasOwnProperty('dataSource')# or (graph_id.length is 0) 
    alert('dataSource not specified or #graph does not exist!')

#
updateGraph = (start=true) ->
    # TODO - currently we are displaying all nodes/links, not a subset
    # set currentNodes/currentLinks and call force.nodes(currentNodes).links(currentLinks).start();
    # tick should also examine just the visible nodes

    force.nodes(allNodes).links(allEdges)
    if start then force.start()

    if not initialComputationDone
        while force.alpha() > 0.005
            force.tick()
        initialComputationDone = true
        $('#loading-spinner').hide()
        $('#loading-spinner').removeClass('middle')
        console.log(Date() + ' completed initial computation')
        if(gaConf.locked) then force.stop()

    #enter/exit nodes/edges
    path = vis.selectAll("line")
            .data(allEdges, (d) ->
                d.source.id + '-' + d.target.id)
    path.enter()
        .insert("svg:line", 'g.node')
        .attr("class", (d) -> "link #{if d.shortest then 'highlighted' else ''}")
        .attr('id', (d) -> d.source.id + '-' + d.target.id)
        .on('click', edgeClick)
    path.exit().remove()

    path.attr('x1', (d) -> d.source.x)
        .attr('y1', (d) -> d.source.y)
        .attr('x2', (d) -> d.target.x)
        .attr('y2', (d) -> d.target.y)

    node = vis.selectAll("g.node")
              .data(allNodes, (d) -> d.id)

    nodeEnter = node.enter()
                    .append("svg:g")
                    .attr('class', (d) -> "node #{if d.category? then d.category.join ' ' else ''}")
                    .attr('id', (d) -> "node-#{d.id}")
                    .attr('transform', (d) -> "translate(#{d.x}, #{d.y})")
                    .on('mousedown', (d) -> d.fixed = true)
                    .on('mouseover', nodeMouseOver)
                    .on('dblclick', nodeDoubleClick)
                    .on('click', nodeClick)

    if gaConf.locked then nodeEnter.call node_drag else nodeEnter.call force.drag

    nodeEnter
        .append('circle')
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "circle-#{d.id}")
        .attr('r', (d) ->
            if d.node_type is 'root'
                rootNodeRadius
            else
                if not gaConf.scaleNodes then nodeRadius else scale d.count
            )
        .attr('style', (d) ->
            if gaConf.cluster
                if isNaN parseInt d.cluster
                    colour = '#EBECE4'
                else if d.cluster < colours.length
                    colour = colours[d.cluster]
                else
                    ''
            else if gaConf.colours
                if d[gaConf.colourProperty]? and gaConf.colours[d[gaConf.colourProperty]]?
                    colour = gaConf.colours[d[gaConf.colourProperty]]
                else
                    colour = gaConf.colours['default']
            else
                ''
            "fill: #{colour}; stroke: #{colour};"
            )

    nodeEnter
        .append('svg:text')
        .text((d) -> d.label)
        .attr('class', (d) -> d.node_type)
        .attr('id', (d) -> "text-#{d.id}")
        .attr('dy', (d) -> if d.node_type is 'root' then rootNodeRadius / 2 else nodeRadius * 2 - 5)

    vis
        .selectAll('.node text')
        .text((d) -> return d.label)

    node
        .exit()
        .remove()

  # API FIXME: run user specified afterLoad function here?

#position root nodes
positionRootNodes = () ->
    #fix or unfix root nodes
    fixRootNodes = gaConf.fixRootNodes
    #count root nodes
    rootNodes = Array()
    for n in allNodes
        if (n.node_type == 'root') or (n.id == rootNodeId)
            n.node_type = 'root'
            rootNodes.push(n)

    #currently we center the graph on one or two root nodes
    if rootNodes.length == 1
        rootNodes[0].x = container.width / 2
        rootNodes[0].y = container.height / 2
        rootNodes[0].px = container.width / 2
        rootNodes[0].py = container.height / 2
        rootNodes[0].fixed = fixRootNodes
        rootNodes[0].r = rootNodeRadius
    else
        rootNodes[0].x = container.width * 0.25
        rootNodes[0].y = container.height / 2
        rootNodes[0].px = container.width * 0.25
        rootNodes[0].py = container.height / 2
        rootNodes[0].fixed = fixRootNodes
        rootNodes[0].r = rootNodeRadius
        rootNodes[1].x = container.width * 0.75
        rootNodes[1].y = container.height / 2
        rootNodes[1].px = container.width * 0.75
        rootNodes[1].py = container.height / 2
        rootNodes[1].fixed = fixRootNodes
        rootNodes[1].r = rootNodeRadius

updateCaptions = () ->
    captions = []
    for key of allCaptions
        captions.push({label: key, value: allCaptions[key]})
    captions.sort((a, b) ->
        if a.label < b.label then return -1
        if a.label > b.label then return 1
        0
    )
    $('#igraph-search').autocomplete('option', 'source', captions)

fixNodesTags = (nodes, edges) ->
    #lowercase tags for matching
    for n in nodes
        allCaptions[n.label] = n.id
        n._tags = []
        if gaConf.nodeTypesProperty then currentNodeTypes[n[gaConf.nodeTypesProperty]] = true
        if typeof(n[gaConf.tagsProperty]) == 'undefined' then continue
        for t in n[gaConf.tagsProperty]
            tag = t.trim().toLowerCase()
            allTags[tag] = true
            n._tags.push(tag)

    updateCaptions()
    
    if 'nodeTypes' of gaConf
        # $('#filter-nodes').append('<fieldset id="filter-nodes"><legend>Show Only</legend></fieldset>')
        checkboxes = ''
        column = 0
        for t in gaConf.nodeTypes
            if not currentNodeTypes[t] then continue
            l = t.replace('_', ' ')
            checked = $('#filter-nodes input[name="' + t + '"]:checked').length ? ' checked' : ''
            checkboxes += '<label class="checkbox" data-toggle="tooltip"><input type="checkbox" name="' + t + '"' + checked + '> ' + l + '</label>'
            column++
            #check boxes should create a column of 3
            if column % 3 == 0 then checkboxes += '<br>'
        $('#filter-nodes label, #filter-nodes br').remove()
        $('#filter-nodes').append(checkboxes)
        $('#filter-nodes input').click(updateFilters)

    if 'edgeTypes' of gaConf
        for e in edges
            currentRelationshipTypes[[e].caption] = true

        checkboxes = ''
        column = 0
        for t in gaConf.edgeTypes
            if not t then continue
            caption = t.replace('_', ' ')
            checked = $('#filter-relationships input[name="' + t + '"]:checked').length ? ' checked' : ''
            checkboxes += '<label class="checkbox" data-toggle="tooltip"><input type="checkbox" name="' + t + '"' + checked + '> ' + caption + '</label>'
            column++
            if column % 3 == 0 then checkboxes += '<br>'
        $('#filter-relationships label, #filter-relationships br').remove()
        $('#filter-relationships').append(checkboxes)
        $('#filter-relationships input').click(updateFilters)

    tags = Object.keys(allTags)
    tags.sort()
    $('#add-tag').autocomplete('option', 'source', tags)

#position the nodes
positionNodes = (nodes, x, y) ->
    if typeof(x) is 'undefined'
        x = container.width / 2
        y = container.height / 2
    for n in nodes
        min_radius = linkDistance * 3
        max_radius = linkDistance * 5
        radius = Math.random() * (max_radius - min_radius) + min_radius
        angle = Math.random() * 2 * Math.PI
        node_x = Math.cos(angle) * linkDistance
        node_y = Math.sin(angle) * linkDistance
        n.x = x + node_x
        n.y = y + node_y
####


###
filters
###

#create graph filters
if gaConf.showFilters
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
    $('#controls-container').prepend(filter_html)
    $('#filters form')
        .on('hide.bs.collapse', () -> $('#filters>h4').html('<i class="icon-caret-right"></i> Show Filters'))
        .on('show.bs.collapse', () -> $('#filters>h4').html('<i class="icon-caret-down"></i> Hide Filters'))

    $('#filters form').submit(false)

updateTagsAutocomplete = () ->
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

#add tags when a user clicks #TODO, needs to be tested
addTag = (event, ui) ->
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
    updateFilters()
    event.preventDefault()

#create tag box and tags
if gaConf.tagsProperty
    tag_html = """
                <fieldset id="tags">
                    <legend>Tags:</legend>
                    <input type="text" id="add-tag" placeholder="search for tags in graph" data-toggle="tooltip" title="tags">
                    <ul id="tags-list" class="unstyled"></ul>
                </fieldset>
               """
    $('#filters form').append(tag_html)
    $('#add-tag').autocomplete({select: addTag, minLength: 0})
    $('#add-tag').focus ->
        $(this).autocomplete('search')

#create relationship filters
if gaConf.edgeTypes
    rel_filter_html = """
                        <fieldset id="filter-relationships">
                            <legend>Filter Relationships 
                                <button class="toggle">Toggle All</button>
                            </legend>
                        </fieldset>
                      """
    $('#filters form').append(rel_filter_html)

#create node filters
if gaConf.nodeTypes
    node_filter_html = """
                        <fieldset id="filter-nodes">
                            <legend>Filter Nodes 
                                <button class="toggle">Toggle All</button>
                            </legend>
                        </fieldset>
                       """
    $('#filters form').append(node_filter_html)

if gaConf.removeNodes
    node_filter_html = """
                        <fieldset id="remove-nodes">
                            <legend>Remove Nodes
                                <button>Remove</button>
                            </legend>
                        </fieldset>
                       """
    $('#filters form').append(node_filter_html)

    $('#filters #remove-nodes button').click ->
        # remove all nodes and associated tags and captions with class selected or search-match
        ids = []
        $('.node.selected, .node.search-match').each((i, n) ->
            ids.push n.__data__.id
            delete allCaptions[n.__data__.label]
        )
        allNodes = allNodes.filter((n) ->
            ids.indexOf(n.id) is -1
        )
        allEdges = allEdges.filter((e) ->
            ids.indexOf(e.source.id) is -1 and ids.indexOf(e.target.id) is -1
        )
        updateCaptions()
        updateGraph(false)
        # clear all filters
        $('#tags-list').html('')
        $('#filters input:checked').parent().remove()
        updateFilters()
        deselectAll()

$('#filters form').append('<div class="clear"></div>')

toggle_button = $('#filters form').find('button.toggle')
toggle_button.click ->
    #if all boxes are unchecked, check them all
    #otherwise uncheck all
    #todo not sure if @ is used correctly here for "this"
    checkboxes = $(@).parents('fieldset').find('input')
    checked = $(@).parents('fieldset').find('input:checked').length
    checkboxes.prop('checked', (checked == 0))
    updateFilters()

#update filters
updateFilters = () ->
    tagList = $('#tags-list')
    nodeTypeList = $('#filter-nodes :checked')
    relationshipTypeList = $('#filter-relationships :checked')
    nodes = vis.selectAll('g.node')
    edges = vis.selectAll('line')
    if tagList.children().length + nodeTypeList.length + relationshipTypeList.length > 0
        active = true
        graph_elem.attr('class', 'search-active')
    else
        nodes.classed('search-match', false)
        edges.classed('search-match', false)
        graph_elem.attr('class', '')
        return
    nodes.classed('search-match', (d) ->
        if tagList.children().length + nodeTypeList.length is 0
            return false
        match = true
        for tag in tagList.children()
            if d._tags.indexOf(tag.textContent.trim()) is -1
                match = false

        if match and nodeTypeList.length > 0
            match = nodeTypeList.filter('[name="' + d.type + '"]').length > 0

        match
    )
    edges.classed('search-match', (d) ->
        if relationshipTypeList.filter('[name="' + d.label + '"]').length
            $('#node-' + d.source.id)[0].classList.add('search-match')
            $('#node-' + d.target.id)[0].classList.add('search-match')
            return true
        else
            return false
    )
    matched = false
    relationshipTypeList.each( (d) ->
        if d.caption is $(this).attr('name')
            matched = true
    matched
    )

#label toggle
if gaConf.labelsToggle
    $('#labels-toggle').click = () ->
        currentClasses = ($('svg').attr(class) or '').split(' ')
        if (currentClasses.indexOf('hidetext') > -1)
            currentClasses.splice(currentClasses.indexOf('hidetext'), 1)
        else
            currentClasses.push('hidetext')
        $('svg').attr('class', currentClasses.join(' '))

#links toggle
if gaConf.linksToggle
    $('#links-toggle').click = () ->
        currentClasses = ($('svg').attr('class') or '').split(' ')
        if(currentClasses.indexOf('hidelinks') > -1)
            currentClasses.splice(currentClasses.indexOf('hidelinks'), 1)
        else
            currentClasses.push('hidelinks')
        $('svg').attr('class', currentClasses.join(' '))




###
visual controls
###
#current scope of the view
getCurrentViewParams = () ->
    #return array with current translation & scale settings
    params = $('#graph > g').attr('transform')
    if not params
        [0, 0, 1]
    else
        params = params.match(/translate\(([0-9e.-]*), ?([0-9e.-]*)\)(?: scale\(([0-9e.]*)\))?/)
        params.shift()
        # if scale has not been specified, set it to 1
        if not params[2] then params[2] = 1
        params

#redraw
redraw = () ->
    vis.attr("transform",
             "translate(#{ d3.event.translate }) scale(#{ d3.event.scale })")

#graph control actions
zoomIn = () ->
    #google analytics event tracking -  keep?
    #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'zoom', 'in']);
    params = getCurrentViewParams()
    x = params[0]
    y = params[1]
    level = parseFloat(params[2]) * 1.2
    vis.attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
    zoom.translate([x, y]).scale(level)

zoomOut = () ->
     #google analytics
     #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'zoom', 'out']);
     params = getCurrentViewParams()
     x = params[0]
     y = params[1]
     level = parseFloat(params[2]) / 1.2
     vis.attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
     zoom.translate([x, y]).scale(level)

zoomReset = () ->
    #google analytics old
    #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'reset', 'reset']);
    deselectAll()
    ax = ay = ar = 0
    for n in allNodes
        delete n.fixed
        if n.node_type is 'root'
            ax += n.x
            ay += n.y
    x = 0#container.width / 2
    y = 0#container.height / 2
    if ar isnt 0
        x -= ax / ar
        y -= ay / ar

    vis.attr('transform', "translate(#{ x }, #{ y }) scale(1)")
    zoom.translate([x, y]).scale(1)

$('#zoom-in').click(zoomIn)
$('#zoom-out').click(zoomOut)
$('#zoom-reset').click(zoomReset)

#igraphsearch
#deprecated: graphSearch
iGraphSearch = (event) ->
    if event and (event.keyCode == 27)
        $('#igraph-search').val('')
    term = $('#igraph-search').val().toLowerCase()
    nodes = vis.selectAll('g.node')
    if term == ''
        #deactivate search
        updateFilters()
        return
    graph_elem.attr('class', 'search-active')
    #Feature: allow for different property name(s) to be matched
    matches = (d) -> d.name.toLowerCase().indexOf(term) >= 0
    nodes.classed('search-match', matches)
    #Feature: autocomplete drop down list
    #Feature: zoom and pan to first node in list
    #and then other nodes if user selects them
#clear-graph-search does not exist just now
#$('#clear-graph-search').click(function() {
#  $('#graph-search').val('');
#  graphSearch();
#  return false;
#});

centreView = (id) ->
    # centre view on node with given id
    svg = $('#graph').get(0)
    node = $(id).get(0)
    svgBounds = svg.getBoundingClientRect()
    nodeBounds = node.getBoundingClientRect()
    delta = [svgBounds.width / 2 + svgBounds.left - nodeBounds.left - nodeBounds.width / 2,
            svgBounds.height / 2 + svgBounds.top - nodeBounds.top - nodeBounds.height / 2]
    params = getCurrentViewParams()
    x = parseFloat(params[0]) + delta[0]
    y = parseFloat(params[1]) + delta[1]
    level = parseFloat(params[2])
    vis.transition().attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
    zoom.translate([x, y]).scale(level)

iGraphSearchSelect = (event, ui) ->
    # item has been selected from list, centre on it, click it and clear in graph search
    id = "#node-#{ui.item.value}"
    $(id).d3Click()
    centreView(id)
    @value = ''
    updateFilters()
    event.preventDefault()

iGraphSearchFocus = (event, ui) ->
    # if there is only one item in the list, centre on it
    # if $('.ui-autocomplete').children().length is 1
    centreView "#node-#{ui.item.value}"
    event.preventDefault()

$('#igraph-search').keyup(iGraphSearch)
                    .autocomplete({
                        select: iGraphSearchSelect,
                        focus: iGraphSearchFocus,
                        minLength: 0
                    })
                    .focus ->
                        $(this).autocomplete('search')

###
force layout functions
###
node_drag = d3.behavior.drag()
            .on("dragstart", dragstart)
            .on("drag", dragmove)
            .on("dragend", dragend)

dragstart = (d, i) ->
    @parentNode.appendChild(this)

dragmove = (d, i) ->
    d.px += d3.event.dx
    d.py += d3.event.dy
    d.x += d3.event.dx
    d.y += d3.event.dy

    path.attr("x1", (d) -> d.source.x )
      .attr("y1", (d) -> d.source.y )
      .attr("x2", (d) -> d.target.x )
      .attr("y2", (d) -> d.target.y )

    node.attr("transform", (d) "translate(" + d.x + "," + d.y + ")" )

    force.stop()

dragend = (d, i) ->
  force.stop()

charge = (n) ->
    if gaConf.cluster
        n.node_type == 'root' ? -1600 : -400
    else
        -350

strength = (edge) ->
    if edge.source.node_type == 'root'
        .2
    else
        if gaConf.cluster
            edge.source.cluster == edge.target.cluster ? 0.5 : 0.01
        else
            1

friction = () ->
    if gaConf.cluster
        0.7
    else
        0.9

linkDistanceFn = (edge) ->
    if typeof(edge.distance) isnt 'undefined' then edge.distance
    if gaConf.cluster
        # FIXME: parameterise this
        if edge.source.node_type is 'root' then 100
        edge.source.cluster == edge.target.cluster ? 180 : 540
    else
        if typeof(edge.source.connectedNodes is 'undefined') then edge.source.connectedNodes = 0
        if typeof(edge.target.connectedNodes is 'undefined') then edge.target.connectedNodes = 0
        edge.source.connectedNodes++
        edge.target.connectedNodes++
        edge.distance = (Math.floor(Math.sqrt(edge.source.connectedNodes + edge.target.connectedNodes)) + 2) * 35
        edge.distance

tick = () ->
    # NOTE: allNodes should be changed to currentNodes when node hiding is introduced
    q = d3.geom.quadtree(allNodes)
    if gaConf.cluster
        c = cluster(10 * force.alpha() * force.alpha())
    for n in allNodes
        q.visit(collide(n))
        if gaConf.cluster then c[n]
    if path?
        path.attr('x1', (d) -> d.source.x)
        path.attr('y1', (d) -> d.source.y)
        path.attr('x2', (d) -> d.target.x)
        path.attr('y2', (d) -> d.source.y)
    if node?
        node.attr('transform', (d) ->
            'translate(#{ d.x }, #{ d.y })')

cluster = (alpha) ->
    centroids = {}
    allNodes.forEach (d) ->
        if d.cluster == ''
            return
        if d.cluster not in centroids
            centroids[d.cluster] = {'x':0, 'y':0, 'c':0}
        centroids[d.cluster].x += d.x
        centroids[d.cluster].y += d.y
        centroids[d.cluster].c++
        
    for c in centroids
        c.x = c.x / c.c
        c.y = c.y / c.c

    (d) ->
        if d.cluster is '' then return
        c = centroids[d.cluster]
        x = d.x - c.x
        y = d.y - c.y
        l = Math.sqrt( x * x * y * y)
        if l > nodeRadius * 2 + 5
            l = (l - nodeRadius) / l * alpha
            d.x -= x * l
            d.y -= y * l

collide = (node) ->
    r = nodeRadius + 16
    nx1 = node.x - r
    nx2 = node.x + r
    ny1 = node.y - r
    ny2 = node.y + r
    (quad, x1, y1, x2, y2) ->
        if quad.point and (quad.point isnt node)
            x = node.x - quad.point.x
            y = node.y - quad.point.y
            l = Math.sqrt(x * x + y * y)
            r = nodeRadius + nodeRadius + 10
            if l < r
                l = (l - r) / l * .5
                node.x -= x *= l
                node.y -= y *= l
                quad.point.x += x
                quad.point.y += y
        x1 > nx2 or
        x2 < nx1 or
        y1 > ny2 or
        y2 < ny1

###
graph interaction
###
#deselect all nodes and links
#deprectated: 'deselect'
deselectAll = () ->
    # this function is also fired at the end of a drag, do nothing if this happens
    if d3.event?.defaultPrevented then return
    vis.selectAll('.node, line')
        .classed('selected highlight', false)
    $('#graph').removeClass('highlight-active')

    # vis.selectAll('line.edge')
    #     .classed('highlighted connected unconnected', false)
    # vis.selectAll('g.node,circle,text')
    #     .classed('selected unselected neighbor unconnected connecting', false)
    #call user-specified deselect function if specified
    if gaConf.deselectAll and typeof(gaConf.deselectAll == 'function')
        gaConf.deselectAll()

edgeClick = (d) ->
    vis.selectAll('line')
        .classed('highlight', false)
    d3.select(this)
        .classed('highlight', true)
    d3.event.stopPropagation
    if typeof gaConf.edgeClick? is 'function'
        gaConf.edgeClick()

nodeMouseOver = (n) ->
    if typeof gaConf.nodeMouseOver? is 'function'
        gaConf.nodeMouseOver()

nodeDoubleClick = (c) ->
    if not gaConf.extraDataSource or
        c.expanded or
        gaConf.unexpandable.indexOf c.type is not -1 then return

    $('#loading-spinner').show()
    console.log "loading more data for #{c.id}"
    c.expanded = true
    d3.json gaConf.extraDataSource + c.id, loadMoreNodes

    links = findAllEdges c
    for e of edges
        edges[e].distance *= 2

loadMoreNodes = (data) ->
    ###
    TRY:
      - fixing all nodes before laying out graph with added nodes, so only the new ones move
      - extending length of connection between requester node and root so there is some space around it for new nodes to display in
    ###
    console.log "loading more data for #{data.type} #{data.permalink}, #{data.nodes.length} nodes, #{data.links.length} edges"
    console.log "#{allNodes.length} nodes initially"
    console.log "#{allEdges.length} edges initially"
    requester = allNodes[findNode data.id]
    console.log "requester node index #{findNode data.id}"

    fixNodesTags data.nodes, data.links

    for i in data.nodes
        node = data.nodes[i]
        if findNode node.id is null
            console.log "adding node #{node.id}"

            min_radius = linkDistance * 3
            max_radius = linkDistance * 5
            radius = Math.random * (max_radius - min_radius) + min_radius
            angle = Math.random * 2 * Math.PI
            node_x = Math.cos angle * linkDistance
            node_y = Math.sin angle * linkDistance

            node.x = requester.x + node_x
            node.y = requester.y + node_y
            node.px = requester.x + node_x
            node.py = requester.y + node_y
            allNodes.push node

        if typeof gaConf.nodeAdded? is 'function'
            gaConf.nodeAdded(node)

    nodesMap = d3.map()
    allNodes.forEach (n) -> nodesMap.set n.id, n
    data.links.forEach (l) ->
        l.source = nodesMap.get(l.source)
        l.target = nodesMap.get(l.target)

    for i in data.links
        link = data.links[i]
        # see if link is already in dataset
        if findEdge link.source, link.target isnt null
            allEdges.push link

            if typeof gaConf.edgeAdded? is 'function'
                gaConf.edgeAdded(node)

            console.log "adding link #{link.source.id}-#{link.target.id}"
        else
            console.log "already have link #{link.source.id}-#{link.target.id} index #{findEdge link.source, link.target}"

    updateGraph()
    nodeClick requester

    requester.fixed = false
    setTimeout (-> requester.fixed = true), 1500

    if gaConf.showFilters then updateFilters
    $('#loading-spinner').hide
    console.log "#{allNodes.length} nodes afterwards"
    console.log "#{allEdges.length} edges afterwards"

    if typeof gaConf.nodeDoubleClick? is 'function'
        gaConf.nodeDoubleClick(requester)

nodeClick = (c) ->
    vis.selectAll('line')
        .classed('highlight', (d) -> return c.id is d.source.id or c.id is d.target.id)
    vis.selectAll('.node')
        .classed('selected', (d) -> return c.id is d.id)
        .classed('highlight', (d) ->
            return d.id is c.id or allEdges.some (e) ->
                return (e.source.id is c.id and e.target.id is d.id) or (e.source.id is d.id and e.target.id is c.id))

    $('#graph').addClass 'highlight-active'

    if d3.event
        d3.event.stopPropagation()
        if gaConf.nodeClick? and typeof gaConf.nodeClick is 'function'
            gaConf.nodeClick c

###
utility functions
###
# for dispatching clicks to d3 handlsers
jQuery.fn.d3Click = () ->
    @each((i, e) ->
        evt = document.createEvent("MouseEvents")
        evt.initMouseEvent("click", true,
                            true, window,
                            0, 0, 0, 0, 0,
                            false, false,
                            false, false,
                            0, null)
        e.dispatchEvent(evt)
    )

#for scaling the visualization
scale = (x) ->
    #returns minimum 10, maximum 60
    #scale linearly from 1 to 50 (?), then logarithmically
    min = 100
    mid_scale = 40
    elbow_point = 50
    if x > elbow_point
        # log
        Math.min(max, mid_scale + (Math.log(x) - Math.log(elbow_point)))
    else 
        # linear
        (mid_scale - min) * (x / elbow_point) + min

#find node
findNode = (id) ->
    if n.id == id then n for n in allNodes

#find edge
findEdge = (source, target) ->
    for e in allEdges
        if e.source.id == source.id and e.target.id == target.id
            e
        if e.target.id == source.id and e.source.id == target.id
            e

#find all those links
findAllEdges = (source) ->
    Q = []
    for e in allEdges
        if (e.source.id == source.id) or (e.target.id == source.id)
            Q.push(e)
    Q

resize = () ->
    container =
        'width': $(window).width()
        'height': $(window).height()
    d3.select('#graph')
        .attr("width", container.width)
        .attr("height", container.height)

startGraph = (data) ->
    # debugger
    # see if data is ok
    if not data
        # allow for user specified error
        no_results = """
                    <div class="modal fade" id="no-results">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Sorry!</h4>
                                </div>
                                <div class="modal-body">
                                    <p>No data found, try searching for movies, actors or directors.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                   """
        $('body').append(no_results)
        $('#no-results').modal('show')
        $('#loading-spinner').hide()
        return

    # save nodes & edges
    allNodes = data.nodes
    allEdges = data.edges

    #see if root node id has been specified
    if 'id' of data
        rootNodeId = data.id

    # create nodes map and update links
    nodesMap = d3.map()
    data.nodes.forEach (n) ->
        nodesMap.set(n.id, n)
    data.edges.forEach (e) ->
        e.source = nodesMap.get(e.source)
        e.target = nodesMap.get(e.target)

    #get graph size
    container =
        'width': $(window).width()
        'height': $(window).height()

    #API FIXME: allow alternative root node positioning?
    positionRootNodes();

    #API FIXME: allow custom styling
    #colours is spelled like whoever originally wrote this is from Scotland
    # as it should be ;)
    colours = gaConf.colours
    if Array.isArray colours
        colours.sort(() -> 0.5 - Math.random())

    #position nodes initially
    # API FIXME: allow specified positions for nodes?
    positionNodes(data.nodes)

    # TODO: fix this in the graph file generating view instead of here
    fixNodesTags(allNodes, allEdges);

    # create layout
    force = d3.layout.force()
        .charge(charge)
        .linkDistance(linkDistanceFn)
        .theta(1.0)
        .gravity(0)
        .linkStrength(strength)
        .friction(friction())
        .size([container.width, container.height])
        .on("tick", tick);

    force.nodes(allNodes)
         .links(allEdges)
         .start()

    zoom = d3.behavior.zoom()
        .scaleExtent([0.1, 2])

    #create SVG
    vis = d3.select('#graph')
        .attr("width", container.width)
        .attr("height", container.height)
        .attr("pointer-events", "all")
        .call(zoom.on("zoom", redraw))
        .on("dblclick.zoom", null)
        .on('click', deselectAll)
        .append('svg:g')

    updateGraph()

    window.onresize = resize

    # call user-specified functions after load function if specified
    user_spec = gaConf.afterLoad
    if user_spec and typeof(user_spec is 'function') then user_spec()

# start the graph
d3.json(gaConf.dataSource, startGraph)
