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
            styles = @a.svgStyles.edge.populate edge
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
            a = @a

            square = (num) ->
                return num * num

            source = edge.source
            target = edge.target

            if !a.conf.curvedEdges 

                padding = a.conf.nodePadding

                sourcePadding = source.radius + padding + (source["stroke-width"] / 2)
                targetPadding = target.radius + padding + (target["stroke-width"] / 2)
                xDist = edge.source.x - edge.target.x
                yDist = edge.source.y - edge.target.y
                distance = Math.sqrt(square(xDist) + square(yDist))

                if !a.conf.directedEdges 
                    # return straight, undirected path
                    return "M #{sourcePadding} 0 L #{distance - targetPadding} 0"
                else
                    # return straight, directed path
                    headLength = a.conf.edgeWidth() * 2.4
                    return "
                    M #{sourcePadding} 0 
                    L #{distance - targetPadding - headLength} 0
                    l 0 2
                    l #{headLength/2} -2
                    l #{-headLength/2} -2
                    L #{distance - targetPadding - headLength} 0
                    "
                    
            else

                padding = a.conf.edgeWidth() * 1.7
                arrowWidth = a.conf.edgeWidth() * 0.6 
                shaftRadius = arrowWidth / 2
                headRadius = shaftRadius * 2.4
                headLength = if a.conf.directedEdges then headRadius * 2 else 0.0001

                xDist = edge.source.x - edge.target.x
                yDist = edge.source.y - edge.target.y
                edgeLength = Math.sqrt(square(xDist) + square(yDist))

                # start = { x: 0, y: 0, r: edge.source.radius }
                startX = 0
                startY = 0
                startR = edge.source.radius

                # end = { x: edgeLength, y: 0, r: edge.target.radius }
                endX = edgeLength
                endY = 0
                endR = edge.target.radius

                d = endX - startX

                radiusRatio = (startR + padding) / (endR + headLength + padding)
                homotheticCenter = -d * radiusRatio / (1 - radiusRatio)

                # arcDegree changes severity of arc
                # optimal values = [1..3].  breaks outside [~(0.1)..~(3.1)]
                arcDegree = 1.5
                angle = arcDegree * headRadius * 2 / startR 

                startAttachX = Math.cos(angle) * (startR + padding)
                startAttachY = Math.sin(angle) * (startR + padding)

                gradient = startAttachY / (startAttachX - homotheticCenter)
                hc = startAttachY - gradient * startAttachX
                p = endX

                A = 1 + square(gradient)
                B = 2 * (gradient * hc - p)
                C = square(hc) + square(p) - square(endR + headLength + padding)

                endAttachX = (-(B) - Math.sqrt(square(B) - 4 * A * C)) / (2 * A)
                endAttachY = (endAttachX - homotheticCenter) * gradient

                g1 = -startAttachX / startAttachY
                c1 = startAttachY + (square(startAttachX) / startAttachY)
                g2 = -(endAttachX - endX) / endAttachY
                c2 = endAttachY + (endAttachX - endX) * endAttachX / endAttachY

                cx = (c1 - c2) / (g2 - g1)
                cy = g1 * cx + c1

                arcRadius = Math.sqrt(square(cx - startAttachX) + square(cy - startAttachY))

                startTangent = (dr) ->
                    if dr < 0
                        num = -1
                    else 
                        num = 1
                    dx = num * Math.sqrt(square(dr) / (1 + square(g1)))
                    dy = g1 * dx
                    return "#{startAttachX + dx}, #{startAttachY + dy}"

                endTangent = (dr) ->
                    if dr < 0
                        num = -1
                    else 
                        num = 1
                    dx = num * Math.sqrt(square(dr) / (1 + square(g2)))
                    dy = g2 * dx
                    return "#{endAttachX + dx}, #{endAttachY + dy}"

                endNormal = (dc) ->
                    if dc < 0
                        num = -1
                    else 
                        num = 1
                    dx = num * Math.sqrt(square(dc) / (1 + square((1 / g2))))
                    dy = dx / g2
                    return "#{endAttachX + dx}, #{endAttachY - dy}"

                if !a.conf.directedEdges
                # return curved, undirected path
                    return "
                    M #{startTangent(-shaftRadius)}
                    A #{arcRadius - shaftRadius}, #{arcRadius - shaftRadius} 0 0 0 #{endTangent(-shaftRadius)}
                    "
                else
                # return curved, directed path
                    return "
                    M #{startTangent(-shaftRadius)}
                    L #{startTangent(shaftRadius)}
                    A #{arcRadius - shaftRadius}, #{arcRadius - shaftRadius} 0 0 0 #{endTangent(-shaftRadius)}
                    L #{endTangent(-headRadius)}
                    L #{endNormal(headLength)}
                    L #{endTangent(headRadius)}
                    L #{endTangent(shaftRadius)}
                    A #{arcRadius + shaftRadius}, #{arcRadius + shaftRadius} 0 0 1 #{startTangent(-shaftRadius)}
                    Z
                    "

        styleLink: (edges) ->
            a = @a
            conf = a.conf
            utils = a.drawing.DrawEdge

            edges.each (edge) ->
                g = d3.select(@)
                edgeData = utils.edgeData edge

                g.attr('transform', 
                    "translate(#{edge.source.x}, #{edge.source.y}) rotate(#{utils.edgeAngle(edge)})")
                g.select '.edge-line'
                 .attr 'd', do ->
                    utils.edgeWalk edge
                 .attr 'stroke-width', do ->
                    a.conf.edgeWidth
                 .style utils.edgeStyle edge



        classEdge: (edge) ->
            edge.classed 'active', true

        styleText: (edge) ->
            conf = @a.conf
            edge.select 'text'
                .each (d) ->
                    xDist = d.source.x - d.target.x
                    yDist = d.source.y - d.target.y
                    edgeLength = Math.sqrt(xDist**2 + yDist**2)
                    captionAngle: (angle) ->
                        if angle < -90 or angle > 90
                            180
                        else
                            0
                    dx = edgeLength / 2
                    dy = - d['stroke-width'] * 2
                    d3.select(@)
                      .attr 'dx', "#{dx}"
                      .attr "dy", "#{dy}"
                      .select ".textpath"
                      .text d.caption
                      .attr "xlink:xlink:href", "#path-#{d.source.id}-#{d.target.id}"
                      .style "display", (d)->
                        return "block" if conf.edgeCaptionsOnByDefault

        setInteractions: (edges) ->
            interactions = @a.interactions
            # editorEnabled = @a.get.state("interactions") is "editor"
            # if editorEnabled
            #     editorInteractions = new @a.editor.Interactions
            #     edge.select '.edge-handler'
            #         .on 'click', editorInteractions.edgeClick
            # else
            edges
                 .on 'click', interactions.edgeClick 
                 .on 'mouseover', (d)-> interactions.edgeMouseOver(d)
                 .on 'mouseout', (d)-> interactions.edgeMouseOut(d)
                
