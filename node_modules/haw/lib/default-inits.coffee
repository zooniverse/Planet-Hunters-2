defaultsInits =
  default:
    app:
      'main.coffee': ''

      models:
        '.gitkeep': ''

      views:
        '.gitkeep': ''

      controllers:
        '.gitkeep': ''

    css:
      'main.styl': '''
        body
          margin: 0
      '''

    public:
      'index.html': '''
        <!DOCTYPE html>

        <html>
          <head>
            <meta charset="utf-8" />
            <title>{{name}}</title>
            <link rel="stylesheet" href="./main.css" />
          </head>

          <body>
            <script src="./main.js"></script>
          </body>
        </html>
      '''

      images:
        '.gitkeep': ''

  controller:
    app:
      controllers:
        '{{dashed name}}.coffee': '''
          class {{classCase name}}
            className: '{{dashed name}}'

          module.exports = {{classCase name}}
        '''

    css:
      '{{dashed name}}.styl': '''
        .{{dashed name}}
          color: inherit
      '''

module.exports = defaultsInits
