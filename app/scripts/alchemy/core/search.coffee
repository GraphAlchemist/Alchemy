
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


# not working - but, logic here for search

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

#igraphsearch
#deprecated: graphSearch
iGraphSearch = (event) ->
    vis = app.vis
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

updateCaptions = () ->
    captions = []
    for key of allCaptions
        captions.push({caption: key, value: allCaptions[key]})
    captions.sort((a, b) ->
        if a.caption < b.caption then return -1
        if a.caption > b.caption then return 1
        0
    )
    $('#igraph-search').autocomplete('option', 'source', captions)