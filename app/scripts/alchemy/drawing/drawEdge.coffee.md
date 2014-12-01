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

        triangle: (edge) ->
            width = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            hyp = Math.sqrt height * height + width * width
            [width, height, hyp]

        edgeData: (edge) ->
            [width, height, hyp] = @triangle edge

            edgeWidth = edge['stroke-width']

            curveOffset = 2

            startPathX = edge.source.radius + edge.source['stroke-width'] - (edgeWidth / 2) + curveOffset
            edgeLength = hyp - startPathX - curveOffset * 1.5

            edgeAngle: Math.atan2(height, width) / Math.PI * 180
            edgeLength: edgeLength

        edgeAngle: (edge) ->
            width  = edge.target.x - edge.source.x
            height = edge.target.y - edge.source.y
            Math.atan2(height, width) / Math.PI * 180

        edgeStyle: (d) ->
            conf = @a.conf
            edge = @a._edges[d.id][d.pos]
            styles = @a.svgStyles.edge.update edge
            nodes = @a._nodes

            # edge styles based on clustering
            if @a.conf.cluster
                clustering = @a.layout._clustering
                styles.stroke = do (d) ->
                    clusterKey = conf.clusterKey
                    source = nodes[d.source.id]._properties
                    target = nodes[d.target.id]._properties
                    if source.root or target.root
                        index = if source.root then target[clusterKey] else source[clusterKey]
                        "#{clustering.getClusterColour(index)}"
                    else if source[clusterKey] is target[clusterKey]
                        index = source[clusterKey]
                        "#{clustering.getClusterColour(index)}"
                    else if source[clusterKey] isnt target[clusterKey]
                        # use gradient between the two clusters' colours
                        id = "#{source[clusterKey]}-#{target[clusterKey]}"
                        gid = "cluster-gradient-#{id}"
                        "url(##{gid})"

            styles

        edgeWalk: (edge) ->
            alch = @a

            square = (num) ->
                return num * num

            padding = alch.conf.nodePadding

            if !alch.conf.curvedEdges and !alch.conf.directedEdges
            # return straight, undirected edges
                source = edge.source
                target = edge.target
                sourcePadding = source.radius + padding
                targetPadding = target.radius + padding
                xDist = edge.source.x - edge.target.x
                yDist = edge.source.y - edge.target.y
                distance = Math.sqrt(square(xDist) + square(yDist)) 
                return "M #{sourcePadding} 0 L #{distance - targetPadding} 0"

            # else if !alch.conf.curvedEdges

            # padding = edge.source.radius
            # arrowWidth = 2.4 # optimal = 2.4, breaks outside [~0.4..3.3]
            # shaftRadius = arrowWidth / 2
            # headRadius = shaftRadius * 2
            # headLength = headRadius * 2

            # xDist = edge.source.x - edge.target.x
            # yDist = edge.source.y - edge.target.y
            # edgeLength = Math.sqrt(square(xDist) + square(yDist))

            # # start = { x: 0, y: 0, r: edge.source.radius }
            # startX = 0
            # startY = 0
            # startR = edge.source.radius

            # # end = { x: edgeLength, y: 0, r: edge.target.radius }
            # endX = edgeLength
            # endY = 0
            # endR = edge.target.radius

            # d = endX - startX

            # radiusRatio = (startR + padding) / (endR + headLength + padding)
            # homotheticCenter = -d * radiusRatio / (1 - radiusRatio)

            # # arcDegree changes severity of arc
            # # optimal values = [1, 2, 3].  breaks outside [~(0.1)..~(3)]
            # arcDegree = 1
            # angle = arcDegree * headRadius * 2 / startR 

            # startAttachX = Math.cos(angle) * (startR + padding)
            # startAttachY = Math.sin(angle) * (startR + padding)

            # gradient = startAttachY / (startAttachX - homotheticCenter)
            # hc = startAttachY - gradient * startAttachX
            # p = endX

            # a = 1 + square(gradient)
            # b = 2 * (gradient * hc - p)
            # c = square(hc) + square(p) - square(endR + headLength + padding)

            # endAttachX = (-(b) - Math.sqrt(square(b) - 4 * a * c)) / (2 * a)
            # endAttachY = (endAttachX - homotheticCenter) * gradient

            # g1 = -startAttachX / startAttachY
            # c1 = startAttachY + (square(startAttachX) / startAttachY)
            # g2 = -(endAttachX - endX) / endAttachY
            # c2 = endAttachY + (endAttachX - endX) * endAttachX / endAttachY

            # cx = (c1 - c2) / (g2 - g1)
            # cy = g1 * cx + c1

            # arcRadius = Math.sqrt(square(cx - startAttachX) + square(cy - startAttachY))

            # startTangent = (dr) ->
            #     if dr < 0
            #         num = -1
            #     else 
            #         num = 1
            #     dx = num * Math.sqrt(square(dr) / (1 + square(g1)))
            #     dy = g1 * dx
            #     return "#{startAttachX + dx}, #{startAttachY + dy}"

            # endTangent = (dr) ->
            #     if dr < 0
            #         num = -1
            #     else 
            #         num = 1
            #     dx = num * Math.sqrt(square(dr) / (1 + square(g2)))
            #     dy = g2 * dx
            #     return "#{endAttachX + dx}, #{endAttachY + dy}"

            # endNormal = (dc) ->
            #     if dc < 0
            #         num = -1
            #     else 
            #         num = 1
            #     dx = num * Math.sqrt(square(dc) / (1 + square((1 / g2))))
            #     dy = dx / g2
            #     return "#{endAttachX + dx}, #{endAttachY - dy}"

            # else if !alch.conf.directedEdges
            # # Curved undirected
            #     return "
            #     M #{startTangent(-shaftRadius)}
            #     A #{arcRadius - shaftRadius}, #{arcRadius - shaftRadius} 0 0 0 #{endTangent(-shaftRadius)}
            #     L #{endNormal(headLength)}
            #     "
            # else
            # # compute and return curved edges
            #     return "
            #     M #{startTangent(-shaftRadius)}
            #     L #{startTangent(shaftRadius)}
            #     A #{arcRadius - shaftRadius}, #{arcRadius - shaftRadius} 0 0 0 #{endTangent(-shaftRadius)}
            #     L #{endTangent(-headRadius)}
            #     L #{endNormal(headLength)}
            #     L #{endTangent(headRadius)}
            #     L #{endTangent(shaftRadius)}
            #     A #{arcRadius + shaftRadius}, #{arcRadius + shaftRadius} 0 0 1 #{startTangent(-shaftRadius)}
            #     Z
            #     "

        styleLink: (edges) ->
            a = @a
            conf = a.conf
            utils = a.drawing.DrawEdge

            edges.each (edge) ->
                g = d3.select(@)
                edgeData = utils.edgeData edge
                g.style utils.edgeStyle edge
                g.attr('transform', 
                    "translate(#{edge.source.x}, #{edge.source.y}) rotate(#{utils.edgeAngle(edge)})")
                g.select '.edge-line'
                 .attr 'd', do ->
                    utils.edgeWalk edge

                g.select '.edge-handler'
                    .attr 'd', (d) -> g.select('.edge-line').attr('d')

        classEdge: (edge) ->
            edge.classed 'active', true

        styleText: (edge) ->
            conf = @a.conf
            curved = conf.curvedEdges
            utils = @a.drawing.DrawEdge

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
