api_url = 'http://localhost:3000/api/v1/'
systemLanguage = navigator.language.substr(0,2)
showFormErrors = (formElement, server_errors, errors_normalizer)->
    formElement.find('div.error').hide()
    for key, value of server_errors
        for v in server_errors[key]
            try
                index = server_errors[key].indexOf(v)
                server_errors[key][index] = errors_normalizer[key][v]
            catch
        formElement.find("div.error.#{key}").text(value.join(', '))
        formElement.find("div.error.#{key}").show()

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

$mainControllerScope = null
app.controller 'MainController', ($scope, $timeout, $mdSidenav, $mdDialog)->
    $mainControllerScope = $scope
    $scope.bgColor = 'blue'
    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
    $mainControllerScope.UnknowErrorAlert = ->
        $mdDialog.show(
            $mdDialog.alert()
            .clickOutsideToClose(true)
            .title('Error')
            .textContent('Unknow error')
            .ok('OK')
        )

app.controller 'LoginController', ($scope, $mdDialog, $http)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
        $http.post(api_url+'account/sign_in', $scope.form).then((response)->
            response = response.data
            console.log response
            if response.error == 2
                $mdDialog.show(
                    $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Error')
                    .textContent('Username or password is invalid')
                    .ok('OK')
                )
            else if response.error == 0
                alert 'good'
            else
                $mainControllerScope.UnknowErrorAlert
        , $mainControllerScope.UnknowErrorAlert)
app.controller 'JoinController', ($scope, $mdDialog, $http)->
    $scope.form = {
        first_name: '',
        last_name: '',
        gender: '',
        username: '',
        password: '',
        language: systemLanguage
    }
    $scope.submit = ->
        $http.post(api_url+'account/sign_up', $scope.form).then((response)->
            response = response.data
            if response.error == 3
                showFormErrors($('form[name="JoinForm"]'), response.body, {
                    first_name: {
                        min: 'Required',
                        max: 'Maximum',
                    }
                })
            else
                alert 'good'
        , $mainControllerScope.UnknowErrorAlert)
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
