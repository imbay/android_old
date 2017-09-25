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
        templateUrl: '/start.html',
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

$mainScope = null
app.controller 'MainController', ($scope, $timeout, $mdSidenav, $mdDialog, $http)->
    $scope.bgColor = 'blue'
    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
    $scope.UnknowErrorAlert = ->
        $mdDialog.show(
            $mdDialog.alert()
            .clickOutsideToClose(true)
            .title('Error')
            .textContent('Unknow error')
            .ok('OK')
        )
    $scope.is_auth = false
    $scope.getCurrentUser = (callback)->
        $http.post(api_url+'account/current_user', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            callback(response.body)
        , $scope.UnknowErrorAlert)
    
    $scope.deleteSession = ->
        $http.post(api_url+'account/sign_out', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            if response.error == 0
                localStorage.setItem('session_key', null)
                location.href = '/'
            else
                $scope.UnknowErrorAlert()
            return null
        , $scope.UnknowErrorAlert)
    
    $scope.getCurrentUser((response)->
        if response != null
            # Is auth.
            location.href = '/#!/people'
            $scope.current_user = response
        else
            # Is not auth.
            location.href = '/#!/login'
    )
    
    $mainScope = $scope

app.controller 'LoginController', ($scope, $mdDialog, $http)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
        $http.post(api_url+'account/sign_in', $scope.form).then((response)->
            response = response.data
            if response.error == 2
                $mdDialog.show(
                    $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Error')
                    .textContent('Username or password is invalid')
                    .ok('OK')
                )
            else if response.error == 0
                localStorage.setItem('session_key', response.body)
                location.href = '/'
            else
                $mainScope.UnknowErrorAlert
        , $mainScope.UnknowErrorAlert)
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
                location.href = '/#!/people'
        , $mainScope.UnknowErrorAlert)
app.controller 'RecoveryController', ($scope, $mdDialog)->

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
