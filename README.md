Zappa is a [CoffeeScript](http://coffeescript.org)-optimized interface to [Express](http://expressjs.com) and [Socket.IO](http://socket.io).

## Synopsis

```coffee
require('zappajs') ->

  # Server-side

  @get '/': ->
    @render 'index',
      title: 'Zappa!'
      scripts: '/zappa/Zappa-simple.js /zappa/sammy.js /index.js /client.js'
      stylesheet: '/index.css'

  @view index: ->
    doctype 5
    html ->
      head ->
        title @title if @title
        for s in @scripts.split ' '
          script src: s
        link rel:'stylesheet', href:@stylesheet
      body ->
        h1 'Welcome to Zappa!'
        div id:'content'

  @css '/index.css':
    body:
      font: '12px Helvetica'
    h1:
      color: 'pink'

  @get '/:name/data.json': ->
    record =
      id: 123
      name: @params.name
      email: "#{@params.name}@example.com"
    @send record

  @on 'ready': ->
    console.log "Client #{@id} is ready and says #{@data}."

  # Client-side

  @coffee '/index.js': ->
    alert 'hi'

  @client '/client.js': ->
    @connect()

    $ =>
      @emit 'ready', 'hello'

    @get '#/': ->
      @app.swap 'Ready to roll!'
```

## Install

    npm install zappajs

## Learn More

- Get the gist with the [crash course](http://zappajs.github.com/zappajs/docs/crashcourse)

- Check the [API reference](http://zappajs.github.com/zappajs/docs/reference)

- See the [examples](https://github.com/zappajs/zappajs/tree/master/examples) included with the source

- Read the [annotated source](http://zappajs.github.com/zappajs/docs/zappa.html) generated by [docco](http://jashkenas.github.com/docco/)

- Get started with the [template](https://github.com/zappajs/zappajs-template)

## Other resources

- The source code [repository](http://github.com/zappajs/zappajs) at github

- Questions, suggestions? Drop us a line on the [mailing list](http://groups.google.com/group/zappajs)

- Found a bug? Open an [issue](http://github.com/zappajs/zappajs/issues) at github

- Check the project's history at the [change log](https://github.com/zappajs/zappajs/blob/master/CHANGELOG.md)

- Deploying to heroku? Check [this blog post](http://superbigtree.tumblr.com/post/20748825617/hosting-zappa-on-heroku)

[![Build Status](https://secure.travis-ci.org/zappajs/zappajs.png)](http://travis-ci.org/zappajs/zappajs)
