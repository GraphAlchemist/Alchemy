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

    class Alchemy::Search
        constructor: (instance) ->
            @a = instance

        nodes: (query) ->
            a = @a
            if a.conf.searchMethod is "contains" 
                _.filter a._nodes, (node) -> 
                    node if (new RegExp query, "i").test(node._properties.caption)

            if a.conf.searchMethod is "begins"
                _.filter a._nodes, (node) -> 
                    node if (new RegExp("^" + query, "i")).test(node._properties.caption)

        edges: (query) ->
            a = @a
            if a.conf.searchMethod is "contains" 
                _.filter [].concat.apply([], _.map(a._edges)), (edge) -> 
                    edge if (new RegExp query, "i").test(edge._properties.caption)

            if a.conf.searchMethod is "begins" 
                _.filter [].concat.apply([], _.map(a._edges)), (edge) -> 
                    edge if (new RegExp "^" + query, "i").test(edge._properties.caption)
