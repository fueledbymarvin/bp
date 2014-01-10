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

postsDirectives.directive('navBtn', ->
  return {
    restrict: 'E'
    scope: {
      item: "@"
      inverted: "@"
      link: "@"
    }
    link: (scope, element, attrs) ->
      element.hover ->
        element.find('.nav-d-hover').addClass('reveal')
        element.find('.nav-d-normal').addClass('reveal')
      , ->
        element.find('.nav-d-hover').removeClass('reveal')
        element.find('.nav-d-normal').removeClass('reveal')
    templateUrl: 'assets/navBtn.html'
  }
)

postsDirectives.directive('navBar', ->
  return {
    restrict: 'E'
    scope:
      inverted: "@"
    templateUrl: 'assets/navBar.html'
    controller: ($scope, $element) ->
      $scope.menuOpen = ->
        $element.find('#nav-wrapper').css({ height: "auto" })
        navHeight = $element.find('#nav-wrapper').height()
        $element.find('#nav-wrapper').css({ height: 0 })
        $element.find('#nav-wrapper').css({ height: navHeight + "px" })
        if $scope.inverted
          $('#base #header-bar').addClass('reveal')
          $('#base #content').addClass('reveal')
        else
          $('#bg-wrapper').css({ minHeight: navHeight + 560 + "px" })
          bgHeight = $(window).height()
          if bgHeight < 560
            $('#home-content').css({ marginTop: navHeight * 0.45 + "px" })
          else if bgHeight < 560 + navHeight
            $('#home-content').css({ marginTop: navHeight - (bgHeight - 560) * 0.55 + "px" })
          else
            $('#home-content').css({ marginTop: navHeight + "px" })
      $scope.menuClose = ->
        $element.find('#nav-wrapper').css({ height: 0 })
        if $scope.inverted
          $('#base #header-bar').removeClass('reveal')
          $('#base #content').removeClass('reveal')
        else
          $('#home-content').css({ marginTop: 0 })
          $('#bg-wrapper').css({ minHeight: "560px" })
    link: (scope, element, attrs) ->
      element.find('#nav-mobile').click ->
        if element.find('#nav-wrapper').height() is 0
          scope.menuOpen()
        else
          scope.menuClose()

      $(window).resize ->
        if $(window).width() >= 768 and element.find('#nav-wrapper').height() > 0
          scope.menuClose()
  }
)

postsDirectives.directive('navText', ->
  return {
    restrict: 'E'
    scope:
      inverted: "@"
      link: "@"
    transclude: true
    templateUrl: 'assets/navText.html'
    link: (scope, element, attrs) ->
      element.hover ->
        element.find('.line').addClass('reveal')
      , ->
        element.find('.line').removeClass('reveal')
  }
)

postsDirectives.directive('btnLine', ->
  return {
    restrict: 'E'
    scope:
      link: "@"
    transclude: true
    templateUrl: 'assets/btnLine.html'
    link: (scope, element, attrs) ->
      wrapH = element.find('.wrapper').outerHeight()
      wrapW = element.find('.wrapper').outerWidth() + 3

      element.find('.wrapper').prepend('<div class="expander"></div>')
      element.find('.expander').css
        height: wrapH + "px"
        width: wrapW + "px"
        top: 0
        left: 0
        background: "white"
        position: "absolute"
        zIndex: -100
        opacity: 0
        borderRadius: "0.3em"

      element.hover ->
        element.addClass('reveal')
        element.find('.expander').css
          opacity: 1
      , ->
        element.removeClass('reveal')
        element.find('.expander').css
          opacity: 0
  }
)

postsDirectives.directive('logo', ->
  return {
    restrict: 'E'
    scope:
      inverted: "@"
    templateUrl: 'assets/logo.html'
    link: (scope, element, attrs) ->
      element.hover ->
        element.find('#logo-hover').addClass('transition')
        element.find('#logo-hover').addClass('reveal')
      , ->
        element.find('#logo-hover').removeClass('transition')
        element.find('#logo-hover').removeClass('reveal')
  }
)
