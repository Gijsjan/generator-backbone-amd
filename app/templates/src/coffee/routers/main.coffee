define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'managers/view'
	Pubsub = require 'pubsub'
	currentUser = require 'models/currentUser'

	Views =
		Home: require 'views/home'

	class MainRouter extends Backbone.Router
		view: null

		query: {}

		show: (route, params) ->
			viewManager.clear() # Empty the viewManager before initializing new views
			viewManager.show new @view @query

			@query = {}

		initialize: ->
			_.extend @, Pubsub

			@on 'route', @show, @

		'routes':
			'': 'home'

		home: ->
			@view = Views.Home