const path = require('path')
const webpack = require('webpack')

module.exports = {
  mode: 'development',
  entry: './javascripts/main-dev.js',
  devtool: 'eval-source-maps',
  devServer: {
    contentBase: './static/js',
    headers: { "Access-Control-Allow-Origin": "*" },
    hot: true,
    sockPort: 8080,
  },
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'static/js'),
    publicPath: 'http://localhost:8080/',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve(__dirname, './javascripts'),
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: ['file-loader']
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: ['file-loader']
      }
    ]
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.HotModuleReplacementPlugin(),
  ],
}
