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

# not working
if conf.removeNodes
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
        # updateFilters()
        deselectAll()