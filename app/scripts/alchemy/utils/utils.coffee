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
        alchemy.vis.selectAll('.node, line')
            .classed('selected highlight', false)
        
        d3.select('.alchemy svg').classed({'highlight-active':false})

        alchemy.vis.selectAll('line.edge')
            .classed('highlighted connected unconnected', false)
        alchemy.vis.selectAll('g.node,circle,text')
            .classed('selected unselected neighbor unconnected connecting', false)
        # call user-specified deselect function if specified
        if conf.deselectAll and typeof(conf.deselectAll == 'function')
            conf.deselectAll()

    # resize: ->
    #     d3.select('.alchemy svg')
    #         .attr("width", alchemy.container.width)
    #         .attr("height", alchemy.container.height)
    
    # Not currently used - Deprecate?
    # scale: (x) ->
    #     #returns minimum 10, maximum 60
    #     #scale linearly from 1 to 50 (?), then logarithmically
    #     min = 100
    #     mid_scale = 40
    #     elbow_point = 50
    #     if x > elbow_point
    #         # log
    #         Math.min(max, mid_scale + (Math.log(x) - Math.log(elbow_point)))
    #     else 
    #         # linear
    #         (mid_scale - min) * (x / elbow_point) + min

    # Not currently used - Deprecate?
    # jQuery.fn.d3Click = () ->
    #     @each((i, e) ->
    #         evt = document.createEvent("MouseEvents")
    #         evt.initMouseEvent("click", true,
    #                             true, window,
    #                             0, 0, 0, 0, 0,
    #                             false, false,
    #                             false, false,
    #                             0, null)
    #         e.dispatchEvent(evt)
    #     )
    
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
        if conf.caption and typeof conf.caption is 'string'
            if d[conf.caption]?
                d[conf.caption]
            else
                ''
        else if conf.caption and typeof conf.caption is 'function'
            caption = conf.caption(d)
            if caption == undefined or String(caption) == 'undefined'
                alchemy.log["caption"] = "At least one caption returned undefined"
                conf.caption = false
            return caption

    nodeSize: (d, i) ->
        # refactor for speed
        if conf.nodeRadius?
            if typeof conf.nodeRadius is 'function'
                if d.node_type is 'root'
                    conf.rootNodeRadius
                else                
                    conf.nodeRadius(d)
            else if typeof conf.nodeRadius is 'string'
                # this does not work
                key = conf.nodeRadius
                if d.node_type is 'root'
                    conf.rootNodeRadius
                else                  
                    d.degree
            else if typeof conf.nodeRadius is 'number'
                if d.node_type is 'root'
                    conf.rootNodeRadius
                else
                    conf.nodeRadius
        else
            20
