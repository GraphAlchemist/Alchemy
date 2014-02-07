#utility functions
utils.deselectAll = () ->
    # this function is also fired at the end of a drag, do nothing if this happens
    if d3.event?.defaultPrevented then return
    vis.selectAll('.node, line')
        .classed('selected highlight', false)
    $('#graph').removeClass('highlight-active')

    # vis.selectAll('line.edge')
    #     .classed('highlighted connected unconnected', false)
    # vis.selectAll('g.node,circle,text')
    #     .classed('selected unselected neighbor unconnected connecting', false)
    #call user-specified deselect function if specified
    if conf.deselectAll and typeof(conf.deselectAll == 'function')
        conf.deselectAll()

resize = () ->
    container =
        'width': $(window).width()
        'height': $(window).height()
    d3.select('#graph')
        .attr("width", container.width)
        .attr("height", container.height)

scale = (x) ->
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

jQuery.fn.d3Click = () ->
    @each((i, e) ->
        evt = document.createEvent("MouseEvents")
        evt.initMouseEvent("click", true,
                            true, window,
                            0, 0, 0, 0, 0,
                            false, false,
                            false, false,
                            0, null)
        e.dispatchEvent(evt)
    )

centreView = (id) ->
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
    vis.transition().attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
    zoom.translate([x, y]).scale(level)