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
            divSelector = alchemy.conf.divSelector
            # add dashboard wrapper
            d3.select("#{divSelector}")
                .append("div")
                .attr("id", "control-dash-wrapper")
                .attr("class", "col-md-4 initial")

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
            # alchemy.controlDash.modifyElements()

    search: () ->
        if alchemy.conf.search
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
        if alchemy.conf.showFilters
            d3.select("#control-dash")
                .append("div")
                .attr("id", "filters")
            alchemy.filters.init()

    stats: () ->
        if alchemy.conf.showStats
            stats_html = """
                    <div id = "stats-header" data-toggle="collapse" data-target="#stats #all-stats">
                    <h3>
                        Statistics
                    </h3>
                    <span class = "fa fa-caret-right fa-2x"></span>
                    </div>
                    <div id="all-stats" class="collapse">
                        <ul class = "list-group" id="node-stats"></ul>
                        <ul class = "list-group" id="rel-stats"></ul>  
                    </div>
                """

            d3.select("#control-dash")
                .append("div")
                .attr("id", "stats")
                .html(stats_html)
                .select('#stats-header')
                .on('click', () ->
                    if d3.select('#all-stats').classed("in")
                        d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-right")
                    else d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-down")
                )

            alchemy.stats.init()

    # modifyElements: () ->
    #     if alchemy.conf.showEditor
    #         modifyElements_html = """
    #                 <div id = "editor-header" data-toggle="collapse" data-target="#editor #element-options">
    #                      <h3>
    #                         Editor
    #                     </h3>
    #                     <span class = "fa fa-2x fa-caret-right"></span>
    #                 </div>
    #                 """
    #         d3.select("#control-dash")
    #             .append("div")
    #             .attr("id", "editor")
    #             .html(modifyElements_html)
    #             .select('#editor-header')
    #             .on('click', () ->
    #                 if d3.select('#element-options').classed("in")
    #                     d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-right")
    #                 else d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-down")
    #             )      
    #         editor = new alchemy.editor.Editor()
    #         editor.init()