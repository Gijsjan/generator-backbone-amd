define (require) ->
	config = require 'config'
	Backbone = require 'backbone'
	viewManager = require 'hilib/managers/view'
	Pubsub = require 'hilib/mixins/pubsub'
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
			viewManager.show config.rootEl, Views.Home