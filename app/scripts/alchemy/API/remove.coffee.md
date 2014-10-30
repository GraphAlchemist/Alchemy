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

    class Alchemy::remove
        constructor: (instance)->
            @a = instance

        nodes: (nodeMap) ->
            _.each nodeMap, (n) ->
                if n._nodeType?
                    _.each n._adjacentEdges, (adjacentEdge) ->
                        [source, target, pos] = adjacentEdge.split("-")
                        _.remove n.a._nodes[target]._adjacentEdges, (targetAdjacentEdge) ->
                            [tSource, tTarget, tPos] = targetAdjacentEdge.split("-")
                            if tTarget is n.id.toString() or tSource  is n.id.toString()
                                targetAdjacentEdge
                        delete n.a._edges[source + "-" + target]
                        n.a.vis.select("#edge-" + source + "-" + target + "-" + pos).remove()
                    delete n.a._nodes[n.id]
                    n.a.vis.select("#node-" + n.id).remove()
        edges: (edgeMap) ->
            _.each edgeMap, (e) ->
                if e._edgeType?
                    _.remove e.a._nodes[e._properties.source]._adjacentEdges, (adjacentEdge) ->
                        [source, target, pos] = adjacentEdge.split("-")
                        if target is e._properties.target.toString()
                            adjacentEdge
                    _.remove e.a._nodes[e._properties.target]._adjacentEdges, (adjacentEdge) ->
                        [source, target, pos] = adjacentEdge.split("-")
                        if source is e._properties.source.toString()
                            adjacentEdge
                    delete e.a._edges[e.id]
                    e.a.vis.select("#edge-" + e.id + "-" + e._index).remove()
