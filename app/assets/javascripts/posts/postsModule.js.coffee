postsApp = angular.module("postsApp", ["ngResource"])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])
