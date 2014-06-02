if conf.zoomControls
    d3.select("#graph")
      .append("div", "#controls-container")
      .attr("id", "zoom-controls")
      .html("<button class='btn btn-defualt btn-primary'><i class='fa fa-plus fa-2x'></i></button>
             <button class='btn btn-default btn-primary'><i class='fa fa-minus fa-2x'></i></button>")