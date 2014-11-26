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
                .append 'textPath'
                .classed "textpath", true
            edge.append 'path'
                .attr 'class', 'edge-handler'
                .style 'stroke-width', "#{conf.edgeOverlayWidth}"
                .style 'opacity', "0"

        styleLink: (edge) ->
            a = @a
            conf = @a.conf
            utils = @a.drawing.EdgeUtils
            edge.each (d) ->

                [width, height, hyp] = utils.triangle d

                source = 
                    r : d.source.radius + d.source['stroke-width']
                    x : d.source.x
                    y : d.source.y

                target = 
                    r : d.target.radius + d.target['stroke-width']
                    x : d.target.x
                    y : d.target.y

                e = 
                    width  : d['stroke-width']
                    length : hyp - ((target.r + source.r))
                    angle  : Math.atan2(height, width) / Math.PI * 180

                curviness = if conf.curvedEdges then 30 else 0
                curve = curviness / 10
                
                startx = source.r
                starty = curve
                midpoint = e.length / 2
                endx = e.length
                endy = curve

                g = d3.select(@)
                g.style utils.edgeStyle d
                g.attr('transform', 
                    "translate(#{d.source.x}, #{d.source.y}) rotate(#{e.angle})")
                g.select '.edge-line'
                 .attr 'd', do ->
                    line = "M#{startx},#{starty}q#{midpoint},#{curve * 10} #{endx},#{endy}"

                    if conf.directedEdges
                        w = d["stroke-width"] * 2
                        arrow = "l#{-w},#{w + curve} l#{w},#{-w - curve} l#{-w},#{-w + curve}"

                        return line + arrow
                    line

                g.select '.edge-handler'
                    .attr 'd', (d) -> g.select('.edge-line').attr('d')
                    .style "stroke-width", "100px"
        classEdge: (edge) ->
            edge.classed 'active', true

        styleText: (edge) ->
            conf = @a.conf
            curved = conf.curvedEdges
            utils = @a.drawing.EdgeUtils

            edge.select 'text'
                .each (d) ->
                    edgeWalk = utils.edgeWalk d
                    captionAngle = utils.captionAngle edgeWalk.edgeLength
                    dx = edgeWalk.edgeLength / 2
                    dy = - d['stroke-width'] * 2
                    d3.select(@)
                      .attr 'dx', "#{dx}"
                      .attr "dy", "#{dy}"
                      .select ".textpath"
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
