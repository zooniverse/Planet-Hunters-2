optimist = require 'optimist'

CWD = process.cwd()
DEFAULT_CONFIG = 'publisssh'

options = optimist.usage('''
  Usage:
    publisssh ./local bucket/destination -dr
''').options({
  c: alias: 'config', description: 'Configuration file (overridden by options)'

  k: alias: 'key', description: 'AWS access key ID'
  s: alias: 'secret', description: 'AWS secret access key'

  r: alias: 'remove', description: 'Delete remote files that don\'t exist locally'
  i: alias: 'ignore', description: 'Ignore files whose names contain this string'
  d: alias: 'dry-run', description: 'Don\'t actually change anything remotely'

  q: alias: 'quiet', description: 'Don\'t log anything'
  V: alias: 'verbose', description: 'Log extra debugging information'

  h: alias: 'help', description: 'Show these options'
  v: alias: 'version', description: 'Show the version number'
}).argv

if options.help
  optimist.showHelp()
  process.exit 0

else if options.version
  {version} = require '../package'
  console.log version
  process.exit 0

else
  path = require 'path'

  try
    config = require path.resolve CWD, (options.config || DEFAULT_CONFIG)

    if typeof config is 'function'
      options = config.call options, options
    else
      options[option] = value for option, value of config when option not of options

  catch e
    if 'config' of options
      throw "Couldn't read config file '#{options.config}'"

  {_: [[localFromArgs]..., remoteFromArgs]} = options

  local = path.resolve localFromArgs || options.local || CWD
  remote = remoteFromArgs || path.basename CWD

  [bucketFromRemote, prefixesFromRemote...] = remote.split path.sep
  prefixFromRemote = prefixesFromRemote.join path.sep

  bucket = (options.bucket || bucketFromRemote).replace /^\/|\/$/g, ''
  prefix = (options.prefix || prefixFromRemote).replace /^\/|\/$/g, ''

  Publisher = require '../lib/publisher'
  publisher = new Publisher {local, bucket, prefix, options}
  publisher.publish()
