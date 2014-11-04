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

    Alchemy::controlDash = (instance) ->
        a = instance

        init: () ->
            if @dashIsShown()
                divSelector = a.conf.divSelector
                # add dashboard wrapper
                a.dash = d3.select "#{divSelector}"
                                 .append "div"
                                 .attr "id", "control-dash-wrapper"
                                 .attr "class", "col-md-4 initial"

                # add the dash toggle button 
                a.dash
                       .append "i"
                       .attr "id", "dash-toggle"
                       .attr "class", "fa fa-flask col-md-offset-12"

                # add the control dash
                a.dash
                       .append "div"
                       .attr "id", "control-dash"
                       .attr "class", "col-md-12"

                a.dash.select '#dash-toggle'
                       .on 'click', a.interactions.toggleControlDash

                a.controlDash.zoomCtrl()
                a.controlDash.search()
                a.controlDash.filters()
                a.controlDash.stats()
                a.controlDash.clustering()
                a.controlDash.exports()

        search: ->
            if a.conf.search
                a.dash
                       .select "#control-dash"
                       .append "div"
                       .attr "id", "search"
                       .html """
                            <div class='input-group'>
                                <input class='form-control' placeholder='Search'>
                                <i class='input-group-addon search-icon'><span class='fa fa-search fa-1x'></span></i>
                            </div> 
                              """
                a.search.init()
 
        zoomCtrl: ->
            if a.conf.zoomControls 
                a.dash
                    .select "#control-dash-wrapper"
                    .append "div"
                    .attr "id", "zoom-controls"
                    .attr "class", "col-md-offset-12"
                    .html "<button id='zoom-reset'  class='btn btn-defualt btn-primary'><i class='fa fa-crosshairs fa-lg'></i></button>
                            <button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus'></i></button>
                            <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus'></i></button>"
                
                a.dash
                       .select '#zoom-in'
                       .on "click", -> a.interactions.clickZoom 'in'
                
                a.dash
                       .select '#zoom-out'
                       .on "click", -> a.interactions.clickZoom 'out'
                
                a.dash
                       .select '#zoom-reset'
                       .on "click", -> a.interactions.clickZoom 'reset'

        filters: ->
            if a.conf.nodeFilters or a.conf.edgeFilters
                a.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "filters"
                a.filters.init()

        stats: ->
            if a.conf.nodeStats or a.conf.edgeStats
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

                a.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "stats"
                    .html stats_html
                    .select '#stats-header'
                    .on 'click', () ->
                        if a.dash.select('#all-stats').classed "in"
                            a.dash
                                   .select "#stats-header>span"
                                   .attr "class", "fa fa-2x fa-caret-right"
                        else
                            a.dash
                                   .select "#stats-header>span"
                                   .attr "class", "fa fa-2x fa-caret-down"

                a.stats.init()

        exports: ->
            if a.conf.exportSVG
                exports_html = """
                        <div id="exports-header" data-toggle="collapse" data-target="#all-exports" style="padding:10px;">
                            <h3>
                                Exports
                            </h3>
                            <span class="fa fa-caret-right fa-2x"></span>
                        </div>
                        <div id="all-exports" class="collapse"></div>
                        """
                a.dash.select "#control-dash"
                 .append "div"
                 .attr "id", "exports"
                 .attr "style", "padding: 0.5em 1em; border-bottom: thin dashed #E89619; color: white;"
                 .html exports_html
                 .select "#exports-header"

                a.exports.init()

        clustering: ->
            if a.conf.clusterControl
                clusterControl_html = """
                        <div id="clustering-container">
                            <div id="cluster_control_header" data-toggle="collapse" data-target="#clustering #cluster-options">
                                 <h3>Clustering</h3>
                                <span id="cluster-arrow" class="fa fa-2x fa-caret-right"></span>
                            </div>
                        </div>
                        """
                a.dash
                    .select "#control-dash"
                    .append "div"
                    .attr "id", "clustering"
                    .html clusterControl_html
                    .select '#cluster_control_header'

                a.clusterControls.init()

        dashIsShown: ->
            conf = a.conf

            conf.showEditor    || conf.captionToggle  || conf.toggleRootNodes ||
            conf.removeElement || conf.clusterControl || conf.nodeStats       ||
            conf.edgeStats     || conf.edgeFilters    || conf.nodeFilters     || 
            conf.edgesToggle   || conf.nodesToggle    || conf.search          ||
            conf.exportSVG