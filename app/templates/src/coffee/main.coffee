require.config 
	paths:
		'jquery': '../lib/jquery/jquery'
		'underscore': '../lib/underscore-amd/underscore'
		'backbone': '../lib/backbone-amd/backbone'
		'domready': '../lib/requirejs-domready/domReady'
		'classList': '../lib/classList.js/classList'
		'hilib': '../lib/hilib/compiled'
		'jade': '../lib/jade/runtime'
		'tpls': '../templates'


	shim:
		'underscore':
			exports: '_'
		'backbone':
			deps: ['underscore', 'jquery']
			exports: 'Backbone'

require ['domready', 'app', 'classList'], (domready, app) ->
	domready -> app.initialize()