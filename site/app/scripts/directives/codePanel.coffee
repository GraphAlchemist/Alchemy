
'use strict'

angular.module 'site'
    .directive 'codePanel', ()->
        template: '<div></div>'          
        restrict: 'A'
        link: postLink = (scope, element, attrs)->  
            $.get config.dataSource, (res)->
                $("#graphJSON").html prettyPrintOne(JSON.stringify(res, null, 2))


