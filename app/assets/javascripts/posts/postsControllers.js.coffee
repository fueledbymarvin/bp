postsApp.controller("PostsCtrl", ["$scope", "Post", ($scope, Post) ->
  $scope.posts = Post.query()

  $scope.addPost = ->
    Post.save($scope.newPost, (resource) ->
        $scope.posts.push(resource)
        $scope.newPost = {}
      ,
      (response) ->
        #failure
    )
])