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

		watch:
			js:
				files: ['test/**/*.coffee']
				tasks: ['coffee:test', 'shell:mocha-phantomjs']


	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-shell'

	grunt.registerTask('default', ['shell:mocha-phantomjs']);