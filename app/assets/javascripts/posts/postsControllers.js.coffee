postsApp = angular.module("postsApp", ['ngRoute', 'posts.services', 'posts.directives'])

postsApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/'
    templateUrl: '/assets/home.html'
  ).when('/films',
    controller: 'FilmsListCtrl'
    resolve:
      films: (FilmsListLoader) ->
        return FilmsListLoader()
    templateUrl: '/assets/films.html'
  ).when('/blog',
    controller: 'PostsListCtrl'
    resolve:
      posts: (PostsListLoader) ->
        return PostsListLoader()
    templateUrl: '/assets/blog.html'
  ).when('/blog/edit/:postId',
    controller: 'PostsEditCtrl'
    resolve:
      post: (PostsLoader) ->
        return PostsLoader()
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/view/:postId',
    controller: 'PostsViewCtrl'
    resolve:
      post: (PostsLoader) ->
        return PostsLoader()
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsView.html'
  ).when('/films/new',
    controller: 'PostsNewCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/blog/new',
    controller: 'PostsNewCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/postsForm.html'
  ).when('/creators',
    controller: 'UsersCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
      creators: (UsersListLoader) ->
        return UsersListLoader()
    templateUrl: '/assets/usersIndex.html'
  ).when('/creators/view/:userId',
    controller: 'UsersViewCtrl'
    resolve:
      user: (UsersLoader) ->
        return UsersLoader()
      currentUser: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/usersView.html'
  ).when('/creators/edit/:userId',
    controller: 'UsersEditCtrl'
    resolve:
      user: (UsersLoader) ->
        return UsersLoader()
      currentUser: (AuthService) ->
        return AuthService.currentUser()
    templateUrl: '/assets/usersForm.html'
  ).when('/about',
    controller: 'AboutCtrl'
    resolve:
      user: (AuthService) ->
        return AuthService.currentUser()
      creators: (UsersListLoader) ->
        return UsersListLoader()
    templateUrl: '/assets/about.html'
  ).otherwise(
    redirectTo: '/'
  )
])

postsApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

postsApp.controller('PostsListCtrl', ['$scope', 'posts', ($scope, posts) ->
  $scope.posts = posts
])

postsApp.controller('FilmsListCtrl', ['$scope', 'films', 'ContentParser', ($scope, films, ContentParser) ->
  $scope.films = films

  $scope.changeVideo = (url) ->
    $scope.video = ContentParser.parseVimeo(url)
    ContentParser.toggleVideo()

  $scope.toggleVideo = ContentParser.toggleVideo

  updateHeight = () ->
    element = $('header-bar')
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
    $('.films-wrapper').css
      marginTop: $('header-bar').outerHeight()
  updateHeight()
  $(window).resize ->
    updateHeight()
])

postsApp.controller('PostsViewCtrl', ['$scope', '$location', 'post', 'ContentParser', 'user', ($scope, $location, post, ContentParser, user) ->
  $scope.user = user
  $scope.post = post
  if post.video
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date(post.created_at))

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.editable = user.admin is true or user.id is post.user_id

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.edit = ->
    $location.path("/blog/edit/" + post.id)
])

postsApp.controller('PostsEditCtrl', ['$scope', '$location', 'post', 'ContentParser', 'user', ($scope, $location, post, ContentParser, user) ->
  $scope.post = post
  $scope.user = user

  if user is "null" or (user.admin is false and user.id isnt post.user_id)
    $location.path "/"
    console.log "editing post that's not yours"

  if post.video
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date(post.created_at))

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.save = ->
    $scope.post.$update ->
      $location.path("/blog/view/" + post.id)
      # add failure callback

  $scope.delete = ->
    $scope.post.$delete ->
      $location.path("/creators/view/" + user.id)
      delete $scope.post
      # add failure callback
])

postsApp.controller('PostsNewCtrl', ['$scope', '$location', 'Post', 'ContentParser', 'user', 'AuthService', ($scope, $location, Post, ContentParser, user, AuthService) ->
  $scope.user = user
  AuthService.permission(user, false)
  $scope.post = new Post({user_id: $scope.user.id})

  if $location.path().indexOf('/films') is 0
    $scope.type = 'film'
  else
    $scope.type = 'post'
  $scope.date = ContentParser.parseDate(new Date())

  $scope.toggleVideo = ContentParser.toggleVideo

  $scope.parseVimeo = (url) ->
    return ContentParser.parseVimeo(url)

  $scope.save = ->
    $scope.post.$save (post) ->
      $location.path('/blog/view/' + post.id)
      # add failure callback
])

postsApp.controller('UsersCtrl', ['$scope', 'user', 'creators', ($scope, user, creators) ->
  $scope.user = user
  $scope.creators = creators
])

postsApp.controller('UsersViewCtrl', ['$scope', '$location', 'user', 'currentUser', 'ContentParser', ($scope, $location, user, currentUser, ContentParser) ->
  $scope.user = user
  $scope.currentUser = currentUser
  $scope.match = user.id is currentUser.id or currentUser.admin
  if user.approved is false and currentUser.admin is false and $scope.match is false
    $location.path "/"
    console.log "viewing unapproved user"
  $scope.dateParser = (date) ->
    ContentParser.parseDate(new Date(date))
])

postsApp.controller('UsersEditCtrl', ['$scope', '$location', 'user', 'currentUser', ($scope, $location, user, currentUser) ->
  $scope.user = user
  $scope.currentUser = currentUser

  $scope.colleges = ["Berkeley", "Branford", "Calhoun", "Davenport", "Ezra Stiles", "Jonathan Edwards", "Morse", "Pierson", "Saybrook", "Silliman", "Timothy Dwight", "Trumbull"]
  currentYear = (new Date()).getFullYear()
  $scope.years = []
  for yr in [2014...(currentYear + 4)]
    $scope.years.push({short: yr - (Math.floor(yr / 100) * 100), long: yr})

  if user.year is "Unknown"
    $scope.college = ""
    $scope.year = ""
  else
    $scope.college = user.year.substring(0, user.year.indexOf("'") - 1)
    $scope.year = user.year.substring(user.year.indexOf("'") + 1)

  if currentUser is "null" or currentUser.admin is false and user.id isnt currentUser.user_id
    $location.path "/"
    console.log "editing profile that's not yours"

  $scope.$watch('college', (newCollege) ->
    $scope.user.year = newCollege + " '" + $scope.year
  )
  $scope.$watch('year', (newYear) ->
    $scope.user.year = $scope.college + " '" + newYear
  )

  $scope.save = ->
    $scope.user.$update ->
      $location.path("/creators/view/" + user.id)
      # add failure callback

  $scope.delete = ->
    $scope.user.$delete ->
      $location.path("/")
      delete $scope.user
      # add failure callback
])

postsApp.controller('AboutCtrl', ['$scope', 'user', 'creators', ($scope, user, creators) ->
  $scope.user = user
  admins = []
  for creator in creators
    if creator.admin
      admins.push creator
  $scope.admins = admins
])