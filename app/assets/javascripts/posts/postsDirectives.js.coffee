postsDirectives = angular.module('posts.directives', [])

postsDirectives.directive('bindHtmlUnsafe', ['$compile', ($compile) ->
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
])

postsDirectives.directive('loading', ['$rootScope', ($rootScope) ->
  return {
    link: (scope, element, attrs) ->
      element.addClass('hide')

      $rootScope.$on('$routeChangeStart', ->
        element.removeClass('hide')
      )

      $rootScope.$on('$routeChangeStop', ->
        element.addClass('hide')
      )
  }
])

postsDirectives.directive('markdownEditor', ->
  return {
    link: (scope, element, attrs) ->
      element.markdown({})
  }
)