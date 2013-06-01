sass = require 'node-sass'
fs   = require 'fs'

module.exports = (env, callback) ->

  class ScssPlugin extends env.ContentPlugin

    constructor: (@filepath, @source) ->

    getFilename: -> @filepath.relative.replace /scss$/, 'css'
    
    getView: -> (env, locals, contents, templates, callback) ->
      sass.render
        data: @source
        success: (css) ->
          callback null, new Buffer css
        error: (error) ->
          callback error
        outputStyle: "compressed"

  ScssPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, buffer) ->
      if error
        callback error
      else
        callback null, new ScssPlugin filepath, buffer.toString()


  env.registerContentPlugin 'scss', '**/*.scss', ScssPlugin
  callback()
