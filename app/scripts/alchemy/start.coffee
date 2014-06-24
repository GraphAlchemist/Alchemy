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
# lets

if d3.select('.alchemy').empty()
    console.warn("create an element with `alchemy` as a class")

class Alchemy
    constructor: () ->   
        @version = "0.1.0"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @drawing = {}
        @log = {}

allTags = {}
allCaptions = {}
currentNodeTypes = {}
currentRelationshipTypes = {}
container = null
rootNodeId = null

window.alchemy = new Alchemy()
