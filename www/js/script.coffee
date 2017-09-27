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

app = angular.module 'imbay', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'angularFileUpload']
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
    .when '/photo', {
        templateUrl: '/photo.html',
    }
    .when '/my_photos', {
        templateUrl: '/my_photos.html',
    }

$mainScope = null
app.controller 'MainController', ($scope, $timeout, $mdSidenav, $mdDialog, $http)->
    $scope.api_url = api_url
    $scope.bgColor = 'blue'
    $scope.is_auth = false
    $scope.current_user = null

    $scope.alert = {
        success: (message = 'Success')->
            $mdDialog.show(
                $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Success')
                    .textContent(message)
                    .ok('OK')
            )
        error: (message = 'Unknow')->
            $mdDialog.show(
                $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Error')
                    .textContent(message)
                    .ok('OK')
            )
    }

    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
    $scope.getCurrentUser = (callback)->
        $http.post(api_url+'/account/current_user', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            callback(response.body)
        , $scope.alert.error)
    
    $scope.deleteSession = ->
        $http.post(api_url+'/account/sign_out', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            if response.error == 0
                localStorage.setItem('session_key', null)
                location.href = '/'
            else
                $scope.alert.error()
            return null
        , $scope.alert.error)

    if navigator.onLine == true
        $scope.getCurrentUser((response)->
            if response != null
                # Is auth.
                location.href = '/#!/people'
                $scope.current_user = response
            else
                # Is not auth.
                location.href = '/#!/login'
        )
    else
        $mdDialog.show(
            $mdDialog.alert()
            .clickOutsideToClose(true)
            .title('Error')
            .textContent('No internet connection')
            .ok('OK')
        )
    
    $mainScope = $scope

app.controller 'LoginController', ($scope, $mdDialog, $http)->
    $scope.form = {
        username: '',
        password: ''
    }
    $scope.submit = ->
        $http.post(api_url+'/account/sign_in', $scope.form).then((response)->
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
                $mainScope.alert.error
        , $mainScope.alert.error)
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
        $http.post(api_url+'/account/sign_up', $scope.form).then((response)->
            response = response.data
            if response.error == 3
                showFormErrors($('form[name="JoinForm"]'), response.body, {
                    first_name: {
                        min: 'Required',
                        max: 'Maximum',
                    }
                })
            else
                $http.post(api_url+'/account/sign_in', { username: $scope.form.username, password: $scope.form.password }).then((response)->
                    response = response.data
                    if response.error == 0
                        localStorage.setItem('session_key', response.body)
                        location.href = '/'
                    else
                        $mainScope.alert.error
                , $mainScope.alert.error)
                
        , $mainScope.alert.error)

app.controller 'PeopleController', ($scope, $mdDialog)->
    $scope.title = 'People'
app.controller 'MyPhotosController', ($scope, $mdDialog, $http, FileUploader)->
    $scope.title = 'My photos'
    $scope.photos = []
    $scope.uploader = new FileUploader({
        url: api_url+'/photo/upload',
        alias: 'photo',
        autoUpload: true,
        method: 'post',
        removeAfterUpload: true,
        formData: ['session_key': localStorage.getItem('session_key')],
        onSuccessItem: (item, response)->
            if response.error == 0
                $mainScope.alert.success()
            else if response.error == 3
                if response.body['image'].includes('invalid')
                    $mainScope.alert.error('invalid')
                else if response.body['image'].includes('mime')
                    $mainScope.alert.error('mime')
                else if response.body['image'].includes('size')
                    $mainScope.alert.error('size')
                else if response.body['image'].includes('pixels')
                    $mainScope.alert.error('pixels')
                else if response.body['image'].includes('count')
                    $mainScope.alert.error('count')
                else
                    $mainScope.error.alert()
            else
                $mainScope.alert.error()
            $scope.getList()
            $('.file_select_text').text('Upload photo')
        onProgressItem: (item, progress)->
            $('.file_select_text').text(progress+'%')
        onError: ->
            $mainScope.alert.error()
    })

    $scope.getList = ->
        $http.get(api_url+'/photo/list?session_key='+localStorage.getItem('session_key')).then((response)->
            response = response.data
            if response.error == 0
                $scope.photos = response.body
            else if response.error == 2
                location.href = '/'
            else
                $mainScope.alert.error()
                
        , $mainScope.alert.error)
    $scope.getList()

    $scope.show_dialog = (photo_id)->
        $http.get(api_url+'photo/comments?photo_id='+photo_id+'&session_key='+localStorage.getItem('session_key')).then((response)->
            response = response.data
            if response.error == 0
                # read comments.
                $http.post(api_url+'/photo/read_comments', { photo_id: photo_id, session_key: localStorage.getItem('session_key') })
                $mdDialog.show({
                    templateUrl: 'comment_dialog.html',
                    parent: angular.element(document.body),
                    controller: ($scope, $mdDialog)->
                        $scope.comments = response.body
                        $scope.cancel_dialog = ->
                            $mdDialog.cancel()
                })
            else
                $mainScope.alert.error()
        , $mainScope.alert.error)
    
    remove_confirm = $mdDialog.confirm()
                        .title('?')
                        .textContent('All remove')
                        .ok('Yes')
                        .cancel('No')

    $scope.remove = (photo_id)->
        $mdDialog.show(remove_confirm).then(->
            $http.post(api_url+'/photo/delete', { photo_id: photo_id, session_key: localStorage.getItem('session_key') }).then((response)->
                response = response.data
                if response.error == 0
                    $scope.getList()
                else
                    $mainScope.alert.error
            , $mainScope.alert.error)
        , ->
            # not remove callback.
        )

app.controller 'SettingsController', ($scope, $mdDialog)->
    $scope.title = 'Settings'
    $scope.form = {
        first_name: $mainScope.current_user.first_name
        last_name: $mainScope.current_user.last_name
        gender: $mainScope.current_user.gender

        username: $mainScope.current_user.username
    }
app.controller 'AboutController', ($scope, $mdDialog)->
    $scope.title = 'About'

app.controller 'PhotoController', ($scope, $mdDialog, $http, $routeParams)->
    $scope.title = 'Gentlemen'
    $scope.bgColor = 'blue'
    $scope.form = {
        text: ''
    }
    
    if $routeParams['gender'] == "0"
        $scope.title = 'Lady'
        $scope.bgColor = 'pink'

    $scope.like = null
    $scope.get = ->
        $http.get(api_url+'/photo/get?gender='+$routeParams['gender']+'&session_key='+localStorage.getItem('session_key')).then((response)->
            response = response.data
            if response.error == 0
                $scope.photo = response.body
                $scope.like = $scope.photo.like

                # View image.
                $http.post(api_url+'/photo/to_view', { photo_id: $scope.photo.id, session_key: localStorage.getItem('session_key') }).then((response)->
                    response = response.data
                , $mainScope.alert.error)

                $scope.to_like = (like)->
                    $http.post(api_url+'/photo/to_like', { photo_id: $scope.photo.id, up: like, session_key: localStorage.getItem('session_key') }).then((response)->
                        response = response.data
                        if response.error == 0
                            $scope.like = like
                    , $mainScope.alert.error)

            else if response.error == 2
                location.href = '/'
            else if response.error == 4
                # photos not found.
                $mainScope.alert.error('Photo not found')
                location.href = '/#!/people'
            else
                $mainScope.alert.error()
                
        , $mainScope.alert.error)
    $scope.get()

    $scope.write_comment = ->
        $http.post(api_url+'/photo/write_comment', { photo_id: $scope.photo.id, text: $scope.form.text, session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            if response.error == 0
                $scope.form.text = ''
                $mainScope.alert.success('Success')
            else if response.error == 3
                try
                    response.body['text']['min']
                    $mainScope.alert.error('Min')
                catch
                try
                    response.body['comment']['count']
                    $mainScope.alert.error('Limit')
                catch
            else
                $mainScope.alert.error()
        , $mainScope.alert.error)
