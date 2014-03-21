postsApp = angular.module("postsApp", ['ngRoute', 'posts.services', 'posts.directives'])

postsApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/'
    templateUrl: '/assets/home.html'
  ).when('/films',
    controller: 'FilmsListCtrl'
    resolve:
      films: (FilmsListLoader) ->
        return FilmsListLoader()
    templateUrl: '/assets/films.html'
  ).when('/blog/edit/:postId',
    controller: 'PostsEditCtrl'
    resolve:
      post: (PostsLoader) ->
        return PostsLoader()
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/view/:postId',
    controller: 'PostsViewCtrl'
    resolve:
      post: (PostsLoader) ->
        return PostsLoader()
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsView.html'
  ).when('/films/new',
    controller: 'PostsNewCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/new',
    controller: 'PostsNewCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/creators',
    controller: 'UsersCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/usersIndex.html'
  ).when('/creators/view/:userId',
    controller: 'UsersViewCtrl'
    resolve:
      user: (UsersLoader) ->
        return UsersLoader()
      currentUser: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/usersView.html'
  ).when('/creators/edit/:userId',
    controller: 'UsersEditCtrl'
    resolve:
      user: (UsersLoader) ->
        return UsersLoader()
      currentUser: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/usersForm.html'
  ).otherwise(
    redirectTo: '/'
  )
])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

postsApp.controller('PostsListCtrl', ['$scop  $scope.user = usere', 'posts', ($scope, posts) ->
  $scope.posts = posts
])

postsApp.controller('FilmsListCtrl', ['$scope', 'films', ($scope, films) ->
  $scope.films = films
])

postsApp.controller('PostsViewCtrl', ['$scope', '$location', 'post', 'ContentParser', 'user', ($scope, $location, post, ContentParser, user) ->
  $scope.user = user
  $scope.post = post
  if post.video
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date(post.created_at))

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.editable = user.admin is true or user.id is post.user_id

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.edit = ->
    $location.path("/blog/edit/" + post.id)
])

postsApp.controller('PostsEditCtrl', ['$scope', '$location', 'post', 'ContentParser', 'user', ($scope, $location, post, ContentParser, user) ->
  $scope.post = post
  $scope.user = user

  if user is "null" or (user.admin is false and user.id isnt post.user_id)
    $location.path "/"
    console.log "editing post that's not yours"

  if post.video
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date(post.created_at))

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.save = ->
    $scope.post.$update ->
      $location.path("/blog/view/" + post.id)
      # add failure callback

  $scope.delete = ->
    $scope.post.$delete ->
      $location.path("/creators/view/" + user.id)
      delete $scope.post
      # add failure callback
])

postsApp.controller('PostsNewCtrl', ['$scope', '$location', 'Post', 'ContentParser', 'user', 'AuthService', ($scope, $location, Post, ContentParser, user, AuthService) ->
  $scope.user = user
  AuthService.permission(user, false)
  $scope.post = new Post({user_id: $scope.user.id})

  if $location.path().indexOf('/films') is 0
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date())

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.save = ->
    $scope.post.$save (post) ->
      $location.path('/blog/view/' + post.id)
      # add failure callback
])

postsApp.controller('UsersCtrl', ['$scope', "AuthService", ($scope, AuthService) ->
  $scope.login = AuthService.login
])

postsApp.controller('UsersViewCtrl', ['$scope', '$location', 'user', 'currentUser', ($scope, $location, user, currentUser) ->
  $scope.user = user
  $scope.currentUser = currentUser
  $scope.match = user.id is currentUser.id
  if $scope.user.approved is false
    $location.path "/"
    console.log "viewing unapproved user"
])

postsApp.controller('UsersEditCtrl', ['$scope', '$location', 'user', 'currentUser', ($scope, $location, user, currentUser) ->
  $scope.user = user
  $scope.currentUser = currentUser

  if currentUser is "null" or $scope.user.admin is false and $scope.user.id isnt post.user_id
    $location.path "/"
    console.log "editing profile that's not yours"

  $scope.save = ->
    $scope.user.$update ->
      $location.path("/creators/view/" + user.id)
      # add failure callback

  $scope.delete = ->
    $scope.user.$delete ->
      $location.path("/")
      delete $scope.post
      # add failure callback
])