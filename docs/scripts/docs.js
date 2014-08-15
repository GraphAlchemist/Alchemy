(function() {
  $(function() {
    var activate, configHeader, header, href, id, inView, item, nextLvl, scrollActivate, section, sectionContent, ssID, subSectionContent, text, _i, _j, _k, _len, _len1, _len2, _ref;
    _ref = $("#sidebar").children();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      section = _ref[_i];
      href = $(section).children("a.level-1")[0].hash.replace("#", "");
      sectionContent = $("#" + href).children("section, h2, h3, h4, h5");
      if (sectionContent.length) {
        $(section).append("<div id='lvl-2-" + href + "' class='level-2 list-group'>");
        nextLvl = $("#lvl-2-" + href);
        for (_j = 0, _len1 = sectionContent.length; _j < _len1; _j++) {
          header = sectionContent[_j];
          id = $(header).prop("id");
          if (href !== "Configuration") {
            text = $(header)[0].innerText;
            nextLvl.append("<a class='level-2 list-group-item' href='#" + id + "'>" + text + "</a>");
          } else {
            nextLvl.append("<a href='#" + id + "' class='level-2 list-group-item'>" + id + "</a>");
            nextLvl.append("<div id='lvl-3-" + id + "' class='level-3 list-group'></div>");
            configHeader = $("#lvl-3-" + id);
            subSectionContent = $("#" + id).children("h5");
            for (_k = 0, _len2 = subSectionContent.length; _k < _len2; _k++) {
              item = subSectionContent[_k];
              ssID = $(item).prop("id");
              text = $(item)[0].innerText;
              configHeader.append("<a class='level-3 list-group-item' href='#" + ssID + "'>" + text + "</a>");
            }
            $(configHeader).find("div.level-3").addClass("hidden");
          }
          $("#sidebar").find("div.level-2").addClass("hidden");
        }
      }
    }
    $("#doc-content").on('scroll', function() {
      var _l, _len3, _ref1, _results;
      _ref1 = $("#sidebar").find("a.level-1, a.level-2, a.level-3");
      _results = [];
      for (_l = 0, _len3 = _ref1.length; _l < _len3; _l++) {
        item = _ref1[_l];
        id = item.hash.replace("#", "");
        _results.push(inView(id));
      }
      return _results;
    });
    inView = function(elementId) {
      var docItem, position, sideBarItem;
      docItem = $("#" + elementId);
      console.log(docItem);
      position = docItem.position().top;
      if (position < 30) {
        sideBarItem = "a[href='#" + elementId + "']";
        activate(sideBarItem, false);
        return docItem;
      } else {
        return null;
      }
    };
    $(window).on('load', function() {
      var activeItem, targetItem;
      activeItem = window.location.hash || "#Start";
      targetItem = "a[href='" + activeItem + "']";
      return activate(targetItem, false);
    });
    $(".section-bar a").on('click', function() {
      return activate(this, true);
    });
    scrollActivate = function(tocEl) {
      var offset, padding, pos;
      padding = 50 - 15;
      offset = $("#sidebar").offset().top - padding;
      if ($(tocEl).hasClass("active")) {
        $("#pointer").removeClass("hidden");
        $(tocEl).parents(".level-3, .level-2, .level-1, .section-bar").removeClass("hidden").addClass("active");
        $(tocEl).siblings("a.level-1, a.level-2, a.level-3").removeClass("active");
      } else if (!$(tocEl).hasClass("active")) {
        $("#pointer").addClass("hidden");
        $(tocEl).parents(".level-3,  .level-2, .level-1, .section-bar").removeClass("active");
        $(tocEl).siblings("a.level-1, a.level-2, a.level-3").removeClass("active");
      }
      pos = $(tocEl).offset().top - offset;
      return $("#sidebar-wrapper").scrollTop(pos);
    };
    return activate = function(tocEl, click) {
      var offset, padding, pos;
      if ($(tocEl).length) {
        padding = 50 - 15;
        offset = $("#sidebar").offset().top - padding;
        $("#sidebar").find('.active').removeClass("active");
        if ($(tocEl).hasClass("level-1")) {
          if (click) {
            $(tocEl).toggleClass("active");
            $(tocEl).parent().children(".level-2").toggleClass("hidden", function() {
              if ($(tocEl).hasClass(".active")) {
                return false;
              } else {
                return true;
              }
            });
            $(tocEl).parent().find("div.level-3").addClass("hidden");
          } else {
            $(tocEl).addClass("active");
          }
        } else if ($(tocEl).hasClass("level-2")) {
          if ($(tocEl).next().hasClass("level-3")) {
            if (click) {
              $(tocEl).toggleClass("active");
              $(tocEl).next().toggleClass("hidden", function() {
                if ($(tocEl).hasClass(".active")) {
                  return false;
                } else {
                  return true;
                }
              });
            } else {
              $(tocEl).addClass("active");
              $(tocEl).next().removeClass("hidden");
            }
          } else {
            $(tocEl).addClass("active");
          }
        } else if ($(tocEl).hasClass("level-3")) {
          $("#sidebar").find(".level-3").removeClass("active");
          $("#sidebar").find(".level-2").removeClass("active");
          $(tocEl).addClass("active");
          $(tocEl).parent().prev().addClass("active");
        }
        if ($(tocEl).hasClass("active")) {
          $("#pointer").removeClass("hidden");
          $(tocEl).parents(".level-3, .level-2, .level-1, .section-bar").removeClass("hidden").addClass("active");
          $(tocEl).siblings("a.level-1, a.level-2, a.level-3").removeClass("active");
        } else if (!$(tocEl).hasClass("active")) {
          $("#pointer").addClass("hidden");
          $(tocEl).parents(".level-3,  .level-2, .level-1, .section-bar").removeClass("active");
          $(tocEl).siblings("a.level-1, a.level-2, a.level-3").removeClass("active");
        }
        pos = $(tocEl).offset().top - offset;
        return $("#sidebar-wrapper").scrollTop(pos);
      }
    };
  });

}).call(this);
