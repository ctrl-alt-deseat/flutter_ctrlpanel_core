const path = require('path')
const MinifyPlugin = require('babel-minify-webpack-plugin')
const { ConcatSource, ReplaceSource } = require('webpack-sources')

function ToDartPlugin (options) {
  this.options = options
}

ToDartPlugin.prototype.apply = function (compiler) {
  compiler.hooks.compilation.tap({ name: 'ToDart' }, (compilation) => {
    compilation.hooks.optimizeChunkAssets.tapAsync({ name: 'ToDart' }, (chunks, done) => {
      for (const chunk of chunks) {
        for (const fileName of chunk.files) {
          const source = compilation.assets[fileName].source()
          const escaped = new ReplaceSource(compilation.assets[fileName], fileName)

          for (let idx = source.length; idx >= 0; idx--) {
            if (source[idx] === '\\' || source[idx] === '$') {
              escaped.insert(idx, '\\')
            }
          }

          compilation.assets[fileName] = new ConcatSource(`const String ${this.options.variableName} = """\n`, escaped, '\n""";\n')
        }
      }

      done()
    })
  })
}

module.exports = {
  mode: 'production',
  entry: path.join(__dirname, 'index.js'),
  output: {
    path: path.join(__dirname, 'lib'),
    filename: 'js_source.dart'
  },
  optimization: {
    minimize: true
  },
  plugins: [
    new MinifyPlugin({}, {
      test: /\.dart$/,
      comments: false
    }),
    new ToDartPlugin({
      variableName: 'libraryCode'
    })
  ]
}
