'use strict'

angular.module('site')
    .directive 'prettyPrint', () ->
        restrict: 'A',
        link: 
            makePretty = ($scope, $element, attrs) ->
                $element.html(prettyPrintOne($element.html()))

    .directive 'popupTweet', () ->
        restrict: 'A',
        link: 
            popup = ($element) ->
                angular.element('#custom-tweet-button')
                    .on 'click', () ->  
                        width  = 575
                        height = 400
                        left   = ($(window).width()  - width)  / 2
                        top    = $(window).height() - height / 2
                        url    = this.href
                        opts   = 'status=1' +
                                 ',width='  + width  +
                                 ',height=' + height +
                                 ',top='    + top    +
                                 ',left='   + left   
                        window.open(url, 'twitter', opts)
                    return false      

    .controller 'MainCtrl', ($scope, $location) ->
        $scope.sectionSnap = (currentSection) ->
            body = angular.element('body')
            section = angular.element(currentSection)
            offset = section.offset().top
            # headerOffset = angular.element('.navbar').height()
            body.animate({scrollTop: offset}, 500)
            return

        # very hacky scrollSnap, should probably be a directive
        $scope.snapElement = (inview, part) ->
            # body = angular.element(document).find('body')
            # section = angular.element(element)
            # # offset = section.offset().top
            # # headerOffset = angular.element('.navbar').height()s            
            # if part is "top"
            #     @sectionSnap(section)
            #     return
        return

angular.module('navigation', ['ui.bootstrap'])
    .controller 'navCtrl', ($scope, $location, $route, $http) ->
        $scope.$on '$routeChangeSuccess', ->
            if $location.path() is '/examples/FullApp'
                $scope.showNav = "hidden"
            else
                $scope.showNav = ""

        $scope.init = ->
            # $scope.getGHData()
            $scope.links =   
            [
                { name: 'Home', href: '/'},
                { name: 'Examples', href: '/examples'},
                # { name: 'Tutorial', tooltip:"Coming Soon!"} 
            ] 
            $scope.active($location.path())

        $scope.active = (navTab) ->
            $location.hash("")
            for link in $scope.links
                if navTab is link.href
                    link.state= "active"
                    $location.path(link.href)
                else 
                    link.state= ""

angular.module('alchemyExamples', [])
    .controller 'examplesCtrl', ($scope, $location) ->
        $scope.init = ->
            $scope.examples =
             [
                {
                    name: 'Basic Graph',
                    src: 'views/examples/example1.html', 
                    id:"example1", 
                    desc: "A basic Alchemy.js graph, with only a custom dataSource defined." },
                {
                    name: 'Embedded Graph', 
                    src: "views/examples/example2.html", 
                    id: "example2",
                    desc: "An example with custom graphHeight, graphWidth, and linkDistance making it easy to include and embed within larger applications."},
                {
                    name: 'Custom Styling',
                    src: 'views/examples/example4.html',
                    id:"example4",
                    desc: "An example illustrating how to apply custom styles to the graph, overriding Alchemy.css by using nodeTypes and edgeTypes."},
                {
                    name: 'Full Application',
                    src: 'views/examples/example3.html',
                    id: "example3",
                    desc: "A full application using clustering, filters, node typing, and search."},
                {
                    name: 'Advanced Styling',
                    src: 'views/examples/example5.html',
                    id: "example5",
                    desc: "Styling based on node and edge properties."}
            ]
        # should probably be moved to a directive
        $scope.showExample = (e) ->
            $scope.current_example = e
            if angular.element("#removethis")?
                angular.element("#removethis").remove()
            for example in $scope.examples
                if $scope.current_example is example
                    example.state = "active"
                else
                    example.state= ""
            name = e.name.replace " ", "_"
            $location.hash(name)

        $scope.showViz = ->
            $location.path("examples/FullApp")

        $scope.hideViz = ->
            $location.hash("")
            $location.path("examples/")

angular.module('featCarousel', ['ui.bootstrap'])
    .controller 'carouselCtrl', ($scope) ->
        $scope.myInterval = 3000
        $scope.slides=[
            {image: "images/features/search_movies.png", text: "Search within the graph to quickly find insights"},
            {image: "images/features/cluster_team.png", text: "Cluster nodes for easy identification of patterns"},
            {image: "images/features/filters_movies.png", text: "Automatically generate filters based on the data"},
            {image: "images/features/clusterHighlight_team.png", text: "Cluster nodes for easy identification of patterns"},
            {image: "images/features/filters&Stats_movies.png", text: "Network statistic API endpoints to use in the rest of your app"}
        ]