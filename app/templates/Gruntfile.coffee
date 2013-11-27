connect_middleware = require 'my-grunt-modules/connect-middleware'

module.exports = (grunt) ->
	require('load-grunt-tasks') grunt
	require('my-grunt-modules/create-symlinks') grunt

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
				command: 'groc'

		createSymlinks:
			compiled: [
				src: 'images'
				dest: 'compiled/images'
			,
				src: '~/Projects/hilib'
				dest: 'compiled/lib/hilib'
			]
			dist: [{
				src: 'images'
				dest: 'dist/images'
			}]

		### SERVER ###	

		connect:
			keepalive:
				options:
					port: 9666
					base: 'compiled'
					middleware: connect_middleware
					keepalive: true
			compiled:
				options:
					port: 9666
					base: 'compiled'
					middleware: connect_middleware
			dist:
				options:
					port: 9667
					base: 'dist'
					middleware: connect_middleware			
			test:
				options:
					port: 9668
					base: ''
					middleware: connect_middleware

		### HTML ###
		
		jade:
			index:
				files: 'compiled/index.html': 'src/index.jade'
			compile:
				files: 'compiled/templates.js': 'src/jade/**/*.jade'
				options:
					compileDebug: false
					client: true
					amd: true
					processName: (filename) -> filename.substring(9, filename.length-5)

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
				]
				dest:
					'compiled/css/main.css'

		cssmin:
			dist:
				files:
					'dist/css/main.css': 'compiled/css/main.css'

		### JS ###

		coffee:
			compile:
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
		
		### OTHER ###

		concurrent:
			compile: ['coffee:compile', 'jade', 'stylus:compile']
			documentation: ['shell:groc', 'plato']

		plato:
			run:
				files: 'compiled/plato': ['compiled/js/**/*.js']

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
						'jade': '../lib/jade/runtime'
						'classList': '../lib/classList.js/classList'
						'hilib': '../lib/hilib/compiled'
						'tpls': '../templates'
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
				tasks: 'newer:coffee:compile'
			jade:
				files: ['src/index.jade', 'src/jade/**/*.jade']
				tasks: 'newer:jade'
			stylus:
				files: ['src/stylus/**/*.styl']
				tasks: ['newer:stylus:compile', 'concat:css']

	#############
	### TASKS ###
	#############

	grunt.registerTask 'default', ['compile', 'build', 'server-watch']
	
	# Generate docs
	grunt.registerTask 'docs', 'concurrent:documentation'

	# Start server and/or watch
	grunt.registerTask 'server-watch', [
		'connect:compiled'
		'connect:test'
		'watch'
	]
	grunt.registerTask 'sw', 'server-watch'
	grunt.registerTask 'w', 'watch'
	grunt.registerTask 'server', 'connect:keepalive'
	grunt.registerTask 's', 'connect:keepalive'

	# Compile
	grunt.registerTask 'compile', [
		'shell:emptycompiled' # rm -rf compiled/
		'shell:bowerinstall' # Get dependencies first, cuz css needs to be included (and maybe images?)
		'createSymlinks:compiled'
		'concurrent:compile'
		'concat:css'
		'concurrent:documentation'
	]
	grunt.registerTask 'c', 'compile'

	# Build
	grunt.registerTask 'build', [
		'shell:emptydist'
		'createSymlinks:dist'
		'replace:html' # Copy and replace index.html
		'cssmin:dist'
		'requirejs:compile' # Run r.js
		# 'shell:rsync' # Rsync to test server
	]
	grunt.registerTask 'b', 'build'