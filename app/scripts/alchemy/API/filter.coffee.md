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

    API::Filter = (instance, api)->
        a = instance 

        filter = (type)->
            _.each api._el, (el)-> 
                key = do ->
                    "_edgeType"  if api._elType is "edge"
                    "_nodeType"  if api._elType is "node"

                el.toggleHidden() if el[key] is type

        filter.nodes = (type)->
            nodes = a.elements.nodes.val

            _.each nodes, (n)->
                n.toggleHidden() if n._nodeType is type
        
        filter.edges = (type)->
            edges = a.elements.edges.flat

            _.each edges, (e)->
                e.toggleHidden() if e._edgeType is type

        filter