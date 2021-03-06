zappa = require '../src/zappa'
port = 15000

@tests =
  hello: (t) ->
    t.expect 1, 2, 3, 4, 5
    t.wait 3000

    zapp = zappa port++, ->
      @get '/string': 'string'
      @get '/return': -> 'return'
      @get '/send': -> @send 'send'
      @get /\/regex$/, 'regex'
      @get /\/regex_function$/, -> 'regex function'

    c = t.client(zapp.server)
    c.get '/string', (err, res) -> t.equal 1, res.body, 'string'
    c.get '/return', (err, res) -> t.equal 2, res.body, 'return'
    c.get '/send', (err, res) -> t.equal 3, res.body, 'send'
    c.get '/regex', (err, res) -> t.equal 4, res.body, 'regex'
    c.get '/regex_function', (err, res) -> t.equal 5, res.body, 'regex function'

  verbs: (t) ->
    t.expect 1, 2, 3
    t.wait 3000

    zapp = zappa port++, ->
      @post '/': -> 'post'
      @put '/': -> 'put'
      @del '/': -> 'del'

    c = t.client(zapp.server)
    c.post '/', (err, res) -> t.equal 1, res.body, 'post'
    c.put '/', (err, res) -> t.equal 2, res.body, 'put'
    c.del '/', (err, res) -> t.equal 3, res.body, 'del'

  redirect: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      @get '/': -> @redirect '/foo'

    c = t.client(zapp.server)
    c.get '/', (err, res) ->
      t.equal 1, res.statusCode, 302
      t.ok 2, res.headers.location.match /\/foo$/

  params: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      @use 'bodyParser'
      @get '/:foo': -> @params.foo + @query.ping
      @post '/:foo': -> @params.foo + @query.ping + @body.zig

    c = t.client(zapp.server)

    c.get '/bar?ping=pong', (err, res) ->
      t.equal 1, res.body, 'barpong'

    headers = 'Content-Type': 'application/x-www-form-urlencoded'
    json = {zig: 'zag'}
    c.post '/bar?ping=pong', {headers, json}, (err, res) ->
      t.equal 2, res.body, 'barpongzag'

  middleware: (t) ->
    t.expect 1, 2, 3
    t.wait 3000

    zapp = zappa port++, ->

      users =
        bob: 'bob user'

      load_user = ->
        user = users[@params.id]
        if user
          @request.user = user
          @next()
        else
          @next "Failed to load user #{@params.id}"

      @get '/string/:id', load_user, -> 'string'
      @get '/return/:id', load_user, -> 'return'
      @get '/send/:id', load_user, -> @send 'send'

    c = t.client(zapp.server)
    c.get '/string/bob', (err, res) -> t.equal 1, res.body, 'string'
    c.get '/return/bob', (err, res) -> t.equal 2, res.body, 'return'
    c.get '/send/bob', (err, res) -> t.equal 3, res.body, 'send'
    c.get '/send/bar', (err, res) -> t.equal 3, res.body, 'Failed to load user bar'
