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

    alchemy.drawing.DrawEdge =
        createLink: (edge) =>
            conf = alchemy.conf
            curved = conf.curvedEdges
            directed = conf.directedEdges
            interactions = alchemy.interactions
            utils = alchemy.drawing.EdgeUtils

            edge.append 'path'
                .attr 'class', 'edge-line'
                .attr 'id', (d) -> "path-#{d.id}"
            edge.filter (d) -> d.caption?
                .append 'text'
            edge.append 'path'
                .attr 'class', 'edge-handler'
                .style 'stroke-width', "#{conf.edgeOverlayWidth}"

        styleLink: (edge) =>
            conf = alchemy.conf
            directed = conf.directedEdges
            utils = alchemy.drawing.EdgeUtils
            edge.each (d) ->
                edgeWalk = utils.edgeWalk d
                g = d3.select(@)
                g.style utils.edgeStyle d
                
                if !conf.curvedEdges #and !directed
                    g.attr('transform', 
                       "translate(#{edgeWalk.startEdgeX}, #{edgeWalk.startEdgeY}) rotate(#{edgeWalk.edgeAngle})")

                g.select('.edge-line')
                 .attr 'd',

**This can be refactored for readability (please!)**                    
                
                if conf.curvedEdges
                        angle = utils.edgeAngle d

                        sideOfY = if Math.abs(angle) > 90 then -1 else 1
                        sideOfX = do (angle) ->
                                return 0 if angle is 0
                                return if angle < 0 then -1 else 1

                        startLine = utils.startLine(d)
                        endLine = utils.endLine(d)
                        sourceX = startLine.x
                        sourceY = startLine.y
                        targetX = endLine.x
                        targetY = endLine.y

                        dx = targetX - sourceX
                        dy = targetY - sourceY
                        
                        hyp = Math.sqrt( dx * dx + dy * dy)

                        offsetX = (dx * alchemy.conf.nodeRadius + 2) / hyp
                        offsetY = (dy * alchemy.conf.nodeRadius + 2) / hyp

                        arrowX = (-sideOfX * ( conf.edgeArrowSize )) + offsetX
                        arrowY = ( sideOfY * ( conf.edgeArrowSize )) + offsetY
                        # "M #{startLine.x},#{startLine.y} A #{hyp}, #{hyp} #{utils.captionAngle(d)} 0, 1 #{endLine.x}, #{endLine.y}")
                        "M #{sourceX-offsetX},#{sourceY-offsetY} A #{hyp}, #{hyp} #{utils.edgeAngle(d)} 0, 1 #{targetX - arrowX}, #{targetY - arrowY}"

                else
                    if conf.directedEdges
                        """
                        M #{edgeWalk.startPathX} #{edgeWalk.startPathBottomY}
                        L #{edgeWalk.arrowBendX} #{edgeWalk.arrowBendBottomY}
                        L #{edgeWalk.arrowBendX} #{edgeWalk.arrowTipBottomY}
                        L #{edgeWalk.arrowEndX} #{edgeWalk.arrowEndY} 
                        L #{edgeWalk.arrowBendX} #{edgeWalk.arrowTipTopY} 
                        L #{edgeWalk.arrowBendX} #{edgeWalk.arrowBendTopY}
                        L #{edgeWalk.startPathX} #{edgeWalk.startPathTopY}
                        Z
                        """
                    else
                        """
                        M #{edgeWalk.startPathX} #{edgeWalk.startPathBottomY}
                        L #{edgeWalk.arrowEndX} #{edgeWalk.arrowBendBottomY}
                        L #{edgeWalk.arrowEndX} #{edgeWalk.arrowBendTopY}
                        L #{edgeWalk.startPathX} #{edgeWalk.startPathTopY}
                        Z
                        """
                g.select '.edge-handler'
                        .attr('d', (d) -> g.select('.edge-line').attr('d'))

        classEdge: (edge) =>
            edge.classed 'active', true

        styleText: (edge) =>
            conf = alchemy.conf
            curved = conf.curvedEdges
            directed = conf.directedEdges
            utils = alchemy.drawing.EdgeUtils

            if curved
                edge.select 'text' 
                    .each (d) ->
                        edgeWalk = utils.edgeWalk d
                        d3.select(@).attr 'dx', (d) -> utils.middlePath(d).x
                                    .attr 'dy', (d) -> utils.middlePath(d).y + 20
                                    .attr 'transform', "rotate(#{utils.captionAngle(d)})"
                                    .text d.caption
                                    .style "display", (d)-> return "block" if conf.edgeCaptionsOnByDefault
            else
                edge.select 'text'
                    .each (d) ->
                        edgeWalk = utils.edgeWalk d
                        captionAngle = utils.captionAngle(d)
                        if captionAngle is 180
                            dx = - edgeWalk.edgeLength / 2
                        else
                            dx = edgeWalk.edgeLength / 2
                        d3.select(@).attr 'dx', "#{dx}"
                                    .attr 'dy', "#{- d['stroke-width'] * 1.1}"
                                    .attr 'transform', "rotate(#{captionAngle})"
                                    .text d.caption
                                    .style "display", (d)->
                                        return "block" if conf.edgeCaptionsOnByDefault

            # TODO: Code to start having text follow path.
            # This will eliminate the need for alot of math and extra work if we can
            # simply get the text to xlink to the path itself.  It's not currently
            # working and we need to get on with the release, but it needs to be
            # implemented.
            #
            # edge.select 'text'
            #     .each (d) ->
            #         d3.select @
            #           .text d.caption
            #           .style "display", (d)-> return "block" if conf.edgeCaptionsOnByDefault
            #           .attr "xlink:xlink:href", "#path-#{d.source.id}-#{d.target.id}"

        setInteractions: (edge) =>
            interactions = alchemy.interactions
            editorEnabled = alchemy.get.state("interactions") is "editor"
            if editorEnabled
                editorInteractions = new alchemy.editor.Interactions
                edge.select '.edge-handler'
                    .on 'click', editorInteractions.edgeClick
            else
                edge.select '.edge-handler'
                    .on 'click', interactions.edgeClick
                    .on 'mouseover', (d)-> interactions.edgeMouseOver(d)
                    .on 'mouseout', (d)-> interactions.edgeMouseOut(d)
