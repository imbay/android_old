// Configuration.
const
dir = {
	html: ['www/*.pug'],
	js: 'www/js/*.coffee',
	css: 'www/css/*.sass'
},
dest = {
	html: 'www/',
	js: 'www/js/',
	css: 'www/css/'
},
ext = {
	html: '.html',
	js: '.js',
	css: '.css'
},
liveReload = {
	on: true, // turn on?
	host: '127.0.0.1',
	port: 2001,
	baseDir: './www',
	open: false,
	notify: false
};
// Require modules.
const
	gulp = require('gulp'),
    pug = require('gulp-pug'),
    coffee = require('gulp-coffee'),
	sass = require('gulp-sass'),
	watch = require('gulp-watch'),
	rename = require('gulp-rename'),
	browserSync = require('browser-sync'),
	reload = browserSync.reload;
// Run livereload.
if(liveReload.on === true) {
	browserSync({
		server: {
			baseDir: liveReload.baseDir
		},
		port: liveReload.port,
		open: liveReload.open,
		notify: liveReload.notify
	});
}
// Tasks.
gulp.task('html', function() {
	gulp.src(dir.html)
		.pipe(pug({
			pretty: true
		}).on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.html
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.html));
});
gulp.task('js', function() {
	gulp.src(dir.js)
		.pipe(coffee().on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.js
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.js));
});
gulp.task('css', function() {
	gulp.src(dir.css)
		.pipe(sass().on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.css
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.css));
});
// Run task.
gulp.task('start', ['html', 'js', 'css'], function() {
	// Watch html files.
	watch(dir.html, function() {
		gulp.start('html');
	});
	// Watch js files.
	watch(dir.js, function() {
		gulp.start('js');
	});
	// Watch css files.
	watch(dir.css, function() {
		gulp.start('css');
	});
});
