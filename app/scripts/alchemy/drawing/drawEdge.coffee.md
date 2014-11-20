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

        styleLink: (edge) ->
            a = @a
            conf = @a.conf
            utils = @a.drawing.EdgeUtils
            edge.each (d) ->
                edgeWalk = utils.edgeWalk d
                
                curviness = if conf.curvedEdges then 30 else 0
                curve = curviness / 10

                startx = d.source.radius + (d["stroke-width"] / 2)
                starty = curviness / 10
                midpoint = edgeWalk.edgeLength / 2
                endx = edgeWalk.edgeLength - (d.target.radius - (d.target["stroke-width"] / 2))
                endy =  curviness / 10

                g = d3.select(@)
                g.style utils.edgeStyle d
                g.attr('transform', 
                    "translate(#{d.source.x}, #{d.source.y}) rotate(#{edgeWalk.edgeAngle})")
                g.select '.edge-line'
                 .attr 'd', do ->
                    line = "M#{startx},#{starty}q#{midpoint},#{curviness} #{endx},#{endy}"

                    if conf.directedEdges
                        w = d["stroke-width"] * 2
                        arrow = "l#{-w},#{w + curve} l#{w},#{-w - curve} l#{-w},#{-w + curve}"

                        return line + arrow
                    line

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
                    edgeWalk = utils.edgeWalk d
                    dx = edgeWalk.edgeLength / 2
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
