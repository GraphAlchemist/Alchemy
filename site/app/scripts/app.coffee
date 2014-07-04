# 'use strict'

angular.module('site',['ngRoute', 'alchemyExamples', 'featCarousel', 'navigation'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/home.html'
        controller: 'MainCtrl'
      .when '/examples',
        templateUrl: 'views/examples.html'
        controller: 'MainCtrl'
        reloadOnSearch: false,
      .when '/examples/FullApp',
        templateUrl: 'views/examples/example3viz.html'
        controller: 'MainCtrl'
    return
