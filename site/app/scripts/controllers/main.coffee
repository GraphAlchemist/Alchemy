'use strict'

angular.module('site')
    .controller 'MainCtrl', ($scope, $location) ->
        angular.element(document).ready( ->
                $("#tutorial").tooltip placement: "bottom"
                $("#btn-alchemy-rel").tooltip placement: "bottom"
                $('pre').addClass('prettyprint')
                prettyPrint()
                $scope.path = $location.path()
            )
            # quick hack
        d3.json('../data/charlize.json', (data) ->
            $scope.movies = data
        )
        d3.json('../data/contrib.json', (data) ->
            $scope.contrib = data
        )

angular.module('navigation', ['ngRoute','ui.bootstrap'])
    .controller 'navCtrl', ($scope, $location, $route) ->
        $scope.init = ->
            # angular links
            $scope.links =   
            [
                { name: 'Home', href: '/'},
                { name: 'Examples', href: '/examples'},
                { name: 'Tutorial', href: '#'} 
            ]
            $scope.active($location.path())
        $scope.active = (navTab) ->
            for link in $scope.links
                if navTab is link.href
                    $("#" + link.name).addClass("active")
                    $location.path(link.href)
                else 
                    $("#" + link.name).removeClass("active")


angular.module('alchemyExamples', [])
    .controller 'examplesCtrl', ($scope, $location) ->
        $scope.init = ->
            console.log $location.path()
            $scope.examples =
             [
                { name: 'Basic Graph', src: 'views/examples/example1.html', id:"example1"},
                { name: 'Embedded Graph', src: 'views/examples/example2.html', id:"example2"},
                { name: 'Full Application', src: 'views/examples/example3.html', id:"example3"},
                { name: 'Custom Styling', src: 'views/examples/example4.html', id:"example4"} 
            ]

        $scope.showExample = (e) ->
            $scope.current_example = e
            for example in $scope.examples
                if $scope.current_example is example
                    $("." + example.id).addClass("active")
                else
                    $("." + example.id).removeClass("active")
            name = e.name.replace " ", "_"
            $location.hash(name)

        $scope.showViz = ->
            $(".footer").addClass("hidden")
            $(".navbar-fixed-top").addClass("hidden")
            $location.path("examples/FullApp")

        $scope.hideViz = ->
            $(".footer").removeClass("hidden")
            $(".navbar-fixed-top").removeClass("hidden")
            $location.hash("")
            $location.path("examples/")

angular.module('featCarousel', ['ui.bootstrap'])
    .controller 'carouselCtrl', ($scope) ->
        $scope.myInterval = 5000
        $scope.slides=[
            {image: "images/features/cluster_team.png", text: "Cluster with team.json"},
            {image: "images/features/clusterHighlight_team.png", text: "Cluster Highlighted Node with team.json"},
            {image: "images/features/filters_movies.png", text: "Filters with movies.json"},
            {image: "images/features/filters&Stats_movies.png", text: "Filters and Stats with movies.json"},
            {image: "images/features/search_movies.png", text: "Search with movies.json"}
        ]