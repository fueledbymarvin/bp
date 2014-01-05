postsApp.factory "Post", ["$resource", ($resource) ->
  $resource("/posts/:id", { id: "@id" }, { update: { method: "PUT" } })
]

postsApp.filter('markdown', ->
  return (text) ->
    converter = new Showdown.converter();
    return converter.makeHtml(text)
)