gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
cache = require 'gulp-cached'
mocha = require 'gulp-mocha'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
indent = require 'gulp-indent'
header = require 'gulp-header'

gulp.task 'coffee', ->
  gulp.src 'src/**/*.coffee'
  .pipe coffee().on 'error', gutil.log
  .pipe gulp.dest 'lib'

gulp.task 'test', ->
  gulp.src 'test/**/*.coffee', {read: false}
  .pipe mocha reporter: 'spec'

gulp.task 'watch-coffee', ['dist'], ->
  gulp.watch 'src/**/*.coffee', ['dist']
  gulp.watch ['src/**/*.coffee', 'test/**/*.coffee'], ['test']

gulp.task 'watch-test', ['test'], ->
  gulp.watch ['src/**/*.coffee', 'test/**/*.coffee'], ['test']

gulp.task 'watch', ['watch-coffee', 'watch-test'], ->

gulp.task 'browserify', ['coffee'], ->
  gulp.src 'lib/index.js'
  .pipe browserify()
  .pipe rename 'reactive-data.js'
  .pipe gulp.dest 'dist'

gulp.task 'dist-amd', ->
  gulp.src 'src/**/*.coffee'
  .pipe(cache('coffee'))
  .pipe indent
    tabs: false
    amount: 2
  .pipe header 'define (require, exports, module) ->\n'
  .pipe coffee().on('error', gutil.log)
  .pipe gulp.dest 'dist/amd'

gulp.task 'dist', ['dist-amd', 'browserify'], ->

gulp.task 'default', ['coffee'], ->
