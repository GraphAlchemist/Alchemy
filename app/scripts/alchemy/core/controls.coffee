alchemy.controlDash = 
    init: () ->
        if conf.showControlDash is true 
            # add dashboard wrapper
            d3.select(".alchemy")
                .append("div")
                .attr("id", "control-dash-wrapper")
                .attr("class", "col-md-4 off-canvas")

            d3.select(".alchemy")
                .append("div")
                .attr("id", "control-dash-background")
                .attr("class", "col-md-4")

            # add the dash toggle button 
            d3.select("#control-dash-wrapper") 
                .append("i")
                .attr("id", "dash-toggle")
                .attr("class", "fa fa-flask col-md-offset-12")

            # add the control dash
            d3.select("#control-dash-wrapper") 
                .append("div")
                .attr("id", "control-dash")
                .attr("class", "col-md-12")

            d3.select('#dash-toggle').on('click', alchemy.interactions.toggleControlDash)

            alchemy.controlDash.zoomCtrl()
            alchemy.controlDash.search()
            alchemy.controlDash.filters()
            alchemy.controlDash.stats()

    search: () ->
        d3.select("#control-dash")
                .append("div")
                .attr("id", "search")
                .html("<span class='fa fa-search fa-2x'></span><input placeholder='Search'></input>")

    zoomCtrl: () ->
        if conf.zoomControls 
            d3.select("#control-dash-wrapper")
                .append("div")
                .attr("id", "zoom-controls")
                .attr("class", "col-md-offset-12")
                .html("<button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus'></i></button>
                            <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus'></i></button>")
            
            d3.select('#zoom-in').on("click", () -> alchemy.interactions.clickZoom 'in' )
            d3.select('#zoom-out').on("click", () -> alchemy.interactions.clickZoom 'out' )

    filters: () ->
        #show the appropriate filters:
        d3.select("#control-dash")
            .append("div")
            .attr("id", "filters")
        alchemy.filters.init()

    stats: () ->
        d3.select("#control-dash")
            .append("div")
            .attr("id", "stats")
        alchemy.stats.init()
