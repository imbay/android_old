app = angular.module 'imbay', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate']
app.config ($mdThemingProvider)->
    $mdThemingProvider.theme('default')
        .primaryPalette('blue')
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
    .when '/people', {
        templateUrl: '/people.html',
    }
    .when '/settings', {
        templateUrl: '/settings.html',
    }
    .when '/about', {
        templateUrl: '/about.html',
    }
    .when '/gentlemen', {
        templateUrl: '/gentlemen.html',
    }
    .when '/lady', {
        templateUrl: '/lady.html',
    }
    .when '/my_photos', {
        templateUrl: '/my_photos.html',
    }
app.controller 'MainController', ($scope, $timeout, $mdSidenav)->
    $scope.bgColor = 'blue'
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

app.controller 'PeopleController', ($scope, $mdDialog)->
    $scope.title = 'People'
app.controller 'MyPhotosController', ($scope, $mdDialog)->
    $scope.title = 'My photos'
    $mdDialog.show({
      templateUrl: 'comment_dialog.html',
      parent: angular.element(document.body),
      clickOutsideToClose: true
    })
app.controller 'SettingsController', ($scope, $mdDialog)->
    $scope.title = 'Settings'
app.controller 'AboutController', ($scope, $mdDialog)->
    $scope.title = 'About'
app.controller 'GentlemenController', ($scope, $mdDialog)->
    $scope.title = 'About'
app.controller 'LadyController', ($scope, $mdDialog)->
    $scope.title = 'About'
    $scope.bgColor = 'pink'
