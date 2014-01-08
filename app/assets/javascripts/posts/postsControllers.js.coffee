postsApp = angular.module("postsApp", ['ngRoute', 'posts.services', 'posts.directives'])

postsApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/'
    templateUrl: '/assets/home.html'
  )
  # $routeProvider.when('/',
  #     controller: 'PostsListCtrl'
  #     resolve:
  #       posts: (PostsListLoader) ->
  #         return PostsListLoader()
  #     templateUrl: '/assets/postsList.html'
  #   ).when('/edit/:postId',
  #     controller: 'PostsEditCtrl'
  #     resolve:
  #       post: (PostsLoader) ->
  #         return PostsLoader()
  #     templateUrl: '/assets/postsForm.html'
  #   ).when('/view/:postId',
  #     controller: 'PostsViewCtrl'
  #     resolve:
  #       post: (PostsLoader) ->
  #         return PostsLoader()
  #     templateUrl: '/assets/postsView.html'
  #   ).when('/new',
  #     controller: 'PostsNewCtrl'
  #     templateUrl: '/assets/postsForm.html'
  #   ).otherwise(
  #     redirectTo: '/'
  #   )
])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

postsApp.controller('PostsListCtrl', ['$scope', 'posts', ($scope, posts) ->
  $scope.posts = posts
])

postsApp.controller('PostsViewCtrl', ['$scope', '$location', 'post', ($scope, $location, post) ->
  $scope.post = post

  $scope.edit = ->
    $location.path("/edit/" + post.id)
])

postsApp.controller('PostsEditCtrl', ['$scope', '$location', 'post', ($scope, $location, post) ->
  $scope.post = post

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

postsApp.controller('PostsNewCtrl', ['$scope', '$location', 'Post', ($scope, $location, Post) ->
  $scope.post = new Post({}) # populate??

  $scope.save = ->
    $scope.post.$save (post) ->
      $location.path('/view/' + post.id)
      # add failure callback
])