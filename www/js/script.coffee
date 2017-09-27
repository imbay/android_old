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

hideFormErrors = (formElement)->
    formElement.find('div.error').hide()

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
        success: (message = 'Успех')->
            $mdDialog.show(
                $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Сообщение')
                    .textContent(message)
                    .ok('ОК')
            )
        error: (message = 'Неизвестная ошибка')->
            $mdDialog.show(
                $mdDialog.alert()
                    .clickOutsideToClose(true)
                    .title('Ошибка')
                    .textContent(message)
                    .ok('ОК')
            )
        server_error: ->
            $scope.alert.error('Возможно соединение с сервером не установлено.')
    }

    $scope.leftMenu = ->
        $mdSidenav('leftMenu').toggle()
    $scope.getCurrentUser = (callback)->
        $http.post(api_url+'/account/current_user', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            callback(response.body)
        , ->
            # $scope.alert.server_error()
            setTimeout(->
                $('md-block.start_page').css('display', 'flex')
            , 500)
        )
    
    $scope.deleteSession = ->
        $http.post(api_url+'/account/sign_out', { session_key: localStorage.getItem('session_key') }).then((response)->
            response = response.data
            if response.error == 0
                localStorage.setItem('session_key', null)
                location.href = '/'
            else
                $scope.alert.error()
            return null
        , ->
            $scope.alert.server_error()
        )

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
        $http.post(api_url+'/account/sign_in', $scope.form).then((response)->
            response = response.data
            if response.error == 2
                $mainScope.alert.error('Неверные данные!')
            else if response.error == 0
                localStorage.setItem('session_key', response.body)
                location.href = '/'
            else
                $mainScope.alert.error
        , ->
            $mainScope.alert.server_error()
        )
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
                        min: 'Введите имя'
                    },
                    last_name: {
                        min: 'Введите фамилия'
                    },
                    gender: {
                        invalid: 'Выберите ваш пол'
                    },
                    username: {
                        min: 'Не меньше 5 символов',
                        unique: 'Имя пользователя занят',
                        invalid: 'Некорректные символы'
                    },
                    password: {
                        min: 'Не меньше 6 символов',
                        invalid: 'Некорректные символы'
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
                , ->
                    $mainScope.alert.server_error()
                )
                
        , ->
            $mainScope.alert.server_error()
        )

app.controller 'PeopleController', ($scope, $mdDialog)->
    $scope.title = 'Люди'
app.controller 'MyPhotosController', ($scope, $mdDialog, $http, FileUploader)->
    $scope.title = 'Мои фотографии'
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
                    $mainScope.alert.error('Ошибка чтения изображения')
                else if response.body['image'].includes('mime')
                    $mainScope.alert.error('Можно загружать только JPEG, PNG или GIF форматы изображения')
                else if response.body['image'].includes('size')
                    $mainScope.alert.error('Загрузите изображения не больше 5мб')
                else if response.body['image'].includes('pixels')
                    $mainScope.alert.error('Нестандартный размер изображения')
                else if response.body['image'].includes('count')
                    $mainScope.alert.error('Вы уже загрузили 20 фотографии, удалите ненужных.')
                else
                    $mainScope.error.alert()
            else
                $mainScope.alert.error()
            $scope.getList()
            $('.file_select_text').text('Загрузить фото')
        onProgressItem: (item, progress)->
            $('.file_select_text').text('Загружено: '+progress+'%')
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
                
        , ->
            $mainScope.alert.server_error()
        )
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
            , ->
                $mainScope.alert.server_error()
            )
        , ->
            # cancel callback.
        )

app.controller 'SettingsController', ($scope, $http, $mdDialog)->
    $scope.title = 'Настройка'
    $scope.form = {
        session_key: localStorage.getItem('session_key')

        first_name: $mainScope.current_user.first_name
        last_name: $mainScope.current_user.last_name
        gender: $mainScope.current_user.gender

        username: $mainScope.current_user.username
        password: ''
    }
    $scope.update = ->
        $http.post(api_url+'/account/update', $scope.form).then((response)->
            response = response.data
            if response.error == 0
                $mainScope.alert.success()
                $scope.form.first_name = response.body.first_name
                $scope.form.last_name = response.body.last_name
                $scope.form.gender = response.body.gender

                $mainScope.current_user.first_name = response.body.first_name
                $mainScope.current_user.last_name = response.body.last_name
                $mainScope.current_user.gender = response.body.gender

                hideFormErrors($('form.update'))
            else if response.error == 3
                showFormErrors($('form.update'), response.body, {
                    first_name: {
                        min: 'Введите имя'
                    },
                    last_name: {
                        min: 'Введите фамилия'
                    }
                })
            else
                $mainScope.alert.error()
        , $mainScope.alert.error)

    $scope.update_username = ->
        $http.post(api_url+'/account/update/username', $scope.form).then((response)->
            response = response.data
            if response.error == 0
                $mainScope.alert.success()
                $scope.form.username = response.body.username
                $mainScope.current_user.username = response.body.username

                hideFormErrors($('form.update_username'))
            else if response.error == 3
                showFormErrors($('form.update_username'), response.body, {
                    username: {
                        min: 'Не меньше 5 символов',
                        unique: 'Имя пользователя занят',
                        invalid: 'Некорректные символы'
                    }
                })
            else
                $mainScope.alert.error()
        , ->
            $mainScope.alert.server_error()
        )

    $scope.update_password = ->
        $http.post(api_url+'/account/update/password', $scope.form).then((response)->
            response = response.data
            if response.error == 0
                $mainScope.alert.success()
                $scope.form.password = ''
                $mainScope.current_user.password = response.body.password
                localStorage.setItem('session_key', response.body)
                hideFormErrors($('form.update_password'))
            else if response.error == 3
                showFormErrors($('form.update_password'), response.body, {
                    password: {
                        min: 'Не меньше 6 символов',
                        invalid: 'Некорректные символы'
                    }
                })
            else
                $mainScope.alert.error()
        , ->
            $mainScope.alert.server_error()
        )

app.controller 'AboutController', ($scope, $mdDialog)->
    $scope.title = 'О нас'

app.controller 'PhotoController', ($scope, $mdDialog, $http, $routeParams)->
    $scope.title = 'Джентлмены'
    $scope.bgColor = 'blue'
    $scope.form = {
        text: ''
    }
    
    if $routeParams['gender'] == "0"
        $scope.title = 'Леди'
        $scope.bgColor = 'pink'

    $scope.like = null
    $scope.get = ->
        $http.get(api_url+'/photo/get?gender='+$routeParams['gender']+'&session_key='+localStorage.getItem('session_key')).then((response)->
            response = response.data
            if response.error == 0
                $scope.photo = response.body
                $scope.like = $scope.photo.like

                $('md-content.photo').hide()
                $('md-content.photo').fadeIn(300)

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
                $mainScope.alert.error('Еще не фотографии')
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
                $mainScope.alert.success('Успешно написано!')
            else if response.error == 3
                try
                    response.body['text']['min']
                    $mainScope.alert.error('Введите ваш комментарий')
                catch
                try
                    response.body['comment']['count']
                    $mainScope.alert.error('В последнее время вы написали много комментариев, попробуйте позже.')
                catch
            else
                $mainScope.alert.error()
        , $mainScope.alert.error)
