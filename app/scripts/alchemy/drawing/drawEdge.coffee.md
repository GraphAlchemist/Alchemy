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
                g.attr('transform', 
                       "translate(#{edgeWalk.startEdgeX}, #{edgeWalk.startEdgeY}) rotate(#{edgeWalk.edgeAngle})")
                 .style utils.edgeStyle d
                
                g.select('.edge-line')
                 .attr 'd',

**This can be refactored for readability (please!)**                    
                
                if conf.curvedEdges
                    angle = edgeWalk.edgeAngle

                    sideOfY = if Math.abs(angle) > 90 then -1 else 1
                    sideOfX = do (angle) ->
                        if angle != 0
                            return if angle < 0 then -1 else 1
                        0

                    #startLine = utils.startLine d
                    #endLine = utils.endLine d
                    #sourceX = edgeWalk.pathStartX
                    #sourceY = startLine.y
                    #targetX = endLine.x
                    #targetY = endLine.y

                    #dx = targetX - sourceX
                    #dy = targetY - sourceY
                    
                    #hyp = Math.sqrt dx * dx + dy * dy

                    #offsetX = (dx * alchemy.conf.nodeRadius + 2) / hyp
                    #offsetY = (dy * alchemy.conf.nodeRadius + 2) / hyp

                    #arrowX = (-sideOfX * ( conf.edgeArrowSize )) + offsetX
                    #arrowY = ( sideOfY * ( conf.edgeArrowSize )) + offsetY
                    # "M #{sourceX-offsetX},#{sourceY-offsetY} A #{hyp}, #{hyp} #{utils.edgeAngle(d)} 0, 1 #{targetX - arrowX}, #{targetY - arrowY}"

Here we need to change the offset the vertical offset of the start and end of the arc.
*(E.g. startPathTopY)*

                    """
                    M #{edgeWalk.startPathX} #{edgeWalk.startPathTopY}
                    A #{edgeWalk.edgeLength} #{edgeWalk.edgeLength} 
                      0 0 1 
                      #{edgeWalk.edgeLength} #{edgeWalk.startPathTopY}
                    """
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
                        d3.select(@).attr 'dx', edgeWalk.midLineX
                                    .attr 'dy', (d) -> edgeWalk.midLineY
                                    .attr 'transform', "rotate(#{utils.captionAngle(d)} #{utils.middlePath(d).x} #{utils.middlePath(d).y})"
                                    .text d.caption
            else
                edge.select 'text'
                    .each (d) ->
                        edgeWalk = utils.edgeWalk d
                        captionAngle = utils.captionAngle(edgeWalk.edgeAngle)
                        if captionAngle is 180
                            dx = - edgeWalk.edgeLength / 2
                        else
                            dx = edgeWalk.edgeLength / 2
                        d3.select(@).attr 'dx', "#{dx}"
                                    .attr 'dy', "#{- d['stroke-width'] * 1.1}"
                                    .attr 'transform', "rotate(#{captionAngle})"
                                    .text d.caption

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
