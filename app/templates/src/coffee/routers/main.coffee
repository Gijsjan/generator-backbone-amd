define (require) ->
	Backbone = require 'backbone'
	viewManager = require('managers/view');

	class MainRouter extends Backbone.Router

		view: null
		
		query: {}

		show: (ev) ->
			viewManager.clear(); # Empty the viewManager before initializing new views
 
			viewManager.show new @view @query

			@query = {};

		initialize: ->
			@on 'route', @show, @

		'routes':
			'': 'home'

		home: ->