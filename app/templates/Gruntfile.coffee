###
<< Adding a local module >>
1. Add a symlink to base dir in createSymlinks
2. Add a symlink to image dir in createSymlinks (optional)
3. Add css to concat:css (optional)
4. Add main.js to requirejs:options:paths
###

fs = require 'fs'
path = require 'path'

connect_middleware = (connect, options) ->
	[
		(req, res, next) ->
			contentTypesMap =
				'.html': 'text/html'
				'.css': 'text/css'
				'.js': 'application/javascript'
				'.map': 'application/javascript' # js source maps
				'.json': 'application/json'
				'.gif': 'image/gif'
				'.jpg': 'image/jpeg'
				'.jpeg': 'image/jpeg'
				'.png': 'image/png'
				'.ico': 'image/x-icon'
				'.ttf': 'application/octet-stream'
			
			sendFile = (reqUrl) ->
				filePath = path.join options.base, reqUrl
				console.log "Fetching #{filePath}"
				
				res.writeHead 200,
					'Content-Type': contentTypesMap[extName] || 'text/html'
					'Content-Length': fs.statSync(filePath).size

				readStream = fs.createReadStream filePath
				readStream.pipe res

			# Create a favicon on the fly if it does not exist
			if req.url is '/favicon.ico' and not fs.existsSync(options.base + req.url)
				fs.openSync options.base + req.url, 'w'
			
			extName = path.extname req.url

			if contentTypesMap[extName]?
				sendFile req.url
			else
				sendFile 'index.html'
	]

module.exports = (grunt) ->

	##############
	### CONFIG ###
	##############

	grunt.initConfig

		### SHELL ###

		shell:
			options:
				stdout: true
				stderr: true
			mocha: 
				command: 'mocha-phantomjs -R dot http://localhost:9002/.test/index.html'
			emptydist:
				command:
					'rm -rf dist/*'
			emptycompiled:
				command:
					'rm -rf compiled/*'
			# rsync:
			# 	command:
			# 		'rsync --copy-links --compress --archive --verbose --checksum --exclude=.svn --chmod=a+r dist/ elaborate4@hi14hingtest.huygens.knaw.nl:elab4testFE/'
			bowerinstall:
				command: 'bower install'
			groc:
				command: 'groc "src/coffee/**/*.coffee" --out=compiled/docs'

		createSymlinks:
			compiled: [
				src: 'images'
				dest: 'compiled/images'
			# ,
			# 	src: '/home/gijs/Projects/faceted-search'
			# 	dest: 'compiled/lib/faceted-search'
			# ,
			# 	src: '/home/gijs/Projects/faceted-search/images'
			# 	dest: 'images/faceted-search'
			]
			dist: [{
				src: 'images'
				dest: 'dist/images'
			}]

		### SERVER ###	

		connect:
			keepalive:
				options:
					port: 9000
					base: 'compiled'
					middleware: connect_middleware
					keepalive: true
			compiled:
				options:
					port: 9000
					base: 'compiled'
					middleware: connect_middleware
			dist:
				options:
					port: 9001
					base: 'dist'
					middleware: connect_middleware			
			test:
				options:
					port: 9002
					base: ''
					middleware: connect_middleware

		### STATIC FILES ###
		rsync:
			options:
				args: ["--verbose", "-i"]
				exclude: [".git*"]
				recursive: true
			compiled:
				options:
					src: "./src/static/"
					dest: "./compiled/static"
			dist:
				options:
					src: "./src/static/"
					dest: "./dist/static"

		### HTML ###
		
		jade:
			init:
				files: [
					expand: true
					cwd: 'src/jade'
					src: '**/*.jade'
					dest: 'compiled/html'
					rename: (dest, src) -> 
						dest + '/' + src.replace(/.jade/, '.html') # Use rename to preserve multiple dots in filenames (nav.user.coffee => nav.user.js)
				,
					'compiled/index.html': 'src/index.jade'
				]
			compile:
				options:
					pretty: true

		replace:
			html:
				src: 'compiled/index.html'
				dest: 'dist/index.html'
				replacements: [
					from: '<script data-main="/js/main" src="/lib/requirejs/require.js"></script>'
					to: '<script src="/js/main.js"></script>'
				]

		### CSS ###

		stylus:
			compile:
				options:
					paths: ['src/stylus/import']
					import: ['variables', 'functions']
				files:
					'compiled/css/project.css': [
						'src/stylus/**/*.styl'
						'!src/stylus/import/*.styl'
					]

		concat:
			css:
				src: [
					'compiled/lib/normalize-css/normalize.css'
					'compiled/css/project.css'
					# 'compiled/lib/faceted-search/compiled/css/main.css'
					# 'compiled/lib/supertinyeditor/main.css'
				]
				dest:
					'compiled/css/main.css'

		cssmin:
			dist:
				files:
					'dist/css/main.css': 'compiled/css/main.css'

		### JS ###

		coffee:
			init:
				files: [
					expand: true
					cwd: 'src/coffee'
					src: '**/*.coffee'
					dest: 'compiled/js'
					rename: (dest, src) -> 
						dest + '/' + src.replace(/.coffee/, '.js') # Use rename to preserve multiple dots in filenames (nav.user.coffee => nav.user.js)
				,
					'.test/tests.js': ['.test/head.coffee', 'test/**/*.coffee']
				]
			test:
				options:
					bare: true
					join: true
				files: 
					'.test/tests.js': ['.test/head.coffee', 'test/**/*.coffee']
			compile:
				options:
					bare: false # UglyHack: set a property to its default value to be able to call coffee:compiled
		
		requirejs:
			compile:
				options:
					baseUrl: "compiled/js"
					name: '../lib/almond/almond'
					include: 'main'
					preserveLicenseComments: false
					out: "dist/js/main.js"
					# optimize: 'none' # Uncomment for debugging
					paths:
						'jquery': '../lib/jquery/jquery.min'
						'underscore': '../lib/underscore-amd/underscore'
						'backbone': '../lib/backbone-amd/backbone'
						'text': '../lib/requirejs-text/text'
						'domready': '../lib/requirejs-domready/domReady'
						# 'faceted-search': '../lib/faceted-search/dist/js/main'
						# 'supertinyeditor': '../lib/supertinyeditor/main'
						'managers': '../lib/managers/dev'
						'helpers': '../lib/helpers/dev'
						'html': '../html'
					wrap: true

		watch:
			options:
				livereload: true
				nospawn: true
			coffeetest:
				files: 'test/**/*.coffee'
				tasks: ['coffee:test', 'shell:mocha']
			coffee:
				files: 'src/coffee/**/*.coffee'
				tasks: 'coffee:compile'
			jade:
				files: ['src/index.jade', 'src/jade/**/*.jade']
				tasks: 'jade:compile'
			stylus:
				files: ['src/stylus/**/*.styl']
				tasks: ['stylus:compile', 'concat:css']

	#############
	### TASKS ###
	#############

	tasks = [
		'grunt-contrib-coffee'
		'grunt-contrib-concat'
		'grunt-contrib-connect'
		'grunt-contrib-copy'
		'grunt-contrib-cssmin'
		'grunt-contrib-jade'
		'grunt-contrib-requirejs'
		'grunt-contrib-stylus'
		'grunt-contrib-uglify'
		'grunt-contrib-watch'
		'grunt-shell'
		'grunt-text-replace'
		'grunt-groc'
		'grunt-rsync'
	]

	grunt.loadNpmTasks task for task in tasks

	jobs = [
			# default
			aliases: ['default']
			tasks: ['sw']
		,
			# generate docs
			aliases: ['d']
			tasks: ['shell:groc']
		,
			# server
			aliases: ['s']
			tasks:['connect:keepalive']
		,
			# watch
			aliases: ['w']
			tasks: ['watch']
		,
			# server and watch
			aliases: ['sw']
			tasks: [
				'connect:compiled'
				'connect:dist'
				'connect:test'
				'watch'
			]
		,
			# compile
			aliases: ['c', 'compile']
			tasks: [
				'shell:emptycompiled'	# rm -rf compiled/
				'shell:bowerinstall'	# Get dependencies first, cuz css needs to be included (and maybe images?)
				'createSymlinks:compiled'
				'coffee:init'
				'jade:init'
				'stylus:compile'
				'rsync:compiled'
				'concat:css'
			]
		,
			# build
			aliases: ['b', 'build']
			tasks: [
				'shell:emptydist'
				'createSymlinks:dist'
				'replace:html' 				# Copy and replace index.html
				'cssmin:dist'
				'rsync:dist'
				'requirejs:compile' 	# Run r.js
				# 'shell:rsync'				# Rsync to test server			
			]
		,q
			# all
			aliases: ['all']
			tasks: ['compile', 'docs', 'build', 'sw']
	]

	for job in jobs
		for alias in job.aliases
			grunt.registerTask alias, job.tasks


	grunt.registerMultiTask 'createSymlinks', 'Creates a symlink', ->
		for own index, config of this.data
			src = if config.src[0] isnt '/' then process.cwd() + '/' + config.src else config.src
			dest = if config.dest[0] isnt '/' then process.cwd() + '/' + config.dest else config.dest

			grunt.log.writeln 'ERROR: source dir does not exist!' if not fs.existsSync(src) # Without a source, all is lost.

			if fs.existsSync(dest)
				stats = fs.lstatSync dest
				
				if stats? and stats.isSymbolicLink()
					fs.unlinkSync dest

			fs.symlinkSync src, dest


	##############
	### EVENTS ###
	##############

	grunt.event.on 'watch', (action, srcPath) ->
		if srcPath.substr(0, 3) is 'src' # Make sure file comes from src/
			type = (srcPath.split('.').splice -1)[0]

			if type is 'coffee'
				testDestPath = srcPath.replace 'src/coffee', 'test'
				destPath = 'compiled'+srcPath.replace(new RegExp(type, 'g'), 'js').substr(3);

			if type is 'jade'
				destPath = 'compiled' + srcPath.replace(new RegExp(type, 'g'), 'html').substr(3);

			if type? and action is 'changed' or action is 'added'
				data = {}
				data[destPath] = srcPath

				grunt.config [type, 'compile', 'files'], data
				grunt.file.copy '.test/template.coffee', testDestPath if testDestPath? and not grunt.file.exists(testDestPath)

			if type? and action is 'deleted'
				grunt.file.delete destPath
				grunt.file.delete testDestPath

		if srcPath.substr(0, 4) is 'test' and action is 'added'
			return false
