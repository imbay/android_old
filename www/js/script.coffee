app = angular.module 'imbay', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate']
app.config ($mdThemingProvider)->
    $mdThemingProvider.theme('default')
        .primaryPalette('blue')
        .accentPalette('blue')
        .warnPalette('red')
        .backgroundPalette('grey');

app.config ($routeProvider)->
    $routeProvider
    .when '/', {
        templateUrl: '/login.html',
    }
    .when '/login', {
        templateUrl: '/login.html',
    }
    .when '/join', {
        templateUrl: '/join.html',
    }
    .when '/recovery', {
        templateUrl: '/recovery.html',
    }
    .when '/home', {
        templateUrl: '/home.html',
    }
    .when '/settings', {
        templateUrl: '/settings.html',
    }
    .when '/about', {
        templateUrl: '/about.html',
    }
app.controller 'MainController', ($scope, $timeout, $mdSidenav)->
    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
app.controller 'LoginController', ($scope, $mdDialog)->
    $scope.submit = ->
        $mdDialog.show(
            $mdDialog.alert()
            .clickOutsideToClose(true)
            .title('Error')
            .textContent('Username or password is invalid')
            .ok('OK')
        )
app.controller 'JoinController', ($scope, $mdDialog)->
    $scope.submit = ->
app.controller 'RecoveryController', ($scope, $mdDialog)->
    $scope.submit = ->

app.controller 'HomeController', ($scope, $mdDialog)->
    $scope.name = 'Home'
app.controller 'SettingsController', ($scope, $mdDialog)->
    $scope.name = 'Settings'
app.controller 'AboutController', ($scope, $mdDialog)->
    $scope.name = 'About'
