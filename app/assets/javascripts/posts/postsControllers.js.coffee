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
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/view/:postId',
    controller: 'PostsViewCtrl'
    resolve:
      post: (PostsLoader) ->
        return PostsLoader()
    templateUrl: '/assets/postsView.html'
  ).when('/films/new',
    controller: 'PostsNewCtrl'
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/new',
    controller: 'PostsNewCtrl'
    templateUrl: '/assets/postsForm.html'
  ).when('/creators',
    controller: 'UsersCtrl'
    templateUrl: '/assets/usersIndex.html'
  ).otherwise(
    redirectTo: '/'
  )
])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

postsApp.controller('PostsListCtrl', ['$scope', 'posts', ($scope, posts) ->
  $scope.posts = posts
])

postsApp.controller('FilmsListCtrl', ['$scope', 'films', ($scope, films) ->
  $scope.films = films
])

postsApp.controller('PostsViewCtrl', ['$scope', '$location', 'post', 'ContentParser', ($scope, $location, post, ContentParser) ->
  $scope.post = post
  if post.video
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date(post.created_at))

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.edit = ->
    $location.path("/edit/" + post.id)
])

postsApp.controller('PostsEditCtrl', ['$scope', '$location', 'post', 'ContentParser', ($scope, $location, post, ContentParser) ->
  $scope.post = post
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
      $location.path("/view/" + post.id)
      # add failure callback

  $scope.delete = ->
    $scope.post.$delete ->
      $location.path("/")
      delete $scope.post
      # add failure callback
])

postsApp.controller('PostsNewCtrl', ['$scope', '$location', 'Post', 'ContentParser', ($scope, $location, Post, ContentParser) ->
  $scope.post = new Post({})
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
      $location.path('/view/' + post.id)
      # add failure callback
])

postsApp.controller('UsersCtrl', ['$scope', "AuthService", ($scope, AuthService) ->
  $scope.login = AuthService.login
  AuthService.currentUser().success(
    (data, status, headers, config) ->
      $scope.user = data
  ).error(
    (data, status, headers, config) ->
      $scope.user = {}
  )
])