'use strict'

angular.module('site')
    .directive 'prettyPrint', () ->
        restrict: 'A',
        link: makePretty = ($scope, $element, attrs) ->
            $element.html(prettyPrintOne($element.html()))

    .directive 'panelSnap', () ->
        restrict: 'A',
        link: snapContent = ($scope, $element, attrs) ->
            console.log $element
            $('#about').on "click", () ->
                console.log "clicked"
            angular.element($element).bind "scroll", () ->
                console.log "element bound"
            # $(window).scroll () ->
            #     console.log "scrolling with window"
    .controller 'MainCtrl', ($scope, $location) ->
        $scope.snapElement = (inview, part, el) ->
            console.log this
            console.log inview
            console.log part
            # snap content to top of page
            if part is "both"
                console.log "this whole element is visible"  


angular.module('navigation', ['ui.bootstrap'])
    .controller 'navCtrl', ($scope, $location, $route) ->

        $scope.$on '$routeChangeSuccess', ->
            if $location.path() is '/examples/FullApp'
                $scope.showNav = "hidden"
            else $scope.showNav = ""

        $scope.init = ->
            $scope.links =   
            [
                { name: 'Home', href: '/'},
                { name: 'Examples', href: '/examples'},
                { name: 'Tutorial', href: '', tooltip:"Coming Soon!"} 
            ] 
            $scope.active($location.path())
        $scope.active = (navTab) ->
            $location.hash("")
            for link in $scope.links
                if navTab is link.href
                    link.state="active"
                    $location.path(link.href)
                else 
                    link.state=" "


angular.module('alchemyExamples', [])
    .controller 'examplesCtrl', ($scope, $location) ->
        $scope.init = ->
            $scope.examples =
             [
                { name: 'Basic Graph', src: 'views/examples/example1.html', id:"example1"},
                { name: 'Embedded Graph', src: 'views/examples/example2.html', id:"example2"},
                { name: 'Full Application', src: 'views/examples/example3.html', id:"example3"},
                { name: 'Custom Styling', src: 'views/examples/example4.html', id:"example4"} 
            ]
        # should probably be moved to a directive
        $scope.showExample = (e) ->
            $scope.current_example = e
            for example in $scope.examples
                if $scope.current_example is example
                    example.state = "active"
                else
                    example.state=""
            name = e.name.replace " ", "_"
            $location.hash(name)

        $scope.showViz = ->
            $location.path("examples/FullApp")

        $scope.hideViz = ->
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