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
        # Alchemy houses a number modules that can be considered submodules
        @version = "#VERSION#"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @models = {}
        @drawing = {}
        @editor = {}
        @log = {}
        @state = {
            "interactions": "default"
            "layout": "default"
            "filters": {
                "edges": {},
                "nodes": {}
            }
        }
        
        # node and edge internals...  It is unadvised to access internals
        # directly.  Use, alchemy.get.nodes or alchemy.get.edges
        @_nodes = {}
        @_edges = {}

        # extend alchemy with API methods
        _.extend(@, api())

    # depricate v1.0
    allEdges: ->
            _.map(@_edges, (e) -> e.properties)
    # depricate in v1.0
    allNodes: ->
            _.map(@_nodes, (n) -> n.properties)

    # change this to alchemy.state.get()
    # alchemy.state.set() 
    getState: (key) =>
        if @state.key?
            @state.key

    setState: (key, value) =>
        @state.key = value

    begin: (userConf) =>
        # overide configuration with user inputs
        @conf = _.assign({}, alchemy.defaults, userConf)
        if typeof alchemy.conf.dataSource == 'string'
            d3.json(alchemy.conf.dataSource, alchemy.startGraph)
        else if typeof alchemy.conf.dataSource == 'object'
            alchemy.startGraph(alchemy.conf.dataSource)

currentRelationshipTypes = {}

if typeof module isnt 'undefined' and module.exports
  module.exports = new Alchemy()
else
  @alchemy = new Alchemy()

api()
