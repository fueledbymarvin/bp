postsServices.factory "Post", ["$resource", ($resource) ->
  $resource("/posts/:id", { id: "@id" }, { update: { method: "PUT" } })
]

postsServices.factory "PostsListLoader", ["Post", "$q", (Recipe, $q) ->
  return ->
    delay = $q.defer()
    Post.query(
      (recipes) ->
        delay.resolve(posts)
      , ->
        delay.reject("Unable to fetch Posts")
    )
    return delay.promise
]

postsServices.factory "PostsLoader", ["Post", "$route", "$q", (Recipe, $route, $q) ->
  return ->
    delay = $q.defer()
    Post.get(
      { id: $route.current.params.recipeId }
      , (recipe) ->
        delay.resolve(post)
      , ->
        delay.reject("Unable to fetch post " + $route.current.params.recipeId)
    )
    return delay.promise
]

postsServices.filter 'markdown', ->
  return (text) ->
    converter = new Showdown.converter();
    return converter.makeHtml(text)