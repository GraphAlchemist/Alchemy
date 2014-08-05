"""
Alchemy.js is a graph drawing application for the web.
Copyright (C) 2014  GraphAlchemist, Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
lets
"""

class Alchemy
    constructor: () ->   
        @version = "#VERSION#"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @models = {}
        @drawing = {}
        @log = {}
        @state = {
            interactions: "default",
            layout: "default"
        }

    getState: (key) ->
        if @state.key?
            @state.key

    setState: (key, value) ->
        @state.key = value

if typeof module isnt 'undefined' and module.exports
  module.exports = new Alchemy()
else
  @alchemy = new Alchemy()

