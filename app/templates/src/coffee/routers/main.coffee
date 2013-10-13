define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'hilib/managers/view'
	Pubsub = require 'hilib/managers/pubsub'
	currentUser = require 'models/currentUser'

	Views =
		Home: require 'views/home'

	class MainRouter extends Backbone.Router

		initialize: ->
			_.extend @, Pubsub

			@on 'route', @show, @

		'routes':
			'': 'home'

		home: ->
			viewManager.show Views.Home