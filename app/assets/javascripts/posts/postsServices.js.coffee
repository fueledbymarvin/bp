postsServices = angular.module('posts.services', ['ngResource'])

postsServices.factory "Post", ["$resource", ($resource) ->
  $resource("/api/posts/:id", { id: "@id" }, { update: { method: "PUT" } })
]

postsServices.factory "PostsListLoader", ["Post", "$q", (Post, $q) ->
  return ->
    delay = $q.defer()
    Post.query(
      (posts) ->
        delay.resolve(posts)
      , ->
        delay.reject("Unable to fetch posts")
    )
    return delay.promise
]

postsServices.factory "FilmsListLoader", ["Post", "$q", (Post, $q) ->
  return ->
    delay = $q.defer()
    Post.query(
      { films: true }
      (films) ->
        delay.resolve(films)
      , ->
        delay.reject("Unable to fetch films")
    )
    return delay.promise
]

postsServices.factory "PostsLoader", ["Post", "$route", "$q", (Post, $route, $q) ->
  return ->
    delay = $q.defer()
    Post.get(
      { id: $route.current.params.postId }
      , (post) ->
        delay.resolve(post)
      , ->
        delay.reject("Unable to fetch post " + $route.current.params.postId)
    )
    return delay.promise
]

postsServices.filter 'markdown', ->
  return (text) ->
    converter = new Showdown.converter()
    return converter.makeHtml(text)

postsServices.factory "ContentParser", ["$sce", ($sce) ->
  return {
    toggleVideo: (url) ->
      $("video-overlay").toggleClass "reveal"
      $("video-overlay").attr("ng-src", url)
      return

    parseVideo: (url) ->
      videoId = url.substr(url.lastIndexOf('/') + 1)
      return $sce.trustAsResourceUrl('//www.youtube.com/embed/' + videoId)

    parseDate: (date) ->
      mo = date.getMonth()
      day = date.getDate()
      year = date.getFullYear()
      months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      return months[mo] + " " + day + ", " + year

    getBlurb: (text) ->
      converter = new Showdown.converter()
      cleaned = converter.makeHtml(text).replace(/(<([^>]+)>)/ig,"")
      cleaned.substring(0, cleaned.indexOf('\n'))
  }
]

postsServices.factory "User", ["$resource", ($resource) ->
  $resource("/api/users/:id", { id: "@id" }, { update: { method: "PUT" } })
]

postsServices.factory "UsersListLoader", ["User", "$q", (User, $q) ->
  return ->
    delay = $q.defer()
    User.query(
      (users) ->
        delay.resolve(users)
      , ->
        delay.reject("Unable to fetch users")
    )
    return delay.promise
]

postsServices.factory "UsersLoader", ["User", "$route", "$q", (User, $route, $q) ->
  return ->
    delay = $q.defer()
    User.get(
      { id: $route.current.params.userId }
      , (user) ->
        delay.resolve(user)
      , ->
        delay.reject("Unable to fetch user " + $route.current.params.userId)
    )
    return delay.promise
]

postsServices.factory "AuthService", ["User", "$http", "$q", "$location", (User, $http, $q, $location) ->
  return {
    login: -> window.location.replace "/auth/google?origin=login"
    signup: -> window.location.replace "/auth/google?origin=signup"
    logout: -> window.location.replace "/logout"
    permission: (user, admin) ->
      if user is "null" or user.approved is false or (user.admin is false and admin is true)
        $location.path "/"
        console.log "not authorized"
    currentUser: ->
      delay = $q.defer()
      $http.get('/api/current').success(
        (data, status, headers, config) ->
          delay.resolve(data)
      ).error(
        (data, status, headers, config) ->
          delay.reject("Unable to fetch current user")
      )
      return delay.promise
  }
]