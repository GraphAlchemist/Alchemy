(function() {
    angular.module("site", ["ngRoute", "alchemyExamples", "featCarousel", "angular-inview", "navigation"]).config(["$routeProvider", function(a) {
        a.when("/", {
            templateUrl: "views/home.html",
            controller: "MainCtrl"
        }).when("/examples/:exampleName?", {
            templateUrl: "views/examples.html",
            controller: "MainCtrl",
            reloadOnSearch: !1
        }).when("/examples/Full_Application/Viz", {
            templateUrl: "views/examples/Full_ApplicationViz.html",
            controller: "MainCtrl"
        })
    }])
}).call(this),
    function() {
        "use strict";
        angular.module("site").directive("prettyPrint", function() {
            var a;
            return {
                restrict: "A",
                link: a = function(a, b) {
                    return b.html(prettyPrintOne(b.html()))
                }
            }
        }).directive("popupTweet", function() {
            var a;
            return {
                restrict: "A",
                link: a = function() {
                    return angular.element("#custom-tweet-button").on("click", function() {
                        var a, b, c, d, e, f;
                        return f = 575, a = 400, b = ($(window).width() - f) / 2, d = $(window).height() - a / 2, e = this.href, c = "status=1,width=" + f + ",height=" + a + ",top=" + d + ",left=" + b, window.open(e, "twitter", c)
                    }), !1
                }
            }
        }).controller("MainCtrl", ["$scope", "$location", function(a) {
            a.sectionSnap = function(a) {
                var b, c, d;
                b = angular.element("body"), d = angular.element(a), c = d.offset().top, b.animate({
                    scrollTop: c
                }, 500)
            }, a.snapElement = function() {}
        }]), angular.module("navigation", ["ui.bootstrap"]).controller("navCtrl", ["$scope", "$location", "$route", "$http", function(a, b) {
            return a.$on("$routeChangeSuccess", function() {
                return a.showNav = "/examples/FullApp" === b.path() ? "hidden" : ""
            }), a.init = function() {
                return a.links = [{
                    name: "Home",
                    href: "/"
                }, {
                    name: "Examples",
                    href: "/examples"
                }], a.active(b.path()), a.hidden = !1
            }, a.active = function(c) {
                var d, e, f, g, h;
                for (b.hash(""), g = a.links, h = [], e = 0, f = g.length; f > e; e++) d = g[e], c === d.href ? (d.state = "active", h.push(b.path(d.href))) : h.push(d.state = "");
                return h
            }, a.socialToggle = function() {
                return a.hidden === !1 ? a.hidden = !0 : a.hidden === !0 ? a.hidden = !1 : void 0
            }
        }]), angular.module("alchemyExamples", ["ngRoute"]).controller("examplesCtrl", ["$scope", "$location", "$routeParams", function(a, b, c) {
            var d;
            return d = function(c) {
                var d;
                return d = a.examples[c], d.state = "active", a.current_example = d, b.path("/examples/" + c), null != angular.element("#removethis") ? angular.element("#removethis").remove() : void 0
            }, a.init = function() {
                a.examples = {
                    Basic_Graph: {
                        name: "Basic Graph",
                        src: "views/examples/Basic_Graph.html",
                        desc: "A basic Alchemy.js graph, with only a custom dataSource defined."
                    },
                    Embedded_Graph: {
                        name: "Embedded Graph",
                        src: "views/examples/Embedded_Graph.html",
                        desc: "An example with custom graphHeight, graphWidth, and linkDistance making it easy to include and embed within larger applications."
                    },
                    Full_Application: {
                        name: "Full Application",
                        src: "views/examples/Full_Application.html",
                        desc: "A full application using clustering, filters, node typing, and search."
                    },
                    Advanced_Styling: {
                        name: "Advanced Styling",
                        src: "views/examples/Advanced_Styling.html",
                        id: "Advanced_Styling",
                        desc: "Differential styling based on the properties of nodes and edges."
                    }
                }, a.orderedExamples = ["Basic_Graph", "Embedded_Graph", "Custom_Styling", "Advanced_Styling", "Full_Application"], "exampleName" in c && d(c.exampleName)
            }, a.showExample = function(a) {
                d(a)
            }, a.showViz = function() {
                b.path("examples/Full_Application/Viz")
            }, a.hideViz = function() {
                return b.path("examples/Full_Application")
            }
        }]), angular.module("featCarousel", ["ui.bootstrap"]).controller("carouselCtrl", ["$scope", function(a) {
            return a.myInterval = 3e3, a.slides = [{
                image: "images/features/search_movies.png",
                text: "Search within the graph to quickly find insights"
            }, {
                image: "images/features/cluster_team.png",
                text: "Cluster nodes for easy identification of patterns"
            }, {
                image: "images/features/filters_movies.png",
                text: "Automatically generate filters based on the data"
            }, {
                image: "images/features/clusterHighlight_team.png",
                text: "Cluster nodes for easy identification of patterns"
            }, {
                image: "images/features/filters&Stats_movies.png",
                text: "Network statistic API endpoints to use in the rest of your app"
            }]
        }])
    }.call(this);
