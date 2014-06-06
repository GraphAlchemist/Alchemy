if conf.zoomControls
    d3.select("#graph")
      .append("div", "#controls-container")
      .attr("id", "zoom-controls")
      .attr("class", conf.controlOrientation)
      .html("<button id='zoom-in'  class='btn btn-defualt btn-primary zoom-in'><i class='fa fa-plus  fa-1x zoom-in'></i></button>
             <button id='zoom-out' class='btn btn-default btn-primary zoom-out'><i class='fa fa-minus fa-1x zoom-out'></i></button>")