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

alchemy.controlDash = 
    init: () ->
        if alchemy.conf.showControlDash is true 
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
            alchemy.controlDash.modifyElements()

    search: () ->
        d3.select("#control-dash")
                .append("div")
                .attr("id", "search")
                .html("""
                    <div class='input-group'>
                        <input class='form-control' placeholder='Search'>
                        <i class='input-group-addon search-icon'><span class='fa fa-search fa-1x'></span></i>
                    </div> 
                      """)
        alchemy.search.init()
    
    zoomCtrl: () ->
        if alchemy.conf.zoomControls 
            d3.select("#control-dash-wrapper")
                .append("div")
                .attr("id", "zoom-controls")
                .attr("class", "col-md-offset-12")
                .html("<button id='zoom-reset'  class='btn btn-defualt btn-primary'><i class='fa fa-crosshairs fa-lg'></i></button>
                        <button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus'></i></button>
                        <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus'></i></button>")
            
            d3.select('#zoom-in').on("click", () -> alchemy.interactions.clickZoom 'in' )
            d3.select('#zoom-out').on("click", () -> alchemy.interactions.clickZoom 'out' )
            d3.select('#zoom-reset').on("click", () -> alchemy.interactions.clickZoom 'reset')

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

    modifyElements: () ->
        d3.select("#control-dash")
            .append("div")
            .attr("id", "update-elements")
        alchemy.modifyElements.init()