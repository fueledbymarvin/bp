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
    scope: {}
    templateUrl: 'assets/navBar.html'
    controller: ($scope, $element) ->
      $scope.menu = ->
        $('#view').toggleClass('open')
        $('body').toggleClass('open')
    link: (scope, element, attrs) ->
      element.find('#nav-mobile nav-btn').click ->
        scope.menu()

      if element.find('#nav-wrapper').css("position") is "fixed"
        element.find('#nav-wrapper').css { height: $(window).height() + "px" }

      $(window).resize ->
        if element.find('#nav-wrapper').css("position") is "fixed"
          element.find('#nav-wrapper').css { height: $(window).height() + "px" }
        else
          $('#view').removeClass('open')
          $('body').removeClass('open')
          element.find('#nav-wrapper').css { height: "auto" }

      $(window).scroll ->
        element.find(".nav-wrapper").toggleClass("down", $(window).scrollTop() > 40)
  }
)

postsDirectives.directive('headerBar', ->
  return {
    restrict: 'E'
    scope:
      image: "@"
      post: "="
      user: "="
      kind: "@"
      type: "@"
      action: "&"
      date: "@"
    templateUrl: 'assets/headerBar.html'
    transclude: true
    link: (scope, element, attrs) ->
      updateImage = () ->
        if scope.image
          element.css
            backgroundImage: "url('" + scope.image + "')"
            backgroundSize: "cover"
            backgroundPosition: "center center"
            backgroundRepeat: "no-repeat"
      updateImage()
      scope.$watch("image", ->
        updateImage()
      )

      updateHeight = () ->
        newHeight = $(window).height() - 142
        element.css
          height: newHeight + "px"
        if newHeight < 480
          element.find(".user").css
            top: "480px"
          element.parent().find(".content").css
            marginTop: "480px"
        else
          element.find(".user").css
            top: newHeight + "px"
          element.parent().find(".content").css
            marginTop: newHeight + "px"
      updateHeight()
      $(window).resize ->
        updateHeight()
  }
)

postsDirectives.directive('navText', ->
  return {
    restrict: 'E'
    scope:
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
      element.hover ->
        element.addClass('reveal')
      , ->
        element.removeClass('reveal')
  }
)

postsDirectives.directive('logo', ->
  return {
    restrict: 'E'
    scope: {}
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

postsDirectives.directive('videoOverlay', ['$sce', ($sce) ->
  return {
    restrict: 'E'
    scope:
      video: "@"
      close: "&"
    templateUrl: 'assets/videoOverlay.html'
    link: (scope, element, attrs) ->
      scope.validate = (url) ->
        $sce.trustAsResourceUrl(url)
  }
])

postsDirectives.directive('film', ->
  return {
    restrict: 'E'
    scope:
      film: "="
    templateUrl: 'assets/film.html'
    link: (scope, element, attrs) ->
      element.css
        backgroundImage: "url('" + scope.film.image + "')"
        backgroundSize: "cover"
        backgroundPosition: "center center"
        backgroundRepeat: "no-repeat"
  }
)

postsDirectives.directive('footer', ->
  return {
    restrict: 'E'
    templateUrl: 'assets/footer.html'
  }
)

postsDirectives.directive('work', ->
  return {
    restrict: 'E'
    scope:
      image: "@"
      post: "="
      date: "@"
    templateUrl: 'assets/work.html'
    link: (scope, element, attrs) ->
      updateImage = () ->
        if scope.image
          element.find('.work-image').css
            backgroundImage: "url('" + scope.image + "')"
            backgroundSize: "cover"
            backgroundPosition: "center center"
            backgroundRepeat: "no-repeat"
      updateImage()

      element.hover(
        ->
          element.find('.work-image').addClass "hover"
          element.find('.work-overlay').css
            opacity: 1
      ,
        ->
          element.find('.work-image').removeClass "hover"
          element.find('.work-overlay').css
            opacity: 0
      )
  }
)

postsDirectives.directive('userImage', ->
  return {
    restrict: 'E'
    scope:
      user: "="
    templateUrl: 'assets/userImage.html'
  }
)