#not currently implemented
alchemy.visControls =
    getCurrentViewParams : () ->
        #return array with current translation & scale settings
        params = $('#graph > g').attr('transform')
        if not params
            [0, 0, 1]
        else
            params = params.match(/translate\(([0-9e.-]*), ?([0-9e.-]*)\)(?: scale\(([0-9e.]*)\))?/)
            params.shift()
            # if scale has not been specified, set it to 1
            if not params[2] then params[2] = 1
            params

    #graph control actions
    zoomIn : () ->
        #google analytics event tracking -  keep?
        #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'zoom', 'in']);
        vis = alchemy.vis
        params = this.getCurrentViewParams()
        x = params[0]
        y = params[1]
        level = parseFloat(params[2]) * 1.2
        vis.attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
        zoom.translate([x, y]).scale(level)

    clickZoomIn : () ->
        vis = alchemy.vis
        x = 0
        y = 0
        level = parseFloat(1 * 1.2)
        vis.attr('tranform', "translate(#{x}, #{y}) scale(#{level})")

        d3.behavior.zoom.translate([x,y]).scale(level)


    zoomOut : () ->
         #google analytics
         #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'zoom', 'out']);
         vis = alchemy.vis
         params = this.getCurrentViewParams()
         x = params[0]
         y = params[1]
         level = parseFloat(params[2]) / 1.2
         vis.attr('transform', "translate(#{ x }, #{ y }) scale(#{level})")
         zoom.translate([x, y]).scale(level)

    zoomReset : () ->
        #google analytics old
        #if(typeof _gaq != 'undefined') _gaq.push(['_trackEvent', 'graph', 'reset', 'reset']);
        alchemy.vis
        utils.deselectAll()
        ax = ay = ar = 0
        for n in allNodes
            delete n.fixed
            if n.node_type is 'root'
                ax += n.x
                ay += n.y
        x = 0#container.width / 2
        y = 0#container.height / 2
        if ar isnt 0
            x -= ax / ar
            y -= ay / ar

        vis.attr('transform', "translate(#{ x }, #{ y }) scale(1)")
        zoom.translate([x, y]).scale(1)

$('#zoom-in').click(alchemy.visControls.clickZoomIn)
# $('#zoom-out').click(alchemy.visControls.zoomOut)
# $('#zoom-reset').click(alchemy.visControls.zoomReset)
