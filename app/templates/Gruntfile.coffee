module.exports = (grunt) ->
	grunt.initConfig
		shell:
			'mocha-phantomjs': 
				command: 'mocha-phantomjs -R dot http://localhost:8000/.test/index.html'
				options:
					stdout: true
					stderr: true

		coffee:
			test:
				options:
					bare: true
					join: true
				files: 
					'.test/tests.js': ['.test/head.coffee', 'test/**/*.coffee']
			compile:
				files: [
					expand: true  
					cwd: 'src/coffee'   
					src: ['**/*.coffee']
					dest: 'dev/js'
					ext: '.js'
				]

		jade:
			compile:
				files: [
					expand: true  
					cwd: 'src/jade'   
					src: ['**/*.jade']
					dest: 'dev/html'
					ext: '.html'
				,	
					'dev/index.html': 'src/index.jade'
				]

		stylus:
			compile:
				files:
					'dev/css/main.css': 'src/stylus/**/*.styl'

		watch:
			test:
				files: ['test/**/*.coffee']
				tasks: ['coffee:test', 'shell:mocha-phantomjs']
			coffee:
				files: ['src/coffee/**/*.coffee']
				tasks: ['coffee:compile']
			jade:
				files: ['src/index.jade', 'src/jade/**/*.jade']
				tasks: ['jade:compile']
			stylus:
				files: 'src/stylus/**/*.styl'
				tasks: ['stylus:compile']


	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-stylus'
	grunt.loadNpmTasks 'grunt-shell'

	grunt.registerTask('default', ['shell:mocha-phantomjs']);