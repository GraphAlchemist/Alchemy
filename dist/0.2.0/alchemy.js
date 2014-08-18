(function() {
  "Alchemy.js is a graph drawing application for the web.\nCopyright (C) 2014  GraphAlchemist, Inc.\n\nThis program is free software: you can redistribute it and/or modify\nit under the terms of the GNU Affero General Public License as published by\nthe Free Software Foundation, either version 3 of the License, or\n(at your option) any later version.\n\nThis program is distributed in the hope that it will be useful,\nbut WITHOUT ANY WARRANTY; without even the implied warranty of\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\nGNU Affero General Public License for more details.\n\nYou should have received a copy of the GNU Affero General Public License\nalong with this program.  If not, see <http://www.gnu.org/licenses/>.\nlets";
  var Alchemy, currentRelationshipTypes,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Alchemy = (function() {
    function Alchemy() {
      this.begin = __bind(this.begin, this);
      this.setState = __bind(this.setState, this);
      this.getState = __bind(this.getState, this);
      this.version = "#VERSION#";
      this.layout = {};
      this.interactions = {};
      this.utils = {};
      this.visControls = {};
      this.styles = {};
      this.models = {};
      this.drawing = {};
      this.log = {};
      this.state = {
        "interactions": "default",
        "layout": "default",
        "filters": {
          "edges": {},
          "nodes": {}
        }
      };
    }

    Alchemy.prototype.getState = function(key) {
      if (this.state.key != null) {
        return this.state.key;
      }
    };

    Alchemy.prototype.setState = function(key, value) {
      return this.state.key = value;
    };

    Alchemy.prototype.begin = function(userConf) {
      this.conf = _.assign({}, alchemy.defaults, userConf);
      if (typeof alchemy.conf.dataSource === 'string') {
        return d3.json(alchemy.conf.dataSource, alchemy.startGraph);
      } else if (typeof alchemy.conf.dataSource === 'object') {
        return alchemy.startGraph(alchemy.conf.dataSource);
      }
    };

    return Alchemy;

  })();

  currentRelationshipTypes = {};

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = new Alchemy();
  } else {
    this.alchemy = new Alchemy();
  }

}).call(this);

(function() {
  alchemy.clustering = (function() {
    function clustering() {
      var nodes, _charge, _friction, _gravity, _linkDistancefn, _linkStrength;
      nodes = alchemy._nodes;
      _charge = -500;
      _linkStrength = function(edge) {
        if (nodes[edge.source.id].properties.cluster === nodes[edge.target.id].properties.cluster) {
          return 1;
        } else {
          return 1;
        }
      };
      _friction = function() {
        return 0.7;
      };
      _linkDistancefn = function(edge) {
        nodes = alchemy._nodes;
        if (nodes[edge.source.id].properties.root || nodes[edge.target.id].properties.root) {
          return 300;
        } else if (nodes[edge.source.id].properties.cluster === nodes[edge.target.id].properties.cluster) {
          return 10;
        } else {
          return 600;
        }
      };
      _gravity = function(k) {
        return 8 * k;
      };
      this.layout = {
        charge: _charge,
        linkStrength: function(edge) {
          return _linkStrength(edge);
        },
        friction: function() {
          return _friction();
        },
        linkDistancefn: function(edge) {
          return _linkDistancefn(edge);
        },
        gravity: function(k) {
          return _gravity(k);
        }
      };
    }

    clustering.prototype.getClusterColour = function(index) {
      if (alchemy.conf.clusterColours[index] != null) {
        return alchemy.conf.clusterColours[index];
      } else {
        return '#EBECE4';
      }
    };

    clustering.prototype.edgeGradient = function(edges) {
      var Q, defs, edge, endColour, gradient, gradient_id, id, ids, nodes, startColour, _i, _len, _ref, _results;
      defs = d3.select("" + alchemy.conf.divSelector + " svg");
      Q = {};
      nodes = alchemy._nodes;
      _ref = _.map(edges, function(edge) {
        return edge._d3;
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        edge = _ref[_i];
        if (nodes[edge.source.id].properties.root || nodes[edge.target.id].properties.root) {
          continue;
        }
        if (nodes[edge.source.id].properties.cluster === nodes[edge.target.id].properties.cluster) {
          continue;
        }
        if (nodes[edge.target.id].properties.cluster !== nodes[edge.source.id].properties.cluster) {
          id = nodes[edge.source.id].properties.cluster + "-" + nodes[edge.target.id].properties.cluster;
          if (id in Q) {
            continue;
          } else if (!(id in Q)) {
            startColour = this.getClusterColour(nodes[edge.target.id].properties.cluster);
            endColour = this.getClusterColour(nodes[edge.source.id].properties.cluster);
            Q[id] = {
              'startColour': startColour,
              'endColour': endColour
            };
          }
        }
      }
      _results = [];
      for (ids in Q) {
        gradient_id = "cluster-gradient-" + ids;
        gradient = defs.append("svg:linearGradient").attr("id", gradient_id);
        gradient.append("svg:stop").attr("offset", "0%").attr("stop-color", Q[ids]['startColour']);
        _results.push(gradient.append("svg:stop").attr("offset", "100%").attr("stop-color", Q[ids]['endColour']));
      }
      return _results;
    };

    return clustering;

  })();

}).call(this);

(function() {
  alchemy.controlDash = {
    init: function() {
      if (alchemy.conf.showControlDash === true) {
        d3.select(".alchemy").append("div").attr("id", "control-dash-wrapper").attr("class", "col-md-4 initial");
        d3.select("#control-dash-wrapper").append("i").attr("id", "dash-toggle").attr("class", "fa fa-flask col-md-offset-12");
        d3.select("#control-dash-wrapper").append("div").attr("id", "control-dash").attr("class", "col-md-12");
        d3.select('#dash-toggle').on('click', alchemy.interactions.toggleControlDash);
        alchemy.controlDash.zoomCtrl();
        alchemy.controlDash.search();
        alchemy.controlDash.filters();
        alchemy.controlDash.stats();
        return alchemy.controlDash.modifyElements();
      }
    },
    search: function() {
      if (alchemy.conf.search) {
        d3.select("#control-dash").append("div").attr("id", "search").html("<div class='input-group'>\n    <input class='form-control' placeholder='Search'>\n    <i class='input-group-addon search-icon'><span class='fa fa-search fa-1x'></span></i>\n</div> ");
        return alchemy.search.init();
      }
    },
    zoomCtrl: function() {
      if (alchemy.conf.zoomControls) {
        d3.select("#control-dash-wrapper").append("div").attr("id", "zoom-controls").attr("class", "col-md-offset-12").html("<button id='zoom-reset'  class='btn btn-defualt btn-primary'><i class='fa fa-crosshairs fa-lg'></i></button> <button id='zoom-in'  class='btn btn-defualt btn-primary'><i class='fa fa-plus'></i></button> <button id='zoom-out' class='btn btn-default btn-primary'><i class='fa fa-minus'></i></button>");
        d3.select('#zoom-in').on("click", function() {
          return alchemy.interactions.clickZoom('in');
        });
        d3.select('#zoom-out').on("click", function() {
          return alchemy.interactions.clickZoom('out');
        });
        return d3.select('#zoom-reset').on("click", function() {
          return alchemy.interactions.clickZoom('reset');
        });
      }
    },
    filters: function() {
      if (alchemy.conf.showFilters) {
        d3.select("#control-dash").append("div").attr("id", "filters");
        return alchemy.filters.init();
      }
    },
    stats: function() {
      var stats_html;
      if (alchemy.conf.showStats) {
        stats_html = "<div id = \"stats-header\" data-toggle=\"collapse\" data-target=\"#stats #all-stats\">\n<h3>\n    Statistics\n</h3>\n<span class = \"fa fa-caret-right fa-2x\"></span>\n</div>\n<div id=\"all-stats\" class=\"collapse\">\n    <ul class = \"list-group\" id=\"node-stats\"></ul>\n    <ul class = \"list-group\" id=\"rel-stats\"></ul>  \n</div>";
        d3.select("#control-dash").append("div").attr("id", "stats").html(stats_html).select('#stats-header').on('click', function() {
          if (d3.select('#all-stats').classed("in")) {
            return d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-right");
          } else {
            return d3.select("#stats-header>span").attr("class", "fa fa-2x fa-caret-down");
          }
        });
        return alchemy.stats.init();
      }
    },
    modifyElements: function() {
      var modifyElements_html;
      if (alchemy.conf.showEditor) {
        modifyElements_html = "<div id = \"editor-header\" data-toggle=\"collapse\" data-target=\"#editor #element-options\">\n     <h3>\n        Editor\n    </h3>\n    <span class = \"fa fa-2x fa-caret-right\"></span>\n</div>";
        d3.select("#control-dash").append("div").attr("id", "editor").html(modifyElements_html).select('#editor-header').on('click', function() {
          if (d3.select('#element-options').classed("in")) {
            return d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-right");
          } else {
            return d3.select("#editor-header>span").attr("class", "fa fa-2x fa-caret-down");
          }
        });
        return alchemy.modifyElements.init();
      }
    }
  };

}).call(this);

(function() {
  alchemy.filters = {
    init: function() {
      var caption, e, edgeType, edgeTypes, nodeKey, nodeType, nodeTypes, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      alchemy.filters.show();
      if (alchemy.conf.edgeFilters) {
        alchemy.filters.showEdgeFilters();
      }
      if (alchemy.conf.nodeFilters) {
        alchemy.filters.showNodeFilters();
      }
      if (alchemy.conf.nodeTypes) {
        nodeKey = Object.keys(alchemy.conf.nodeTypes);
        nodeTypes = '';
        _ref = alchemy.conf.nodeTypes[nodeKey];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          nodeType = _ref[_i];
          alchemy.state.filters.nodes["" + nodeType] = {
            "active": true
          };
          caption = nodeType.replace('_', ' ');
          nodeTypes += "<li class = 'list-group-item nodeType' role = 'menuitem' id='li-" + nodeType + "' name = " + nodeType + ">" + caption + "</li>";
        }
        $('#node-dropdown').append(nodeTypes);
      }
      if (alchemy.conf.edgeTypes) {
        _ref1 = d3.selectAll(".edge")[0];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          e = _ref1[_j];
          currentRelationshipTypes[[e].caption] = true;
        }
        edgeTypes = '';
        _ref2 = alchemy.conf.edgeTypes;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          edgeType = _ref2[_k];
          alchemy.state.filters.edges["" + edgeType] = {
            "active": true
          };
          caption = edgeType.replace('_', ' ');
          edgeTypes += "<li class = 'list-group-item edgeType' role = 'menuitem' id='li-" + edgeType + "' name = " + edgeType + ">" + caption + "</li>";
        }
        $('#rel-dropdown').append(edgeTypes);
      }
      if (alchemy.conf.captionsToggle) {
        alchemy.filters.captionsToggle();
      }
      if (alchemy.conf.edgesToggle) {
        alchemy.filters.edgesToggle();
      }
      if (alchemy.conf.nodesToggle) {
        alchemy.filters.nodesToggle();
      }
      return alchemy.filters.update();
    },
    show: function() {
      var filter_html;
      filter_html = "<div id = \"filter-header\" data-toggle=\"collapse\" data-target=\"#filters form\">\n    <h3>\n        Filters\n    </h3>\n    <span class = \"fa fa-2x fa-caret-right\"></span>\n</div>\n    <form class=\"form-inline collapse\">\n    </form>";
      d3.select('#control-dash #filters').html(filter_html);
      d3.selectAll('#filter-header').on('click', function() {
        if (d3.select('#filters>form').classed("in")) {
          return d3.select("#filter-header>span").attr("class", "fa fa-2x fa-caret-right");
        } else {
          return d3.select("#filter-header>span").attr("class", "fa fa-2x fa-caret-down");
        }
      });
      return $('#filters form').submit(false);
    },
    showEdgeFilters: function() {
      var rel_filter_html;
      rel_filter_html = "<div id=\"filter-relationships\">\n     <div id=\"filter-rel-header\" data-target = \"#rel-dropdown\" data-toggle=\"collapse\">\n         <h4>\n             Edge Types\n         </h4>\n         <span class=\"fa fa-lg fa-caret-right\"></span>\n     </div>\n     <ul id=\"rel-dropdown\" class=\"collapse list-group\" role=\"menu\">\n     </ul>\n</div>\n";
      $('#filters form').append(rel_filter_html);
      return d3.select("#filter-rel-header").on('click', function() {
        if (d3.select('#rel-dropdown').classed("in")) {
          return d3.select("#filter-rel-header>span").attr("class", "fa fa-lg fa-caret-right");
        } else {
          return d3.select("#filter-rel-header>span").attr("class", "fa fa-lg fa-caret-down");
        }
      });
    },
    showNodeFilters: function() {
      var node_filter_html;
      node_filter_html = " <div id=\"filter-nodes\">\n     <div id=\"filter-node-header\" data-target = \"#node-dropdown\" data-toggle=\"collapse\">\n         <h4>\n             Node Types\n         </h4>\n         <span class=\"fa fa-lg fa-caret-right\"></span>\n     </div>\n     <ul id=\"node-dropdown\" class=\"collapse list-group\" role=\"menu\">\n     </ul>\n</div>";
      $('#filters form').append(node_filter_html);
      return d3.select("#filter-node-header").on('click', function() {
        if (d3.select('#node-dropdown').classed("in")) {
          return d3.select("#filter-node-header>span").attr("class", "fa fa-lg fa-caret-right");
        } else {
          return d3.select("#filter-node-header>span").attr("class", "fa fa-lg fa-caret-down");
        }
      });
    },
    captionsToggle: function() {
      return d3.select("#filters form").append("li").attr({
        "id": "toggle-captions",
        "class": "list-group-item active-label toggle"
      }).html("Show Captions").on("click", function() {
        var isDisplayed;
        isDisplayed = d3.select("g text").attr("style");
        if (isDisplayed === "display: block" || null) {
          return d3.selectAll("g text").attr("style", "display: none");
        } else {
          return d3.selectAll("g text").attr("style", "display: block");
        }
      });
    },
    edgesToggle: function() {
      return d3.select("#filters form").append("li").attr({
        "id": "toggle-edges",
        "class": "list-group-item active-label toggle"
      }).html("Toggle Edges").on("click", function() {
        if (d3.selectAll(".edge.hidden")[0].length === 0) {
          return d3.selectAll(".edge").classed("hidden", true);
        } else {
          return d3.selectAll(".edge").classed("hidden", false);
        }
      });
    },
    nodesToggle: function() {
      return d3.select("#filters form").append("li").attr({
        "id": "toggle-nodes",
        "class": "list-group-item active-label toggle"
      }).html("Toggle Nodes").on("click", function() {
        var affectedNodes;
        affectedNodes = alchemy.conf.toggleRootNodes ? ".node,.edge" : ".node:not(.root),.edge";
        if (d3.selectAll(".node.hidden")[0].length === 0) {
          return d3.selectAll(affectedNodes).classed("hidden", true);
        } else {
          return d3.selectAll(affectedNodes).classed("hidden", false);
        }
      });
    },
    update: function() {
      var identifyFilter, reFilter;
      identifyFilter = function(element) {
        var filterType, isDisabled, tag;
        tag = element.attr("name");
        isDisabled = !element.classed("disabled");
        filterType = element.classed("nodeType") ? "nodes" : "edges";
        return [tag, filterType, isDisabled];
      };
      reFilter = function(tag, filterType, isDisabled, highlight) {
        var edge, edgeData, elements, node, _i, _j, _len, _len1, _ref, _ref1;
        if (typeof tag === "object") {
          return;
        }
        elements = d3.selectAll("." + tag);
        elements.classed({
          "inactive": isDisabled,
          "highlight": highlight
        });
        if (filterType === "nodes") {
          _ref = elements.data();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            node = _ref[_i];
            _ref1 = alchemy._nodes[node.id].adjacentEdges;
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              edge = _ref1[_j];
              edgeData = alchemy._edges[edge];
              if (!edgeData.allNodesActive()) {
                isDisabled = true;
              }
              d3.select("[source-target='" + edge + "']").classed({
                "inactive": isDisabled,
                "highlight": highlight
              });
            }
          }
        }
        if (filterType === "edges") {
          elements.classed({
            "inactive": function(d, i) {
              var allNodesActive;
              allNodesActive = alchemy._edges[d.id].allNodesActive();
              return isDisabled || !allNodesActive;
            }
          });
        }
        return alchemy.stats.update();
      };
      return d3.selectAll(".nodeType, .edgeType").on("mouseenter", function() {
        var element, filterType, isDisabled, tag, _ref;
        element = d3.select(this);
        _ref = identifyFilter(element), tag = _ref[0], filterType = _ref[1], isDisabled = _ref[2];
        return d3.selectAll("." + tag).classed("highlight", true);
      }).on("mouseleave", function() {
        var element, filterType, isDisabled, tag, _ref;
        element = d3.select(this);
        _ref = identifyFilter(element), tag = _ref[0], filterType = _ref[1], isDisabled = _ref[2];
        return d3.selectAll("." + tag).classed("highlight", false);
      }).on("click", function() {
        var element, filterType, highlight, isDisabled, tag, _ref;
        element = d3.select(this);
        _ref = identifyFilter(element), tag = _ref[0], filterType = _ref[1], isDisabled = _ref[2];
        highlight = false;
        element.classed({
          'disabled': isDisabled
        });
        return reFilter(tag, filterType, isDisabled, highlight);
      });
    }
  };

}).call(this);

(function() {
  alchemy.interactions = {
    edgeClick: function(d) {
      var vis;
      vis = alchemy.vis;
      vis.selectAll('.edge').classed('highlight', false);
      d3.select("[source-target='" + d.id + "']").classed('highlight', true);
      d3.event.stopPropagation();
      if (typeof (alchemy.conf.edgeClick != null) === 'function') {
        return alchemy.conf.edgeClick();
      }
    },
    nodeMouseOver: function(n) {
      var node;
      if (alchemy.conf.nodeMouseOver != null) {
        node = alchemy._nodes[n.id];
        if (typeof alchemy.conf.nodeMouseOver === 'function') {
          return alchemy.conf.nodeMouseOver(node);
        } else if (typeof alchemy.conf.nodeMouseOver === ('number' || 'string')) {
          return node.properties[alchemy.conf.nodeMouseOver];
        }
      } else {
        return null;
      }
    },
    nodeMouseOut: function(n) {
      if ((alchemy.conf.nodeMouseOut != null) && typeof alchemy.conf.nodeMouseOut === 'function') {
        return alchemy.conf.nodeMouseOut(n);
      } else {
        return null;
      }
    },
    nodeMouseUp: function(n) {},
    nodeDoubleClick: function(c) {
      var e, links, _results;
      d3.event.stopPropagation();
      if (!alchemy.conf.extraDataSource || c.expanded || alchemy.conf.unexpandable.indexOf(c.type === !-1)) {
        return;
      }
      $('<div id="loading-spi"></div>nner').show();
      console.log("loading more data for " + c.id);
      c.expanded = true;
      d3.json(alchemy.conf.extraDataSource + c.id, loadMoreNodes);
      links = findAllEdges(c);
      _results = [];
      for (e in edges) {
        _results.push(edges[e].distance *= 2);
      }
      return _results;
    },
    nodeClick: function(c) {
      var selected;
      d3.event.stopPropagation();
      if (!alchemy.vis.select("#node-" + c.id).empty()) {
        selected = alchemy.vis.select("#node-" + c.id).classed('selected');
        alchemy.vis.select("#node-" + c.id).classed('selected', !selected);
      }
      if (typeof alchemy.conf.nodeClick === 'function') {
        alchemy.conf.nodeClick(c);
      }
    },
    zoom: function(extent) {
      if (this._zoomBehavior == null) {
        this._zoomBehavior = d3.behavior.zoom();
      }
      return this._zoomBehavior.scaleExtent(extent).on("zoom", function() {
        return alchemy.vis.attr("transform", "translate(" + d3.event.translate + ") scale(" + d3.event.scale + ")");
      });
    },
    clickZoom: function(direction) {
      var scale, x, y, _ref;
      _ref = alchemy.vis.attr("transform").match(/(-*\d+\.*\d*)/g).map(function(a) {
        return parseFloat(a);
      }), x = _ref[0], y = _ref[1], scale = _ref[2];
      alchemy.vis.attr("transform", function() {
        if (direction === "in") {
          if (scale < alchemy.conf.scaleExtent[1]) {
            scale += 0.2;
          }
          return "translate(" + x + "," + y + ") scale(" + scale + ")";
        } else if (direction === "out") {
          if (scale > alchemy.conf.scaleExtent[0]) {
            scale -= 0.2;
          }
          return "translate(" + x + "," + y + ") scale(" + scale + ")";
        } else if (direction === "reset") {
          return "translate(0,0) scale(1)";
        } else {
          return console.log('error');
        }
      });
      if (this._zoomBehavior == null) {
        this._zoomBehavior = d3.behavior.zoom();
      }
      return this._zoomBehavior.scale(scale).translate([x, y]);
    },
    toggleControlDash: function() {
      var offCanvas;
      offCanvas = d3.select("#control-dash-wrapper").classed("off-canvas") || d3.select("#control-dash-wrapper").classed("initial");
      return d3.select("#control-dash-wrapper").classed({
        "off-canvas": !offCanvas,
        "initial": false,
        "on-canvas": offCanvas
      });
    },
    nodeDragStarted: function(d, i) {
      d3.event.sourceEvent.stopPropagation();
      d3.select(this).classed("dragging", true);
      return d.fixed = true;
    },
    nodeDragged: function(d, i) {
      var drawEdges, edgeIDs, id, node, selection, _i, _len, _results;
      d.x += d3.event.dx;
      d.y += d3.event.dy;
      d.px += d3.event.dx;
      d.py += d3.event.dy;
      node = d3.select(this);
      node.attr("transform", "translate(" + d.x + ", " + d.y + ")");
      edgeIDs = alchemy._nodes[node.datum().id].adjacentEdges;
      drawEdges = new alchemy.drawing.DrawEdges;
      _results = [];
      for (_i = 0, _len = edgeIDs.length; _i < _len; _i++) {
        id = edgeIDs[_i];
        selection = d3.select("g.edge[source-target='" + id + "']");
        _results.push(drawEdges.updateEdge(selection));
      }
      return _results;
    },
    nodeDragended: function(d, i) {
      d3.select(this).classed({
        "dragging": false
      });
      if (!alchemy.conf.forceLocked) {
        return alchemy.force.start();
      }
    }
  };

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.Layout = (function() {
    function Layout() {
      this.linkDistancefn = __bind(this.linkDistancefn, this);
      this.tick = __bind(this.tick, this);
      this.collide = __bind(this.collide, this);
      this.linkStrength = __bind(this.linkStrength, this);
      this.gravity = __bind(this.gravity, this);
      var conf, nodes;
      conf = alchemy.conf;
      nodes = alchemy._nodes;
      this.k = Math.sqrt(Math.log(_.size(alchemy._nodes)) / (conf.graphWidth() * conf.graphHeight()));
      this._clustering = new alchemy.clustering;
      if (conf.cluster) {
        this._charge = function() {
          return this._clustering.layout.charge;
        };
        this._linkStrength = function(edge) {
          return this._clustering.layout.linkStrength(edge);
        };
      } else {
        this._charge = function() {
          return -10 / this.k;
        };
        this._linkStrength = function(edge) {
          if (nodes[edge.source.id].properties.root || nodes[edge.target.id].properties.root) {
            return 1;
          } else {
            return 0.9;
          }
        };
      }
      if (conf.cluster) {
        this._linkDistancefn = function(edge) {
          return this._clustering.layout.linkDistancefn(edge);
        };
      } else if (conf.linkDistancefn === 'default') {
        this._linkDistancefn = function(edge) {
          return 1 / (this.k * 50);
        };
      } else if (typeof conf.linkDistancefn === 'number') {
        this._linkDistancefn = function(edge) {
          return conf.linkDistancefn;
        };
      } else if (typeof conf.linkDistancefn === 'function') {
        this._linkDistancefn = function(edge) {
          return conf.linkDistancefn(edge);
        };
      }
    }

    Layout.prototype.gravity = function() {
      if (alchemy.conf.cluster) {
        return this._clustering.layout.gravity(this.k);
      } else {
        return 50 * this.k;
      }
    };

    Layout.prototype.linkStrength = function(edge) {
      return this._linkStrength(edge);
    };

    Layout.prototype.friction = function() {
      if (alchemy.conf.cluster) {
        return 0.7;
      } else {
        return 0.9;
      }
    };

    Layout.prototype.collide = function(node) {
      var conf, nx1, nx2, ny1, ny2, r;
      node = node._d3;
      conf = alchemy.conf;
      r = 2 * (node.r + node['stroke-width']) + conf.nodeOverlap;
      nx1 = node.x - r;
      nx2 = node.x + r;
      ny1 = node.y - r;
      ny2 = node.y + r;
      return function(quad, x1, y1, x2, y2) {
        var l, x, y;
        if (quad.point && (quad.point !== node)) {
          x = node.x - Math.abs(quad.point.x);
          y = node.y - quad.point.y;
          l = Math.sqrt(x * x + y * y);
          r = r;
          if (l < r) {
            l = (l - r) / l * alchemy.conf.alpha;
            node.x -= x *= l;
            node.y -= y *= l;
            quad.point.x += x;
            quad.point.y += y;
          }
        }
        return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
      };
    };

    Layout.prototype.tick = function() {
      var node, q, _i, _len, _ref;
      if (alchemy.conf.collisionDetection) {
        q = d3.geom.quadtree(_.map(alchemy._nodes, function(node) {
          return node._d3;
        }));
        _ref = _.values(alchemy._nodes);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          q.visit(this.collide(node));
        }
      }
      alchemy.node.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });
      if (this.drawEdge == null) {
        this.drawEdge = new alchemy.drawing.DrawEdge;
      }
      this.drawEdge.styleText(alchemy.edge);
      return this.drawEdge.styleLink(alchemy.edge);
    };

    Layout.prototype.positionRootNodes = function() {
      var conf, container, n, number, rootNodes, _i, _len, _ref, _ref1, _results;
      conf = alchemy.conf;
      container = {
        width: conf.graphWidth(),
        height: conf.graphHeight()
      };
      rootNodes = _.filter(alchemy._nodes, function(d) {
        return d.properties.root;
      });
      if (rootNodes.length === 1) {
        n = rootNodes[0];
        _ref = [container.width / 2, container.width / 2], n._d3.x = _ref[0], n._d3.px = _ref[1];
        _ref1 = [container.height / 2, container.height / 2], n._d3.y = _ref1[0], n._d3.py = _ref1[1];
        n._d3.fixed = true;
      } else {
        number = 0;
        _results = [];
        for (_i = 0, _len = rootNodes.length; _i < _len; _i++) {
          n = rootNodes[_i];
          number++;
          n._d3.x = container.width / Math.sqrt(rootNodes.length * number);
          n._d3.y = container.height / 2;
          _results.push(n._d3.fixed = true);
        }
        return _results;
      }
    };

    Layout.prototype.chargeDistance = function() {
      return 500;
    };

    Layout.prototype.linkDistancefn = function(edge) {
      return this._linkDistancefn(edge);
    };

    Layout.prototype.charge = function() {
      return this._charge();
    };

    return Layout;

  })();

}).call(this);

(function() {
  alchemy.modifyElements = {
    init: function() {
      if (alchemy.conf.showEditor === true) {
        alchemy.modifyElements.showOptions();
        return alchemy.modifyElements.nodeEditorInit();
      }
    },
    showOptions: function() {
      var optionsHTML;
      optionsHTML = "<ul class=\"list-group\"> \n<li class=\"list-group-item\" id=\"remove\">Remove Selected</li> \n</ul>";
      d3.select('#editor').append("div").attr("id", "element-options").attr("class", "collapse").html(optionsHTML);
      d3.select('#element-options ul').append("li").attr("class", function() {
        if (alchemy.conf.editorInteractions === true) {
          return "active list-group-item";
        } else {
          return "inactive list-group-item";
        }
      }).attr("id", "editor-interactions").html(function() {
        if (alchemy.conf.editorInteractions === true) {
          return "Disable Editor Interactions";
        } else {
          return "Enable Editor Interactions";
        }
      });
      d3.select("#remove").on("click", function() {
        return alchemy.editor.remove();
      });
      return d3.select("#editor-interactions").on("click", function() {
        if (!d3.select("#editor-interactions").classed("active")) {
          alchemy.editor.enableEditor();
          return d3.select("#editor-interactions").classed({
            "active": true,
            "inactive": false
          }).html("Editor mode enabled, click to disable editor interactions");
        } else {
          alchemy.editor.disableEditor();
          return d3.select("#editor-interactions").classed({
            "active": false,
            "inactive": true
          }).html("Editor mode disabled, click to enable editor interactions");
        }
      });
    },
    nodeEditorInit: function() {
      var addPropHTML;
      addPropHTML = "<div id=\"add-property\">\n    <input class='form-control' id='node-add-prop-key' placeholder=\"Property Name\"></input>\n    <input class='form-control' id='node-add-prop-value' placeholder=\"Property Value\"></input>\n</div>";
      d3.select("#element-options").append("div").attr("id", "node-editor").attr("class", function() {
        if (d3.select("#editor-interactions").classed("active")) {
          return "enabled";
        } else {
          return "hidden";
        }
      }).html("<h4>Node Editor</h4>");
      d3.select("#node-editor").append("form").attr("id", "node-add-property").html(addPropHTML);
      d3.select("#node-add-property").append("input").attr("id", "node-add-prop-submit").attr("type", "submit").attr("value", "Add Property");
      return d3.select("#node-add-property").on("submit", function() {
        event.preventDefault();
        if (d3.select(".node.selected").empty()) {
          return d3.selectAll("#node-add-prop-value, #node-add-prop-key").attr("placeholder", "select a node first");
        }
      });
    },
    nodeEditor: function(n) {
      var nodeProperties, property, updateProperty, val;
      d3.select("#node-editor").append("form").attr("id", "node-properties-list");
      d3.selectAll("#node-add-prop-key").attr("placeholder", "New Property Name").attr("value", null);
      d3.selectAll("#node-add-prop-value").attr("placeholder", "New Property Value").attr("value", null);
      nodeProperties = alchemy._nodes[n.id].getProperties();
      d3.select("#node-" + n.id).classed({
        "editing": true
      });
      for (property in nodeProperties) {
        val = nodeProperties[property];
        d3.select("#node-properties-list").append("div").attr("id", "node-" + property).attr("class", "node-property form-inline form-group").append("label").attr("for", "node-" + property + "-input").attr("class", "form-control property-name").text("" + property);
        d3.select("#node-" + property).append("input").attr("id", "node-" + property + "-input").attr("class", "form-control property-value").attr("placeholder", "" + val);
      }
      d3.select("#node-properties-list").append("input").attr("id", "update-properties").attr("type", "submit").attr("value", "Update Properties");
      d3.selectAll("#node-add-prop-key, #node-add-prop-value, .node-property").on("keydown", function() {
        if (d3.event.keyCode === 13) {
          event.preventDefault();
        }
        return d3.select(this).classed({
          "edited-property": true
        });
      });
      d3.select("#node-add-property").on("submit", function() {
        var key, value;
        event.preventDefault();
        key = d3.select("#node-add-prop-key")[0][0].value;
        key = key.replace(/\s/g, "_");
        value = d3.select("#node-add-prop-value")[0][0].value;
        updateProperty(key, value, true);
        d3.selectAll("#add-property .edited-property").classed({
          "edited-property": false
        });
        return this.reset();
      });
      d3.select("#node-properties-list").on("submit", function() {
        var key, properties, value, _i, _len, _ref;
        event.preventDefault();
        properties = d3.selectAll(".edited-property");
        _ref = properties[0];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          property = _ref[_i];
          console.log(property);
          key = d3.select(property).select("label").text();
          value = d3.select(property).select("input")[0][0].value;
          updateProperty(key, value, false);
        }
        d3.selectAll("#node-properties-list .edited-property").classed({
          "edited-property": false
        });
        return this.reset();
      });
      return updateProperty = function(key, value, newProperty) {
        var drawNodes, nodeID;
        nodeID = n.id;
        if ((key !== "") && (value !== "")) {
          alchemy._nodes[nodeID].setProperty("" + key, "" + value);
          drawNodes = new alchemy.drawing.DrawNodes;
          drawNodes.updateNode(d3.select("#node-" + nodeID));
          if (newProperty === true) {
            d3.select("#node-add-prop-key").attr("placeholder", "property added/updated to key: " + key);
            return d3.select("#node-add-prop-value").attr("placeholder", "property at " + key + " updated to: " + value);
          } else {
            return d3.select("#node-" + key + "-input").attr("placeholder", "property at " + key + " updated to: " + value);
          }
        } else {
          if (newProperty === true) {
            d3.select("#node-add-prop-key").attr("placeholder", "null or invalid input");
            return d3.select("#node-add-prop-value").attr("placeholder", "null or invlid input");
          } else {
            return d3.select("#node-" + key + "-input").attr("placeholder", "null or invalid input");
          }
        }
      };
    },
    nodeEditorClear: function() {
      d3.selectAll(".node").classed({
        "editing": false
      });
      d3.select("#node-properties-list").remove();
      return d3.select("#node-add-prop-submit").attr("placeholder", function() {
        if (d3.selectAll(".node.selected").empty()) {
          return "select a node to edit properties";
        } else {
          return "add a property to this node";
        }
      });
    }
  };

  alchemy.editor = {
    enableEditor: function() {
      var dragLine;
      alchemy.setState("interactions", "editor");
      dragLine = alchemy.vis.append("line").attr("id", "dragline");
      d3.select("#node-editor").attr("class", "enabled").style("opacity", 1);
      this.drawNodes.updateNode(alchemy.node);
      return d3.selectAll(".node").classed({
        "selected": false
      });
    },
    disableEditor: function() {
      alchemy.setState("interactions", "default");
      alchemy.vis.select("#dragline").remove();
      d3.select("#node-editor").transition().duration(300).style("opacity", 0);
      d3.select("#node-editor").transition().delay(300).attr("class", "hidden");
      this.drawNodes.updateNode(alchemy.node);
      return d3.selectAll(".node").classed({
        "selected": false
      });
    },
    remove: function() {
      var edge, node, nodeID, node_data, selectedNodes, _i, _j, _len, _len1, _ref, _ref1, _results;
      selectedNodes = d3.selectAll(".selected.node");
      _ref = selectedNodes[0];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        nodeID = d3.select(node).data()[0].id;
        node_data = alchemy._nodes[nodeID];
        if (node_data != null) {
          _ref1 = node_data.adjacentEdges;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            edge = _ref1[_j];
            alchemy._edges = _.omit(alchemy._edges, "" + edge);
            alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, function(e) {
              return e._d3;
            }), function(e) {
              return e.id;
            });
            d3.select("#edge-" + edge).remove();
          }
          alchemy._nodes = _.omit(alchemy._nodes, "" + nodeID);
          alchemy.node = alchemy.node.data(_.map(alchemy._nodes, function(n) {
            return n._d3;
          }), function(n) {
            return n.id;
          });
          d3.select(node).remove();
          if (alchemy.getState("interactions") === "editor") {
            _results.push(alchemy.modifyElements.nodeEditorClear());
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    addNode: function(node) {
      var newNode;
      newNode = alchemy._nodes[node.id] = new alchemy.models.Node({
        id: "" + node.id
      });
      newNode.setProperty("caption", node.caption);
      newNode.setD3Property("x", node.x);
      newNode.setD3Property("y", node.y);
      return alchemy.node = alchemy.node.data(_.map(alchemy._nodes, function(n) {
        return n._d3;
      }), function(n) {
        return n.id;
      });
    },
    addEdge: function(edge) {
      var newEdge;
      newEdge = alchemy._edges[edge.id] = new alchemy.models.Edge(edge);
      return alchemy.edge = alchemy.edge.data(_.map(alchemy._edges, function(e) {
        return e._d3;
      }), function(e) {
        return e.id;
      });
    },
    update: function(node, edge) {
      if (!this.mouseUpNode) {
        alchemy.editor.addNode(node);
        alchemy.editor.addEdge(edge);
        this.drawEdges.createEdge(alchemy.edge);
        this.drawNodes.createNode(alchemy.node);
      } else {
        alchemy.editor.addEdge(edge);
        this.drawEdges.createEdge(alchemy.edge);
      }
      return alchemy.layout.tick();
    }
  };

  alchemy.editor.interactions = function() {
    this.mouseUpNode = null;
    this.sourceNode = null;
    this.targetNode = null;
    this.newEdge = null;
    this.click = null;
    this.drawNodes = new alchemy.drawing.DrawNodes;
    this.drawEdges = new alchemy.drawing.DrawEdges;
    this.nodeMouseOver = function(n) {
      var radius;
      if (!d3.select(this).select("circle").empty()) {
        radius = d3.select(this).select("circle").attr("r");
        d3.select(this).select("circle").attr("r", radius * 3);
      }
      return this;
    };
    this.nodeMouseUp = (function(_this) {
      return function(n) {
        if (_this.sourceNode !== n) {
          _this.mouseUpNode = true;
          _this.targetNode = n;
          _this.click = false;
        } else {
          _this.click = true;
        }
        return _this;
      };
    })(this);
    this.nodeMouseOut = function(n) {
      var radius;
      if (!d3.select(this).select("circle").empty()) {
        radius = d3.select(this).select("circle").attr("r");
        d3.select(this).select("circle").attr("r", radius / 3);
      }
      return this;
    };
    this.nodeClick = (function(_this) {
      return function(c) {
        var selected;
        d3.event.stopPropagation();
        if (!alchemy.vis.select("#node-" + c.id).empty()) {
          selected = alchemy.vis.select("#node-" + c.id).classed('selected');
          alchemy.vis.select("#node-" + c.id).classed('selected', !selected);
        }
        alchemy.modifyElements.nodeEditorClear();
        alchemy.modifyElements.nodeEditor(c);
        return _this;
      };
    })(this);
    this.addNodeStart = (function(_this) {
      return function(d, i) {
        d3.event.sourceEvent.stopPropagation();
        _this.sourceNode = d;
        d3.select('#dragline').classed({
          "hidden": false
        });
        return _this;
      };
    })(this);
    this.addNodeDragging = (function(_this) {
      return function(d, i) {
        var x2coord, y2coord;
        x2coord = d3.event.x;
        y2coord = d3.event.y;
        d3.select('#dragline').attr("x1", _this.sourceNode.x).attr("y1", _this.sourceNode.y).attr("x2", x2coord).attr("y2", y2coord).attr("style", "stroke: #FFF");
        return _this;
      };
    })(this);
    this.addNodeDragended = (function(_this) {
      return function(d, i) {
        var dragline, targetX, targetY;
        if (!_this.click) {
          if (!_this.mouseUpNode) {
            dragline = d3.select("#dragline");
            targetX = dragline.attr("x2");
            targetY = dragline.attr("y2");
            _this.targetNode = {
              id: "" + (_.uniqueId('addedNode_')),
              x: parseFloat(targetX),
              y: parseFloat(targetY),
              caption: "node added"
            };
          }
          _this.newEdge = {
            id: "" + _this.sourceNode.id + "-" + _this.targetNode.id,
            source: _this.sourceNode.id,
            target: _this.targetNode.id,
            caption: "edited"
          };
          alchemy.editor.update(_this.targetNode, _this.newEdge);
        }
        alchemy.editor.interactions().reset();
        return _this;
      };
    })(this);
    this.deleteSelected = (function(_this) {
      return function(d) {
        switch (d3.event.keyCode) {
          case 8:
          case 46:
            if (!(d3.select(d3.event.target).node().tagName === ("INPUT" || "TEXTAREA"))) {
              d3.event.preventDefault();
              return alchemy.editor.remove();
            }
        }
      };
    })(this);
    this.reset = (function(_this) {
      return function() {
        _this.mouseUpNode = null;
        _this.sourceNode = null;
        _this.targetNode = null;
        _this.newEdge = null;
        _this.click = null;
        d3.select("#dragline").classed({
          "hidden": true
        }).attr("x1", 0).attr("y1", 0).attr("x2", 0).attr("y2", 0);
        return _this;
      };
    })(this);
    return this;
  };

}).call(this);

(function() {
  alchemy.search = {
    init: function() {
      var searchBox;
      searchBox = d3.select("#search input");
      return searchBox.on("keyup", function() {
        var input;
        input = searchBox[0][0].value.toLowerCase();
        d3.selectAll(".node").classed("inactive", false);
        d3.selectAll("text").attr("style", function() {
          if (input !== "") {
            return "display: inline;";
          }
        });
        return d3.selectAll(".node").classed("inactive", function(node) {
          var DOMnode, hidden;
          DOMnode = d3.select(this);
          if (alchemy.conf.searchMethod === "contains") {
            hidden = DOMnode.text().toLowerCase().indexOf(input) < 0;
          }
          if (alchemy.conf.searchMethod === "begins") {
            hidden = DOMnode.text().toLowerCase().indexOf(input) !== 0;
          }
          if (hidden) {
            d3.selectAll("[source-target*='" + node.id + "']").classed("inactive", hidden);
          } else {
            d3.selectAll("[source-target*='" + node.id + "']").classed("inactive", function(edge) {
              var nodeIDs, sourceHidden, targetHidden;
              nodeIDs = [edge.source.id, edge.target.id];
              sourceHidden = d3.select("#node-" + nodeIDs[0]).classed("inactive");
              targetHidden = d3.select("#node-" + nodeIDs[1]).classed("inactive");
              return targetHidden || sourceHidden;
            });
          }
          return hidden;
        });
      });
    }
  };

}).call(this);

(function() {
  alchemy.startGraph = function(data) {
    var arrowSize, conf, defs, marker;
    conf = alchemy.conf;
    if (d3.select(conf.divSelector).empty()) {
      console.warn(alchemy.utils.warnings.divWarning());
    }
    if (!data) {
      alchemy.utils.warnings.dataWarning();
    }
    alchemy._nodes = {};
    alchemy._edges = {};
    data.nodes.forEach(function(n) {
      return alchemy._nodes[n.id] = new alchemy.models.Node(n);
    });
    data.edges.forEach(function(e) {
      var edge;
      edge = new alchemy.models.Edge(e);
      return alchemy._edges[edge.id] = edge;
    });
    alchemy.vis = d3.select(conf.divSelector).attr("style", "width:" + (conf.graphWidth()) + "px; height:" + (conf.graphHeight()) + "px").append("svg").attr("xmlns", "http://www.w3.org/2000/svg").attr("pointer-events", "all").on("dblclick.zoom", null).on('click', alchemy.utils.deselectAll).call(alchemy.interactions.zoom(conf.scaleExtent)).append('g').attr("transform", "translate(" + conf.initialTranslate + ") scale(" + conf.initialScale + ")");
    d3.select("body").on('keydown', alchemy.editor.interactions().deleteSelected);
    alchemy.layout = new alchemy.Layout;
    alchemy.force = d3.layout.force().size([conf.graphWidth(), conf.graphHeight()]).nodes(_.map(alchemy._nodes, function(node) {
      return node._d3;
    })).links(_.map(alchemy._edges, function(edge) {
      return edge._d3;
    }));
    alchemy.force.charge(alchemy.layout.charge()).linkDistance(function(link) {
      return alchemy.layout.linkDistancefn(link);
    }).theta(1.0).gravity(alchemy.layout.gravity()).linkStrength(function(link) {
      return alchemy.layout.linkStrength(link);
    }).friction(alchemy.layout.friction()).chargeDistance(alchemy.layout.chargeDistance()).on("tick", alchemy.layout.tick);
    alchemy.updateGraph();
    alchemy.controlDash.init();
    if (!conf.forceLocked) {
      alchemy.force.on("tick", alchemy.layout.tick).start();
    }
    if (conf.afterLoad != null) {
      if (typeof conf.afterLoad === 'function') {
        conf.afterLoad();
      } else if (typeof conf.afterLoad === 'string') {
        alchemy[conf.afterLoad] = true;
      }
    }
    if (conf.initialScale !== alchemy.defaults.initialScale) {
      alchemy.interactions.zoom().scale(conf.initialScale);
      return;
    }
    if (conf.initialTranslate !== alchemy.defaults.initialTranslate) {
      alchemy.interactions.zoom().translate(conf.initialTranslate);
      return;
    }
    if (conf.cluster || conf.directedEdges) {
      defs = d3.select("" + alchemy.conf.divSelector + " svg").append("svg:defs");
    }
    if (conf.directedEdges) {
      arrowSize = conf.edgeArrowSize;
      marker = defs.append("svg:marker").attr("id", "arrow").attr("viewBox", "0 -" + (arrowSize * 0.4) + " " + arrowSize + " " + arrowSize).attr('markerUnits', 'userSpaceOnUse').attr("markerWidth", arrowSize).attr("markerHeight", arrowSize).attr("orient", "auto");
      marker.append("svg:path").attr("d", "M " + arrowSize + ",0 L 0," + (arrowSize * 0.4) + " L 0,-" + (arrowSize * 0.4));
      if (conf.curvedEdges) {
        return marker.attr("refX", arrowSize + 1);
      } else {
        return marker.attr('refX', 1);
      }
    }
  };

}).call(this);

(function() {
  alchemy.stats = {
    init: function() {
      return alchemy.stats.update();
    },
    nodeStats: function() {
      var activeNodes, caption, inactiveNodes, nodeGraph, nodeKey, nodeNum, nodeStats, nodeType, nodeTypes, _i, _len, _ref;
      nodeStats = '';
      nodeNum = d3.selectAll(".node")[0].length;
      activeNodes = d3.selectAll(".node.active")[0].length;
      inactiveNodes = d3.selectAll(".node.inactive")[0].length;
      nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of nodes: <span class='badge'>" + nodeNum + "</span></li>";
      nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of active nodes: <span class='badge'>" + activeNodes + "</span></li>";
      nodeStats += "<li class = 'list-group-item gen_node_stat'>Number of inactive nodes: <span class='badge'>" + inactiveNodes + "</span></li>";
      if (alchemy.conf.nodeTypes) {
        nodeKey = Object.keys(alchemy.conf.nodeTypes);
        nodeTypes = '';
        _ref = alchemy.conf.nodeTypes[nodeKey];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          nodeType = _ref[_i];
          caption = nodeType.replace('_', ' ');
          nodeNum = d3.selectAll("g.node." + nodeType)[0].length;
          nodeTypes += "<li class = 'list-group-item nodeType' id='li-" + nodeType + "' name = " + caption + ">Number of nodes of type " + caption + ": <span class='badge'>" + nodeNum + "</span></li>";
        }
        nodeStats += nodeTypes;
      }
      nodeGraph = "<li id='node-stats-graph' class='list-group-item'></li>";
      nodeStats += nodeGraph;
      return $('#node-stats').html(nodeStats);
    },
    edgeStats: function() {
      var activeEdges, caption, e, edgeData, edgeGraph, edgeNum, edgeType, inactiveEdges, _i, _j, _len, _len1, _ref, _ref1;
      edgeData = null;
      edgeNum = d3.selectAll(".edge")[0].length;
      activeEdges = d3.selectAll(".edge.active")[0].length;
      inactiveEdges = d3.selectAll(".edge.inactive")[0].length;
      edgeGraph = "<li class = 'list-group-item gen_edge_stat'>Number of relationships: <span class='badge'>" + edgeNum + "</span></li> <li class = 'list-group-item gen_edge_stat'>Number of active relationships: <span class='badge'>" + activeEdges + "</span></li> <li class = 'list-group-item gen_edge_stat'>Number of inactive relationships: <span class='badge'>" + inactiveEdges + "</span></li> <li id='edge-stats-graph' class='list-group-item'></li>";
      if (alchemy.conf.edgeTypes) {
        edgeData = [];
        _ref = d3.selectAll(".edge")[0];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          e = _ref[_i];
          currentRelationshipTypes[[e].caption] = true;
        }
        _ref1 = alchemy.conf.edgeTypes;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          edgeType = _ref1[_j];
          if (!edgeType) {
            continue;
          }
          caption = edgeType.replace('_', ' ');
          edgeNum = d3.selectAll(".edge." + edgeType)[0].length;
          edgeData.push(["" + caption, edgeNum]);
        }
      }
      $('#rel-stats').html(edgeGraph);
      alchemy.stats.insertSVG("edge", edgeData);
      return edgeData;
    },
    nodeStats: function() {
      var activeNodes, inactiveNodes, nodeData, nodeGraph, nodeKey, nodeNum, nodeType, totalNodes, _i, _len, _ref;
      nodeData = null;
      totalNodes = d3.selectAll(".node")[0].length;
      activeNodes = d3.selectAll(".node.active")[0].length;
      inactiveNodes = d3.selectAll(".node.inactive")[0].length;
      if (alchemy.conf.nodeTypes) {
        nodeData = [];
        nodeKey = Object.keys(alchemy.conf.nodeTypes);
        _ref = alchemy.conf.nodeTypes[nodeKey];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          nodeType = _ref[_i];
          nodeNum = d3.selectAll("g.node." + nodeType)[0].length;
          nodeData.push(["" + nodeType, nodeNum]);
        }
      }
      nodeGraph = "<li class = 'list-group-item gen_node_stat'>Number of nodes: <span class='badge'>" + totalNodes + "</span></li> <li class = 'list-group-item gen_node_stat'>Number of active nodes: <span class='badge'>" + activeNodes + "</span></li> <li class = 'list-group-item gen_node_stat'>Number of inactive nodes: <span class='badge'>" + inactiveNodes + "</span></li> <li id='node-stats-graph' class='list-group-item'></li>";
      $('#node-stats').html(nodeGraph);
      alchemy.stats.insertSVG("node", nodeData);
      return nodeData;
    },
    insertSVG: function(element, data) {
      var arc, arcs, color, height, pie, radius, svg, width;
      if (data === null) {
        return d3.select("#" + element + "-stats-graph").html("<br><h4 class='no-data'>There are no " + element + "Types listed in your conf.</h4>");
      } else {
        width = alchemy.conf.graphWidth() * .25;
        height = 250;
        radius = width / 4;
        color = d3.scale.category20();
        arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius / 2);
        pie = d3.layout.pie().sort(null).value(function(d) {
          return d[1];
        });
        svg = d3.select("#" + element + "-stats-graph").append("svg").append("g").style({
          "width": width,
          "height": height
        }).attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
        arcs = svg.selectAll(".arc").data(pie(data)).enter().append("g").classed("arc", true).on("mouseover", function(d, i) {
          return d3.select("#" + data[i][0] + "-stat").classed("hidden", false);
        }).on("mouseout", function(d, i) {
          return d3.select("#" + data[i][0] + "-stat").classed("hidden", true);
        });
        arcs.append("path").attr("d", arc).attr("stroke", function(d, i) {
          return color(i);
        }).attr("stroke-width", 2).attr("fill-opacity", "0.3");
        return arcs.append("text").attr("transform", function(d) {
          return "translate(" + arc.centroid(d) + ")";
        }).attr("id", function(d, i) {
          return "" + data[i][0] + "-stat";
        }).attr("dy", ".35em").classed("hidden", true).text(function(d, i) {
          return data[i][0];
        });
      }
    },
    update: function() {
      if (alchemy.conf.nodeStats === true) {
        alchemy.stats.nodeStats();
      }
      if (alchemy.conf.edgeStats === true) {
        return alchemy.stats.edgeStats();
      }
    }
  };

}).call(this);

(function() {
  alchemy.updateGraph = function(start) {
    var clustering, drawEdges, drawNodes, initialComputationDone;
    if (start == null) {
      start = true;
    }
    alchemy.edge = alchemy.vis.selectAll("g.edge").data(_.map(alchemy._edges, function(e) {
      return e._d3;
    }), function(e) {
      return e.id;
    });
    alchemy.node = alchemy.vis.selectAll("g.node").data(_.map(alchemy._nodes, function(n) {
      return n._d3;
    }), function(n) {
      return n.id;
    });
    if (start) {
      alchemy.layout.positionRootNodes();
      this.force.start();
      while (this.force.alpha() > 0.005) {
        alchemy.force.tick();
      }
      initialComputationDone = true;
      console.log(Date() + ' completed initial computation');
    }
    if (alchemy.conf.cluster) {
      clustering = new alchemy.clustering;
      clustering.edgeGradient(alchemy._edges);
    }
    drawEdges = new alchemy.drawing.DrawEdges;
    drawEdges.createEdge(alchemy.edge);
    drawNodes = new alchemy.drawing.DrawNodes;
    drawNodes.createNode(alchemy.node);
    alchemy.vis.selectAll('g.node').attr('transform', function(id, i) {
      return "translate(" + id.x + ", " + id.y + ")";
    });
    alchemy.vis.selectAll('.node text').html((function(_this) {
      return function(d) {
        return _this.utils.nodeText(d);
      };
    })(this));
    return alchemy.node.exit().remove();
  };

}).call(this);

(function() {
  alchemy.defaults = {
    graphWidth: function() {
      return d3.select(this.divSelector).node().parentElement.clientWidth;
    },
    graphHeight: function() {
      if (d3.select(this.divSelector).node().parentElement.nodeName === "BODY") {
        return window.innerHeight;
      } else {
        return d3.select(this.divSelector).node().parentElement.clientHeight;
      }
    },
    alpha: 0.5,
    cluster: false,
    clusterColours: d3.shuffle(["#DD79FF", "#FFFC00", "#00FF30", "#5168FF", "#00C0FF", "#FF004B", "#00CDCD", "#f83f00", "#f800df", "#ff8d8f", "#ffcd00", "#184fff", "#ff7e00"]),
    collisionDetection: true,
    nodeOverlap: 25,
    fixNodes: false,
    fixRootNodes: false,
    forceLocked: true,
    linkDistancefn: 'default',
    nodePositions: null,
    showEditor: false,
    captionToggle: false,
    toggleRootNodes: false,
    removeElement: false,
    showControlDash: false,
    showStats: false,
    nodeStats: false,
    edgeStats: false,
    showFilters: false,
    edgeFilters: false,
    nodeFilters: false,
    edgesToggle: false,
    nodesToggle: false,
    zoomControls: false,
    nodeCaption: 'caption',
    nodeStyle: {},
    nodeColour: null,
    nodeMouseOver: 'caption',
    nodeRadius: 10,
    nodeTypes: null,
    rootNodes: 'root',
    rootNodeRadius: 15,
    edgeCaption: 'caption',
    edgeClick: 'default',
    edgeStyle: function(d) {
      return null;
    },
    edgeTypes: null,
    curvedEdges: false,
    edgeWidth: 4,
    edgeOverlayWidth: 20,
    directedEdges: false,
    edgeArrowSize: 5,
    search: true,
    searchMethod: "contains",
    afterLoad: 'afterLoad',
    divSelector: '#alchemy',
    dataSource: null,
    initialScale: 1,
    initialTranslate: [0, 0],
    scaleExtent: [0.5, 2.4],
    dataWarning: "default",
    warningMessage: "There be no data!  What's going on?"
  };

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.drawing.DrawEdge = (function() {
    function DrawEdge() {
      this.styleText = __bind(this.styleText, this);
      this.classEdge = __bind(this.classEdge, this);
      this.styleLink = __bind(this.styleLink, this);
      this.createLink = __bind(this.createLink, this);
      var conf;
      conf = alchemy.conf;
      this.curved = conf.curvedEdges;
      this.directed = conf.directedEdges;
      this.utils = new alchemy.drawing.EdgeUtils;
    }

    DrawEdge.prototype.createLink = function(edge) {
      var conf, interactions, utils;
      utils = this.utils;
      conf = alchemy.conf;
      interactions = alchemy.interactions;
      if (this.curved) {
        edge.append('path').attr('class', 'edge-line').attr('id', function(d) {
          return "path-" + d.id;
        });
        edge.filter(function(d) {
          return d.caption != null;
        }).append('text');
        return edge.append('path').attr('class', 'edge-handler').style('stroke-width', "" + conf.edgeOverlayWidth).on('click', alchemy.interactions.edgeClick);
      } else {
        edge.append('line').attr('class', 'edge-line').attr('shape-rendering', 'optimizeSpeed').style('stroke', function(d) {
          return utils.edgeStyle(d);
        }).style('stroke-width', conf.edgeWidth);
        edge.filter(function(d) {
          return d.caption != null;
        }).append('text');
        return edge.append('rect').attr('class', 'edge-handler').on('click', alchemy.interactions.edgeClick);
      }
    };

    DrawEdge.prototype.styleLink = function(edge) {
      var conf, utils;
      utils = this.utils;
      conf = alchemy.conf;
      if (this.curved) {
        edge.selectAll('path').attr('d', function(d) {
          var dx, dy, endLine, hyp, sourceX, sourceY, startLine, targetX, targetY;
          startLine = utils.startLine(d);
          endLine = utils.endLine(d);
          sourceX = startLine.x;
          sourceY = startLine.y;
          targetX = endLine.x;
          targetY = endLine.y;
          dx = targetX - sourceX;
          dy = targetY - sourceY;
          hyp = Math.sqrt(dx * dx + dy * dy);
          return "M " + sourceX + "," + sourceY + " A " + hyp + ", " + hyp + " " + (utils.captionAngle(d)) + " 0, 1 " + targetX + ", " + targetY;
        });
        edge.select('path.edge-line').style('stroke', function(d) {
          return utils.edgeStyle(d);
        });
      } else {
        edge.select('.edge-line').each(function(d) {
          var endLine, startLine;
          startLine = utils.startLine(d);
          endLine = utils.endLine(d);
          return d3.select(this).attr({
            'x1': startLine.x,
            'y1': startLine.y,
            'x2': endLine.x,
            'y2': endLine.y
          });
        });
        edge.select('.edge-handler').attr('x', 0).attr('y', -conf.edgeOverlayWidth / 2).attr('height', conf.edgeOverlayWidth).attr('width', function(d) {
          return utils.edgeLength(d);
        }).attr('transform', function(d) {
          return "translate(" + d.source.x + ", " + d.source.y + ") rotate(" + (utils.edgeAngle(d)) + ")";
        });
      }
      if (this.directed) {
        return edge.select('.edge-line').attr('marker-end', 'url(#arrow)');
      }
    };

    DrawEdge.prototype.classEdge = function(edge) {
      return edge.classed('active', true);
    };

    DrawEdge.prototype.styleText = function(edge) {
      var utils;
      utils = this.utils;
      if (this.curved) {
        return edge.select('text').attr('dx', function(d) {
          return utils.middlePath(d).x;
        }).attr('dy', function(d) {
          return utils.middlePath(d).y + 20;
        }).attr('transform', function(d) {
          return "rotate(" + (utils.captionAngle(d)) + " " + (utils.middlePath(d).x) + " " + (utils.middlePath(d).y) + ")";
        }).text(function(d) {
          return d.caption;
        });
      } else {
        return edge.select('text').attr('dx', function(d) {
          return utils.middleLine(d).x;
        }).attr('dy', function(d) {
          return utils.middleLine(d).y - 5;
        }).attr('transform', function(d) {
          return "rotate(" + (utils.captionAngle(d)) + " " + (utils.middleLine(d).x) + " " + (utils.middleLine(d).y) + ")";
        }).text(function(d) {
          return d.caption;
        });
      }
    };

    return DrawEdge;

  })();

}).call(this);

(function() {
  alchemy.drawing.DrawEdges = (function() {
    function DrawEdges() {
      this.drawEdge = new alchemy.drawing.DrawEdge;
    }

    DrawEdges.prototype.createEdge = function(edge) {
      edge.enter().append('g').attr("id", function(d) {
        return "edge-" + d.id;
      }).attr('class', function(d) {
        var edgeType;
        edgeType = alchemy._edges[d.id].properties.caption;
        return "edge " + edgeType;
      }).attr('source-target', function(d) {
        return "" + d.source.id + "-" + d.target.id;
      });
      this.drawEdge.createLink(edge);
      this.drawEdge.classEdge(edge);
      this.drawEdge.styleLink(edge);
      this.drawEdge.styleText(edge);
      return edge.exit().remove();
    };

    DrawEdges.prototype.updateEdge = function(edge) {
      this.drawEdge.classEdge(edge);
      this.drawEdge.styleLink(edge);
      return this.drawEdge.styleText(edge);
    };

    return DrawEdges;

  })();

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.drawing.DrawNode = (function() {
    function DrawNode() {
      this.styleNode = __bind(this.styleNode, this);
      this.setInteractions = __bind(this.setInteractions, this);
      this.createNode = __bind(this.createNode, this);
      this.styleText = __bind(this.styleText, this);
      var conf, interactions, nodes, utils;
      utils = new alchemy.drawing.NodeUtils;
      interactions = alchemy.interactions;
      conf = alchemy.conf;
      nodes = alchemy._nodes;
      interactions = alchemy.interactions;
      this._styleText = function(node) {
        return node.selectAll("text").attr('dy', function(d) {
          if (nodes[d.id].properties.root) {
            return conf.rootNodeRadius / 2;
          } else {
            return conf.nodeRadius * 2 - 5;
          }
        }).html(function(d) {
          return alchemy.utils.nodeText(d);
        });
      };
      this._createNode = function(node) {
        node.append('circle').attr('id', function(d) {
          return "circle-" + d.id;
        });
        return node.append('svg:text').attr('id', function(d) {
          return "text-" + d.id;
        });
      };
      this._styleNode = function(node) {
        return node.select('circle').attr('r', function(d) {
          return d.r;
        }).attr('shape-rendering', 'optimizeSpeed').attr('style', function(d) {
          return utils.nodeStyle(d);
        });
      };
      this._setInteractions = function(node) {
        var drag, editor, editorEnabled, nonRootNodes, rootNodes;
        editorEnabled = alchemy.getState("interactions") === "editor";
        editor = alchemy.editor.interactions();
        interactions = alchemy.interactions;
        drag = d3.behavior.drag().origin(Object).on("dragstart", null).on("drag", null).on("dragend", null);
        if (editorEnabled) {
          node.on('mouseup', editor.nodeMouseUp).on('mouseover', editor.nodeMouseOver).on('mouseout', editor.nodeMouseOut).on('dblclick', interactions.nodeDoubleClick).on('click', editor.nodeClick);
          drag = d3.behavior.drag().origin(Object).on("dragstart", editor.addNodeStart).on("drag", editor.addNodeDragging).on("dragend", editor.addNodeDragended);
          return node.call(drag);
        } else {
          node.on('mouseup', null).on('mouseover', interactions.nodeMouseOver).on('mouseout', interactions.nodeMouseOut).on('dblclick', interactions.nodeDoubleClick).on('click', interactions.nodeClick);
          drag = d3.behavior.drag().origin(Object).on("dragstart", interactions.nodeDragStarted).on("drag", interactions.nodeDragged).on("dragend", interactions.nodeDragended);
          if (!conf.fixNodes) {
            nonRootNodes = node.filter(function(d) {
              return d.root !== true;
            });
            nonRootNodes.call(drag);
          }
          if (!conf.fixRootNodes) {
            rootNodes = node.filter(function(d) {
              return d.root === true;
            });
            return rootNodes.call(drag);
          }
        }
      };
    }

    DrawNode.prototype.styleText = function(node) {
      return this._styleText(node);
    };

    DrawNode.prototype.createNode = function(node) {
      return this._createNode(node);
    };

    DrawNode.prototype.setInteractions = function(node) {
      return this._setInteractions(node);
    };

    DrawNode.prototype.styleNode = function(node) {
      return this._styleNode(node);
    };

    return DrawNode;

  })();

}).call(this);

(function() {
  alchemy.drawing.DrawNodes = (function() {
    function DrawNodes() {
      this.drawNode = new alchemy.drawing.DrawNode;
    }

    DrawNodes.prototype.createNode = function(node) {
      node.enter().append("g").attr("class", function(d) {
        var node_data;
        node_data = alchemy._nodes[d.id].getProperties();
        if (d.nodeType != null) {
          return "node " + d.nodeType + " active";
        } else {
          return "node active";
        }
      }).attr('id', function(d) {
        return "node-" + d.id;
      }).classed('root', function(d) {
        return d.root;
      });
      this.drawNode.createNode(node);
      this.drawNode.styleNode(node);
      this.drawNode.styleText(node);
      this.drawNode.setInteractions(node);
      return node.exit().remove();
    };

    DrawNodes.prototype.updateNode = function(node) {
      this.drawNode.styleNode(node);
      this.drawNode.styleText(node);
      return this.drawNode.setInteractions(node);
    };

    return DrawNodes;

  })();

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.drawing.EdgeUtils = (function() {
    function EdgeUtils() {
      this.captionAngle = __bind(this.captionAngle, this);
      var clustering, conf, edges, hyp, nodes, square;
      conf = alchemy.conf;
      nodes = alchemy._nodes;
      edges = alchemy._edges;
      clustering = new alchemy.clustering;
      if (alchemy.conf.cluster) {
        this.edgeStyle = function(d) {
          var gid, id, index;
          if (nodes[d.source.id].properties.root || nodes[d.target.id].properties.root) {
            index = (nodes[d.source.id].properties.root ? nodes[d.target.id].properties.cluster : nodes[d.source.id].properties.cluster);
            return "" + (clustering.getClusterColour(index));
          } else if (nodes[d.source.id].properties.cluster === nodes[d.target.id].properties.cluster) {
            index = nodes[d.source.id].properties.cluster;
            return "" + (clustering.getClusterColour(index));
          } else if (nodes[d.source.id].properties.cluster !== nodes[d.target.id].properties.cluster) {
            id = "" + nodes[d.source.id].properties.cluster + "-" + nodes[d.target.id].properties.cluster;
            gid = "cluster-gradient-" + id;
            return "url(#" + gid + ")";
          }
        };
      } else if ((alchemy.conf.edgeStyle != null) && !alchemy.conf.cluster) {
        this.edgeStyle = function(d) {
          return "" + (alchemy.conf.edgeStyle(d));
        };
      } else {
        this.edgeStyle = function(d) {
          return "";
        };
      }
      square = function(n) {
        return n * n;
      };
      hyp = function(edge) {
        var height, width;
        width = edge.target.x - edge.source.x;
        height = edge.target.y - edge.source.y;
        return Math.sqrt(height * height + width * width);
      };
      this._edgeWalk = function(edge, point) {
        var distance, height, width;
        width = edge.target.x - edge.source.x;
        height = edge.target.y - edge.source.y;
        hyp = Math.sqrt(height * height + width * width);
        if (point === 'middle') {
          distance = hyp / 2;
          return {
            x: edge.source.x + width * distance / hyp,
            y: edge.source.y + height * distance / hyp
          };
        } else if (point === 'linkStart') {
          if (conf.curvedEdges) {
            return {
              x: edge.source.x,
              y: edge.source.y
            };
          } else {
            distance = edge.source.r + edge.source['stroke-width'];
            return {
              x: edge.source.x + width * distance / hyp,
              y: edge.source.y + height * distance / hyp
            };
          }
        } else if (point === 'linkEnd') {
          if (conf.curvedEdges) {
            distance = hyp;
          } else {
            distance = hyp - (edge.target.r + edge.target['stroke-width']);
          }
          if (conf.directedEdges) {
            distance = distance - conf.edgeArrowSize;
          }
          return {
            x: edge.source.x + width * distance / hyp,
            y: edge.source.y + height * distance / hyp
          };
        }
      };
    }

    EdgeUtils.prototype.middleLine = function(edge) {
      return this._edgeWalk(edge, 'middle');
    };

    EdgeUtils.prototype.startLine = function(edge) {
      return this._edgeWalk(edge, 'linkStart');
    };

    EdgeUtils.prototype.endLine = function(edge) {
      return this._edgeWalk(edge, 'linkEnd');
    };

    EdgeUtils.prototype.edgeLength = function(edge) {
      var height, hyp, width;
      width = edge.target.x - edge.source.x;
      height = edge.target.y - edge.source.y;
      return hyp = Math.sqrt(height * height + width * width);
    };

    EdgeUtils.prototype.edgeAngle = function(edge) {
      var height, width;
      width = edge.target.x - edge.source.x;
      height = edge.target.y - edge.source.y;
      return Math.atan2(height, width) / Math.PI * 180;
    };

    EdgeUtils.prototype.captionAngle = function(edge) {
      var angle;
      angle = this.edgeAngle(edge);
      if (angle < -90 || angle > 90) {
        return angle += 180;
      } else {
        return angle;
      }
    };

    EdgeUtils.prototype.hyp = function(edge) {
      return hyp(edge);
    };

    EdgeUtils.prototype.middlePath = function(edge) {
      var midPoint, pathNode;
      pathNode = d3.select("#path-" + edge.id).node();
      midPoint = pathNode.getPointAtLength(pathNode.getTotalLength() / 2);
      return {
        x: midPoint.x,
        y: midPoint.y
      };
    };

    return EdgeUtils;

  })();

}).call(this);

(function() {
  alchemy.drawing.NodeUtils = (function() {
    function NodeUtils() {
      var conf, nodes;
      nodes = alchemy._nodes;
      conf = alchemy.conf;
      if (conf.cluster) {
        this.nodeColours = function(d) {
          var colour, node_data;
          node_data = nodes[d.id].getProperties();
          if ((isNaN(parseInt(node_data.cluster))) || (node_data.cluster > conf.clusterColours.length)) {
            colour = conf.clusterColours[conf.clusterColours.length - 1];
          } else {
            colour = conf.clusterColours[node_data.cluster];
          }
          return "" + colour;
        };
      } else {
        this.nodeColours = function(d) {
          var colour;
          if (conf.nodeColour) {
            return colour = conf.nodeColour;
          } else {
            return '';
          }
        };
      }
    }

    NodeUtils.prototype.nodeStyle = function(d) {
      var color, stroke;
      color = this.nodeColours(d);
      stroke = alchemy.getState("interactions") === "editor" ? "#E82C0C" : color;
      return "fill: " + color + "; stroke: " + color + "; stroke-width: " + d['stroke-width'] + ";";
    };

    return NodeUtils;

  })();

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.models.Edge = (function() {
    function Edge(edge) {
      this.allNodesActive = __bind(this.allNodesActive, this);
      this.setD3Property = __bind(this.setD3Property, this);
      this.setProperty = __bind(this.setProperty, this);
      this.toPublic = __bind(this.toPublic, this);
      var caption, conf;
      conf = alchemy.conf;
      this.id = edge.id != null ? edge.id : "" + edge.source + "-" + edge.target;
      this.edgeStyle = _.merge(conf.edgeStyle, this.edgeStyle);
      this.state = {
        'active': true
      };
      this.properties = edge;
      this._edgeAttributes = new alchemy.models.EdgeAttributes;
      caption = this._edgeAttributes.edgeCaption(this.properties);
      this.properties.caption = caption;
      this._d3 = {
        'id': this.id,
        'source': alchemy._nodes[this.properties.source]._d3,
        'target': alchemy._nodes[this.properties.target]._d3,
        'caption': caption
      };
      alchemy._nodes["" + edge.source].addEdge(this.id);
      alchemy._nodes["" + edge.target].addEdge(this.id);
    }

    Edge.prototype.toPublic = function() {
      var keys;
      keys = _.keys(this.properties);
      return _.pick(this, keys);
    };

    Edge.prototype.setProperty = function(property, value) {
      return this.properties[property] = value;
    };

    Edge.prototype.setD3Property = function(property, value) {
      return this._d3[property] = value;
    };

    Edge.prototype.allNodesActive = function() {
      var source, target;
      source = d3.select("#node-" + this.properties.source);
      target = d3.select("#node-" + this.properties.target);
      return !source.classed("inactive") && !target.classed("inactive");
    };

    return Edge;

  })();

}).call(this);

(function() {
  alchemy.models.EdgeAttributes = (function() {
    function EdgeAttributes() {
      var caption, conf;
      conf = alchemy.conf;
      caption = conf.edgeCaption;
      if (typeof caption === ('string' || 'number')) {
        this.edgeCaption = function(edge) {
          return edge[caption];
        };
      } else if (typeof caption === 'function') {
        this.edgeCaption = function(edge) {
          return caption(edge);
        };
      }
    }

    return EdgeAttributes;

  })();

}).call(this);


/*
leave in drawing.drawingUtils for now...
We are tied to d3 methods so it does not makes sense to abstract out into a model
 */

(function() {


}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  alchemy.models.Node = (function() {
    function Node(node) {
      this.removeProperty = __bind(this.removeProperty, this);
      this.setD3Property = __bind(this.setD3Property, this);
      this.setProperty = __bind(this.setProperty, this);
      this.getProperties = __bind(this.getProperties, this);
      var conf, nodeAttr, radius;
      conf = alchemy.conf;
      nodeAttr = new alchemy.models.NodeAttributes;
      radius = nodeAttr.nodeSize(node);
      this.id = node.id;
      this.properties = node;
      this.state = {
        "active": true
      };
      this._d3 = {
        'id': node.id,
        'r': radius,
        'stroke-width': nodeAttr.strokeWidth(radius),
        'root': this.properties[conf.rootNodes]
      };
      this.nodeStyle = _.merge(conf.nodeStyle, this.nodeStyle);
      this.adjacentEdges = [];
      Node.prototype.all.push(this.id);
      if (conf.nodeTypes) {
        this.nodeType = this.properties[Object.keys(alchemy.conf.nodeTypes)];
        if (this.nodeType) {
          this._d3['nodeType'] = this.nodeType;
        }
      }
    }

    Node.prototype.addEdge = function(edge) {
      this.adjacentEdges.push(edge);
      return this.adjacentEdges = _.uniq(this.adjacentEdges);
    };

    Node.prototype.outDegree = function() {
      return this.adjacentEdges.length;
    };

    Node.prototype.neighbors = function() {
      var regex;
      regex = new RegExp("[(" + this.id + '\\' + "-)(" + '\\' + "-" + this.id + ")]", "g");
      return _.map(this.adjacentEdges, function(edgeID) {
        return edgeID.replace(regex, "");
      });
    };

    Node.prototype.getProperties = function() {
      return this.properties;
    };

    Node.prototype.setProperty = function(property, value) {
      return this.properties[property] = value;
    };

    Node.prototype.setD3Property = function(property, value) {
      return this._d3[property] = value;
    };

    Node.prototype.removeProperty = function(property) {
      if (this.properties.property != null) {
        return _.omit(this.properties, property);
      }
    };

    Node.prototype.all = [];

    return Node;

  })();

}).call(this);

(function() {
  alchemy.models.NodeAttributes = (function() {
    function NodeAttributes() {
      var rootKey;
      rootKey = alchemy.conf.rootNodes;
      if (typeof alchemy.conf.nodeRadius === 'function') {
        this.nodeSize = function(node) {
          if ((node[rootKey] != null) && d[rootKey]) {
            return alchemy.conf.rootNodeRadius(node);
          } else {
            return alchemy.conf.nodeRadius(node);
          }
        };
      } else if (typeof alchemy.conf.nodeRadius === 'string') {
        this.nodeSize = function(node) {
          var key;
          key = alchemy.conf.nodeRadius;
          if (node[rootKey] != null) {
            return alchemy.conf.rootNodeRadius;
          } else if (node[key] != null) {
            return node[key];
          } else {
            return alchemy.defaults.rootNodeRadius;
          }
        };
      } else if (typeof alchemy.conf.nodeRadius === 'number') {
        this.nodeSize = function(node) {
          if (node[rootKey] != null) {
            return alchemy.conf.rootNodeRadius;
          } else {
            return alchemy.conf.nodeRadius;
          }
        };
      }
    }

    NodeAttributes.prototype.strokeWidth = function(radius) {
      return radius / 3;
    };

    return NodeAttributes;

  })();

}).call(this);

(function() {
  alchemy.utils = {
    deselectAll: function() {
      var _ref;
      if ((_ref = d3.event) != null ? _ref.defaultPrevented : void 0) {
        return;
      }
      alchemy.vis.selectAll('.node, .edge').classed('selected highlight', false);
      d3.select('.alchemy svg').classed({
        'highlight-active': false
      });
      if (alchemy.conf.showEditor === true) {
        alchemy.modifyElements.nodeEditorClear();
      }
      alchemy.vis.selectAll('line.edge').classed('highlighted connected unconnected', false);
      alchemy.vis.selectAll('g.node,circle,text').classed('selected unselected neighbor unconnected connecting', false);
      if (alchemy.conf.deselectAll && typeof (alchemy.conf.deselectAll === 'function')) {
        return alchemy.conf.deselectAll();
      }
    },
    centreView: function(id) {
      var delta, level, node, nodeBounds, params, svg, svgBounds, x, y;
      svg = $('#graph').get(0);
      node = $(id).get(0);
      svgBounds = svg.getBoundingClientRect();
      nodeBounds = node.getBoundingClientRect();
      delta = [svgBounds.width / 2 + svgBounds.left - nodeBounds.left - nodeBounds.width / 2, svgBounds.height / 2 + svgBounds.top - nodeBounds.top - nodeBounds.height / 2];
      params = getCurrentViewParams();
      x = parseFloat(params[0]) + delta[0];
      y = parseFloat(params[1]) + delta[1];
      level = parseFloat(params[2]);
      alchemy.vis.transition().attr('transform', "translate(" + x + ", " + y + ") scale(" + level + ")");
      return zoom.translate([x, y]).scale(level);
    },
    nodeText: function(d) {
      var caption, node;
      node = alchemy._nodes[d.id];
      if (alchemy.conf.nodeCaption && typeof alchemy.conf.nodeCaption === 'string') {
        if (node.properties[alchemy.conf.nodeCaption] != null) {
          return node.properties[alchemy.conf.nodeCaption];
        } else {
          return '';
        }
      } else if (alchemy.conf.nodeCaption && typeof alchemy.conf.nodeCaption === 'function') {
        caption = alchemy.conf.nodeCaption(node);
        if (caption === void 0 || String(caption) === 'undefined') {
          alchemy.log["caption"] = "At least one caption returned undefined";
          alchemy.conf.caption = false;
        }
        return caption;
      }
    }
  };

}).call(this);

(function() {
  alchemy.utils.warnings = {
    dataWarning: function() {
      var no_results;
      if (alchemy.conf.dataWarning && typeof alchemy.conf.dataWarning === 'function') {
        return alchemy.conf.dataWarning();
      } else if (alchemy.conf.dataWarning === 'default') {
        no_results = "<div class=\"modal fade\" id=\"no-results\">\n    <div class=\"modal-dialog\">\n        <div class=\"modal-content\">\n            <div class=\"modal-header\">\n                <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>\n                <h4 class=\"modal-title\">Sorry!</h4>\n            </div>\n            <div class=\"modal-body\">\n                <p>" + alchemy.conf.warningMessage + "</p>\n            </div>\n            <div class=\"modal-footer\">\n                <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>\n            </div>\n        </div>\n    </div>\n</div>";
        $('body').append(no_results);
        $('#no-results').modal('show');
        $('#loading-spinner').hide();
      }
    },
    divWarning: function() {
      return "create an element that matches the value for 'divSelector' in your conf.\nFor instance, if you are using the default 'divSelector' conf, simply provide\n<div id='#alchemy'></div>.";
    }
  };

}).call(this);
