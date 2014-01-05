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
    $scope.post.$save ->
      $location.path("/view/" + post.id)
      # add failure callback

  $scope.remove = ->
    $scope.post.$delete ->
      delete $scope.post
      # add failure callback
])

postsApp.controller('PostsNewCtrl', ['$scope', '$location', 'post', ($scope, $location, Post) ->
  $scope.post = new Post({}) # populate??

  $scope.save = ->
    $scope.post.$save ->
      $location.path('/view/' + post.id)
      # add failure callback
])