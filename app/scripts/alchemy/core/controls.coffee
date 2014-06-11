alchemy.zoomControls = 
    init: ->
        if conf.zoomControls
            d3.select("#graph")
              .append("div", "#controls-container")
              .attr("id", "zoom-controls")
              .attr("class", conf.controlOrientation)
              .html("<button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus  fa-1x'></i></button>
                     <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus fa-1x'></i></button>")
        
        d3.select('#zoom-in').on("click", () -> alchemy.interactions.clickZoom 'in' )
        d3.select('#zoom-out').on("click", () -> alchemy.interactions.clickZoom 'out' )