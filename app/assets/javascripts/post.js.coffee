app = angular.module("Posts", ["ngResource"])

app.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'
])

app.factory "Post", ["$resource", ($resource) ->
  $resource("/posts/:id", { id: "@id" }, { update: {method: "PUT"} })
]

@PostCtrl = ["$scope", "Post", ($scope, Post) ->
  $scope.posts = Post.query()

  $scope.addPost = ->
    post = Post.save($scope.newPost)
    $scope.posts.push(post)
    $scope.newPost = {}

  converter = new Showdown.converter();
]