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
        init: ->
            if @dashIsShown()
                divSelector = alchemy.conf.divSelector
                # add dashboard wrapper
                alchemy.dash = d3.select "#{divSelector}"
                                 .append "div"
                                 .attr "id", "control-dash-wrapper"
                                 .attr "class", "col-md-4 initial"

                # add the dash toggle button 
                alchemy.dash
                       .append "i"
                       .attr "id", "dash-toggle"
                       .attr "class", "fa fa-flask col-md-offset-12"

                # add the control dash
                alchemy.dash
                       .append "div"
                       .attr "id", "control-dash"
                       .attr "class", "col-md-12"

                alchemy.dash.select '#dash-toggle'
                       .on 'click', alchemy.interactions.toggleControlDash

                alchemy.controlDash.zoomCtrl()
                alchemy.controlDash.search()
                alchemy.controlDash.filters()
                alchemy.controlDash.stats()
                alchemy.controlDash.clustering()

        search: ->
            if alchemy.conf.search
                alchemy.dash
                       .select "#control-dash"
                       .append "div"
                       .attr "id", "search"
                       .html """
                            <div class='input-group'>
                                <input class='form-control' placeholder='Search'>
                                <i class='input-group-addon search-icon'><span class='fa fa-search fa-1x'></span></i>
                            </div> 
                              """
                alchemy.search.init()
        
        zoomCtrl: ->
            if alchemy.conf.zoomControls 
                alchemy.dash
                    .select "#control-dash-wrapper"
                    .append "div"
                    .attr "id", "zoom-controls"
                    .attr "class", "col-md-offset-12"
                    .html "<button id='zoom-reset'  class='btn btn-defualt btn-primary'><i class='fa fa-crosshairs fa-lg'></i></button>
                            <button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus'></i></button>
                            <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus'></i></button>"
                
                alchemy.dash
                       .select '#zoom-in'
                       .on "click", -> alchemy.interactions.clickZoom 'in'
                
                alchemy.dash
                       .select '#zoom-out'
                       .on "click", -> alchemy.interactions.clickZoom 'out'
                
                alchemy.dash
                       .select '#zoom-reset'
                       .on "click", -> alchemy.interactions.clickZoom 'reset'

        filters: ->
            if alchemy.conf.nodeFilters or alchemy.conf.edgeFilters
                alchemy.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "filters"
                alchemy.filters.init()

        stats: ->
            if alchemy.conf.nodeStats or alchemy.conf.edgeStats
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

                alchemy.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "stats"
                    .html stats_html
                    .select '#stats-header'
                    .on 'click', () ->
                        if alchemy.dash.select('#all-stats').classed "in"
                            alchemy.dash
                                   .select "#stats-header>span"
                                   .attr "class", "fa fa-2x fa-caret-right"
                        else
                            alchemy.dash
                                   .select "#stats-header>span"
                                   .attr "class", "fa fa-2x fa-caret-down"

                alchemy.stats.init()

        clustering: ->
            if alchemy.conf.clusterControl
                clusterControl_html = """
                        <div id="clustering-container">
                            <div id="cluster_control_header" data-toggle="collapse" data-target="#clustering #cluster-options">
                                 <h3>Clustering</h3>
                                <span id="cluster-arrow" class="fa fa-2x fa-caret-right"></span>
                            </div>
                        </div>
                        """
                alchemy.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "clustering"
                    .html clusterControl_html
                    .select '#cluster_control_header'

                alchemy.clusterControls.init()

        dashIsShown: ->
            conf = alchemy.conf

            conf.showEditor    || conf.captionToggle  || conf.toggleRootNodes ||
            conf.removeElement || conf.clusterControl || conf.nodeStats       ||
            conf.edgeStats     || conf.edgeFilters    || conf.nodeFilters     || 
            conf.edgesToggle   || conf.nodesToggle    || conf.search