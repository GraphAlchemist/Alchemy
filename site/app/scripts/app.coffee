# 'use strict'

angular.module('site',['ngRoute'
                       'alchemyExamples'
                       'featCarousel'
                       'angular-inview'
                       'navigation'
                       'yaru22.md'
                       
                       ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/home.html'
        controller: 'MainCtrl'
      .when '/examples/:exampleName?',
        templateUrl: 'views/examples.html'
        controller: 'MainCtrl'
        reloadOnSearch: false,
      .when '/examples/Full_Application/Viz',
        templateUrl: 'views/examples/Full_ApplicationViz.html'
        controller: 'MainCtrl'
    return
