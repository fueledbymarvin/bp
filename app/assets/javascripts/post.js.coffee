postsApp = angular.module("postsApp", ["ngResource"])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'
])

postsApp.factory "Post", ["$resource", ($resource) ->
  $resource("/posts/:id", { id: "@id" }, { update: {method: "PUT"} })
]

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

postsApp.directive('bindHtmlUnsafe', ($compile) ->
  return ($scope, $element, $attrs) ->
    compile = (newHTML) ->
      newHTML = $compile(newHTML)($scope)
      $element.html('').append(newHTML)
    
    htmlName = $attrs.bindHtmlUnsafe

    $scope.$watch(htmlName, (newHTML) ->
      if not newHTML
        return
      compile(newHTML)
    )
)

postsApp.filter('markdown', ->
  return (text) ->
    converter = new Showdown.converter();
    return converter.makeHtml(text)
)