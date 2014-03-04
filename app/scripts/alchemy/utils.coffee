#utility functions
utils.deselectAll = () ->
    # this function is also fired at the end of a drag, do nothing if this happens
    # if d3.event?.defaultPrevented then return
    # app.vis.selectAll('.node, line')
    #     .classed('selected highlight', false)
    
    # d3.select('.alchemy svg').classed({'highlight-active':false})

    # # vis.selectAll('line.edge')
    # #     .classed('highlighted connected unconnected', false)
    # # vis.selectAll('g.node,circle,text')
    # #     .classed('selected unselected neighbor unconnected connecting', false)
    # #call user-specified deselect function if specified
    # if conf.deselectAll and typeof(conf.deselectAll == 'function')
    #     conf.deselectAll()

utils.resize = ->
    container =
        'width': $(window).width()
        'height': $(window).height()
    d3.select('.alchemy svg')
        .attr("width", container.width)
        .attr("height", container.height)

utils.scale = (x) ->
    #returns minimum 10, maximum 60
    #scale linearly from 1 to 50 (?), then logarithmically
    min = 100
    mid_scale = 40
    elbow_point = 50
    if x > elbow_point
        # log
        Math.min(max, mid_scale + (Math.log(x) - Math.log(elbow_point)))
    else 
        # linear
        (mid_scale - min) * (x / elbow_point) + min

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

utils.centreView = (id) ->
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
    app.vis.transition().attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
    zoom.translate([x, y]).scale(level)

utils.nodeText = (d) -> 
    if d.caption
        d.caption
    else if conf.caption and typeof conf.caption is 'string'
        if d[conf.caption]?
            d[conf.caption]
        else
            ''
    else if conf.caption and typeof conf.caption is 'function'
        conf.caption(d)

#redraw
    # utils.redraw = () ->
    #     app.vis.selectAll("line").remove()
    #     app.vis.attr("transform",
    #              "translate(#{ d3.event.translate }) scale(#{ d3.event.scale })")

