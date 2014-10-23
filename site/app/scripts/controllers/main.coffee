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
            $scope.hidden = false

        $scope.active = (navTab) ->
            $location.hash("")
            for link in $scope.links
                if navTab is link.href
                    link.state= "active"
                    $location.path(link.href)
                else 
                    link.state= ""
        
        $scope.socialToggle = ->
            if $scope.hidden is false
                $scope.hidden = true
            else if $scope.hidden is true
                $scope.hidden = false


angular.module('alchemyExamples', ['ngRoute'])
    .controller 'examplesCtrl', ($scope, $location, $routeParams) ->
        showExample = (name) ->
            e = $scope.examples[name]
            e.state = 'active'
            $scope.current_example = e
            $location.path("/examples/#{name}")
            if angular.element("#removethis")?
                angular.element("#removethis").remove()
        
        $scope.init = ->
            $scope.examples =
                'Basic_Graph':
                    name: 'Basic Graph'
                    src: 'views/examples/Basic_Graph.html'
                    desc: "A basic Alchemy.js graph, with only a custom dataSource defined."
                'Embedded_Graph':
                    name: 'Embedded Graph'
                    src: "views/examples/Embedded_Graph.html"
                    desc: "An example with custom graphHeight, graphWidth, and linkDistance making it easy to include and embed within larger applications."
                'Custom_Styling':
                    name: 'Custom Styling'
                    src: 'views/examples/Custom_Styling.html',
                    desc: "An example illustrating how to apply custom styles to the graph, overriding Alchemy's default configuration by using nodeTypes and edgeTypes."
                'Full_Application':    
                    name: 'Full Application'
                    src: 'views/examples/Full_Application.html'
                    desc: "A full application using clustering, filters, node typing, and search."
                'Advanced_Styling':
                    name: 'Advanced Styling'
                    src: 'views/examples/Advanced_Styling.html'
                    id: 'Advanced_Styling'
                    desc: 'Differential styling based on the properties of nodes and edges.'

            $scope.orderedExamples = ['Basic_Graph', 'Embedded_Graph', 
                                      'Custom_Styling','Advanced_Styling',
                                      'Full_Application'
                                  ]

            if 'exampleName' of $routeParams
                showExample($routeParams.exampleName)

            return

        # should probably be moved to a directive
        $scope.showExample = (name) ->
            showExample(name)
            return

        $scope.showViz = ->
            $location.path("examples/Full_Application/Viz")
            return

        $scope.hideViz = ->
            $location.path("examples/Full_Application")
        

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


   









