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
    .controller 'examplesCtrl', ($scope, $location) ->
        $scope.init = ->
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
            console.log "hideViz called"
            $(".footer").removeClass("hidden")
            $(".navbar-fixed-top").removeClass("hidden")
            $location.path("examples/")




