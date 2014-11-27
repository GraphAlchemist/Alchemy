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

    DrawEdge = (instance)->
        a: instance
        createLink: (edge) ->
            conf = @a.conf

            edge.append 'path'
                .attr 'class', 'edge-line'
                .attr 'id', (d) -> "path-#{d.id}"
            edge.filter (d) -> d.caption?
                .append 'text'
            edge.append 'path'
                .attr 'class', 'edge-handler'
                .style 'stroke-width', "#{conf.edgeOverlayWidth}"
                .style 'opacity', "0"

        styleLink: (edges) ->
            a = @a
            conf = a.conf
            utils = a.drawing.EdgeUtils

            edges.each (edge) ->
                g = d3.select(@)
                edgeData = utils.edgeData edge
                g.style utils.edgeStyle edge
                g.attr('transform', 
                    "translate(#{edge.source.x}, #{edge.source.y}) rotate(#{utils.edgeAngle(edge)})")
                g.select '.edge-line'
                 .attr 'd', do ->
                    utils.newEdgeWalk edge

                g.select '.edge-handler'
                    .attr 'd', (d) -> g.select('.edge-line').attr('d')

        classEdge: (edge) ->
            edge.classed 'active', true

        styleText: (edge) ->
            conf = @a.conf
            curved = conf.curvedEdges
            utils = @a.drawing.EdgeUtils

            edge.select 'text'
                .each (d) ->
                    edgeLength = utils.edgeData(d).edgeLength
                    dx = edgeLength / 2
                    d3.select(@).attr 'dx', "#{dx}"
                                .text d.caption
                                .attr "xlink:xlink:href", "#path-#{d.source.id}-#{d.target.id}"
                                .style "display", (d)->
                                    return "block" if conf.edgeCaptionsOnByDefault

        setInteractions: (edge) ->
            interactions = @a.interactions
            # editorEnabled = @a.get.state("interactions") is "editor"
            # if editorEnabled
            #     editorInteractions = new @a.editor.Interactions
            #     edge.select '.edge-handler'
            #         .on 'click', editorInteractions.edgeClick
            # else
            edge.select '.edge-handler'
                .on 'click', interactions.edgeClick
                .on 'mouseover', (d)-> interactions.edgeMouseOver(d)
                .on 'mouseout', (d)-> interactions.edgeMouseOut(d)
