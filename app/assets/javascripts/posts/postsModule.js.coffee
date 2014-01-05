postsServices = angular.module('posts.services', ['ngResource'])

postsDirectives = angular.module('posts.directives', [])

postsApp = angular.module("postsApp", ['posts.services', 'posts.directives'])

postsApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/',
      controller: 'PostsListCtrl'
      resolve:
        posts: (PostsListLoader) ->
          return PostsListLoader()
      templateUrl: '/assets/postsList.html'
    ).when('/edit/:postId',
      controller: 'PostsEditCtrl'
      resolve:
        post: (PostsLoader) ->
          return PostsLoader()
      templateUrl: '/assets/postsForm.html'
    ).when('/view/:postId',
      controller: 'PostsViewCtrl'
      resolve:
        post: (PostsLoader) ->
          return PostsLoader()
      templateUrl: '/assets/postsView.html'
    ).when('/new',
      controller: 'PostsNewCtrl'
      templateUrl: '/assets/postsForm.html'
    ).otherwise(
      redirectTo: '/'
    )
])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])
