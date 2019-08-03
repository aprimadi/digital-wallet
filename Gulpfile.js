var fs                = require('fs')
var gulp              = require('gulp')
var livereload        = require('gulp-livereload')
var hash              = require('gulp-hash')
var webpack           = require('webpack-stream')
var WebpackDevServer  = require('webpack-dev-server')

var sass              = require('gulp-sass')
sass.compiler         = require('node-sass')

gulp.task('sass', function () {
  return gulp.src('./stylesheets/main.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('static/css/'))
})

gulp.task('js', function() {
  return gulp.src('javascripts/main.js')
    .pipe(webpack(require('./webpack.config.js')))
    .pipe(gulp.dest('static/js/'))
})

gulp.task('asset-manifest', function() {
  return gulp.src(['static/js/main.js', 'static/css/main.css'], { base: 'static' })
    .pipe(hash())
    .pipe(gulp.dest('static'))
    .pipe(hash.manifest('static/assets-manifest.json', {
      sourceDir: __dirname + '/static'
    }))
    .pipe(gulp.dest('.'))
})

gulp.task("webpack-dev-server", function(callback) {
  // Start a webpack-dev-server
  var compiler = webpack( require('./webpack.config.js') )

  new WebpackDevServer(compiler, {
    // server and middleware options
  }).listen(8080, "localhost", function(err) {
    if(err) throw new gutil.PluginError("webpack-dev-server", err)
    // Server listening
    gutil.log("[webpack-dev-server]", "http://localhost:8080/webpack-dev-server/index.html")

    // keep the server alive or continue?
    // callback();
  })
})

gulp.task('sass:watch', ['sass'], function () {
  gulp.watch('./stylesheets/**/*.scss', ['sass'])
})
