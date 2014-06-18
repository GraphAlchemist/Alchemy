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

class Alchemy
    constructor: (@conf) ->   
        @version = "0.1.0"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @drawing = {}
        @log = {}

graph_elem = $('#graph')
igraph_search = $('#igraph-search')

allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
rootNodeId = null

window.alchemy = new Alchemy(conf)

# alchemy.container =
#     'width': parseInt(d3.select('.alchemy').style('width'))
#     'height': parseInt(d3.select('.alchemy').style('height'))
