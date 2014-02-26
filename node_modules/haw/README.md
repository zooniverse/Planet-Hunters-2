An alternative to `hem`

```
npm install haw
haw help
```

All commands can be given a `--config` option. By default, haw will attempt to load `slug.{json,js,coffee}` in the current working directory.

`haw init [type] [name]`
========================

This generates folders and files based on the `init` property of your config. By default, it builds out MVC-ish kinda stuff (defined in `lib/default-inits`).

You can specify a type of thing to init, like, a controller or a model or what-have-you, and a name to pass into its templates. Running `haw init controller SomeController` will build out the structure defined in `(config).init.controller` with `"SomeController"` available in its templates as `name`. Templates are in Handlebars.

If not given a type and name, `haw init` will build the structure defined in `(config).init.default`.

`haw serve [port]`
==================

This runs a development server.

By default, it'll serve static files out of the `public` directory. You can change this with the `mount` config property.

By default, it'll generate `/main.js` from `app/main.coffee` and provide `require` function to load modules.

By default, it'll generate `/main.css` from `css/main.styl`, inlining in any `@import` statements.

Change these with the `generate` config property, and modify the `compile` config properties to change how things are compiled.

`haw build [output]`
====================

This will copy your `(config).mount` directories into a build directory, generate files in `(config).generate`, optimize JS, CSS, and images in the build directory, timestamp filenames and rename their references as defined in `(config).timestamp`.

Push the build directory to S3 or whatever and you've got yourself a web site.
