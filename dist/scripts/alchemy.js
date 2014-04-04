(function() {
  var addTag, allCaptions, allTags, conf, container, currentNodeTypes, currentRelationshipTypes, defaults, filter_html, findAllEdges, findEdge, findNode, fisherYates, fixNodesTags, graph_elem, iGraphSearch, iGraphSearchFocus, iGraphSearchSelect, igraph_search, initialComputationDone, key, linkDistance, nodeRadius, node_filter_html, rel_filter_html, rootNodeId, rootNodeRadius, tag_html, toggle_button, updateCaptions, updateFilters, updateTagsAutocomplete, zoomIn, zoomOut, zoomReset,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fisherYates = function(arr) {
    var i, j, tempi, tempj;
    i = arr.length;
    if (i === 0) {
      return false;
    }
    while (--i) {
      j = Math.floor(Math.random() * (i + 1));
      tempi = arr[i];
      tempj = arr[j];
      arr[i] = tempj;
      arr[j] = tempi;
    }
    return arr;
  };

  if (!window.alchemyConf) {
    window.alchemyConf = {};
  }

  defaults = {
    alpha: .5,
    dataSource: null,
    nodeFilters: ['gender', 'type'],
    edgeFilters: false,
    filterAttribute: null,
    tagsProperty: null,
    nodeTypes: {},
    edgeTypes: {},
    removeNodes: false,
    fixRootNodes: true,
    colours: fisherYates(["#DD79FF", "#FFFC00", "#00FF30", "#5168FF", "#00C0FF", "#FF004B", "#00CDCD", "#f83f00", "#f800df", "#ff8d8f", "#ffcd00", "#184fff", "#ff7e00"]),
    positions: false,
    captionToggle: false,
    edgesToggle: false,
    cluster: true,
    locked: true,
    nodeCat: [],
    linkDistance: 2000,
    rootNodeRadius: 45,
    nodeMouseOver: null,
    tipBody: null,
    nodeRadius: 20,
    caption: 'caption',
    initialScale: 0,
    initialTranslate: [0, 0],
    warningMessage: "There be no data!  What's going on?"
  };

  window.alchemyConf = $.extend({}, defaults, window.alchemyConf);

  conf = window.alchemyConf;


  /*
  application scopes
   */

  window.app = {};

  window.layout = {};

  window.interactions = {};

  window.utils = {};

  window.visControls = {};

  window.styles = {};

  linkDistance = conf.linkDistance;

  rootNodeRadius = conf.rootNodeRadius;

  nodeRadius = conf.nodeRadius;

  initialComputationDone = false;

  graph_elem = $('#graph');

  igraph_search = $('#igraph-search');

  allTags = {};

  allCaptions = {};

  currentNodeTypes = {};

  currentRelationshipTypes = {};

  container = null;

  rootNodeId = null;

  if (!conf.hasOwnProperty('dataSource')) {
    alert('dataSource not specified or #graph does not exist!');
  }

  app.startGraph = function(data) {
    var colours, no_results, nodesMap, user_spec;
    if (!data) {
      no_results = "<div class=\"modal fade\" id=\"no-results\">\n    <div class=\"modal-dialog\">\n        <div class=\"modal-content\">\n            <div class=\"modal-header\">\n                <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>\n                <h4 class=\"modal-title\">Sorry!</h4>\n            </div>\n            <div class=\"modal-body\">\n                <p>No data found, try searching for movies, actors or directors.</p>\n            </div>\n            <div class=\"modal-footer\">\n                <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>\n            </div>\n        </div>\n    </div>\n</div>";
      $('body').append(no_results);
      $('#no-results').modal('show');
      $('#loading-spinner').hide();
      return;
    }
    app.nodes = data.nodes;
    app.edges = data.edges;
    if ('id' in data) {
      rootNodeId = data.id;
    }
    nodesMap = d3.map();
    data.nodes.forEach(function(n) {
      return nodesMap.set(n.id, n);
    });
    data.edges.forEach(function(e) {
      e.source = nodesMap.get(e.source);
      return e.target = nodesMap.get(e.target);
    });
    container = {
      'width': $(window).width(),
      'height': $(window).height()
    };
    layout.positionRootNodes();
    colours = conf.colours;
    if (Array.isArray(colours)) {
      colours.sort(function() {
        return 0.5 - Math.random();
      });
    }
    layout.positionNodes(app.nodes);
    fixNodesTags(app.nodes, app.edges);
    app.force = d3.layout.force().charge(layout.charge).linkDistance(layout.linkDistanceFn).theta(1.0).gravity(0).linkStrength(layout.strength).friction(layout.friction()).chargeDistance(layout.chargeDistance(1000)).size([container.width, container.height]).on("tick", layout.tick);
    app.force.nodes(data.nodes).links(data.edges).start();
    app.vis = d3.select('.alchemy').append("svg").attr("width", container.width).attr("height", container.height).attr("xmlns", "http://www.w3.org/2000/svg").attr("pointer-events", "all").on("dblclick.zoom", null).on('click', utils.deselectAll).call(interactions.zoom).append('g').attr("transform", "translate(" + conf.initialTranslate + " scale(" + conf.initialScale + ")");
    $('body').popover();
    utils.resize();
    app.updateGraph();
    window.onresize = utils.resize;
    user_spec = conf.afterLoad;
    if (user_spec && typeof (user_spec === 'function')) {
      return user_spec();
    }
  };

  app.drawing = {};

  app.drawing.drawedges = function(edge) {
    edge.enter().insert("line", 'g.node').attr("class", function(d) {
      return "edge " + (d.shortest ? 'highlighted' : '');
    }).attr('id', function(d) {
      return d.source.id + '-' + d.target.id;
    }).on('click', interactions.edgeClick);
    edge.exit().remove();
    return edge.attr('x1', function(d) {
      return d.source.x;
    }).attr('y1', function(d) {
      return d.source.y;
    }).attr('x2', function(d) {
      return d.target.x;
    }).attr('y2', function(d) {
      return d.target.y;
    }).attr('shape-rendering', 'optimizeSpeed').attr("style", function(d) {
      var gid, id, index;
      index = void 0;
      if (d.source.node_type === "root" || d.target.node_type === "root") {
        index = (d.source.node_type === "root" ? d.target.cluster : d.source.cluster);
      } else if (d.source.cluster === d.target.cluster) {
        index = d.source.cluster;
      } else if (d.source.cluster !== d.target.cluster) {
        id = "" + d.source.cluster + "-" + d.target.cluster;
        gid = "cluster-gradient-" + id;
        return "stroke: url(#" + gid + ")";
      }
      return "stroke: " + (styles.getClusterColour(index));
    });
  };

  app.drawing.drawnodes = function(node) {
    var nodeEnter;
    nodeEnter = node.enter().append("g").attr('class', function(d) {
      return "node " + (d.category != null ? d.category.join(' ') : '');
    }).attr('id', function(d) {
      return "node-" + d.id;
    }).on('mousedown', function(d) {
      return d.fixed = true;
    }).on('mouseover', interactions.nodeMouseOver).on('mouseout', interactions.nodeMouseOut).on('dblclick', interactions.nodeDoubleClick).on('click', interactions.nodeClick).call(interactions.drag);
    nodeEnter.append('circle').attr('class', function(d) {
      return d.node_type;
    }).attr('id', function(d) {
      return "circle-" + d.id;
    }).attr('r', function(d) {
      return utils.nodeSize(d);
    }).attr('shape-rendering', 'optimizeSpeed').attr('style', function(d) {
      var colour;
      if (conf.cluster) {
        if (isNaN(parseInt(d.cluster))) {
          colour = '#EBECE4';
        } else if (d.cluster < conf.colours.length) {
          colour = conf.colours[d.cluster];
        } else {
          '';
        }
      } else if (conf.colours) {
        if ((d[conf.colourProperty] != null) && (conf.colours[d[conf.colourProperty]] != null)) {
          colour = conf.colours[d[conf.colourProperty]];
        } else {
          colour = conf.colours['default'];
        }
      } else {
        '';
      }
      return "fill: " + colour + "; stroke: " + colour + ";";
    });
    return nodeEnter.append('svg:text').attr('class', function(d) {
      return d.node_type;
    }).attr('id', function(d) {
      return "text-" + d.id;
    }).attr('dy', function(d) {
      if (d.node_type === 'root') {
        return rootNodeRadius / 2;
      } else {
        return nodeRadius * 2 - 5;
      }
    }).text(function(d) {
      return utils.nodeText(d);
    });
  };

  if (conf.removeNodes) {
    node_filter_html = "<fieldset id=\"remove-nodes\">\n    <legend>Remove Nodes\n        <button>Remove</button>\n    </legend>\n</fieldset>";
    $('#filters form').append(node_filter_html);
    $('#filters #remove-nodes button').click(function() {
      var allEdges, allNodes, ids;
      ids = [];
      $('.node.selected, .node.search-match').each(function(i, n) {
        ids.push(n.__data__.id);
        return delete allCaptions[n.__data__.label];
      });
      allNodes = allNodes.filter(function(n) {
        return ids.indexOf(n.id) === -1;
      });
      allEdges = allEdges.filter(function(e) {
        return ids.indexOf(e.source.id) === -1 && ids.indexOf(e.target.id) === -1;
      });
      updateCaptions();
      updateGraph(false);
      $('#tags-list').html('');
      $('#filters input:checked').parent().remove();
      updateFilters();
      return deselectAll();
    });
  }

  if (conf.showFilters) {
    filter_html = "<div id=\"filters\">\n    <h4 data-toggle=\"collapse\" data-target=\"#filters form\">\n        <i class=\"icon-caret-right\"></i> \n        Show Filters\n    </h4>\n    <form class=\"form-inline collapse\">\n    </form>\n</div>";
    $('#controls-container').prepend(filter_html);
    $('#filters form').on('hide.bs.collapse', function() {
      return $('#filters>h4').html('<i class="icon-caret-right"></i> Show Filters');
    }).on('show.bs.collapse', function() {
      return $('#filters>h4').html('<i class="icon-caret-down"></i> Hide Filters');
    });
    $('#filters form').submit(false);
  }

  updateTagsAutocomplete = function() {
    var newTags, node, ok, selected, tag, tags, _i, _j, _k, _len, _len1, _len2, _ref;
    tags = Object.keys(allTags);
    selected = (function() {
      var _i, _len, _ref, _results;
      _ref = $('#tags-list').children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        _results.push(tag.textContent.trim());
      }
      return _results;
    })();
    if (selected) {
      newTags = {};
      for (_i = 0, _len = allNodes.length; _i < _len; _i++) {
        node = allNodes[_i];
        ok = true;
        for (_j = 0, _len1 = selected.length; _j < _len1; _j++) {
          tag = selected[_j];
          if (node._tags.indexOf(tag) === -1) {
            ok = false;
            break;
          }
        }
        if (ok) {
          _ref = node._tags;
          for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
            tag = _ref[_k];
            if (selected.indexOf(tag) === -1) {
              newTags[tag] = true;
            }
          }
        }
      }
      tags = Object.keys(newTags);
    }
    tags.sort();
    return $('#add-tag').autocomplete('option', 'source', tags);
  };

  addTag = function(event, ui) {
    var li, list, tag;
    tag = ui.item.value;
    list = $('#tags-list');
    if (list.children().filter(function() {
      return this.textContent === tag;
    }).length === 0) {
      li = $("<li>\n  <span>" + tag + "<i class=\"icon-remove-sign\"></i></span>\n</li>");
      li.find('i').click(function() {
        $(this).parents('li').remove();
        updateTagsAutocomplete();
        return updateFilters();
      });
      list.append(li);
      li.after(' ');
    }
    this.value = '';
    this.blur();
    updateTagsAutocomplete();
    updateFilters();
    return event.preventDefault();
  };

  if (conf.tagsProperty) {
    tag_html = "<fieldset id=\"tags\">\n    <legend>Tags:</legend>\n    <input type=\"text\" id=\"add-tag\" placeholder=\"search for tags in graph\" data-toggle=\"tooltip\" title=\"tags\">\n    <ul id=\"tags-list\" class=\"unstyled\"></ul>\n</fieldset>";
    $('#filters form').append(tag_html);
    $('#add-tag').autocomplete({
      select: addTag,
      minLength: 0
    });
    $('#add-tag').focus(function() {
      return $(this).autocomplete('search');
    });
  }

  if (conf.edgeTypes) {
    rel_filter_html = "<fieldset id=\"filter-relationships\">\n    <legend>Filter Relationships \n        <button class=\"toggle\">Toggle All</button>\n    </legend>\n</fieldset>";
    $('#filters form').append(rel_filter_html);
  }

  if (conf.nodeTypes) {
    node_filter_html = "<fieldset id=\"filter-nodes\">\n    <legend>Filter Nodes \n        <button class=\"toggle\">Toggle All</button>\n    </legend>\n</fieldset>";
    $('#filters form').append(node_filter_html);
  }

  $('#filters form').append('<div class="clear"></div>');

  toggle_button = $('#filters form').find('button.toggle');

  toggle_button.click(function() {
    var checkboxes, checked;
    checkboxes = $(this).parents('fieldset').find('input');
    checked = $(this).parents('fieldset').find('input:checked').length;
    checkboxes.prop('checked', checked === 0);
    return updateFilters();
  });

  updateFilters = function() {
    var active, edges, matched, nodeTypeList, nodes, relationshipTypeList, tagList, vis;
    vis = app.vis;
    tagList = $('#tags-list');
    nodeTypeList = $('#filter-nodes :checked');
    relationshipTypeList = $('#filter-relationships :checked');
    nodes = vis.selectAll('g.node');
    edges = vis.selectAll('line');
    if (tagList.children().length + nodeTypeList.length + relationshipTypeList.length > 0) {
      active = true;
      graph_elem.attr('class', 'search-active');
    } else {
      nodes.classed('search-match', false);
      edges.classed('search-match', false);
      graph_elem.attr('class', '');
      return;
    }
    nodes.classed('search-match', function(d) {
      var match, tag, _i, _len, _ref;
      if (tagList.children().length + nodeTypeList.length === 0) {
        return false;
      }
      match = true;
      _ref = tagList.children();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        if (d._tags.indexOf(tag.textContent.trim()) === -1) {
          match = false;
        }
      }
      if (match && nodeTypeList.length > 0) {
        match = nodeTypeList.filter('[name="' + d.type + '"]').length > 0;
      }
      return match;
    });
    edges.classed('search-match', function(d) {
      if (relationshipTypeList.filter('[name="' + d.label + '"]').length) {
        $('#node-' + d.source.id)[0].classList.add('search-match');
        $('#node-' + d.target.id)[0].classList.add('search-match');
        return true;
      } else {
        return false;
      }
    });
    matched = false;
    return relationshipTypeList.each(function(d) {
      if (d.caption === $(this).attr('name')) {
        return matched = true;
      }
    }, matched);
  };

  if (conf.captionsToggle) {
    $('#labels-toggle').click = function() {
      var currentClasses;
      currentClasses = ($('svg').attr((function() {
        function _Class() {}

        return _Class;

      })()) || '').split(' ');
      if (currentClasses.indexOf('hidetext') > -1) {
        currentClasses.splice(currentClasses.indexOf('hidetext'), 1);
      } else {
        currentClasses.push('hidetext');
      }
      return $('svg').attr('class', currentClasses.join(' '));
    };
  }

  if (conf.linksToggle) {
    $('#links-toggle').click = function() {
      var currentClasses;
      currentClasses = ($('svg').attr('class') || '').split(' ');
      if (currentClasses.indexOf('hidelinks') > -1) {
        currentClasses.splice(currentClasses.indexOf('hidelinks'), 1);
      } else {
        currentClasses.push('hidelinks');
      }
      return $('svg').attr('class', currentClasses.join(' '));
    };
  }

  fixNodesTags = function(nodes, edges) {
    var caption, checkboxes, checked, column, e, l, n, t, tag, tags, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _ref3, _ref4;
    for (_i = 0, _len = nodes.length; _i < _len; _i++) {
      n = nodes[_i];
      allCaptions[n.label] = n.id;
      n._tags = [];
      if (conf.nodeTypesProperty) {
        currentNodeTypes[n[conf.nodeTypesProperty]] = true;
      }
      if (typeof n[conf.tagsProperty] === 'undefined') {
        continue;
      }
      _ref = n[conf.tagsProperty];
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        t = _ref[_j];
        tag = t.trim().toLowerCase();
        allTags[tag] = true;
        n._tags.push(tag);
      }
    }
    updateCaptions();
    if ('nodeTypes' in conf) {
      checkboxes = '';
      column = 0;
      _ref1 = conf.nodeTypes;
      for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
        t = _ref1[_k];
        if (!currentNodeTypes[t]) {
          continue;
        }
        l = t.replace('_', ' ');
        checked = (_ref2 = $('#filter-nodes input[name="' + t + '"]:checked').length) != null ? _ref2 : {
          ' checked': ''
        };
        checkboxes += '<label class="checkbox" data-toggle="tooltip"><input type="checkbox" name="' + t + '"' + checked + '> ' + l + '</label>';
        column++;
        if (column % 3 === 0) {
          checkboxes += '<br>';
        }
      }
      $('#filter-nodes label, #filter-nodes br').remove();
      $('#filter-nodes').append(checkboxes);
      $('#filter-nodes input').click(updateFilters);
    }
    if ('edgeTypes' in conf) {
      for (_l = 0, _len3 = edges.length; _l < _len3; _l++) {
        e = edges[_l];
        currentRelationshipTypes[[e].caption] = true;
      }
      checkboxes = '';
      column = 0;
      _ref3 = conf.edgeTypes;
      for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
        t = _ref3[_m];
        if (!t) {
          continue;
        }
        caption = t.replace('_', ' ');
        checked = (_ref4 = $('#filter-relationships input[name="' + t + '"]:checked').length) != null ? _ref4 : {
          ' checked': ''
        };
        checkboxes += '<label class="checkbox" data-toggle="tooltip"><input type="checkbox" name="' + t + '"' + checked + '> ' + caption + '</label>';
        column++;
        if (column % 3 === 0) {
          checkboxes += '<br>';
        }
      }
      $('#filter-relationships label, #filter-relationships br').remove();
      $('#filter-relationships').append(checkboxes);
      $('#filter-relationships input').click(updateFilters);
    }
    tags = Object.keys(allTags);
    tags.sort();
    return $('#add-tag').autocomplete('option', 'source', tags);
  };

  interactions.edgeClick = function(d) {
    var vis;
    vis = app.vis;
    vis.selectAll('line').classed('highlight', false);
    d3.select(this).classed('highlight', true);
    d3.event.stopPropagation;
    if (typeof (conf.edgeClick != null) === 'function') {
      return conf.edgeClick();
    }
  };

  interactions.nodeMouseOver = function(n) {
    if (conf.nodeMouseOver != null) {
      if (typeof conf.nodeMouseOver === 'function') {
        return conf.nodeMouseOver(n);
      } else if (typeof conf.nodeMouseOver === ('number' || 'string')) {
        return n[conf.nodeMouseOver];
      }
    } else {
      return null;
    }
  };

  interactions.nodeMouseOut = function(n) {
    if ((conf.nodeMouseOut != null) && typeof conf.nodeMouseOut === 'function') {
      return conf.nodeMouseOut(n);
    } else {
      return null;
    }
  };

  interactions.nodeDoubleClick = function(c) {
    var e, links, _results;
    if (!conf.extraDataSource || c.expanded || conf.unexpandable.indexOf(c.type === !-1)) {
      return;
    }
    $('#loading-spinner').show();
    console.log("loading more data for " + c.id);
    c.expanded = true;
    d3.json(conf.extraDataSource + c.id, loadMoreNodes);
    links = findAllEdges(c);
    _results = [];
    for (e in edges) {
      _results.push(edges[e].distance *= 2);
    }
    return _results;
  };

  interactions.loadMoreNodes = function(data) {

    /*
    TRY:
      - fixing all nodes before laying out graph with added nodes, so only the new ones move
      - extending length of connection between requester node and root so there is some space around it for new nodes to display in
     */
    var angle, i, link, max_radius, min_radius, node, node_x, node_y, nodesMap, radius, requester, _i, _j, _len, _len1, _ref, _ref1;
    console.log("loading more data for " + data.type + " " + data.permalink + ", " + data.nodes.length + " nodes, " + data.links.length + " edges");
    console.log("" + allNodes.length + " nodes initially");
    console.log("" + allEdges.length + " edges initially");
    requester = allNodes[findNode(data.id)];
    console.log("requester node index " + (findNode(data.id)));
    fixNodesTags(data.nodes, data.links);
    _ref = data.nodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      node = data.nodes[i];
      if (findNode(node.id === null)) {
        console.log("adding node " + node.id);
        min_radius = linkDistance * 3;
        max_radius = linkDistance * 5;
        radius = Math.random * (max_radius - min_radius) + min_radius;
        angle = Math.random * 2 * Math.PI;
        node_x = Math.cos(angle * linkDistance);
        node_y = Math.sin(angle * linkDistance);
        node.x = requester.x + node_x;
        node.y = requester.y + node_y;
        node.px = requester.x + node_x;
        node.py = requester.y + node_y;
        allNodes.push(node);
      }
      if (typeof (conf.nodeAdded != null) === 'function') {
        conf.nodeAdded(node);
      }
    }
    nodesMap = d3.map();
    allNodes.forEach(function(n) {
      return nodesMap.set(n.id, n);
    });
    data.links.forEach(function(l) {
      l.source = nodesMap.get(l.source);
      return l.target = nodesMap.get(l.target);
    });
    _ref1 = data.links;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      i = _ref1[_j];
      link = data.links[i];
      if (findEdge(link.source, link.target !== null)) {
        allEdges.push(link);
        if (typeof (conf.edgeAdded != null) === 'function') {
          conf.edgeAdded(node);
        }
        console.log("adding link " + link.source.id + "-" + link.target.id);
      } else {
        console.log("already have link " + link.source.id + "-" + link.target.id + " index " + (findEdge(link.source, link.target)));
      }
    }
    updateGraph();
    nodeClick(requester);
    requester.fixed = false;
    setTimeout((function() {
      return requester.fixed = true;
    }), 1500);
    if (conf.showFilters) {
      updateFilters;
    }
    $('#loading-spinner').hide;
    console.log("" + allNodes.length + " nodes afterwards");
    console.log("" + allEdges.length + " edges afterwards");
    if (typeof (conf.nodeDoubleClick != null) === 'function') {
      return conf.nodeDoubleClick(requester);
    }
  };

  interactions.nodeClick = function(c) {
    d3.event.stopPropagation();
    app.vis.selectAll('line').classed('selected', function(d) {
      return c.id === d.source.id || c.id === d.target.id;
    });
    app.vis.selectAll('.node').classed('selected', function(d) {
      return c.id === d.id;
    }).classed('selected', function(d) {
      return d.id === c.id || app.edges.some(function(e) {
        return (e.source.id === c.id && e.target.id === d.id) || (e.source.id === d.id && e.target.id === c.id);
      });
    });
    if (typeof conf.nodeClick === 'function') {
      conf.nodeClick(c);
    }
  };

  interactions.dragstarted = function(d, i) {
    d3.event.sourceEvent.stopPropagation();
    d3.select(this).classed("dragging", true);
  };

  interactions.dragged = function(d, i) {
    d.x += d3.event.dx;
    d.y += d3.event.dy;
    d.px += d3.event.dx;
    d.py += d3.event.dy;
    d3.select(this).attr("transform", "translate(" + d.x + ", " + d.y + ")");
    app.edge.attr("x1", function(d) {
      return d.source.x;
    }).attr("y1", function(d) {
      return d.source.y;
    }).attr("x2", function(d) {
      return d.target.x;
    }).attr("y2", function(d) {
      return d.target.y;
    }).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
  };

  interactions.dragended = function(d, i) {
    d3.select(this).classed("dragging", false);
  };

  interactions.drag = d3.behavior.drag().origin(Object).on("dragstart", interactions.dragstarted).on("drag", interactions.dragged).on("dragend", interactions.dragended);

  interactions.zooming = function() {
    return interactions.levels = {
      'translate': d3.event.translate,
      'scale': d3.event.scale
    };
  };

  interactions.zoomend = function() {
    return d3.select(".alchemy svg g").attr("transform", "translate(" + interactions.levels.translate + ") scale(" + interactions.levels.scale + ")");
  };


  /*TODO */

  interactions.zoom = d3.behavior.zoom().scaleExtent([0.28, 2]).on("zoom", function() {
    return d3.select(".alchemy svg g").attr("transform", "translate(" + d3.event.translate + ") scale(" + d3.event.scale + ")");
  });


  /*
  force layout functions
   */

  layout.charge = function(node) {
    if (conf.cluster) {
      return -1600;
    } else {
      return -150;
    }
  };

  layout.strength = function(edge) {
    var _ref;
    if ((edge.source.node_type || edge.target.node_type) === 'root') {
      return .2;
    } else {
      if (conf.cluster) {
        return (_ref = edge.source.cluster === edge.target.cluster) != null ? _ref : {
          0.011: 0.01
        };
      } else {
        return 1;
      }
    }
  };

  layout.friction = function() {
    if (conf.cluster) {
      return 0.7;
    } else {
      return 0.9;
    }
  };

  layout.linkDistanceFn = function(edge) {
    var _ref;
    if (conf.cluster) {
      if ((edge.source.node_type || edge.target.node_type) === 'root') {
        300;
      }
      return (_ref = edge.source.cluster === edge.target.cluster) != null ? _ref : {
        200: 600
      };
    } else {
      if (typeof (edge.source.connectedNodes === 'undefined')) {
        edge.source.connectedNodes = 0;
      }
      if (typeof (edge.target.connectedNodes === 'undefined')) {
        edge.target.connectedNodes = 0;
      }
      edge.source.connectedNodes++;
      edge.target.connectedNodes++;
      edge.distance = (Math.floor(Math.sqrt(edge.source.connectedNodes + edge.target.connectedNodes)) + 2) * 35;
      return edge.distance;
    }
  };

  layout.cluster = function(alpha) {
    var c, centroids, _i, _len;
    centroids = {};
    app.nodes.forEach(function(d) {
      var _ref;
      if (d.cluster === '') {
        return;
      }
      if (_ref = d.cluster, __indexOf.call(centroids, _ref) < 0) {
        centroids[d.cluster] = {
          'x': 0,
          'y': 0,
          'c': 0
        };
      }
      centroids[d.cluster].x += d.x;
      centroids[d.cluster].y += d.y;
      return centroids[d.cluster].c++;
    });
    for (_i = 0, _len = centroids.length; _i < _len; _i++) {
      c = centroids[_i];
      c.x = c.x / c.c;
      c.y = c.y / c.c;
    }
    return function(d) {
      var l, x, y;
      if (d.cluster === '') {
        return;
      }
      c = centroids[d.cluster];
      x = d.x - c.x;
      y = d.y - c.y;
      l = Math.sqrt(x * x * y * y);
      if (l > nodeRadius * 2 + 5) {
        l = (l - nodeRadius) / l * alpha;
        d.x -= x * l;
        return d.y -= y * l;
      }
    };
  };

  layout.collide = function(node) {
    var nx1, nx2, ny1, ny2, r;
    r = utils.nodeSize(node) + 200;
    nx1 = node.x - r;
    nx2 = node.x + r;
    ny1 = node.y - r;
    ny2 = node.y + r;
    return function(quad, x1, y1, x2, y2) {
      var l, x, y;
      if (quad.point && (quad.point !== node)) {
        x = node.x - quad.point.x;
        y = node.y - quad.point.y;
        l = Math.sqrt(x * x + y * y);
        r = conf.nodeRadius + quad.point.radius;
        if (l < r) {
          l = (l - r) / l * conf.alpha;
          node.x -= x *= l;
          node.y -= y *= l;
          quad.point.x += x;
          quad.point.y += y;
        }
      }
      return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
    };
  };

  layout.tick = function() {};

  layout.positionRootNodes = function() {
    var fixRootNodes, n, rootNodes, _i, _len, _ref;
    fixRootNodes = conf.fixRootNodes;
    rootNodes = Array();
    _ref = app.nodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      n = _ref[_i];
      if ((n.node_type === 'root') || (n.id === rootNodeId)) {
        n.node_type = 'root';
        rootNodes.push(n);
      }
    }
    if (rootNodes.length === 1) {
      rootNodes[0].x = container.width / 2;
      rootNodes[0].y = container.height / 2;
      rootNodes[0].px = container.width / 2;
      rootNodes[0].py = container.height / 2;
      rootNodes[0].fixed = fixRootNodes;
      return rootNodes[0].r = rootNodeRadius;
    } else {
      rootNodes[0].x = container.width * 0.25;
      rootNodes[0].y = container.height / 2;
      rootNodes[0].px = container.width * 0.25;
      rootNodes[0].py = container.height / 2;
      rootNodes[0].fixed = fixRootNodes;
      rootNodes[0].r = rootNodeRadius;
      rootNodes[1].x = container.width * 0.75;
      rootNodes[1].y = container.height / 2;
      rootNodes[1].px = container.width * 0.75;
      rootNodes[1].py = container.height / 2;
      rootNodes[1].fixed = fixRootNodes;
      return rootNodes[1].r = rootNodeRadius;
    }
  };

  layout.positionNodes = function(nodes, x, y) {
    var angle, max_radius, min_radius, n, node_x, node_y, radius, _i, _len, _results;
    if (typeof x === 'undefined') {
      x = container.width / 2;
      y = container.height / 2;
    }
    _results = [];
    for (_i = 0, _len = nodes.length; _i < _len; _i++) {
      n = nodes[_i];
      min_radius = linkDistance * 3;
      max_radius = linkDistance * 5;
      radius = Math.random() * (max_radius - min_radius) + min_radius;
      angle = Math.random() * 2 * Math.PI;
      node_x = Math.cos(angle) * linkDistance;
      node_y = Math.sin(angle) * linkDistance;
      n.x = x + node_x;
      _results.push(n.y = y + node_y);
    }
    return _results;
  };

  layout.chargeDistance = function(distance) {
    return distance;
  };

  findNode = function(id) {
    var n, _i, _len, _results;
    if (n.id === id) {
      _results = [];
      for (_i = 0, _len = allNodes.length; _i < _len; _i++) {
        n = allNodes[_i];
        _results.push(n);
      }
      return _results;
    }
  };

  findEdge = function(source, target) {
    var e, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = allEdges.length; _i < _len; _i++) {
      e = allEdges[_i];
      if (e.source.id === source.id && e.target.id === target.id) {
        e;
      }
      if (e.target.id === source.id && e.source.id === target.id) {
        _results.push(e);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  findAllEdges = function(source) {
    var Q, e, _i, _len;
    Q = [];
    for (_i = 0, _len = allEdges.length; _i < _len; _i++) {
      e = allEdges[_i];
      if ((e.source.id === source.id) || (e.target.id === source.id)) {
        Q.push(e);
      }
    }
    return Q;
  };

  iGraphSearch = function(event) {
    var matches, nodes, term, vis;
    vis = app.vis;
    if (event && (event.keyCode === 27)) {
      $('#igraph-search').val('');
    }
    term = $('#igraph-search').val().toLowerCase();
    nodes = vis.selectAll('g.node');
    if (term === '') {
      updateFilters();
      return;
    }
    graph_elem.attr('class', 'search-active');
    matches = function(d) {
      return d.name.toLowerCase().indexOf(term) >= 0;
    };
    return nodes.classed('search-match', matches);
  };

  iGraphSearchSelect = function(event, ui) {
    var id;
    id = "#node-" + ui.item.value;
    $(id).d3Click();
    centreView(id);
    this.value = '';
    updateFilters();
    return event.preventDefault();
  };

  iGraphSearchFocus = function(event, ui) {
    centreView("#node-" + ui.item.value);
    return event.preventDefault();
  };

  $('#igraph-search').keyup(iGraphSearch).autocomplete({
    select: iGraphSearchSelect,
    focus: iGraphSearchFocus,
    minLength: 0
  }).focus(function() {
    return $(this).autocomplete('search');
  });

  updateCaptions = function() {
    var captions, key;
    captions = [];
    for (key in allCaptions) {
      captions.push({
        caption: key,
        value: allCaptions[key]
      });
    }
    captions.sort(function(a, b) {
      if (a.caption < b.caption) {
        return -1;
      }
      if (a.caption > b.caption) {
        return 1;
      }
      return 0;
    });
    return $('#igraph-search').autocomplete('option', 'source', captions);
  };

  styles.getClusterColour = function(index) {
    if (conf.colours[index] != null) {
      return conf.colours[index];
    } else {
      return '#EBECE4';
    }
  };

  styles.edgeGradient = function(edges) {
    var Q, defs, edge, endColour, gradient, gradient_id, id, ids, startColour, _i, _len, _results;
    defs = d3.select(".alchemy svg").append("svg:defs");
    Q = {};
    for (_i = 0, _len = edges.length; _i < _len; _i++) {
      edge = edges[_i];
      if (edge.source.node_type === "root" || edge.target.node_type === "root") {
        continue;
      }
      if (edge.source.cluster === edge.target.cluster) {
        continue;
      }
      if (edge.target.cluster !== edge.source.cluster) {
        id = edge.source.cluster + "-" + edge.target.cluster;
        if (id in Q) {
          continue;
        } else if (!(id in Q)) {
          startColour = styles.getClusterColour(edge.target.cluster);
          endColour = styles.getClusterColour(edge.source.cluster);
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

  styles.nodeStandOut = function(nodes) {};

  app.updateGraph = function(start) {
    var force, i, q, vis;
    if (start == null) {
      start = true;
    }
    force = app.force;
    vis = app.vis;
    force.nodes(app.nodes).links(app.edges);
    if (start) {
      force.start();
    }
    if (!initialComputationDone) {
      while (force.alpha() > 0.005) {
        force.tick();
      }
      initialComputationDone = true;
      $('#loading-spinner').hide();
      $('#loading-spinner').removeClass('middle');
      console.log(Date() + ' completed initial computation');
      if (conf.locked) {
        force.stop();
      }
    }
    styles.edgeGradient(app.edges);
    app.edge = vis.selectAll("line").data(app.edges, function(d) {
      return d.source.id + '-' + d.target.id;
    });
    app.node = vis.selectAll("g.node").data(app.nodes, function(d) {
      return d.id;
    });
    app.drawing.drawedges(app.edge);
    app.drawing.drawnodes(app.node);
    q = d3.geom.quadtree(app.nodes);
    i = 0;
    while (++i < app.nodes.length) {
      q.visit(layout.collide(app.nodes[i]));
    }
    vis.selectAll('g.node').attr('transform', function(d) {
      return "translate(" + d.px + ", " + d.py + ")";
    });
    vis.selectAll('.node text').text(function(d) {
      return utils.nodeText(d);
    });
    return app.node.exit().remove();
  };

  utils.deselectAll = function() {
    var _ref;
    if ((_ref = d3.event) != null ? _ref.defaultPrevented : void 0) {
      return;
    }
    app.vis.selectAll('.node, line').classed('selected highlight', false);
    d3.select('.alchemy svg').classed({
      'highlight-active': false
    });
    vis.selectAll('line.edge').classed('highlighted connected unconnected', false);
    vis.selectAll('g.node,circle,text').classed('selected unselected neighbor unconnected connecting', false);
    if (conf.deselectAll && typeof (conf.deselectAll === 'function')) {
      return conf.deselectAll();
    }
  };

  utils.resize = function() {
    container = {
      'width': $(window).width(),
      'height': $(window).height()
    };
    return d3.select('.alchemy svg').attr("width", container.width).attr("height", container.height);
  };

  utils.scale = function(x) {
    var elbow_point, mid_scale, min;
    min = 100;
    mid_scale = 40;
    elbow_point = 50;
    if (x > elbow_point) {
      return Math.min(max, mid_scale + (Math.log(x) - Math.log(elbow_point)));
    } else {
      return (mid_scale - min) * (x / elbow_point) + min;
    }
  };

  utils.centreView = function(id) {
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
    app.vis.transition().attr('transform', "translate(" + x + ", " + y + ") scale(" + level + ")");
    return zoom.translate([x, y]).scale(level);
  };

  utils.nodeText = function(d) {
    if (d.caption) {
      return d.caption;
    } else if (conf.caption && typeof conf.caption === 'string') {
      if (d[conf.caption] != null) {
        return d[conf.caption];
      } else {
        return '';
      }
    } else if (conf.caption && typeof conf.caption === 'function') {
      return conf.caption(d);
    }
  };

  if (conf.nodeRadius != null) {
    if (typeof conf.nodeRadius === 'function') {
      utils.nodeSize = function(d) {
        if (d.node_type === 'root') {
          return conf.rootNodeRadius;
        } else {
          return conf.nodeRadius(d);
        }
      };
    } else if (typeof conf.nodeRadius === 'string') {
      key = conf.nodeRadius;
      utils.nodeSize = function(d) {
        if (d.node_type === 'root') {
          return conf.rootNodeRadius;
        } else {
          return d.degree;
        }
      };
    } else if (typeof conf.nodeRadius === 'number') {
      utils.nodeSize = function(d) {
        if (d.node_type === 'root') {
          return conf.rootNodeRadius;
        } else {
          return conf.nodeRadius;
        }
      };
    } else {
      utils.nodeSize = 20;
    }
  }


  /*
  visual controls
   */

  visControls.getCurrentViewParams = function() {
    var params;
    params = $('#graph > g').attr('transform');
    if (!params) {
      return [0, 0, 1];
    } else {
      params = params.match(/translate\(([0-9e.-]*), ?([0-9e.-]*)\)(?: scale\(([0-9e.]*)\))?/);
      params.shift();
      if (!params[2]) {
        params[2] = 1;
      }
      return params;
    }
  };

  zoomIn = function() {
    var level, params, vis, x, y;
    vis = app.vis;
    params = visControls.getCurrentViewParams();
    x = params[0];
    y = params[1];
    level = parseFloat(params[2]) * 1.2;
    vis.attr('transform', "translate(" + x + ", " + y + ") scale(" + level + ")");
    return zoom.translate([x, y]).scale(level);
  };

  zoomOut = function() {
    var level, params, vis, x, y;
    vis = app.vis;
    params = visControls.getCurrentViewParams();
    x = params[0];
    y = params[1];
    level = parseFloat(params[2]) / 1.2;
    vis.attr('transform', "translate(" + x + ", " + y + ") scale(" + level + ")");
    return zoom.translate([x, y]).scale(level);
  };

  zoomReset = function() {
    var ar, ax, ay, n, x, y, _i, _len;
    app.vis;
    utils.deselectAll();
    ax = ay = ar = 0;
    for (_i = 0, _len = allNodes.length; _i < _len; _i++) {
      n = allNodes[_i];
      delete n.fixed;
      if (n.node_type === 'root') {
        ax += n.x;
        ay += n.y;
      }
    }
    x = 0;
    y = 0;
    if (ar !== 0) {
      x -= ax / ar;
      y -= ay / ar;
    }
    vis.attr('transform', "translate(" + x + ", " + y + ") scale(1)");
    return zoom.translate([x, y]).scale(1);
  };

  $('#zoom-in').click(zoomIn);

  $('#zoom-out').click(zoomOut);

  $('#zoom-reset').click(zoomReset);

  if (typeof alchemyConf.dataSource === 'string') {
    d3.json(alchemyConf.dataSource, app.startGraph);
  } else if (typeof alchemyConf.dataSource === 'object') {
    app.startGraph(alchemyConf.dataSource);
  }

}).call(this);

//# sourceMappingURL=alchemy.js.map
