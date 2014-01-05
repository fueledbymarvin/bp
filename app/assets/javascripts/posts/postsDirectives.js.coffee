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

postsApp.directive('addPost', () ->
  return {
    restrict: "E",
    templateUrl: "_addPost.html.slim"
  }
)