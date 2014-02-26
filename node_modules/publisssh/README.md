Sync a directory
----------------

```sh
publisssh ./local-dir bucket/remote-dir
```

Remove remote orphans with `--remove` or `-r`.

Simulate changes with `--dry-run` or `-d`.

AWS keys are `--key` (`-k`) and `--secret` (`-s`), otherwise it'll use the `AMAZON_ACCESS_KEY_ID` and `AMAZON_SECRET_ACCESS_KEY` environment variables.

Config file
-----------

Configuration can be stored in `publisssh.json`, `.js`, or `.coffee`. Specify something else with `--config` or `-c`.

E.g.:

```coffee
# publisssh.coffee
module.exports =
  local: 'public'
  bucket: 'www.example.com'
  prefix: 'demo'
  key: process.env.ALT_AMAZON_ACCESS_KEY_ID
  secret: process.env.ALT_AMAZON_SECRET_ACCESS_KEY
```
