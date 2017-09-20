angular.module 'imbay', ['ngMaterial', 'ngRoute']
.config ($routeProvider)->
    $routeProvider
    .when '/', {
        templateUrl: '/login.html',
        resolve: {
            delay: ($q, $timeout)->
                delay = $q.defer()
                $timeout(delay.resolve, 1000)
                return delay.promise
        }
    }

.controller 'MainController', ($scope)->
