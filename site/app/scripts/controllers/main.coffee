'use strict'

angular.module('site')
    .controller 'MainCtrl', ($scope, $location) ->
        angular.element(document).ready( ->
                $("#tutorial").tooltip placement: "bottom"
                $("#btn-alchemy-rel").tooltip placement: "bottom"
                $('pre').addClass('prettyprint')
                prettyPrint()
                # $("#example3_viz").addClass("hidden")
                # $("#full-app-btn")
                #     .on "click", () ->
                #         $("#examples").toggleClass("hidden")
                #         $(".footer").toggleClass("hidden")
                #         $(".header").toggleClass("hidden")
                #         $("#btn-alchemy-rel").toggleClass("hidden")
                #         $("#example3").toggleClass("hidden")
                #         if $("#examples").hasClass("hidden")
                #             $("#full-app-btn").css("transform", "translate(0%, 0%)")
                #             $("#full-app-btn>h3").html("<i class='glyphicon glyphicon-arrow-left'></i> Go back to Example Code")
                #         else 
                #             $("#full-app-btn").css("transform", "translate(100%, 250%)")
                #             $("#full-app-btn>h3").html("Click to view the Full App in Action <i class='glyphicon glyphicon-arrow-right'></i>")
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

            if e.id is 'example3' then console.log "full app"
                # show the full button 
                #toggle class


