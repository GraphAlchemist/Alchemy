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

alchemy.utils =
    #TODO
    #not yet working
    deselectAll: () ->
        # this function is also fired at the end of a drag, do nothing if this 
        if d3.event?.defaultPrevented then return
        alchemy.vis.selectAll('.node, .edge')
            .classed('selected highlight', false)
        
        d3.select('.alchemy svg').classed({'highlight-active':false})

        if alchemy.conf.showEditor is true
            alchemy.modifyElements.nodeEditorClear()
            
        alchemy.vis.selectAll('line.edge')
            .classed('highlighted connected unconnected', false)
        alchemy.vis.selectAll('g.node,circle,text')
            .classed('selected unselected neighbor unconnected connecting', false)
        # call user-specified deselect function if specified
        if alchemy.conf.deselectAll and typeof(alchemy.conf.deselectAll == 'function')
            alchemy.conf.deselectAll()
    
    # not currently used, but can be implemented
    centreView: (id) ->
        # centre view on node with given id
        svg = $('#graph').get(0)
        node = $(id).get(0)
        svgBounds = svg.getBoundingClientRect()
        nodeBounds = node.getBoundingClientRect()
        delta = [svgBounds.width / 2 + svgBounds.left - nodeBounds.left - nodeBounds.width / 2,
                svgBounds.height / 2 + svgBounds.top - nodeBounds.top - nodeBounds.height / 2]
        params = getCurrentViewParams()
        x = parseFloat(params[0]) + delta[0]
        y = parseFloat(params[1]) + delta[1]
        level = parseFloat(params[2])
        alchemy.vis.transition().attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
        zoom.translate([x, y]).scale(level)

    nodeText: (d) -> 
        node = alchemy._nodes[d.id]
        if alchemy.conf.nodeCaption and typeof alchemy.conf.nodeCaption is 'string'
            if node.properties[alchemy.conf.nodeCaption]?
                node.properties[alchemy.conf.nodeCaption]
            else
                ''
        else if alchemy.conf.nodeCaption and typeof alchemy.conf.nodeCaption is 'function'
            caption = alchemy.conf.nodeCaption(node)
            if caption == undefined or String(caption) == 'undefined'
                alchemy.log["caption"] = "At least one caption returned undefined"
                alchemy.conf.caption = false
            return caption

    # nodeSize: (d, i) ->
    #     # refactor for speed
    #     if alchemy.conf.nodeRadius?
    #         rootKey = alchemy.conf.rootNodes

    #         if typeof alchemy.conf.nodeRadius is 'function'
    #             if d[rootKey]? and d[rootKey]
    #                 alchemy.conf.rootNodeRadius
    #             else                
    #                 alchemy.conf.nodeRadius(d)
    #         else if typeof alchemy.conf.nodeRadius is 'string'
    #             # this does not work
    #             key = alchemy.conf.nodeRadius

    #             if d[rootKey]? and d[rootKey]
    #                 alchemy.conf.rootNodeRadius
    #             else                  
    #                 d.degree
    #         else if typeof alchemy.conf.nodeRadius is 'number'
    #             if d[rootKey]? and d[rootKey]
    #                 alchemy.conf.rootNodeRadius
    #             else
    #                 alchemy.conf.nodeRadius
    #     else
    #         20
