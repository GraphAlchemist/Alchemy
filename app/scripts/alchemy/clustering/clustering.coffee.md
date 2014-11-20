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

    class Clustering
        constructor: (instance)->
            @a = instance
            nodes = @a._nodes
            conf = @a.conf
            clustering = @

            @clusterKey = conf.clusterKey
            @identifyClusters @a
        
            _charge = -500
            _linkStrength = (edge) ->
                sourceCluster = nodes[edge.source.id]._properties[@clusterKey]
                targetCluster = nodes[edge.target.id]._properties[@clusterKey]
                if sourceCluster is targetCluster
                    0.15
                else
                    0
            _friction = () ->
                0.7
            _linkDistancefn = (edge) ->
                nodes = edge.self.a._nodes
                if nodes[edge.source.id]._properties.root or nodes[edge.target.id]._properties.root
                    300
                else if nodes[edge.source.id]._properties[@clusterKey] is nodes[edge.target.id]._properties[@clusterKey]
                    10
                else
                    600
            _gravity = (k) -> 8 * k

            @layout =
                charge: _charge
                linkStrength: (edge) -> _linkStrength(edge)
                friction: () -> _friction()
                linkDistancefn: (edge) -> _linkDistancefn(edge)
                gravity: (k) -> _gravity(k)

        identifyClusters: (a)->
            nodes = a.elements.nodes.val
            clusters = _.uniq _.map(nodes, (node)-> node.getProperties()[a.conf.clusterKey])
            @clusterMap = _.zipObject clusters, [0..clusters.length]
        
        getClusterColour: (clusterValue) ->
            # Modulo reuses colors if not enough are supplied
            index = @clusterMap[clusterValue] % @a.conf.clusterColours.length
            @a.conf.clusterColours[index]

        edgeGradient: (edges) ->
            defs = @a.vis.select "#{@a.conf.divSelector} svg"
            Q = {}
            nodes = @a._nodes
            for edge in _.map(edges, (edge) -> edge._d3)
                # skip root
                continue if nodes[edge.source.id]._properties.root or nodes[edge.target.id]._properties.root
                # skip nodes from the same cluster
                continue if nodes[edge.source.id]._properties[@clusterKey] is nodes[edge.target.id]._properties[@clusterKey]
                if nodes[edge.target.id]._properties[@clusterKey] isnt nodes[edge.source.id]._properties[@clusterKey]
                    # gradient `id`
                    id = nodes[edge.source.id]._properties[@clusterKey] + "-" + nodes[edge.target.id]._properties[@clusterKey]
                    if id of Q
                        continue
                    else if id not of Q
                        startColour = @getClusterColour(nodes[edge.target.id]._properties[@clusterKey])
                        endColour = @getClusterColour(nodes[edge.source.id]._properties[@clusterKey])
                        Q[id] = {'startColour': startColour,'endColour': endColour}
            for ids of Q
                gradient_id = "cluster-gradient-" + ids
                gradient = defs.append("svg:linearGradient").attr("id", gradient_id)
                gradient.append("svg:stop").attr("offset", "0%").attr "stop-color", Q[ids]['startColour']
                gradient.append("svg:stop").attr("offset", "100%").attr "stop-color", Q[ids]['endColour']
        
    Alchemy::clusterControls =
        init: ()->
            changeClusterHTML = """
                                <input class='form-control form-inline' id='cluster-key' placeholder="Cluster Key"></input>
                                """
            @a.dash
                   .select "#clustering-container"
                   .append "div"
                   .attr "id", "cluster-key-container"
                   .attr 'class', 'property form-inline form-group'
                   .html changeClusterHTML
                   .style "display", "none"
                
            @a.dash
                   .select "#cluster_control_header"
                   .on "click", ()->
                        element = @a.dash.select "#cluster-key-container"
                        display = element.style "display"

                element.style "display", (e)-> if display is "block" then "none" else "block"

                if @a.dash.select("#cluster-key-container").style("display") is "none"
                    @a.dash
                           .select "#cluster-arrow"
                           .attr "class", "fa fa-2x fa-caret-right"
                else 
                    @a.dash
                           .select "#cluster-arrow"
                           .attr "class", "fa fa-2x fa-caret-down"
            
            @a.dash
                .select "#cluster-key"
                .on "keydown", -> 
                    if d3.event.keyIdentifier is "Enter"
                        @a.conf.cluster = true
                        @a.conf.clusterKey = this.value
                        @a.generateLayout()
