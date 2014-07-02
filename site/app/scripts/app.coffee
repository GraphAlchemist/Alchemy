'use strict'

angular.module('site', [
  'ngRoute'
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/home.html'
        controller: 'MainCtrl'
      .when '/examples',
        templateUrl: 'views/examples.html'
        controller: 'MainCtrl'

      # .when '/example1',
      #   templateUrl: 'views/examples/example1.html'
      #   controller: 'MainCtrl'
      # .when '/example2',
      #   templateUrl: 'views/examples/example2.html'
      #   controller: 'MainCtrl'
      # .when '/example3',
      #   templateUrl: 'views/examples/example3.html'
      #   controller: 'MainCtrl'
      # .when '/example4',
      #   templateUrl: 'views/examples/example4.html'
      #   controller: 'MainCtrl'
      # .otherwise
      #   redirectTo: '/'
    return