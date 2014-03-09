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
        delay.reject("Unable to fetch Posts")
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
        delay.reject("Unable to fetch Films")
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
    converter = new Showdown.converter();
    return converter.makeHtml(text)

postsServices.factory "ContentParser", ["$sce", ($sce) ->
  return {
    toggleVideo: ->
      $("video-overlay").toggleClass "reveal"
      return

    parseVimeo: (url) ->
      return $sce.trustAsResourceUrl('//player.vimeo.com/video/' + url.substr(url.lastIndexOf('/') + 1))

    parseDate: (date) ->
      mo = date.getMonth()
      day = date.getDate()
      year = date.getFullYear()
      months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      return months[mo] + " " + day + ", " + year
  }
]