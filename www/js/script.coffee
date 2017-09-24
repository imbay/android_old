app = angular.module 'imbay', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate']
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
app.controller 'MainController', ($scope, $timeout, $mdSidenav)->
    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
app.controller 'LoginController', ($scope, $mdDialog)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
        $mdDialog.show(
            $mdDialog.alert()
            .clickOutsideToClose(true)
            .title('Error')
            .textContent('Username or password is invalid')
            .ok('OK')
        )
app.controller 'JoinController', ($scope, $mdDialog)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
app.controller 'RecoveryController', ($scope, $mdDialog)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
app.controller 'HomeController', ($scope, $mdDialog)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
