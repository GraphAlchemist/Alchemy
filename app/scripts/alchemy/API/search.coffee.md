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

    API::Search = (instance, api)->
        a = instance
        search = (query)->
            query = do ->
                return query       if a.conf.searchMethod is "contains"
                return "^#{query}" if a.conf.searchMethod is "begins"

            regex = new RegExp query, "i"

            _.filter api._el, (el)-> regex.test el._properties.caption

        search.nodes = (query) ->
            query = do ->
                return query       if a.conf.searchMethod is "contains"
                return "^#{query}" if a.conf.searchMethod is "begins"
            
            regex = new RegExp query, "i"
            
            _.filter a._nodes, (node) -> regex.test node._properties.caption

        search.edges = (query) ->
            query = do ->
                return query       if a.conf.searchMethod is "contains"
                return "^#{query}" if a.conf.searchMethod is "begins"
            
            regex = new RegExp query, "i"

            _.filter a.elements.edges.flat, (edge) ->
                regex.test edge._properties.caption

        search